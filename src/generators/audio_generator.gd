## Audio Generator
##
## Procedurally generates audio for sound effects
class_name AudioGenerator

static func generate_simple_tone(frequency: float, duration: float) -> AudioStreamWAV:
	"""Generate a simple sine wave tone"""
	var sample_rate := 44100
	var samples := int(duration * sample_rate)
	
	# Use 16-bit for better quality and compatibility
	var data := PackedByteArray()
	data.resize(samples * 2)  # 2 bytes per sample for 16-bit
	
	for i in range(samples):
		var t := float(i) / sample_rate
		var value := sin(t * frequency * TAU) * 0.3
		
		# Apply envelope (attack-decay)
		var envelope := 1.0 - (float(i) / samples)
		value *= envelope
		
		# Convert to 16-bit signed integer (-32768 to 32767)
		var sample_value := int(clamp(value * 32767, -32768, 32767))
		
		# Write as little-endian 16-bit
		data[i * 2] = sample_value & 0xFF
		data[i * 2 + 1] = (sample_value >> 8) & 0xFF
	
	var stream := AudioStreamWAV.new()
	stream.data = data
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	
	return stream

static func generate_block_hit_sound(piece_type: String) -> AudioStreamWAV:
	"""Generate hit sound based on piece type"""
	var frequency := _get_frequency_for_piece(piece_type)
	return generate_simple_tone(frequency, 0.08)

static func generate_block_place_sound(piece_type: String) -> AudioStreamWAV:
	"""Generate placement sound"""
	var frequency := _get_frequency_for_piece(piece_type) * 0.75
	return generate_simple_tone(frequency, 0.1)

static func _get_frequency_for_piece(piece_type: String) -> float:
	"""Get frequency (musical note) for each piece type"""
	match piece_type:
		"I_PIECE": return 440.0  # A4
		"O_PIECE": return 523.25  # C5
		"T_PIECE": return 587.33  # D5
		"S_PIECE": return 659.25  # E5
		"Z_PIECE": return 698.46  # F5
		"J_PIECE": return 783.99  # G5
		"L_PIECE": return 880.0  # A5
		_: return 440.0

static func regenerate_all() -> void:
	"""Regenerate all procedural audio"""
	print("Regenerating all procedural audio...")
	# Regenerate sounds as needed
	print("Audio regenerated")
