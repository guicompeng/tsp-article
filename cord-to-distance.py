import math

def convert_to_radians(value):
    PI = 3.141592
    deg = int(value)
    min_part = value - deg
    rad = PI * (deg + 5.0 * min_part / 3.0) / 180.0
    return rad

def calculate_distance(lat1, lon1, lat2, lon2):
    RRR = 6378.388
    q1 = math.cos(lon1 - lon2)
    q2 = math.cos(lat1 - lat2)
    q3 = math.cos(lat1 + lat2)
    dij = int(RRR * math.acos(0.5 * ((1.0 + q1) * q2 - (1.0 - q1) * q3)) + 1.0)
    return dij

def main():
    # Entrada dos dados
    data = [
       (1, 38.24, 20.42),
   (2, 39.57, 26.15),
   (3, 40.56, 25.32),
   (4, 36.26, 23.12),
   (5, 33.48, 10.54),
   (6, 37.56, 12.19),
   (7, 38.42, 13.11),
   (8, 37.52, 20.44),
   (9, 41.23, 9.10),
   (10, 41.17, 13.05),
   (11, 36.08, -5.21),
   (12, 38.47, 15.13),
   (13, 38.15, 15.35),
   (14, 37.51, 15.17),
   (15, 35.49, 14.32),
   (16, 39.36, 19.56),
   (17, 38.09, 24.36),
   (18, 36.09, 23.00),
   (19, 40.44, 13.57),
   (20, 40.33, 14.15),
   (21, 40.37, 14.23),
   (22, 37.57, 22.56),
   (23, 36.41, 16.51),
   (24, 38.34, 20.80)
    ]
    
    # Convertendo coordenadas para radianos
    coords = [(idx, convert_to_radians(lat), convert_to_radians(lon)) for idx, lat, lon in data]
    
    # Calculando distâncias
    distances = []
    for i in range(len(coords)):
        for j in range(len(coords)):
            if i != j:
                idx1, lat1, lon1 = coords[i]
                idx2, lat2, lon2 = coords[j]
                dij = calculate_distance(lat1, lon1, lat2, lon2)
                distances.append((idx1, idx2, dij))
    
    # Saída dos resultados
    for d in distances:
        print(f"{d[0]:2d} {d[1]:2d} {d[2]:5d}")

if __name__ == "__main__":
    main()