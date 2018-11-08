# Copyright 2016 Google, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "uri"

def detect_faces image_path:
  # [START vision_face_detection]
  # image_path = "Path to local image file, eg. './image.png'"

  require "google/cloud/vision"

  image_annotator = Google::Cloud::Vision::ImageAnnotator.new

  content = File.binread image_path
  image = { content: content }
  feature = { type: :FACE_DETECTION }
  request = { image: image, features: [feature] }

  response = image_annotator.batch_annotate_images([request])
  response.responses.each do |res|
    res.face_annotations.each do |face|
      puts "Joy:      #{face.joy_likelihood}"
      puts "Anger:    #{face.anger_likelihood}"
      puts "Sorrow:   #{face.sorrow_likelihood}"
      puts "Surprise: #{face.surprise_likelihood}"
    end
  end
  # [END vision_face_detection]
end

# This method is a duplicate of the above method, but with a different
# description of the 'image_path' variable, demonstrating the gs://bucket/file
# GCS storage URI format.
def detect_faces_gcs image_path:
  # [START vision_face_detection_gcs]
  # image_path = "Google Cloud Storage URI, eg. 'gs://my-bucket/image.png'"

  require "google/cloud/vision"

  image_annotator = Google::Cloud::Vision::ImageAnnotator.new

  source = { gcs_image_uri: image_path }
  image = { source: source }
  feature = { type: :FACE_DETECTION }
  request = { image: image, features: [feature] }

  response = image_annotator.batch_annotate_images([request])
  response.responses.each do |res|
    res.face_annotations.each do |face|
      puts "Joy:      #{face.joy_likelihood}"
      puts "Anger:    #{face.anger_likelihood}"
      puts "Sorrow:   #{face.sorrow_likelihood}"
      puts "Surprise: #{face.surprise_likelihood}"
    end
  end
  # [END vision_face_detection_gcs]
end

if __FILE__ == $PROGRAM_NAME
  image_path = ARGV.shift

  unless image_path
    return puts <<-USAGE
    Usage: ruby detect_faces.rb [image file path]

    Example:
      ruby detect_faces.rb image.png
      ruby detect_faces.rb https://public-url/image.png
      ruby detect_faces.rb gs://my-bucket/image.png
    USAGE
  end
  if image_path =~ URI::DEFAULT_PARSER.make_regexp
    return detect_faces_gs image_path: image_path
  end

  detect_faces image_path: image_path
end
