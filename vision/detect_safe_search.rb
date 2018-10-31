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

def detect_safe_search image_path:
  # [START vision_safe_search_detection]
  # image_path = "Path to local image file, eg. './image.png'"

  require "google/cloud/vision"

  vision = Google::Cloud::Vision.new
  content = File.binread image_path
  image = { content: content }
  type = :SAFE_SEARCH_DETECTION
  feature = { type: type }
  request = { image: image, features: [feature] }
  # request == {
  #   image: {
  #     content: (File.binread image_path)
  #   },
  #   features: [
  #     {
  #       type: :SAFE_SEARCH_DETECTION
  #     }
  #   ]
  # }
  response = vision.batch_annotate_images([request])
  response.responses.each do |res|
    safe_search = res.safe_search_annotation

    puts "Adult:    #{safe_search.adult}"
    puts "Spoof:    #{safe_search.spoof}"
    puts "Medical:  #{safe_search.medical}"
    puts "Violence: #{safe_search.violence}"
  end
  # [END vision_safe_search_detection]
end

# This method is a duplicate of the above method, but with a different
# description of the 'image_path' variable, demonstrating the gs://bucket/file
# GCS storage URI format.
def detect_safe_search_gcs image_path:
  # [START vision_safe_search_detection_gcs]
  # image_path = "Google Cloud Storage URI, eg. 'gs://my-bucket/image.png'"

  require "google/cloud/vision"

  vision = Google::Cloud::Vision.new
  source = { gcs_image_uri: image_path }
  image = { source: source }
  type = :SAFE_SEARCH_DETECTION
  feature = { type: type }
  request = { image: image, features: [feature] }
  # request == {
  #   image: {
  #     source: {
  #       gcs_image_uri: image_path
  #     }
  #   },
  #   features: [
  #     {
  #       type: :SAFE_SEARCH_DETECTION
  #     }
  #   ]
  # }
  response = vision.batch_annotate_images([request])
  response.responses.each do |res|
    safe_search = res.safe_search_annotation

    puts "Adult:    #{safe_search.adult}"
    puts "Spoof:    #{safe_search.spoof}"
    puts "Medical:  #{safe_search.medical}"
    puts "Violence: #{safe_search.violence}"
  end
  # [END vision_safe_search_detection_gcs]
end

if $PROGRAM_NAME == __FILE__
  require "uri"

  image_path = ARGV.shift

  unless image_path
    return puts <<-USAGE
    Usage: ruby detect_safe_search.rb [image file path]

    Example:
      ruby detect_safe_search.rb image.png
      ruby detect_safe_search.rb https://public-url/image.png
      ruby detect_safe_search.rb gs://my-bucket/image.png
    USAGE
  end
  if image_path =~ URI::DEFAULT_PARSER.new.make_regexp
    return detect_safe_search_gs image_path: image_path
  end

  detect_safe_search image_path: image_path
end
