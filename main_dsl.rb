require 'raylib/dsl'

BACKGROUND = 0x101010ff
FOREGROUND = 0x50ff50ff

Point = Struct.new('Point', :x, :y)
Point3d = Struct.new('Point3d', :x, :y, :z)

@vs = [
  {x:  0.25, y:  0.25, z:  0.25},
  {x:  0.25, y: -0.25, z:  0.25},
  {x: -0.25, y: -0.25, z:  0.25},
  {x: -0.25, y:  0.25, z:  0.25},
  
  {x:  0.25, y:  0.25, z: -0.25},
  {x:  0.25, y: -0.25, z: -0.25},
  {x: -0.25, y: -0.25, z: -0.25},
  {x: -0.25, y:  0.25, z: -0.25},
]

@fs = [
  [0, 1, 2, 3],
  [4, 5, 6, 7],
  [0, 4],
  [1, 5],
  [2, 6],
  [3, 7]
]

@dz = 1
@angle = 0
@fps = 80

init_window(800, 800, 'Z Transformation animation demo')
set_target_fps(@fps)

def point(p)
  r = 6
  draw_circle p.x - r / 2, p.y - r / 2, r, get_color(FOREGROUND)
rescue
  nil
end

def line(p1, p2)
  draw_line(p1[:x], p1[:y], p2[:x], p2[:y], get_color(FOREGROUND))
end

def screen(p)
  Point.new(
    (p.x.to_f + 1) / 2 * screen_width,
    (1 - (p.y.to_f + 1) / 2) * screen_height
  )
end

def project(p3d)
  if p3d.z == 0
    x = p3d.x
    y = p3d.y
  else
    x = p3d.x / p3d.z
    y = p3d.y / p3d.z
  end

  Point.new(x, y)
end
  
def screen_width
  @screen_width ||= get_screen_width
end

def screen_height
  @screen_height ||= get_screen_height
end

def translate_z(p3d, dz)
  Point3d.new(
    p3d.x,
    p3d.y,
    p3d.z + dz
  )
end

def rotate_xz(p3d, angle)
  c = Math.cos(angle)
  s = Math.sin(angle)

  Point3d.new(
    p3d.x * c - p3d.z * s,
    p3d.y,
    p3d.x * s + p3d.z * c
  )
end

def draw_all
  dt = 1.0 / @fps
  @angle += Math::PI * dt

  # uncomment below if you want to see the vertices
  
  # @vs.each do |v|
  #   v3d = Point3d.new(v[:x], v[:y], v[:z])
  #   point(screen(project(translate_z(rotate_xz(v3d, @angle), @dz))))
  # end
  @fs.each do |f|
    (0..(f.length-1)).each do |i|
      a = @vs[f[i]]
      a3d = Point3d.new(a[:x], a[:y], a[:z])
      b = @vs[f[(i+1)%f.length]]
      b3d = Point3d.new(b[:x], b[:y], b[:z])
      line(
        screen(project(translate_z(rotate_xz(a3d, @angle), @dz))),
        screen(project(translate_z(rotate_xz(b3d, @angle), @dz)))
      )
    end
  end
end
    
until window_should_close

  if is_key_pressed(KEY_R)
    @dz = 1
  end

  if is_key_pressed(KEY_UP)
    @dz -= 0.02
  end

  if is_key_pressed(KEY_DOWN)
    @dz += 0.02
  end

  begin_drawing
  clear_background(get_color(BACKGROUND))
  draw_all
  draw_text(
    "Morzesz pszyblirzac lub oddalac \n jak bedziesz naduszac szczauki UP / DOWN",
    10, 740, 21, get_color(FOREGROUND)
  )
  end_drawing
end

close_window
