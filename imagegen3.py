from PIL import Image 

image_path = r'/Users/nicolasferrari/Downloads/winner.png' 
output_file = r'/Users/nicolasferrari/Downloads/winner.txt'

image = Image.open(image_path).convert("RGB")

# 1. RESIZE TO 160x120 (4x Scaling)
image = image.resize((160, 120))

width, height = image.size
print(f"Generating 4x code: {width}x{height}")

def rgb_to_2bit(rgb):
    return tuple(min(3, round(c / 85)) for c in rgb)

with open(output_file, "w") as f:
    for y in range(height):
        for x in range(width):
            rgb = image.getpixel((x, y))

            # 2. UPDATE BIT WIDTHS
            # Width 160 needs 8 bits (0-159)
            # Height 120 needs 7 bits (0-119)
            y_bin = f"{y:07b}" 
            x_bin = f"{x:08b}" 

            coords_bin = y_bin + x_bin
            
            rgb_2bit = rgb_to_2bit(rgb)
            rgb_combined = f"{rgb_2bit[0]:02b}{rgb_2bit[1]:02b}{rgb_2bit[2]:02b}"

            # 3. TAG IS NOW 15 BITS (8+7)
            formatted_output = f'15\'b{coords_bin}: data = 6\'b{rgb_combined};'

            f.write(formatted_output + "\n")

print("Done! 19,200 lines generated.")