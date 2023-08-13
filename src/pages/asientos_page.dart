// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  double precioPelicula = 0;
  bool comprando = false;

  void _cerrarDialog() {
      Navigator.pop(context); // cierra el Dialog
      setState(() {
        comprando = false;
      });
      // Navegar de vuelta a la página principal aquí
    }

    void _mostrarDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              color: const Color(0xFFCFDDE3),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                  SizedBox(height: 25.0),
                  Text('Comprando...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                ],
              ),
            ),
          );
        },
      );
      Timer(const Duration(seconds: 4), _cerrarDialog);
    }

  _crearBotonComprar(BuildContext context) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              comprando = true;
            });
            _mostrarDialog();
            // ignore: prefer_const_constructors
            Future.delayed(Duration(seconds: 4), () {
              Navigator.pop(context); // Cerramos el modal
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pelicula comprada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            });
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Comprar Pelicula'),
        ),
      );
    }

  Future<void> obtenerPrecioPelicula() async {
    SharedPreferences prefsValor = await SharedPreferences.getInstance();
    setState(() {
      precioPelicula = prefsValor.getDouble('precioPelicula') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    obtenerPrecioPelicula();
  }

  List<List<Seat>> seats = List.generate(
    5, // número de filas
    (row) => List.generate(7, (seatIndex) => Seat(row, seatIndex + 1, SeatStatus.disponible)),
  )..[2][3].status = SeatStatus.ocupado; // Marcar un asiento como ocupado

  int selectedSeatCount = 0;
  static const maxSelectedSeats = 10;

  void _toggleSeatSelection(int row, int seatIndex) {
    if (selectedSeatCount < maxSelectedSeats || seats[row][seatIndex].status == SeatStatus.seleccionado) {
      setState(() {
        if (seats[row][seatIndex].status == SeatStatus.disponible) {
          if (selectedSeatCount < maxSelectedSeats) {
            seats[row][seatIndex].status = SeatStatus.seleccionado;
            selectedSeatCount++;
          }
        } else if (seats[row][seatIndex].status == SeatStatus.seleccionado) {
          seats[row][seatIndex].status = SeatStatus.disponible;
          selectedSeatCount--;
        }
      });
    }
  }

  double calculateTotalValue() {
    double totalValue = selectedSeatCount * precioPelicula;
    return double.parse(totalValue.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selección de Asientos'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 200, // Altura del cuadro de la pantalla de cine
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Pantalla de Cine',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 25,
                height: 25,
                color: Colors.yellow, // Amarillo para seleccionados
              ),
              const Text(
                'Seleccionados',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Container(
                width: 25,
                height: 25,
                color: Colors.green, // Verde para disponibles
              ),
              const Text(
                'Disponibles',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Container(
                width: 25,
                height: 25,
                color: Colors.red, // Rojo para ocupados
              ),
              const Text(
                'Ocupados',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int row = 0; row < seats.length; row++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int seatIndex = 0;
                            seatIndex < seats[row].length;
                            seatIndex++)
                          GestureDetector(
                            onTap: () {
                              _toggleSeatSelection(row, seatIndex);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: seats[row][seatIndex].status == SeatStatus.disponible
                                    ? Colors.green
                                    : seats[row][seatIndex].status == SeatStatus.seleccionado
                                        ? Colors.yellow
                                        : Colors.red,
                                border: Border.all(),
                              ),
                              child: Center(
                                child: Text(
                                  seats[row][seatIndex].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: seats[row][seatIndex].status == SeatStatus.ocupado
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom:40, left: 30),
                child: Text(
                  'Total: ${calculateTotalValue()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom:40, left: 50),
                child: _crearBotonComprar(context)
              ),
            ],
          ),

          

        ],
      ),
    );
  }
}

enum SeatStatus {
  disponible,
  seleccionado,
  ocupado,
}

class Seat {
  final int row;
  final int number;
  SeatStatus status;

  Seat(this.row, this.number, this.status);

  String get name {
    return 'Fila $row $number';
  }
}

