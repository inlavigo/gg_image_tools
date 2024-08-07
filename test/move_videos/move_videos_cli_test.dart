// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_capture_print/gg_capture_print.dart';
import 'package:gg_image_tools/gg_image_tools.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  final tmpDir = Directory.systemTemp;
  final inDir = tmpDir.createTempSync();
  final outDir = Directory(join(tmpDir.path, 'outDir'));
  if (outDir.existsSync()) {
    outDir.deleteSync(recursive: true);
  }

  group('MoveVideos', () {
    // #########################################################################
    group('run()', () {
      test('should allow to execute the command from cli', () async {
        final m = <String>[];
        capturePrint(
          ggLog: m.add,
          code: () async {
            // Create command runner
            final runner = CommandRunner<void>('test', 'test');
            final command = MoveVideosCli(log: print);
            runner.addCommand(command);

            // Run command without options
            // Did usage description?
            await runner.run([]);
            expect(m.last, contains('sage: test <command> [arguments]'));
            expect(m.last, contains(command.name));
            expect(m.last, contains(command.description));

            // Run command with split, but without input option.
            // Did complain about missing input?
            await expectLater(
              runner.run(['moveVideos']),
              throwsA(
                isA<ArgumentError>().having(
                  (ArgumentError e) => e.message,
                  'message',
                  contains('Option input is mandatory.'),
                ),
              ),
            );

            // Run command with split, but without output option.
            // Did complain about missing input?
            await expectLater(
              runner.run(['moveVideos', '--input', inDir.path]),
              throwsA(
                isA<ArgumentError>().having(
                  (ArgumentError e) => e.message,
                  'message',
                  contains('Option output is mandatory.'),
                ),
              ),
            );

            // Run command with split and output, but without existing output
            // Did complain about missing input?

            await expectLater(
              runner.run([
                'moveVideos',
                '--input',
                inDir.path,
                '--output',
                tmpDir.path,
              ]),
              throwsA(
                isA<ArgumentError>().having(
                  (ArgumentError e) => e.message,
                  'message',
                  contains('Target folder already exist'),
                ),
              ),
            );

            // Run command with split and input and fine target folder
            // Did report success?
            await runner.run([
              'moveVideos',
              '--input',
              inDir.path,
              '--output',
              outDir.path,
            ]);

            expect(m.last, 'Done.');
          },
        );

        // Is already tested split_test.dart
      });
    });
  });
}
