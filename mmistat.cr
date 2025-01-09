def read_mmi_file(filename : Path)
  file = File.open(filename, "rb")

  # Read and verify the magic number
  magic = file.read_string(4)
  puts "Magic number (raw): #{magic}"
  if magic != "MMI\2"
    raise "Invalid .mmi file: Magic number mismatch"
  end

  # Read the header values
  seed_width = file.read_bytes(Int32)
  kmer_size = file.read_bytes(Int32)
  bucket_bits = file.read_bytes(Int32)
  num_sequences = file.read_bytes(Int32)
  flags = file.read_bytes(Int32)

  puts "MMI Header:"
  puts "  k-mer size: #{kmer_size}"
  puts "  Seed width: #{seed_width}"
  puts "  Bucket bits: #{bucket_bits}"
  puts "  Number of sequences: #{num_sequences}"
  puts "  Flags: 0x#{flags.to_s(16)}"
  puts

  # Read sequence information
  puts "Sequences:"
  num_digits = num_sequences.to_s.size
  num_sequences.times do |i|
    name_length = file.read_bytes(UInt8)
    name = file.read_string(name_length)
    seq_length = file.read_bytes(Int32)
    puts "  [#{(i + 1).to_s.rjust(num_digits)}] Name: #{name}, Length: #{seq_length}"
  end

  file.close
end

if ARGV.size != 1
  puts "Usage: crystal #{__FILE__} <index.mmi>"
  exit 1
end

filename = Path[ARGV[0]]
read_mmi_file(filename)
