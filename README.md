# BubbleChat con CoreGraphics
Core Graphics es el framework de dibujo vectorial de iOS. Al principio puede resultar intimidante, pero con él puedes personalizar tus interfaces con efectos interesantes y atractivos, pudiendo prescindir de un diseñador que te proporcione los recursos.

Core Graphics es API muy potente y, en algunos casos, compleja, pero que en ciertos contextos compensa el tiempo invertido. Por ejemplo, si tu aplicación consume bastante memoria, o tiene vistas muy pesadas, dibujar algunos de sus componentes, en vez de cargar una imagen, puede resultar interesante para ir reduciendo poco a poco el gasto de recursos. Tener en memoria cada pixel consume mucho más que unas cuantas líneas de código. Con Core Graphics, lo que creas es independiente de la resolución del dispositivo, por lo que no tendrás que preocuparte de en qué pantalla se vaya a mostrar, actuales o futuras, dado que siempre se verá nítido. Pero no todo es positivo, el tiempo y trabajo extra que conlleva el dibujar una vista, frente a cargar una imagen, a veces no es una opción viable. Además, vistas con formas complejas pueden convertirse en un infierno, no solo por el tiempo que tengas que invertir en ellas, sino porque puede llegar a necesitar mucho código, y para nada trivial.

Una consideración a tener en cuenta a la hora de elegir Core Graphics es si tu vista va a ser estática o va a tener que moverse o redibujarse constantemente. Si tu caso es el segundo, otras opciones, como Core Animation, optimizado para que sea la GPU, y no la CPU, la que se encargue de la mayor parte del procesamiento, pueden resultarte más interesantes.

## Dibujo de la burbuja

Primero crea un fichero que sea subclase de UIView y reescribe el método drawRect:(CGRect)rect{}. Puedes añadir esta clase como controladora de un UIView en InterfaceBuilder, o añadir la vista como subvista de otra por código. 
El siguiente bloque corresponde con mi implementación del drawRect:.
```objective-c
CGContextRef context = UIGraphicsGetCurrentContext();
CGContextBeginPath(context);
CGContextSetLineWidth(context, self.borderWidth);
CGContextMoveToPoint(context, rect.origin.x + (2 * cornerRadious), rect.origin.y + cornerRadious);
// Superior-left corner
CGContextAddQuadCurveToPoint(context, rect.origin.x + cornerRadious, rect.origin.y + cornerRadious,rect.origin.x + cornerRadious, rect.origin.y + (2 * cornerRadious));
//Inferior-left corner
[self drawInferiorLeftCornerInContext:context withRect:rect];
CGContextAddLineToPoint(context, rect.size.width - (2 * cornerRadious), rect.size.height - 2 * cornerRadious);

//Inferior-right corner
CGContextAddQuadCurveToPoint(context, rect.size.width - cornerRadious, rect.size.height - 2 * cornerRadious, rect.size.width - cornerRadious, rect.size.height - 3 * cornerRadious);
    
CGContextAddLineToPoint(context, rect.size.width - cornerRadious, rect.origin.y + (2 * cornerRadious));
//Superior-right corner
CGContextAddQuadCurveToPoint(context, rect.size.width - cornerRadious, rect.origin.y + cornerRadious, rect.size.width - (2 * cornerRadious), rect.origin.y + cornerRadious);
    
CGContextClosePath(context);
//CGContextStrokePath(context);
[self paintBubbleInContext:context];
```
(1)Al estar reescribiendo el drawRect:, se te proporciona un contexto, no hace falta crear uno nuevo.

(2)Todo lo que hagas hay que ir añadiéndolo a un Path, este es fácil imaginárselo como un conjunto de puntos y que a la hora de dibujarlo se va avanzando por ellos, uniéndolos.

(3)Seteas el ancho de las lineas que vas a dibujar

(4)Inicialmente, tienes que colocarte en algún punto desde el que comenzar a dibujar, yo he decidido ponerme en la esquina superior izquierda, antes de la curva de la esquina. Todo lo que vayas añadiendo se colocará a continuación de lo anterior, siempre que no cierres el Path actual. Por eso no hace falta definir el punto inicial de todos los elementos, solo el final. También es importante recalcar que lo que se va añadiendo a un Path no se va dibujando. Lo hace cuando le indica que lo haga, pero ya llegaremos a eso.

(5)Las curvas de las esquinas se definen con un punto de control y un punto final. Cuanto más alejes el punto de control del origen y destino, más aguda será la curva creada.

![puntoControl](http://aluxion.com/blog/wp-content/uploads/2016/02/movida-272x300.png)

(6)La siguiente esquina, como decidí que podía tener diferentes diseños, la he metido en una función aparte para mantener la legibilidad del código.

El resto es repetición de lo anterior, avanzar hasta el siguiente punto y hacer la curva de la esquina correspondiente.

(10)Para finalizar, CGContextClosePath añade una linea desde el punto actual hasta el origen y cierra el Path.

Dibujar la esquina de la burbuja con forma de pico tiene mayor complejidad que tu quieras darle, puedes hacer curvas más estilizadas, o lineas rectas. Yo opté por hacer las que se muestran en la imagen, siempre puedes crearte otras con la forma que te guste.

![Esquinas](http://aluxion.com/blog/wp-content/uploads/2016/02/Untitled.png)

Una vez has creado tu bocadillo, ya puedes dibujarlo. Si quieres que se dibuje una linea describiendo el contorno de tu figura, CGContextStrokePath() dibujará una linea del ancho y color que le hayas definido anteriormente a lo largo del Path. Si, por el contrario, lo que quieres es rellenarlo de color, CGContextFillPath() pintará el area de tu Path del color especificado. Es importante tener en cuenta que en el momento que se dibuja un Path, se elimina. Por lo que si quieres colorear el path y también añadirle un borde, no puedes llamar a una función y después la otra. Para esto existe la función CGContextDrawPath(CGContextRef c, CGPathDrawingMode mode), pasándole como modo kCGPathFillStroke.

Finalmente, y aunque no esté directamente relacionado con Core Graphics, normalmente querrás girarlo hacia la persona que habla. Para eso se le aplica una transformación a la vista, creando su reflejo. Puedes aplicar la misma transformación a todas las subvistas de tu burbuja para que solo se refleje este, y no todo lo que contiene.
```objective-c
self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        for (UIView *view in self.subviews) {
            view.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        }
```
Esto es todo. Como habrás visto, no es complicado, todo depende de lo que quieras hacer. En el proyecto de ejemplo que incluyo está todo el código y un par de ejemplos muy sencillos. Espero que te haya resultado de interés y utilidad.
Paz