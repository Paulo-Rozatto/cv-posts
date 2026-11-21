#import "../../../templates/blueprint.typ": *
#import "cover.typ": *
#import "page02.typ": *

#blueprint-cover()

#pagebreak()

#blueprint-slide(
  tag: "02 / 06",
  title: "Convolução",
)[
  Uma imagem digital pode ser representada por três matrizes. Cada matriz guarda informações sobre a intensidade de uma cor : *vermelho*, *verde* e *azul* (*RGB*). Juntas, elas formam a imagem que vemos na tela.

  Cada matriz de cor é chamada de canal.

  #box(width: 100%, fill: graphite, inset: 80pt, radius: 5pt)[
    #align(center)[#standard-conv-hero()]
  ]

  

  Uma convolução padrão realiza duas tarefas ao mesmo tempo:

  - *Identifica padrões locais*, como bordas e texturas, ao percorrer pequenas regiões da imagem.

  - *Combina os canais*, usando informações de vermelho, verde e azul para gerar mapas de características.

  No exemplo, uma imagem RGB de $10 times 10 times 3$ é processada por dois filtros $3 times 3$, cada um abrangendo os três canais de entrada. O resultado são dois mapas de características de $8 times 8$.
]

#blueprint-slide(
  tag: "03 / 06",
  title: "Uma ideia antiga ainda em uso.",
)[
  A convolução não é uma novidade na inteligência artificial.

  Ela já era usada em redes neurais para reconhecer padrões em imagens no final dos anos 1980.

  #v(8pt)

  - *LeNet (1989)*: uma das arquiteturas pioneiras de redes convolucionais, capaz de reconhecer dígitos escritos à mão.

  - *AlexNet (2012)*: redes convolucionas profundas ganham destaque sendo o melhor método disponível para classificar objetos em imagens.

  #v(14pt)

  De lá para cá, surgiram novas abordagens, como os Vision Transformers (2021), que alcançaram resultados superiores em diversas tarefas de visão computacional.

  Mesmo assim, convoluções continuam presentes em modelos de ponta, especialmente em aplicações que exigem eficiência e processamento em tempo real.

  //E a ideia continua viva. Arquiteturas como a MobileNet usam convoluções para construir modelos de visão computacional mais eficientes.

  #v(20pt)

  #line(length: 100%, stroke: 2pt + volta)

  #v(14pt)


   _Mas eficiência não significa custo zero._
  #v(14pt)

Voltemos ao exemplo da página anterior.

- Para processar uma imagem de *10 × 10 × 3* com *2* filtros *3 × 3*, precisamos de *3.456 multiplicações*.

- Agora imagine uma imagem de *360 × 360 × 3*, processada por *128* filtros *3 × 3*. São aproximadamente *443 milhões de multiplicações*.
  
#v(20pt)

#line(length: 100%, stroke: 2pt + volta)

#v(14pt)

#text(fill: graphite, style: "italic",)[
Será que podemos separar as tarefas da convolução e reduzir esse custo computacional?
  ]


  // Mas existe um problema: o custo computacional.
// 
  // Uma convolução padrão faz duas coisas ao mesmo tempo:
// 
  // Varre a imagem para identificar padrões locais.
// 
  // Combina os canais para gerar os mapas de saída.
// 
  // Para uma convolução 3 × 3 com 256 canais de entrada e 256 de saída, são 589.824 multiplicações por posição.
// 

]

#blueprint-slide(
  tag: "04 / 06",
  title: "E se separássemos o trabalho em dois?",
)[
  A convolução separável em profundidade divide a operação padrão em duas etapas:

  - *Depthwise:* um filtro percorre cada canal separadamente, identificando padrões espaciais sem misturar os canais.
  - *Pointwise:* filtros 1 × 1 combinam as informações dos canais para gerar os mapas de saída.

  #box(width: 100%, fill: graphite, inset: 80pt, radius: 5pt)[
    #align(center)[#depthwise-hero-v2()]
  ]

  No nosso exemplo, a convolução padrão realiza *3.456 multiplicações*. Com a separação das etapas, são *1.728 na Depthwise* e *384 na Pointwise*, totalizando *2.112 multiplicações*. Isso representa uma redução de aproximadamente *39%*.

  A diferença fica ainda maior em imagens maiores. Para uma imagem de 360 × 360 × 3, com 128 filtros de saída, o número de multiplicações cai de aproximadamente *443 milhões* para *52,7 milhões*. Isso é uma redução de *88,1%*.
]


#pagebreak()

#blueprint-slide(
  tag: "05 / 06",
  title: "Nem tudo são vantagens.",
)[
  A convolução separável reduz o número de operações, mas essa economia traz algumas limitações.

  #v(12pt)

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 18pt,
    [
      *Custo 1 — Capacidade de representação*

      A convolução separável não é matematicamente equivalente à convolução padrão.
      
      Sua estrutura impõe restrições aos filtros que podem ser representados, reduzindo sua capacidade de representação.

      Dependendo da tarefa e da arquitetura, isso pode resultar em perda de acurácia.

    ],
    [
      *Custo 2 — Desempenho na prática*

      Menos multiplicações não significam necessariamente menor tempo de execução.
      
      O acesso à memória e a eficiência das operações no hardware também influenciam a latência.

      O trabalho *FreeNet* (AAAI 2025) mostra como convoluções depthwise podem ser menos eficientes na prática do que seu baixo número de FLOPs sugere.
    ],
  )

  #v(16pt)

  #line(length: 100%, stroke: 2pt + volta)

  #v(12pt)


*Mesmo assim, a técnica continua em uso.*

- *2MCD-YOLO11 (2026):* combina MobileNetV4 e convoluções depthwise separáveis para reconhecimento de gestos com as mãos em dispositivos móveis, atingindo até *159,7 FPS* em desktop e *61 FPS* em dispositivos móveis.

- *HBMF-YOLO (2026):* combina MobileNetV4 e YOLO11 para detecção de objetos em direção autônoma, com foco em condições adversas, como chuva, neblina e baixa iluminação, utilizando hardware embarcado.



]



#pagebreak()

#blueprint-slide(
  tag: "06 / 06",
  title: "Referências.",
)[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 8pt,
    [
      *LeCun et al. (1989)*

      *Handwritten Digit Recognition with a Back-Propagation Network*

      Um dos primeiros trabalhos a demonstrar o potencial das redes convolucionais para o reconhecimento de imagens.

      #link("https://papers.nips.cc/paper/1989/hash/53c3bce66e43be4f209556518c2fcb54-Abstract.html")[Acessar artigo]

      //#v(8pt)

      *Krizhevsky et al. (2012)*

      *ImageNet Classification with Deep Convolutional Neural Networks*

      O AlexNet popularizou as redes convolucionais profundas ao alcançar resultados expressivos na classificação de imagens.

      #link("https://proceedings.neurips.cc/paper/2012/hash/c399862d3b9d6b76c8436e924a68c45b-Abstract.html")[Acessar artigo]

      //#v(16pt)

      *Qin et al. (2024)*

      *MobileNetV4: Universal Models for the Mobile Ecosystem*

      Apresenta arquiteturas eficientes para dispositivos móveis, incluindo o uso de convoluções depthwise.
      
      #link("https://doi.org/10.1007/978-3-031-73661-2_5")[Acessar artigo]
    ],
    [
      *Yu et al. (2025)*

      *FreeNet: Liberating Depth-Wise Separable Operations for Building Faster Mobile Vision Architectures*

      Discute limitações de desempenho das operações depthwise na prática.

      #link("https://doi.org/10.1609/aaai.v39i9.33041")[Acessar artigo]

      //#v(10pt)

      *Feng et al. (2026)*

      *2MCD-YOLO11: A Lightweight Algorithm Based on Cross-Scale Feature Fusion for Gesture Recognition*

      Aplica convoluções separáveis ao reconhecimento de gestos com as mãos em tempo real em dispositivos móveis.

      #link("https://doi.org/10.1007/s11227-026-08296-w")[Acessar artigo]

      //#v(10pt)

      *Yang et al. (2026)*

      *HBMF-YOLO: Target Detection in Harsh Environments Based on a Hybrid Backbone Network and Multi-Feature Fusion*

      Aplica arquiteturas eficientes à detecção de objetos em condições adversas, com foco em aplicações de direção autônoma.

      #link("https://doi.org/10.1016/j.imavis.2026.105958")[Acessar artigo]
    ],
  )
]
