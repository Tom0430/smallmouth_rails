# !/usr/bin/env ruby -w

require 'fileutils'
require 'rmagick'
require 'test/unit'
require 'test/unit/ui/console/testrunner'

class ImageList2UT < Test::Unit::TestCase
  def setup
    @ilist = Magick::ImageList.new
  end

  def test_append
    @ilist.read(IMAGES_DIR + '/Button_0.gif', IMAGES_DIR + '/Button_0.gif')
    assert_nothing_raised do
      img = @ilist.append(true)
      assert_instance_of(Magick::Image, img)
    end
    assert_nothing_raised do
      img = @ilist.append(false)
      assert_instance_of(Magick::Image, img)
    end
    assert_raise(ArgumentError) { @ilist.append }
    assert_raise(ArgumentError) { @ilist.append(true, 1) }
  end

  def test_average
    @ilist.read(IMAGES_DIR + '/Button_0.gif', IMAGES_DIR + '/Button_0.gif')
    assert_nothing_raised do
      img = @ilist.average
      assert_instance_of(Magick::Image, img)
    end
    assert_raise(ArgumentError) { @ilist.average(1) }
  end

  def test_clone
    @ilist.read(*Dir[IMAGES_DIR + '/Button_*.gif'])
    ilist2 = @ilist.clone
    assert_equal(ilist2, @ilist)
    assert_equal(@ilist.frozen?, ilist2.frozen?)
    assert_equal(@ilist.tainted?, ilist2.tainted?)
    @ilist.taint
    @ilist.freeze
    ilist2 = @ilist.clone
    assert_equal(@ilist.frozen?, ilist2.frozen?)
    assert_equal(@ilist.tainted?, ilist2.tainted?)
  end

  def test_coalesce
    @ilist.read(IMAGES_DIR + '/Button_0.gif', IMAGES_DIR + '/Button_0.gif')
    ilist = nil
    assert_nothing_raised { ilist = @ilist.coalesce }
    assert_instance_of(Magick::ImageList, ilist)
    assert_equal(2, ilist.length)
    assert_equal(0, ilist.scene)
  end

  def test_copy
    @ilist.read(*Dir[IMAGES_DIR + '/Button_*.gif'])
    @ilist.scene = 7
    ilist2 = @ilist.copy
    assert_not_same(@ilist, ilist2)
    assert_equal(@ilist.scene, ilist2.scene)
    @ilist.each_with_index do |img, x|
      assert_equal(img, ilist2[x])
    end
  end

  def test_deconstruct
    @ilist.read(IMAGES_DIR + '/Button_0.gif', IMAGES_DIR + '/Button_1.gif')
    ilist = nil
    assert_nothing_raised { ilist = @ilist.deconstruct }
    assert_instance_of(Magick::ImageList, ilist)
    assert_equal(2, ilist.length)
    assert_equal(0, ilist.scene)
  end

  def test_dup
    @ilist.read(*Dir[IMAGES_DIR + '/Button_*.gif'])
    ilist2 = @ilist.dup
    assert_equal(ilist2, @ilist)
    assert_equal(@ilist.frozen?, ilist2.frozen?)
    assert_equal(@ilist.tainted?, ilist2.tainted?)
    @ilist.taint
    @ilist.freeze
    ilist2 = @ilist.dup
    assert_not_equal(@ilist.frozen?, ilist2.frozen?)
    assert_equal(@ilist.tainted?, ilist2.tainted?)
  end

  def flatten_images
    @ilist.read(IMAGES_DIR + '/Button_0.gif', IMAGES_DIR + '/Button_1.gif')
    assert_nothing_thrown do
      img = @ilist.flatten_images
      assert_instance_of(Magick::Image, img)
    end
  end

  def test_from_blob
    hat = File.open(FLOWER_HAT, 'rb')
    blob = hat.read
    assert_nothing_raised { @ilist.from_blob(blob) }
    assert_instance_of(Magick::Image, @ilist[0])
    assert_equal(0, @ilist.scene)

    ilist2 = Magick::ImageList.new(FLOWER_HAT)
    assert_equal(@ilist, ilist2)
  end

  def test_marshal
    ilist1 = Magick::ImageList.new(*Dir[IMAGES_DIR + '/Button_*.gif'])
    d = nil
    ilist2 = nil
    assert_nothing_raised { d = Marshal.dump(ilist1) }
    assert_nothing_raised { ilist2 = Marshal.load(d) }
    assert_equal(ilist1, ilist2)
  end

  def test_montage
    @ilist.read(*Dir[IMAGES_DIR + '/Button_*.gif'])
    ilist = @ilist.copy
    montage = nil
    assert_nothing_thrown do
      montage = ilist.montage do
        self.background_color = Magick::Pixel.new(Magick::QuantumRange, 0, 0)
        self.background_color = 'blue'
        self.border_color = Magick::Pixel.new(0, 0, 0)
        self.border_color = 'red'
        self.border_width = 2
        self.compose = Magick::OverCompositeOp
        self.filename = 'test.png'
        self.fill = 'green'
        self.font = 'Arial'
        self.frame = '20x20+4+4'
        self.frame = Magick::Geometry.new(20, 20, 4, 4)
        self.geometry = '63x60+5+5'
        self.geometry = Magick::Geometry.new(63, 60, 5, 5)
        self.gravity = Magick::SouthGravity
        self.matte_color = '#bdbdbd'
        self.matte_color = Magick::Pixel.new(Magick::QuantumRange, 0, 0)
        self.pointsize = 12
        self.shadow = true
        self.stroke = 'transparent'
        self.texture = Magick::Image.read(IMAGES_DIR + '/Button_0.gif').first
        self.texture = Magick::Image.read(IMAGES_DIR + '/Button_1.gif').first
        self.tile = '4x9'
        self.tile = Magick::Geometry.new(4, 9)
        self.title = 'sample'
      end
      assert_instance_of(Magick::ImageList, montage)
      assert_equal(@ilist, ilist)

      montage_image = montage.first
      assert_equal('blue', montage_image.background_color)
      assert_equal('red', montage_image.border_color)
    end

    # test illegal option arguments
    # looks like IM doesn't diagnose invalid geometry args
    # to tile= and geometry=
    assert_raise(TypeError) do
      montage = ilist.montage { self.background_color = 2 }
      assert_equal(@ilist, ilist)
    end
    assert_raise(TypeError) do
      montage = ilist.montage { self.border_color = 2 }
      assert_equal(@ilist, ilist)
    end
    assert_raise(TypeError) do
      montage = ilist.montage { self.border_width = [2] }
      assert_equal(@ilist, ilist)
    end
    assert_raise(TypeError) do
      montage = ilist.montage { self.compose = 2 }
      assert_equal(@ilist, ilist)
    end
    assert_raise(TypeError) do
      montage = ilist.montage { self.filename = 2 }
      assert_equal(@ilist, ilist)
    end
    assert_raise(TypeError) do
      montage = ilist.montage { self.fill = 2 }
      assert_equal(@ilist, ilist)
    end
    assert_raise(TypeError) do
      montage = ilist.montage { self.font = 2 }
      assert_equal(@ilist, ilist)
    end
    assert_raise(TypeError) do
      montage = ilist.montage { self.gravity = 2 }
      assert_equal(@ilist, ilist)
    end
    assert_raise(TypeError) do
      montage = ilist.montage { self.matte_color = 2 }
      assert_equal(@ilist, ilist)
    end
    assert_raise(TypeError) do
      montage = ilist.montage { self.pointsize = 'x' }
      assert_equal(@ilist, ilist)
    end
    assert_raise(ArgumentError) do
      montage = ilist.montage { self.stroke = 'x' }
      assert_equal(@ilist, ilist)
    end
    assert_raise(NoMethodError) do
      montage = ilist.montage { self.texture = 'x' }
      assert_equal(@ilist, ilist)
    end
  end

  def test_morph
    # can't morph an empty list
    assert_raise(ArgumentError) { @ilist.morph(1) }
    @ilist.read(IMAGES_DIR + '/Button_0.gif', IMAGES_DIR + '/Button_1.gif')
    # can't specify a negative argument
    assert_raise(ArgumentError) { @ilist.morph(-1) }
    assert_nothing_raised do
      res = @ilist.morph(2)
      assert_instance_of(Magick::ImageList, res)
      assert_equal(4, res.length)
      assert_equal(0, res.scene)
    end
  end

  def test_mosaic
    @ilist.read(IMAGES_DIR + '/Button_0.gif', IMAGES_DIR + '/Button_1.gif')
    assert_nothing_thrown do
      res = @ilist.mosaic
      assert_instance_of(Magick::Image, res)
    end
  end

  def test_mosaic_with_invalid_imagelist
    list = @ilist.copy
    list.instance_variable_set("@images", nil)
    assert_raise(Magick::ImageMagickError) { list.mosaic }
  end

  def test_new_image
    assert_nothing_raised do
      @ilist.new_image(20, 20)
    end
    assert_equal(1, @ilist.length)
    assert_equal(0, @ilist.scene)
    @ilist.new_image(20, 20, Magick::HatchFill.new('black'))
    assert_equal(2, @ilist.length)
    assert_equal(1, @ilist.scene)
    @ilist.new_image(20, 20) { self.background_color = 'red' }
    assert_equal(3, @ilist.length)
    assert_equal(2, @ilist.scene)
  end

  def test_optimize_layers
    @ilist.read(IMAGES_DIR + '/Button_0.gif', IMAGES_DIR + '/Button_1.gif')
    Magick::LayerMethod.values do |method|
      next if [Magick::UndefinedLayer, Magick::CompositeLayer, Magick::TrimBoundsLayer].include?(method)

      assert_nothing_raised do
        res = @ilist.optimize_layers(method)
        assert_instance_of(Magick::ImageList, res)
        assert_kind_of(Integer, res.length)
      end
    end

    assert_nothing_raised { @ilist.optimize_layers(Magick::CompareClearLayer) }
    assert_raise(ArgumentError) { @ilist.optimize_layers(Magick::UndefinedLayer) }
    assert_raise(TypeError) { @ilist.optimize_layers(2) }
    assert_raise(NotImplementedError) { @ilist.optimize_layers(Magick::CompositeLayer) }
  end

  def test_ping
    assert_nothing_raised { @ilist.ping(FLOWER_HAT) }
    assert_equal(1, @ilist.length)
    assert_equal(0, @ilist.scene)
    assert_nothing_raised { @ilist.ping(FLOWER_HAT, FLOWER_HAT) }
    assert_equal(3, @ilist.length)
    assert_equal(2, @ilist.scene)
    assert_nothing_raised { @ilist.ping(FLOWER_HAT) { self.background_color = 'red ' } }
    assert_equal(4, @ilist.length)
    assert_equal(3, @ilist.scene)
  end

  def test_quantize
    @ilist.read(IMAGES_DIR + '/Button_0.gif', IMAGES_DIR + '/Button_1.gif')
    assert_nothing_raised do
      res = @ilist.quantize
      assert_instance_of(Magick::ImageList, res)
      assert_equal(1, res.scene)
    end
    assert_nothing_raised { @ilist.quantize(128) }
    assert_raise(TypeError) { @ilist.quantize('x') }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace) }
    assert_raise(TypeError) { @ilist.quantize(128, 'x') }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace, true, 0) }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace, true) }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace, false) }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace, Magick::NoDitherMethod) }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace, Magick::RiemersmaDitherMethod) }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace, Magick::FloydSteinbergDitherMethod) }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace, Magick::FloydSteinbergDitherMethod, 32) }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace, Magick::FloydSteinbergDitherMethod, 32, true) }
    assert_nothing_raised { @ilist.quantize(128, Magick::RGBColorspace, Magick::FloydSteinbergDitherMethod, 32, false) }
    assert_raise(TypeError) { @ilist.quantize(128, Magick::RGBColorspace, true, 'x') }
    assert_raise(ArgumentError) { @ilist.quantize(128, Magick::RGBColorspace, true, 0, false, 'extra') }
  end

  def test_read
    assert_nothing_raised { @ilist.read(FLOWER_HAT) }
    assert_equal(1, @ilist.length)
    assert_equal(0, @ilist.scene)
    assert_nothing_raised { @ilist.read(FLOWER_HAT, FLOWER_HAT) }
    assert_equal(3, @ilist.length)
    assert_equal(2, @ilist.scene)
    assert_nothing_raised { @ilist.read(FLOWER_HAT) { self.background_color = 'red ' } }
    assert_equal(4, @ilist.length)
    assert_equal(3, @ilist.scene)
  end

  def test_remap
    @ilist.read(*Dir[IMAGES_DIR + '/Button_*.gif'])
    assert_nothing_raised { @ilist.remap }
    remap_image = Magick::Image.new(20, 20) { self.background_color = 'green' }
    assert_nothing_raised { @ilist.remap(remap_image) }
    assert_nothing_raised { @ilist.remap(remap_image, Magick::NoDitherMethod) }
    assert_nothing_raised { @ilist.remap(remap_image, Magick::RiemersmaDitherMethod) }
    assert_nothing_raised { @ilist.remap(remap_image, Magick::FloydSteinbergDitherMethod) }
    assert_raise(ArgumentError) { @ilist.remap(remap_image, Magick::NoDitherMethod, 1) }

    remap_image.destroy!
    assert_raise(Magick::DestroyedImageError) { @ilist.remap(remap_image) }
    # assert_raise(TypeError) { @ilist.affinity(affinity_image, 1) }
  end

  def test_to_blob
    @ilist.read(IMAGES_DIR + '/Button_0.gif')
    blob = nil
    assert_nothing_raised { blob = @ilist.to_blob }
    img = @ilist.from_blob(blob)
    assert_equal(@ilist[0], img[0])
    assert_equal(1, img.scene)
  end

  def test_write
    @ilist.read(IMAGES_DIR + '/Button_0.gif')
    assert_nothing_raised do
      @ilist.write('temp.gif')
    end
    list = Magick::ImageList.new('temp.gif')
    assert_equal('GIF', list.format)
    FileUtils.rm('temp.gif')

    @ilist.write('jpg:temp.foo')
    list = Magick::ImageList.new('temp.foo')
    assert_equal('JPEG', list.format)
    FileUtils.rm('temp.foo')

    @ilist.write('temp.0') { self.format = 'JPEG' }
    list = Magick::ImageList.new('temp.0')
    assert_equal('JPEG', list.format)
    FileUtils.rm('temp.0')

    f = File.new('test.0', 'w')
    @ilist.write(f) { self.format = 'JPEG' }
    f.close
    list = Magick::ImageList.new('test.0')
    assert_equal('JPEG', list.format)
    FileUtils.rm('test.0')
  end
end

if $PROGRAM_NAME == __FILE__
  IMAGES_DIR = '../doc/ex/images'
  FLOWER_HAT = IMAGES_DIR + '/Flower_Hat.jpg'
  Test::Unit::UI::Console::TestRunner.run(ImageList2UT)
end
