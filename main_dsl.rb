require 'raylib/dsl'

init_window(800, 450, 'Raylib template - DSL version!')

until window_should_close
  begin_drawing
  clear_background(WHITE)
  draw_text("You\'re running raylib in Ruby!\nESC to close this window", 190, 200, 20, BLACK)
  end_drawing
end

close_window