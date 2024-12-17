# clig

**CLIG** is a command-line tool for compressing and decompressing text files using a combination of **Run-Length Encoding (RLE)** and **dictionary-based compression**. It efficiently reduces file size for repetitive and common text patterns.

## **Features**

1. **Run-Length Encoding (RLE):** Compresses consecutive repeated characters.
2. **Dictionary-based Compression:** Replaces common sequences like `the`, `and`, and spaces with tokens to save space.
3. **Command-Line Interface (CLI):** Intuitive and easy-to-use text-based interface.
4. **Decompression:** Reverses the compression to recover the original file.

## **Build Instructions**

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/clig.git
   cd clig
   ```

2. Build the project:
   ```bash
   zig build
   ```

3. The executable will be generated in `zig-out/bin/`:
   ```bash
   ./zig-out/bin/clig
   ```

## **Usage**

### **Compress a File**

To compress a file, use:
```bash
./zig-out/bin/clig compress <input_file> <output_file>
```

**Example:**
```bash
./zig-out/bin/clig compress input.txt output.clig
```

### **Decompress a File**

To decompress a file, use:
```bash
./zig-out/bin/clig decompress <input_file> <output_file>
```

**Example:**
```bash
./zig-out/bin/clig decompress output.clig decompressed.txt
```

## **Example**

### Command

```bash
./zig-out/bin/clig compress input.txt output.clig
./zig-out/bin/clig decompress output.clig decompressed.txt
```

### Output
- **Compression:**  
   ```
   Compressed input.txt to output.clig
   Original size: 242 bytes
   Compressed size: 234 bytes
   Compression Ratio: 96.69%
   ```

- **Decompression:**  
   ```
   Decompressed output.clig to decompressed.txt
   Original size: 234 bytes
   Decompressed size: 242 bytes
   ```

## **Testing**

Run all tests using:
```bash
zig build test
```

