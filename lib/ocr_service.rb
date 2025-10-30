# frozen_string_literal: true
require "tempfile"
require "open3"
require "tempfile"
require "open3"
require 'rmagick'
class OcrService

  @@locations_to_coordinates = {
    "temixco" => [18.85254, -99.22537],
    "cuernavaca" => [18.9261, -99.23075],
    "jiutepec" => [18.88139, -99.17778],
    "puente de ixtla" => [18.61472, -99.31806],
    "yautepec" => [18.88188, -99.06715],
    "zacatepec" => [18.65409, -99.18981],
    "xochitepec" => [18.7808, -99.23049]
  }
  def self.parse(file)
    filename = File.basename(file.path)
    im = Magick::Image.read(file.path)
    im[0].write(filename + ".jpg")

    # Ejecutar tesseract y capturar salida
    #
    stdout, stderr, status = Open3.capture3("tesseract #{filename + ".jpg"} stdout")
    raise "OCR failed: #{stderr}" unless status.success?

    text = stdout.downcase

    # Heurísticas básicas
    hectares = text[/(\d+(?:\.\d+)?)\s*hect[aá]reas?/, 1]&.to_f
    location = text[/((?:temixco|cuernavaca|jiutepec|puente de ixtla|yautepec|xochitepec))/i, 1] || "desconocida"
    confidence = 0.85
    coordinates =  @@locations_to_coordinates[location]
    lat = coordinates[0]
    lon = coordinates[1]

    {
      "raw_text" => text.strip,
      "hectares" => hectares || 0,
      "location_text" => location,
      "lat" => lat || 0,
      "lon" => lon || 0,
      "confidence" => confidence
    }
  ensure
    file.close!
    file.unlink
  end
end
