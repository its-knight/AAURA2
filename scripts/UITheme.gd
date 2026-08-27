extends RefCounted
class_name UITheme
## Builds the game's "glassmorphism" look purely from code: translucent,
## blurred-looking rounded panels with soft borders, gold/purple accents.
## Keeping this in one place means every menu shares an identical style.

const COLOR_GOLD := Color(0.886, 0.717, 0.078)      # #e2b714
const COLOR_PURPLE := Color(0.424, 0.361, 0.906)    # #6c5ce7
const COLOR_WHITE := Color(1, 1, 1)
const COLOR_BG_TOP := Color(0.102, 0.102, 0.180)    # #1a1a2e
const COLOR_BG_BOTTOM := Color(0.086, 0.129, 0.243) # #16213e

static func glass_panel(radius: int = 24, border_color: Color = Color(1,1,1,0.25)) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 1, 0.08)
	sb.set_corner_radius_all(radius)
	sb.set_border_width_all(2)
	sb.border_color = border_color
	sb.shadow_size = 12
	sb.shadow_color = Color(0, 0, 0, 0.25)
	sb.content_margin_left = 24
	sb.content_margin_right = 24
	sb.content_margin_top = 16
	sb.content_margin_bottom = 16
	return sb

static func button_style(base_color: Color = COLOR_GOLD, hover: bool = false) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	var c := base_color
	sb.bg_color = c.lightened(0.15) if hover else c
	sb.set_corner_radius_all(18)
	sb.set_border_width_all(2)
	sb.border_color = Color(1, 1, 1, 0.35)
	sb.content_margin_left = 28
	sb.content_margin_right = 28
	sb.content_margin_top = 14
	sb.content_margin_bottom = 14
	return sb

static func style_primary_button(btn: Button) -> void:
	btn.add_theme_stylebox_override("normal", button_style(COLOR_GOLD, false))
	btn.add_theme_stylebox_override("hover", button_style(COLOR_GOLD, true))
	btn.add_theme_stylebox_override("pressed", button_style(COLOR_GOLD.darkened(0.15), false))
	btn.add_theme_color_override("font_color", Color(0.1, 0.1, 0.15))
	btn.add_theme_color_override("font_hover_color", Color(0.05, 0.05, 0.1))
	btn.add_theme_font_size_override("font_size", 26)
	btn.custom_minimum_size = Vector2(260, 64)

static func style_secondary_button(btn: Button) -> void:
	btn.add_theme_stylebox_override("normal", button_style(COLOR_PURPLE, false))
	btn.add_theme_stylebox_override("hover", button_style(COLOR_PURPLE, true))
	btn.add_theme_stylebox_override("pressed", button_style(COLOR_PURPLE.darkened(0.15), false))
	btn.add_theme_color_override("font_color", Color(1, 1, 1))
	btn.add_theme_font_size_override("font_size", 24)
	btn.custom_minimum_size = Vector2(220, 58)

static func style_title(label: Label, size: int = 72) -> void:
	label.add_theme_color_override("font_color", COLOR_GOLD)
	label.add_theme_color_override("font_outline_color", Color(1, 1, 1, 0.5))
	label.add_theme_constant_override("outline_size", 6)
	label.add_theme_font_size_override("font_size", size)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

static func background_gradient() -> GradientTexture2D:
	var grad := Gradient.new()
	grad.set_color(0, COLOR_BG_TOP)
	grad.set_color(1, COLOR_BG_BOTTOM)
	var tex := GradientTexture2D.new()
	tex.gradient = grad
	tex.fill_from = Vector2(0.5, 0)
	tex.fill_to = Vector2(0.5, 1)
	tex.width = 16
	tex.height = 16
	return tex
