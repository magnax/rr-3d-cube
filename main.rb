require 'raylib'

Raylib.init_window(800, 450, 'Raylib template!')

until Raylib.window_should_close
  Raylib.begin_drawing
  Raylib.clear_background(Raylib::WHITE)
  Raylib.draw_text("You\'re running raylib in Ruby!\nESC to close this window", 190, 200, 20, Raylib::BLACK)
  Raylib.end_drawing
end

Raylib.close_window