const http = require('http');

const hostname = 'localhost';
const port = 3000;

const titulo = 'Actividad 1 - Jose Luis Rojas Bohorquez - Herramientas DevOps';
const parrafo = `Este trabajo describe el desarrollo de un proceso automatizado, utilizando Packer, para construir imágenes de máquinas virtuales reutilizables que contengan una aplicación Node.js configurada con Nginx como servidor web, destinadas al despliegue en plataformas de nube como Amazon AWS y Google Cloud Platform. El objetivo de esta actividad es crear una plantilla de Packer que permita a TechOps Solutions generar estas imágenes, facilitando despliegues en la nube, alineándose con el proyecto transversal de FinTech Solutions S.A.`;

const html = `
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${titulo}</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            text-align: center;
        }
        .container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            width: 95%;
            max-width: 960px;
        }
        h1 {
            color: #343a40;
            margin-bottom: 15px;
            font-size: 1.5rem;
        }
        p {
            color: #495057;
            line-height: 1.6;
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${titulo}</h1>
        <p>${parrafo}</p>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
`;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  res.end(html);
});

server.listen(port, hostname, () => {
  console.log(`Servidor corriendo en http://${hostname}:${port}/`);
});

