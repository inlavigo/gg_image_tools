// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:gg_image_tools/src/run_gg_image_tools.dart';
import 'package:test/test.dart';

import 'expected_output_pathes.dart';

void main() {
  final tmp =
      Directory('/tmp').existsSync() ? '/tmp' : Directory.systemTemp.path;

  final target = Directory('$tmp/gg_image_tools_test');

  // ...........................................................................
  setUp(() {
    if (target.existsSync()) {
      target.deleteSync(recursive: true);
    }
  });

  group('SplitImageFoldersByCrationDateCmd, runGgImageTools', () {
    // #########################################################################
    group('run()', () {
      test('should allow to execute the command from cli', () async {
        await runGgImageTools(
          args: ['split', '-i', './test/test_images', '-o', target.path],
          log: print,
        );

        expectRightFilePathes(output: target, useBirthDate: true);
      });

      // .......................................................................
      test('should log when errors happen', () async {
        final messages = <String>[];

        // Run command with wrong option
        await runGgImageTools(
          args: [
            'split',
            '-x', // Wrong option
          ],
          log: (msg) => messages.add(msg),
        );

        // Expect error message
        expect(messages, isNotEmpty);
        expect(
          messages.last,
          contains('Error: Could not find an option or flag "-x".'),
        );
      });
    });
  });
}