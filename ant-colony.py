import csv, pdb, math, random
import numpy as np

# Lista para armazenar as cidades
cidades = []

# Parâmetros do algoritmo
maxIteracoes = 2000
alfa = 2
beta = 2
melhorCaminho = []
taxaEvaporacao = 0.4
Q = 1

class Probabilidade:
    def __init__(self, cidade, chance):
        self.cidade = cidade
        self.chance = chance

    def __str__(self):
        return str(self.cidade) + "(" + str(self.chance) + "),"

class Cidade:
    def __init__(self, x, y):
        self.x = float(x)
        self.y = float(y)

    def __str__(self):
        return "x=" + str(self.x) + ",y=" + str(self.y)

class Formiga:
    def __init__(self, cidadeInicial):
        self.cidade = cidadeInicial
        self.cidadeAtual = cidadeInicial
        self.solucaoParcial = [cidadeInicial]
        self.tamanhoRota = 0
        self.probabilidades = []

    def distancia(self, cidade1, cidade2):
        # Calcula a distância euclidiana entre duas cidades
        return math.sqrt((cidade2.x - cidade1.x)**2 + (cidade2.y - cidade1.y)**2)

    def escolherCidade(self):
        self.probabilidades = []
        somatorio = 0
        for i in range(0, len(cidades)):
            if i not in self.solucaoParcial:
                somatorio += feromonio[self.cidade][i]**alfa * (1 / self.distancia(cidades[self.cidade], cidades[i])**beta)

        for i in range(0, len(cidades)):
            if i not in self.solucaoParcial:
                probabilidade = (feromonio[self.cidade][i]**alfa * (1 / self.distancia(cidades[self.cidade], cidades[i])**beta) / somatorio)
                self.probabilidades.append(Probabilidade(i, probabilidade))

        roleta = random.uniform(0, 1)
        somatorio = 0
        for i in range(0, len(self.probabilidades)):
            somatorio += self.probabilidades[i].chance
            if roleta < somatorio:
                self.tamanhoRota += self.distancia(cidades[self.cidadeAtual], cidades[self.probabilidades[i].cidade])
                self.solucaoParcial.append(self.probabilidades[i].cidade)
                self.cidadeAtual = self.probabilidades[i].cidade
                return i

# Leitura do arquivo CSV e criação das cidades
with open('Colonia.csv', newline='') as csvfile:
    leitor_csv = csv.reader(csvfile, delimiter=' ', quotechar='|')
    header = next(leitor_csv)
    for row in leitor_csv:
        x = row[0].split(';')[1].replace("['", "").replace("']", "")
        y = row[0].split(';')[2].replace("['", "").replace("']", "")
        cidades.append(Cidade(x, y))


# Inicialização da matriz de feromônio
feromonio = np.ones((len(cidades), len(cidades)))

menorRota = math.inf

# Loop principal do algoritmo
for iteracao in range(0, maxIteracoes):
    # Criação das formigas
    formigas = []
    for i in range(0, len(cidades)):
        formigas.append(Formiga(i))

    print("Iteração " + str(iteracao) + " - melhor:  " + str(menorRota))

    # Inicialização da matriz de delta de feromônio
    deltaFeromonio = np.zeros((len(cidades), len(cidades)))

    # Criar rota para cada formiga
    for c in range(0, len(cidades)):
        for formiga in formigas:
            formiga.escolherCidade()

    # Atualizar a melhor rota encontrada
    for formiga in formigas:
        if formiga.tamanhoRota < menorRota:
            menorRota = formiga.tamanhoRota
            melhorCaminho = formiga.solucaoParcial

    # Atualizar a matriz de delta de feromônio
    for formiga in formigas:
        for j in range(0, len(formiga.solucaoParcial) - 1):
            deltaFeromonio[formiga.solucaoParcial[j + 1]][formiga.solucaoParcial[j]] += Q / formiga.tamanhoRota

    # Atualizar a matriz de feromônio
    for i in range(0, len(cidades)):
        for j in range(0, len(cidades)):
            feromonio[i][j] = (1 - taxaEvaporacao) * feromonio[i][j] + deltaFeromonio[i][j]

# Exibir o melhor caminho encontrado
print("Menor rota: " + str(menorRota))

melhorCaminho = [cidade + 1 for cidade in melhorCaminho]
print("Melhor caminho: " + str(melhorCaminho))
