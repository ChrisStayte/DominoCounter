import 'package:dominoes/enums/domino_type.dart';
import 'package:dominoes/global/global.dart';
import 'package:dominoes/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;

typedef KeypadKeyCallback(DominoType dominoType);

class KeypadKey extends StatelessWidget {
  const KeypadKey({
    Key? key,
    required this.dominoType,
    required this.onTap,
  }) : super(key: key);

  final DominoType dominoType;
  final KeypadKeyCallback onTap;

  Future<bool> _fileExists() async {
    try {
      ByteData data = await rootBundle
          .load('assets/pips/${this.dominoType.name}_colored.svg');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(dominoType),
        child: Container(
          margin: EdgeInsets.all(1),
          color: context.watch<SettingsProvider>().isDarkDominoes
              ? Colors.grey
              : Colors.white,
          child: Center(
            child: FutureBuilder(
              future: _fileExists(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (context.watch<SettingsProvider>().isPips) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return FractionallySizedBox(
                        widthFactor: 0.85,
                        child: SvgPicture.asset(
                          'assets/pips/${this.dominoType.name}_colored.svg',
                        ),
                      );
                    }
                  }
                }
                return Text(
                  Global.values.dominoValues[dominoType]?.toString() ??
                      context
                          .watch<SettingsProvider>()
                          .doubleZeroValue
                          .toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Global.colors.dominoColors[dominoType] ??
                        context.watch<SettingsProvider>().appAccentColor,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
