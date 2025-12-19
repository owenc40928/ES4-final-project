from PIL import Image 

# Correct image path
image_path = r'/Users/nicolasferrari/Downloads/loss.jpg'

# Output file path
output_file = r'/Users/nicolasferrari/Downloads/loss.txt'


image = Image.open(image_path).convert("RGB")

# RESIZE TO 32x32
image = image.resize((32, 32))

width, height = image.size

def rgb_to_2bit(rgb):
    return tuple(min(3, round(c / 85)) for c in rgb)

with open(output_file, "w") as f:
    for y in range(height):
        for x in range(width):
            rgb = image.getpixel((x, y))

            # 5 bit width and height
            y_bin = f"{y:05b}"
            x_bin = f"{x:05b}"

            coords_bin = y_bin + x_bin

            rgb_2bit = rgb_to_2bit(rgb)
            rgb_combined = f"{rgb_2bit[0]:02b}{rgb_2bit[1]:02b}{rgb_2bit[2]:02b}"

            #10 bits outpuit
            formatted_output = f'10\'b{coords_bin}: data = 6\'b{rgb_combined};'

            # Write to file
            f.write(formatted_output + "\n")

print("Done! Output saved to:", output_file)