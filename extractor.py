import os

# Read the lat-long-altitude values from the file
with open('points.txt', "r") as file:
    lines = file.readlines()

# Create a list to store vertices
vertices = []
# Parse the lat-long-altitude triplets and create vertices
for line in lines:
    lat, long, alt = line.strip().split(",")
    lat = float(lat)
    long = float(long)
    alt = float(alt)
    vertices.append((long, lat, alt))

print(vertices)