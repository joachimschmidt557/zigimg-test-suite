const ImageInStream = zigimg.ImageInStream;
const ImageSeekStream = zigimg.ImageSeekStream;
const PixelFormat = zigimg.PixelFormat;
const assert = std.debug.assert;
const tga = zigimg.tga;
const color = zigimg.color;
const errors = zigimg.errors;
const std = @import("std");
const testing = std.testing;
const zigimg = @import("zigimg");
usingnamespace @import("../helpers.zig");

test "Should error on non TGA images" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/bmp/simple_v4.bmp");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var tga_file = tga.TGA{};

    var pixelsOpt: ?color.ColorStorage = null;
    const invalidFile = tga_file.read(zigimg_test_allocator, stream_source.inStream(), stream_source.seekableStream(), &pixelsOpt);
    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectError(invalidFile, errors.ImageError.InvalidMagicHeader);
}

test "Read ubw8 TGA file" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/tga/ubw8.tga");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var tga_file = tga.TGA{};

    var pixelsOpt: ?color.ColorStorage = null;
    try tga_file.read(zigimg_test_allocator, stream_source.inStream(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(tga_file.width(), 128);
    expectEq(tga_file.height(), 128);
    expectEq(try tga_file.pixelFormat(), .Grayscale8);

    const expected_strip = [_]u8{ 76, 149, 178, 0, 76, 149, 178, 254, 76, 149, 178, 0, 76, 149, 178, 254 };

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Grayscale8);

        const width = tga_file.width();
        const height = tga_file.height();

        var y: usize = 0;
        while (y < height) : (y += 1) {
            var x: usize = 0;

            const stride = y * width;

            while (x < width) : (x += 1) {
                const strip_index = x / 8;

                expectEq(pixels.Grayscale8[stride + x].value, expected_strip[strip_index]);
            }
        }
    }
}

test "Read ucm8 TGA file" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/tga/ucm8.tga");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var tga_file = tga.TGA{};

    var pixelsOpt: ?color.ColorStorage = null;
    try tga_file.read(zigimg_test_allocator, stream_source.inStream(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(tga_file.width(), 128);
    expectEq(tga_file.height(), 128);
    expectEq(try tga_file.pixelFormat(), .Bpp8);

    const expected_strip = [_]u8{ 64, 128, 192, 0, 64, 128, 192, 255, 64, 128, 192, 0, 64, 128, 192, 255 };

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Bpp8);

        expectEq(pixels.Bpp8.indices.len, 128 * 128);

        expectEq(pixels.Bpp8.palette[0].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0x000000));
        expectEq(pixels.Bpp8.palette[64].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0xff0000));
        expectEq(pixels.Bpp8.palette[128].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0x00ff00));
        expectEq(pixels.Bpp8.palette[192].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0x0000ff));
        expectEq(pixels.Bpp8.palette[255].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0xffffff));

        const width = tga_file.width();
        const height = tga_file.height();

        var y: usize = 0;
        while (y < height) : (y += 1) {
            var x: usize = 0;

            const stride = y * width;

            while (x < width) : (x += 1) {
                const strip_index = x / 8;

                expectEq(pixels.Bpp8.indices[stride + x], expected_strip[strip_index]);
            }
        }
    }
}

test "Read utc16 TGA file" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/tga/utc16.tga");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var tga_file = tga.TGA{};

    var pixelsOpt: ?color.ColorStorage = null;
    try tga_file.read(zigimg_test_allocator, stream_source.inStream(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(tga_file.width(), 128);
    expectEq(tga_file.height(), 128);
    expectEq(try tga_file.pixelFormat(), .Rgb555);

    const expected_strip = [_]u32{ 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xff0000, 0x00ff00, 0x0000ff, 0xffffff, 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xff0000, 0x00ff00, 0x0000ff, 0xffffff };

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Rgb555);

        expectEq(pixels.Rgb555.len, 128 * 128);

        const width = tga_file.width();
        const height = tga_file.height();

        var y: usize = 0;
        while (y < height) : (y += 1) {
            var x: usize = 0;

            const stride = y * width;

            while (x < width) : (x += 1) {
                const strip_index = x / 8;

                expectEq(pixels.Rgb555[stride + x].toColor().toIntegerColor8(), color.IntegerColor8.fromHtmlHex(expected_strip[strip_index]));
            }
        }
    }
}

test "Read utc24 TGA file" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/tga/utc24.tga");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var tga_file = tga.TGA{};

    var pixelsOpt: ?color.ColorStorage = null;
    try tga_file.read(zigimg_test_allocator, stream_source.inStream(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(tga_file.width(), 128);
    expectEq(tga_file.height(), 128);
    expectEq(try tga_file.pixelFormat(), .Rgb24);

    const expected_strip = [_]u32{ 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xff0000, 0x00ff00, 0x0000ff, 0xffffff, 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xff0000, 0x00ff00, 0x0000ff, 0xffffff };

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Rgb24);

        expectEq(pixels.Rgb24.len, 128 * 128);

        const width = tga_file.width();
        const height = tga_file.height();

        var y: usize = 0;
        while (y < height) : (y += 1) {
            var x: usize = 0;

            const stride = y * width;

            while (x < width) : (x += 1) {
                const strip_index = x / 8;

                expectEq(pixels.Rgb24[stride + x].toColor().toIntegerColor8(), color.IntegerColor8.fromHtmlHex(expected_strip[strip_index]));
            }
        }
    }
}

test "Read utc32 TGA file" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/tga/utc32.tga");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var tga_file = tga.TGA{};

    var pixelsOpt: ?color.ColorStorage = null;
    try tga_file.read(zigimg_test_allocator, stream_source.inStream(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(tga_file.width(), 128);
    expectEq(tga_file.height(), 128);
    expectEq(try tga_file.pixelFormat(), .Rgba32);

    const expected_strip = [_]u32{ 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xff0000, 0x00ff00, 0x0000ff, 0xffffff, 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xff0000, 0x00ff00, 0x0000ff, 0xffffff };

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Rgba32);

        expectEq(pixels.Rgba32.len, 128 * 128);

        const width = tga_file.width();
        const height = tga_file.height();

        var y: usize = 0;
        while (y < height) : (y += 1) {
            var x: usize = 0;

            const stride = y * width;

            while (x < width) : (x += 1) {
                const strip_index = x / 8;

                expectEq(pixels.Rgba32[stride + x].toColor().toIntegerColor8(), color.IntegerColor8.fromHtmlHex(expected_strip[strip_index]));
            }
        }
    }
}

test "Read cbw8 TGA file" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/tga/cbw8.tga");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var tga_file = tga.TGA{};

    var pixelsOpt: ?color.ColorStorage = null;
    try tga_file.read(zigimg_test_allocator, stream_source.inStream(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(tga_file.width(), 128);
    expectEq(tga_file.height(), 128);
    expectEq(try tga_file.pixelFormat(), .Grayscale8);

    const expected_strip = [_]u8{ 76, 149, 178, 0, 76, 149, 178, 254, 76, 149, 178, 0, 76, 149, 178, 254 };

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Grayscale8);

        const width = tga_file.width();
        const height = tga_file.height();

        var y: usize = 0;
        while (y < height) : (y += 1) {
            var x: usize = 0;

            const stride = y * width;

            while (x < width) : (x += 1) {
                const strip_index = x / 8;

                expectEq(pixels.Grayscale8[stride + x].value, expected_strip[strip_index]);
            }
        }
    }
}

test "Read ccm8 TGA file" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/tga/ccm8.tga");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var tga_file = tga.TGA{};

    var pixelsOpt: ?color.ColorStorage = null;
    try tga_file.read(zigimg_test_allocator, stream_source.inStream(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(tga_file.width(), 128);
    expectEq(tga_file.height(), 128);
    expectEq(try tga_file.pixelFormat(), .Bpp8);

    const expected_strip = [_]u8{ 64, 128, 192, 0, 64, 128, 192, 255, 64, 128, 192, 0, 64, 128, 192, 255 };

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Bpp8);

        expectEq(pixels.Bpp8.indices.len, 128 * 128);

        expectEq(pixels.Bpp8.palette[0].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0x000000));
        expectEq(pixels.Bpp8.palette[64].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0xff0000));
        expectEq(pixels.Bpp8.palette[128].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0x00ff00));
        expectEq(pixels.Bpp8.palette[192].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0x0000ff));
        expectEq(pixels.Bpp8.palette[255].toIntegerColor8(), color.IntegerColor8.fromHtmlHex(0xffffff));

        const width = tga_file.width();
        const height = tga_file.height();

        var y: usize = 0;
        while (y < height) : (y += 1) {
            var x: usize = 0;

            const stride = y * width;

            while (x < width) : (x += 1) {
                const strip_index = x / 8;

                expectEq(pixels.Bpp8.indices[stride + x], expected_strip[strip_index]);
            }
        }
    }
}

test "Read ctc24 TGA file" {
    const file = try testOpenFile(zigimg_test_allocator, "tests/fixtures/tga/ctc24.tga");
    defer file.close();

    var stream_source = std.io.StreamSource{ .file = file };

    var tga_file = tga.TGA{};

    var pixelsOpt: ?color.ColorStorage = null;
    try tga_file.read(zigimg_test_allocator, stream_source.inStream(), stream_source.seekableStream(), &pixelsOpt);

    defer {
        if (pixelsOpt) |pixels| {
            pixels.deinit(zigimg_test_allocator);
        }
    }

    expectEq(tga_file.width(), 128);
    expectEq(tga_file.height(), 128);
    expectEq(try tga_file.pixelFormat(), .Rgb24);

    const expected_strip = [_]u32{ 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xff0000, 0x00ff00, 0x0000ff, 0xffffff, 0xff0000, 0x00ff00, 0x0000ff, 0x000000, 0xff0000, 0x00ff00, 0x0000ff, 0xffffff };

    testing.expect(pixelsOpt != null);

    if (pixelsOpt) |pixels| {
        testing.expect(pixels == .Rgb24);

        expectEq(pixels.Rgb24.len, 128 * 128);

        const width = tga_file.width();
        const height = tga_file.height();

        var y: usize = 0;
        while (y < height) : (y += 1) {
            var x: usize = 0;

            const stride = y * width;

            while (x < width) : (x += 1) {
                const strip_index = x / 8;

                expectEq(pixels.Rgb24[stride + x].toColor().toIntegerColor8(), color.IntegerColor8.fromHtmlHex(expected_strip[strip_index]));
            }
        }
    }
}