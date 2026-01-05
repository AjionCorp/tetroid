## Global Constants for Tetroid
##
## All game constants defined here for easy modification
class_name Constants

## Board dimensions
const BOARD_WIDTH: int = 60
const BOARD_HEIGHT: int = 62
const CELL_SIZE: int = 16  # pixels per grid cell

## Territory layout
const PLAYER1_START_Y: int = 0
const PLAYER1_END_Y: int = 29
const NEUTRAL_START_Y: int = 30
const NEUTRAL_END_Y: int = 31
const PLAYER2_START_Y: int = 32
const PLAYER2_END_Y: int = 61

## Game settings
const TARGET_FPS: int = 60
const FIXED_DELTA: float = 1.0 / 60.0

## Gameplay values
const STARTING_HP: int = 100
const STARTING_BLOCKS: int = 5

## Physics
const BALL_SPEED_DEFAULT: float = 400.0
const BALL_SPEED_MIN: float = 150.0
const BALL_SPEED_MAX: float = 1000.0
const PADDLE_SPEED: float = 400.0

## Piece types
enum PieceType {
	I_PIECE,
	O_PIECE,
	T_PIECE,
	S_PIECE,
	Z_PIECE,
	J_PIECE,
	L_PIECE
}

## Ball types
enum BallType {
	NORMAL,
	FIRE,
	ICE,
	HEAVY,
	GHOST,
	MULTI
}

## Game modes
enum GameMode {
	ONE_VS_ONE,
	TWO_VS_TWO,
	FREE_FOR_ALL
}

## Colors (from design doc)
const COLOR_CYAN: Color = Color("#00FFFF")      # I-Piece
const COLOR_YELLOW: Color = Color("#FFFF00")    # O-Piece
const COLOR_PURPLE: Color = Color("#AA00FF")    # T-Piece
const COLOR_GREEN: Color = Color("#00FF00")     # S-Piece
const COLOR_RED: Color = Color("#FF0000")       # Z-Piece
const COLOR_BLUE: Color = Color("#0000FF")      # J-Piece
const COLOR_ORANGE: Color = Color("#FF8800")    # L-Piece

## UI Colors
const COLOR_BG_DARK: Color = Color("#0A0A0F")
const COLOR_BG_MEDIUM: Color = Color("#1A1A2E")
const COLOR_PANEL_DARK: Color = Color("#16213E")
const COLOR_PANEL_LIGHT: Color = Color("#0F3460")
const COLOR_ACCENT: Color = Color("#533483")
const COLOR_TEXT_PRIMARY: Color = Color("#EAEAEA")
const COLOR_TEXT_SECONDARY: Color = Color("#9D9D9D")

static func initialize() -> void:
	"""Called on startup"""
	print("Constants initialized")

static func get_piece_color(piece_type: PieceType) -> Color:
	"""Get color for a piece type"""
	match piece_type:
		PieceType.I_PIECE: return COLOR_CYAN
		PieceType.O_PIECE: return COLOR_YELLOW
		PieceType.T_PIECE: return COLOR_PURPLE
		PieceType.S_PIECE: return COLOR_GREEN
		PieceType.Z_PIECE: return COLOR_RED
		PieceType.J_PIECE: return COLOR_BLUE
		PieceType.L_PIECE: return COLOR_ORANGE
		_: return Color.WHITE

static func is_in_player1_territory(y: int) -> bool:
	"""Check if Y position is in player 1 territory"""
	return y >= PLAYER1_START_Y and y <= PLAYER1_END_Y

static func is_in_player2_territory(y: int) -> bool:
	"""Check if Y position is in player 2 territory"""
	return y >= PLAYER2_START_Y and y <= PLAYER2_END_Y

static func is_in_neutral_zone(y: int) -> bool:
	"""Check if Y position is in neutral zone"""
	return y >= NEUTRAL_START_Y and y <= NEUTRAL_END_Y
