class Window
  SCREEN_WIDTH  = 640
  SCREEN_HEIGHT = 480

  getter :renderer, :primitives

  def initialize
    if LibSDL.init(LibSDL::INIT_VIDEO) != 0
      raise "SDL could not initialize! Error: #{String.new(LibSDL.get_error)}"
    end

    @window = LibSDL.create_window("SDL Tutorial", 10, 10, SCREEN_WIDTH, SCREEN_HEIGHT, LibSDL::WindowFlags::WINDOW_SHOWN)
    raise "Window could not be created! Error: #{String.new(LibSDL.get_error)}" if !@window

    renderer_flags = LibSDL::RendererFlags::RENDERER_ACCELERATED | LibSDL::RendererFlags::RENDERER_PRESENTVSYNC
    @renderer = LibSDL.create_renderer(@window, -1, renderer_flags)
    raise "Renderer could not be created! SDL Error: #{String.new(LibSDL.get_error)}" unless @renderer

    # @surface = LibSDL.get_window_surface(@window)
    # LibSDL.fill_rect(@surface, nil, LibSDL.map_rgb(@surface.value.format, 0x20, 0x20, 0x20))
    # LibSDL.update_window_surface(@window)

    @quit = false
    @primitives = [] of Renderable
  end

  def event_loop
    # Main loop
    while (!@quit)
      while LibSDL.poll_event(out e) != 0
        if e.type == LibSDL::EventType::QUIT.to_i
          @quit = true
        end
      end

      # top_left_viewport = LibSDL::Rect.new(x: 0, y: 0, w: SCREEN_WIDTH / 2, h: SCREEN_HEIGHT / 2)
      # LibSDL.render_set_viewport(g_renderer, pointerof(top_left_viewport))
      # LibSDL.render_copy(g_renderer, g_texture, nil, nil)

      # top_right_viewport = LibSDL::Rect.new(x: SCREEN_WIDTH / 2, y: 0, w: SCREEN_WIDTH / 2, h: SCREEN_HEIGHT / 2)
      # LibSDL.render_set_viewport(g_renderer, pointerof(top_right_viewport))
      # LibSDL.render_copy(g_renderer, g_texture, nil, nil)

      # bottom_viewport = LibSDL::Rect.new(x: 0, y: SCREEN_HEIGHT / 2, w: SCREEN_WIDTH, h: SCREEN_HEIGHT / 2)
      # LibSDL.render_set_viewport(g_renderer, pointerof(bottom_viewport))
      # LibSDL.render_copy(g_renderer, g_texture, nil, nil)

      LibSDL.set_render_draw_color(@renderer, 0xFF, 0xFF, 0xFF, 0xFF)
      LibSDL.render_clear(@renderer)
      @primitives.each { |primitive| primitive.render(@renderer) }
      LibSDL.render_present(@renderer)
    end
  end

  def destroy
    LibSDL.destroy_window(@window)
    LibSDL.quit
  end
end
