from PIL import Image

data = [[0] * 28] * 28

with Image.open("5-18.jpg") as img:
    width, height = img.size
    rgbs = img.convert("RGB")
    for i in range(0, width, width / 28):
        for j in range(0, height, height / 28):
            r, g, b = rgbs.getpixel((i, j))
            if (r + g + b) / 3 > 256 / 6:
                data[i, j] = 1