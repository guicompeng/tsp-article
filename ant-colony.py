import csv, math, random
import numpy as np

# Lista para armazenar as cidades
cidades = []

# Parâmetros do algoritmo
maxIteracoes = 2000
alfa = 1
beta = 1
taxaEvaporacao = 0.5
Q = 1
melhorCaminho = []

def convert_to_radians(value):
    PI = 3.141592
    deg = int(value)
    min_part = value - deg
    rad = PI * (deg + 5.0 * min_part / 3.0) / 180.0
    return rad


class Cidade:
    def __init__(self, x, y):
        self.x = float(x)
        self.y = float(y)

class Formiga:
    def __init__(self, cidadeInicial):
        self.cidadeInicial = cidadeInicial
        self.cidadeAtual = cidadeInicial
        self.solucaoParcial = [cidadeInicial]
        self.tamanhoRota = 0
        

    def distancia(self, cidade1, cidade2):
        lat1 = convert_to_radians(cidade1.x)
        lon1 = convert_to_radians(cidade1.y)
        lat2 = convert_to_radians(cidade2.x)
        lon2 = convert_to_radians(cidade2.y)
        
        RRR = 6378.388
        q1 = math.cos(lon1 - lon2)
        q2 = math.cos(lat1 - lat2)
        q3 = math.cos(lat1 + lat2)
        dij = int(RRR * math.acos(0.5 * ((1.0 + q1) * q2 - (1.0 - q1) * q3)) + 1.0)
        return dij

    def escolherCidade(self):
        probabilidades = []
        somatorio = 0
        for i in range(len(cidades)):
            if i not in self.solucaoParcial:
                valor = feromonio[self.cidadeAtual][i]**alfa * (1 / self.distancia(cidades[self.cidadeAtual], cidades[i])**beta)
                probabilidades.append((i, valor))
                somatorio += valor
        
        if not probabilidades:
            return
        
        roleta = random.uniform(0, somatorio)
        acumulado = 0
        for cidade, prob in probabilidades:
            acumulado += prob
            if roleta <= acumulado:
                self.tamanhoRota += self.distancia(cidades[self.cidadeAtual], cidades[cidade])
                self.solucaoParcial.append(cidade)
                self.cidadeAtual = cidade
                return

    def completarCiclo(self):
        if len(self.solucaoParcial) == len(cidades):
            self.tamanhoRota += self.distancia(cidades[self.cidadeAtual], cidades[self.cidadeInicial])
            self.solucaoParcial.append(self.cidadeInicial)

# Leitura do arquivo CSV e criação das cidades
with open('Colonia.csv', newline='') as csvfile:
    leitor_csv = csv.reader(csvfile, delimiter=' ', quotechar='|')
    next(leitor_csv)
    for row in leitor_csv:
        x, y = row[0].split(';')[1:3]
        cidades.append(Cidade(x, y))

# Inicialização da matriz de feromônio
feromonio = np.ones((len(cidades), len(cidades)))
menorRota = math.inf

# Loop principal do algoritmo
for iteracao in range(maxIteracoes):
    formigas = [Formiga(i) for i in range(len(cidades))]
    deltaFeromonio = np.zeros((len(cidades), len(cidades)))
    
    for formiga in formigas:
        while len(formiga.solucaoParcial) < len(cidades):
            formiga.escolherCidade()
        formiga.completarCiclo()
        
        if formiga.tamanhoRota < menorRota:
            menorRota = formiga.tamanhoRota
            melhorCaminho = formiga.solucaoParcial[:]
        
        for j in range(len(formiga.solucaoParcial) - 1):
            deltaFeromonio[formiga.solucaoParcial[j]][formiga.solucaoParcial[j + 1]] += Q / formiga.tamanhoRota
    
    # Atualização do feromônio
    feromonio = (1 - taxaEvaporacao) * feromonio + deltaFeromonio
    
    print(f"Iteração {iteracao} - Melhor Rota: {menorRota}")

# Exibição do melhor caminho encontrado
print(f"Rota aproximada encontrada: {menorRota}")
print(f"Caminho: {[cidade + 1 for cidade in melhorCaminho]}")
