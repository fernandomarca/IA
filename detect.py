import json
import os
import sys
import time
import cv2
import matplotlib.pyplot as plt


def show(caminho):
    imagem = cv2.imread(caminho)
    fig = plt.gcf()
    fig.set_size_inches(18, 10)
    plt.axis('off')
    plt.imshow(cv2.cvtColor(imagem, cv2.COLOR_BGR2RGB))
    plt.show()


def detect(obj_file, cfg_file, weights_file, image_name, thresh=0.9):
    if not (obj_file and obj_file.strip()):
        os.system(
            "./darknet detect {} {} {} -thresh {} -ext_output".format(cfg_file, weights_file, image_name, thresh))
        # show('predictions.jpg')

    os.system(
        "./darknet detector test {} {} {} {} -thresh {} -ext_output".format(obj_file, cfg_file, weights_file, image_name, thresh))
    # show('predictions.jpg')


if __name__ == "__main__":
    with open('config.json') as f:
        data = json.load(f)
    weights_file = data['weights_file']
    cfg_file = data['cfg_file']
    obj_file = data['obj_file']

    image_name = sys.argv[1]
    detect(obj_file, cfg_file, weights_file, image_name)
    split_name = image_name.split("/")
    os.system(
        "cp predictions.jpg results/{}-{}".format(time.time(), split_name[1]))


# diretorio_fotos = 'fotos_teste'
# caminhos = [os.path.join(diretorio_fotos, f) for f in os.listdir(diretorio_fotos)]
# print(caminhos)
# for caminho_imagem in caminhos:
#   try:
#     imagem = cv2.imread(caminho_imagem)
#     (H, W) = imagem.shape[:2]
#   except:
#     print('Erro ao carregar a imagem -> ' + caminho_imagem)
#     continue
