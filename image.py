from PIL import Image 

# Correct image path
image_path = r'C:\Users\owenc\Documents\ES4\imagereadin\back.png'

# Output file path (saved in same folder as script unless you give full path)
output_file = r'C:\Users\owenc\Documents\ES4\imagereadin\bakground.txt'

# Load the image and force RGB mode
image = Image.open(image_path).convert("RGB")

width, height = image.size

# Convert RGB value to 2-bit per channel
def rgb_to_2bit(rgb):
    return tuple(min(3, round(c / 85)) for c in rgb)

# Open text file for writing
with open(output_file, "w") as f:
    for y in range(height):
        for x in range(width):
            rgb = image.getpixel((x, y))

            # 5-bit binary coords
            y_bin = f"{y:06b}"
            x_bin = f"{x:06b}"

            coords_bin = y_bin + x_bin

            rgb_2bit = rgb_to_2bit(rgb)
            rgb_combined = f"{rgb_2bit[0]:02b}{rgb_2bit[1]:02b}{rgb_2bit[2]:02b}"

            formatted_output = f'12\'b{coords_bin}: data = 6\'b{rgb_combined};'

            # Write to file
            f.write(formatted_output + "\n")

print("Done! Output saved to:", output_file)
