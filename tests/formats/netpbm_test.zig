const ImageReader = zigimg.ImageReader;
const ImageSeekStream = zigimg.ImageSeekStream;
const PixelFormat = zigimg.PixelFormat;
const assert = std.debug.assert;
const color = zigimg.color;
const errors = zigimg.errors;
const std = @import("std");
const testing = std.testing;
const netpbm = zigimg.netpbm;
const zigimg = @import("zigimg");
const image = zigimg.image;
usingnamespace @import("../helpers.zig");

test "Load ASCII PBM image" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/netpbm/pbm_ascii.pbm");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var pbmFile = netpbm.PBM{};

    var pixelsOpt: ?color.ColorStorage = null;
    try pbmFile.read(zigimg_test_allocator, stream_source.reader(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(pbmFile.header.width, 8);
    expectEq(pbmFile.header.height, 16);
    expectEq(pbmFile.pixel_format, PixelFormat.Grayscale1);

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Grayscale1);

        expectEq(pixels.Grayscale1[0].value, 0);
        expectEq(pixels.Grayscale1[1].value, 1);
        expectEq(pixels.Grayscale1[15 * 8 + 7].value, 1);
    }
}

test "Load binary PBM image" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/netpbm/pbm_binary.pbm");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var pbmFile = netpbm.PBM{};

    var pixelsOpt: ?color.ColorStorage = null;
    try pbmFile.read(zigimg_test_allocator, stream_source.reader(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(pbmFile.header.width, 8);
    expectEq(pbmFile.header.height, 16);
    expectEq(pbmFile.pixel_format, PixelFormat.Grayscale1);

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Grayscale1);

        expectEq(pixels.Grayscale1[0].value, 0);
        expectEq(pixels.Grayscale1[1].value, 1);
        expectEq(pixels.Grayscale1[15 * 8 + 7].value, 1);
    }
}

test "Load ASCII PGM 8-bit grayscale image" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/netpbm/pgm_ascii_grayscale8.pgm");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var pgmFile = netpbm.PGM{};

    var pixelsOpt: ?color.ColorStorage = null;
    try pgmFile.read(zigimg_test_allocator, stream_source.reader(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(pgmFile.header.width, 16);
    expectEq(pgmFile.header.height, 24);
    expectEq(pgmFile.pixel_format, PixelFormat.Grayscale8);

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Grayscale8);

        expectEq(pixels.Grayscale8[0].value, 2);
        expectEq(pixels.Grayscale8[1].value, 5);
        expectEq(pixels.Grayscale8[383].value, 196);
    }
}

test "Load Binary PGM 8-bit grayscale image" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/netpbm/pgm_binary_grayscale8.pgm");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var pgmFile = netpbm.PGM{};

    var pixelsOpt: ?color.ColorStorage = null;
    try pgmFile.read(zigimg_test_allocator, stream_source.reader(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(pgmFile.header.width, 16);
    expectEq(pgmFile.header.height, 24);
    expectEq(pgmFile.pixel_format, PixelFormat.Grayscale8);

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Grayscale8);

        expectEq(pixels.Grayscale8[0].value, 2);
        expectEq(pixels.Grayscale8[1].value, 5);
        expectEq(pixels.Grayscale8[383].value, 196);
    }
}

test "Load ASCII PGM 16-bit grayscale image" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/netpbm/pgm_ascii_grayscale16.pgm");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var pgmFile = netpbm.PGM{};

    var pixelsOpt: ?color.ColorStorage = null;
    try pgmFile.read(zigimg_test_allocator, stream_source.reader(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(pgmFile.header.width, 8);
    expectEq(pgmFile.header.height, 16);
    expectEq(pgmFile.pixel_format, PixelFormat.Grayscale8);

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Grayscale8);

        expectEq(pixels.Grayscale8[0].value, 13);
        expectEq(pixels.Grayscale8[1].value, 16);
        expectEq(pixels.Grayscale8[127].value, 237);
    }
}

test "Load Binary PGM 16-bit grayscale image" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/netpbm/pgm_binary_grayscale16.pgm");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var pgmFile = netpbm.PGM{};

    var pixelsOpt: ?color.ColorStorage = null;
    try pgmFile.read(zigimg_test_allocator, stream_source.reader(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(pgmFile.header.width, 8);
    expectEq(pgmFile.header.height, 16);
    expectEq(pgmFile.pixel_format, PixelFormat.Grayscale8);

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Grayscale8);

        expectEq(pixels.Grayscale8[0].value, 13);
        expectEq(pixels.Grayscale8[1].value, 16);
        expectEq(pixels.Grayscale8[127].value, 237);
    }
}

test "Load ASCII PPM image" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/netpbm/ppm_ascii_rgb24.ppm");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var ppmFile = netpbm.PPM{};

    var pixelsOpt: ?color.ColorStorage = null;
    try ppmFile.read(zigimg_test_allocator, stream_source.reader(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(ppmFile.header.width, 27);
    expectEq(ppmFile.header.height, 27);
    expectEq(ppmFile.pixel_format, PixelFormat.Rgb24);

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Rgb24);

        expectEq(pixels.Rgb24[0].R, 0x34);
        expectEq(pixels.Rgb24[0].G, 0x53);
        expectEq(pixels.Rgb24[0].B, 0x9f);

        expectEq(pixels.Rgb24[1].R, 0x32);
        expectEq(pixels.Rgb24[1].G, 0x5b);
        expectEq(pixels.Rgb24[1].B, 0x96);

        expectEq(pixels.Rgb24[26].R, 0xa8);
        expectEq(pixels.Rgb24[26].G, 0x5a);
        expectEq(pixels.Rgb24[26].B, 0x78);

        expectEq(pixels.Rgb24[27].R, 0x2e);
        expectEq(pixels.Rgb24[27].G, 0x54);
        expectEq(pixels.Rgb24[27].B, 0x99);

        expectEq(pixels.Rgb24[26 * 27 + 26].R, 0x88);
        expectEq(pixels.Rgb24[26 * 27 + 26].G, 0xb7);
        expectEq(pixels.Rgb24[26 * 27 + 26].B, 0x55);
    }
}

test "Load binary PPM image" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/netpbm/ppm_binary_rgb24.ppm");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var ppmFile = netpbm.PPM{};

    var pixelsOpt: ?color.ColorStorage = null;
    try ppmFile.read(zigimg_test_allocator, stream_source.reader(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(ppmFile.header.width, 27);
    expectEq(ppmFile.header.height, 27);
    expectEq(ppmFile.pixel_format, PixelFormat.Rgb24);

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Rgb24);

        expectEq(pixels.Rgb24[0].R, 0x34);
        expectEq(pixels.Rgb24[0].G, 0x53);
        expectEq(pixels.Rgb24[0].B, 0x9f);

        expectEq(pixels.Rgb24[1].R, 0x32);
        expectEq(pixels.Rgb24[1].G, 0x5b);
        expectEq(pixels.Rgb24[1].B, 0x96);

        expectEq(pixels.Rgb24[26].R, 0xa8);
        expectEq(pixels.Rgb24[26].G, 0x5a);
        expectEq(pixels.Rgb24[26].B, 0x78);

        expectEq(pixels.Rgb24[27].R, 0x2e);
        expectEq(pixels.Rgb24[27].G, 0x54);
        expectEq(pixels.Rgb24[27].B, 0x99);

        expectEq(pixels.Rgb24[26 * 27 + 26].R, 0x88);
        expectEq(pixels.Rgb24[26 * 27 + 26].G, 0xb7);
        expectEq(pixels.Rgb24[26 * 27 + 26].B, 0x55);
    }
}

test "Write bitmap(Grayscale1) ASCII PBM file" {
    const grayscales = [_]u1{
        1, 0, 0, 1,
        1, 0, 1, 0,
        0, 1, 0, 1,
        1, 1, 1, 0,
    };

    const image_file_name = "zigimg_pbm_ascii_test.pbm";
    const width = grayscales.len;
    const height = 1;

    const source_image = try image.Image.create(zigimg_test_allocator, width, height, PixelFormat.Grayscale1);
    defer source_image.deinit();

    if (source_image.pixels) |source| {
        for (grayscales) |value, index| {
            source.Grayscale1[index].value = value;
        }
    }

    try source_image.writeToFilePath(image_file_name, image.ImageFormat.Pbm, image.ImageEncoderOptions{
        .pbm = .{ .binary = false },
    });

    defer {
        std.fs.cwd().deleteFile(image_file_name) catch unreachable;
    }

    const read_image = try image.Image.fromFilePath(zigimg_test_allocator, image_file_name);
    defer read_image.deinit();

    expectEq(read_image.width, width);
    expectEq(read_image.height, height);

    testing.expect(read_image.pixels != null);

    if (read_image.pixels) |read_pixels| {
        testing.expect(read_pixels == .Grayscale1);

        for (grayscales) |grayscale_value, index| {
            expectEq(read_pixels.Grayscale1[index].value, grayscale_value);
        }
    }
}

test "Write bitmap(Grayscale1) binary PBM file" {
    const grayscales = [_]u1{
        1, 0, 0, 1,
        1, 0, 1, 0,
        0, 1, 0, 1,
        1, 1, 1, 0,
        1, 1,
    };

    const image_file_name = "zigimg_pbm_binary_test.pbm";
    const width = grayscales.len;
    const height = 1;

    const source_image = try image.Image.create(zigimg_test_allocator, width, height, PixelFormat.Grayscale1);
    defer source_image.deinit();

    if (source_image.pixels) |source| {
        for (grayscales) |value, index| {
            source.Grayscale1[index].value = value;
        }
    }

    try source_image.writeToFilePath(image_file_name, image.ImageFormat.Pbm, image.ImageEncoderOptions{
        .pbm = .{ .binary = true },
    });

    defer {
        std.fs.cwd().deleteFile(image_file_name) catch unreachable;
    }

    const read_image = try image.Image.fromFilePath(zigimg_test_allocator, image_file_name);
    defer read_image.deinit();

    expectEq(read_image.width, width);
    expectEq(read_image.height, height);

    testing.expect(read_image.pixels != null);

    if (read_image.pixels) |read_pixels| {
        testing.expect(read_pixels == .Grayscale1);

        for (grayscales) |grayscale_value, index| {
            expectEq(read_pixels.Grayscale1[index].value, grayscale_value);
        }
    }
}

test "Write grayscale8 ASCII PGM file" {
    const grayscales = [_]u8{
        0,   29,  56,  85,  113, 142, 170, 199, 227, 255,
        227, 199, 170, 142, 113, 85,  56,  29,  0,
    };

    const image_file_name = "zigimg_pgm_ascii_test.pgm";
    const width = grayscales.len;
    const height = 1;

    const source_image = try image.Image.create(zigimg_test_allocator, width, height, PixelFormat.Grayscale8);
    defer source_image.deinit();

    if (source_image.pixels) |source| {
        for (grayscales) |value, index| {
            source.Grayscale8[index].value = value;
        }
    }

    try source_image.writeToFilePath(image_file_name, image.ImageFormat.Pgm, image.ImageEncoderOptions{
        .pgm = .{ .binary = false },
    });

    defer {
        std.fs.cwd().deleteFile(image_file_name) catch unreachable;
    }

    const read_image = try image.Image.fromFilePath(zigimg_test_allocator, image_file_name);
    defer read_image.deinit();

    expectEq(read_image.width, width);
    expectEq(read_image.height, height);

    testing.expect(read_image.pixels != null);

    if (read_image.pixels) |read_pixels| {
        testing.expect(read_pixels == .Grayscale8);

        for (grayscales) |grayscale_value, index| {
            expectEq(read_pixels.Grayscale8[index].value, grayscale_value);
        }
    }
}

test "Write grayscale8 binary PGM file" {
    const grayscales = [_]u8{
        0,   29,  56,  85,  113, 142, 170, 199, 227, 255,
        227, 199, 170, 142, 113, 85,  56,  29,  0,
    };

    const image_file_name = "zigimg_pgm_binary_test.pgm";
    const width = grayscales.len;
    const height = 1;

    const source_image = try image.Image.create(zigimg_test_allocator, width, height, PixelFormat.Grayscale8);
    defer source_image.deinit();

    if (source_image.pixels) |source| {
        for (grayscales) |value, index| {
            source.Grayscale8[index].value = value;
        }
    }

    try source_image.writeToFilePath(image_file_name, image.ImageFormat.Pgm, image.ImageEncoderOptions{
        .pgm = .{ .binary = true },
    });

    defer {
        std.fs.cwd().deleteFile(image_file_name) catch unreachable;
    }

    const read_image = try image.Image.fromFilePath(zigimg_test_allocator, image_file_name);
    defer read_image.deinit();

    expectEq(read_image.width, width);
    expectEq(read_image.height, height);

    testing.expect(read_image.pixels != null);

    if (read_image.pixels) |read_pixels| {
        testing.expect(read_pixels == .Grayscale8);

        for (grayscales) |grayscale_value, index| {
            expectEq(read_pixels.Grayscale8[index].value, grayscale_value);
        }
    }
}

test "Writing Rgb24 ASCII PPM format" {
    const expected_colors = [_]u32{ 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xffffff, 0x00ffff, 0xff00ff, 0xffff00 };

    const image_file_name = "zigimg_ppm_rgb24_ascii_test.ppm";
    const width = expected_colors.len;
    const height = 1;

    const source_image = try image.Image.create(zigimg_test_allocator, width, height, PixelFormat.Rgb24);
    defer source_image.deinit();

    testing.expect(source_image.pixels != null);

    if (source_image.pixels) |pixels| {
        testing.expect(pixels == .Rgb24);
        testing.expect(pixels.Rgb24.len == width * height);

        // R, G, B
        pixels.Rgb24[0] = color.Rgb24.initRGB(255, 0, 0);
        pixels.Rgb24[1] = color.Rgb24.initRGB(0, 255, 0);
        pixels.Rgb24[2] = color.Rgb24.initRGB(0, 0, 255);

        // Black, white
        pixels.Rgb24[3] = color.Rgb24.initRGB(0, 0, 0);
        pixels.Rgb24[4] = color.Rgb24.initRGB(255, 255, 255);

        // Cyan, Magenta, Yellow
        pixels.Rgb24[5] = color.Rgb24.initRGB(0, 255, 255);
        pixels.Rgb24[6] = color.Rgb24.initRGB(255, 0, 255);
        pixels.Rgb24[7] = color.Rgb24.initRGB(255, 255, 0);
    }

    try source_image.writeToFilePath(image_file_name, image.ImageFormat.Ppm, image.ImageEncoderOptions{
        .ppm = .{ .binary = false },
    });

    defer {
        std.fs.cwd().deleteFile(image_file_name) catch unreachable;
    }

    const read_image = try image.Image.fromFilePath(zigimg_test_allocator, image_file_name);
    defer read_image.deinit();

    expectEq(read_image.width, width);
    expectEq(read_image.height, height);

    testing.expect(read_image.pixels != null);

    if (read_image.pixels) |read_image_pixels| {
        testing.expect(read_image_pixels == .Rgb24);

        for (expected_colors) |hex_color, index| {
            expectEq(read_image_pixels.Rgb24[index].toColor().toIntegerColor8(), color.IntegerColor8.fromHtmlHex(expected_colors[index]));
        }
    }
}

test "Writing Rgb24 binary PPM format" {
    const expected_colors = [_]u32{ 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xffffff, 0x00ffff, 0xff00ff, 0xffff00 };

    const image_file_name = "zigimg_ppm_rgb24_binary_test.ppm";
    const width = expected_colors.len;
    const height = 1;

    const source_image = try image.Image.create(zigimg_test_allocator, width, height, PixelFormat.Rgb24);
    defer source_image.deinit();

    testing.expect(source_image.pixels != null);

    if (source_image.pixels) |pixels| {
        testing.expect(pixels == .Rgb24);
        testing.expect(pixels.Rgb24.len == width * height);

        // R, G, B
        pixels.Rgb24[0] = color.Rgb24.initRGB(255, 0, 0);
        pixels.Rgb24[1] = color.Rgb24.initRGB(0, 255, 0);
        pixels.Rgb24[2] = color.Rgb24.initRGB(0, 0, 255);

        // Black, white
        pixels.Rgb24[3] = color.Rgb24.initRGB(0, 0, 0);
        pixels.Rgb24[4] = color.Rgb24.initRGB(255, 255, 255);

        // Cyan, Magenta, Yellow
        pixels.Rgb24[5] = color.Rgb24.initRGB(0, 255, 255);
        pixels.Rgb24[6] = color.Rgb24.initRGB(255, 0, 255);
        pixels.Rgb24[7] = color.Rgb24.initRGB(255, 255, 0);
    }

    try source_image.writeToFilePath(image_file_name, image.ImageFormat.Ppm, image.ImageEncoderOptions{
        .ppm = .{ .binary = true },
    });

    defer {
        std.fs.cwd().deleteFile(image_file_name) catch unreachable;
    }

    const read_image = try image.Image.fromFilePath(zigimg_test_allocator, image_file_name);
    defer read_image.deinit();

    expectEq(read_image.width, width);
    expectEq(read_image.height, height);

    testing.expect(read_image.pixels != null);

    if (read_image.pixels) |read_image_pixels| {
        testing.expect(read_image_pixels == .Rgb24);

        for (expected_colors) |hex_color, index| {
            expectEq(read_image_pixels.Rgb24[index].toColor().toIntegerColor8(), color.IntegerColor8.fromHtmlHex(expected_colors[index]));
        }
    }
}
