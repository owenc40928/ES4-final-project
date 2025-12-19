from PIL import Image 

image_path = r'/Users/nicolasferrari/Downloads/jackpotfinal.jpg' # Update if needed
output_file = r'/Users/nicolasferrari/Downloads/jackpotfinal.txt'

image = Image.open(image_path).convert("RGB")

# Resize to 80x60, 4x3 aspect ratio
image = image.resize((80, 60))

width, height = image.size

def rgb_to_2bit(rgb):
    return tuple(min(3, round(c / 85)) for c in rgb)

with open(output_file, "w") as f:
    for y in range(height):
        for x in range(width):
            rgb = image.getpixel((x, y))

        
            y_bin = f"{y:06b}" # 6 bits for Y
            x_bin = f"{x:07b}" # 7 bits for X 

            coords_bin = y_bin + x_bin
            
            rgb_2bit = rgb_to_2bit(rgb)
            rgb_combined = f"{rgb_2bit[0]:02b}{rgb_2bit[1]:02b}{rgb_2bit[2]:02b}"

            # must be 13'b
            formatted_output = f'13\'b{coords_bin}: data = 6\'b{rgb_combined};'

            f.write(formatted_output + "\n")

print(f"Done! {width}x{height} image processed.")