<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Oguzhan_Sarigol_HW4.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet" />
    <!-- Three.js ana kütüphanesi -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <!-- GLTF Loader - 3D modelleri yüklemek için gerekli -->
    <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/GLTFLoader.js"></script>
    <!-- OrbitControls - kolay mouse kontrolü için -->
    <script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/controls/OrbitControls.js"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', sans-serif;
            background-color: #ffffff;
        }
        .container {
            display: flex;
            height: 100vh;
        }
        .image-side {
            flex: 1;
            background-color: #0d1b28; /* Koyu mavi arka plan rengi */
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .doctor-image {
            height: 100%;
            object-fit: cover;
            object-position: center;
        }
        .form-side {
            flex: 1;
            background-color: #f8f9fa; /* Açık gri arka plan */
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: #000000;
            position: relative;
        }
        .login-box {
            width: 80%;
            max-width: 350px;
            margin-top: 60px; /* 3D objeye yer açmak için biraz aşağı itiyorum */
        }
        h2 {
            margin-bottom: 10px;
            font-weight: 500;
            font-family: 'Roboto', sans-serif;
        }   
        h2:first-of-type {
            margin-bottom: 5px;
        }
        h2:nth-of-type(2) {
            margin-top: 0;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 28px;
        }
        input[type="text"], input[type="password"], .btn-login {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
       .btn-login {
            background-color: #000000;
            color: white;
            font-weight: bold;
            cursor: pointer;
            outline: none;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            text-align: center;
            font-family: 'Roboto', sans-serif;
        }
        .error-message {
            color: red;
            font-size: 13px;
            margin-top: 5px;
        }
        #model3DContainer {
            position: absolute;
            top: 100px;
            width: 200px;
            height: 200px;
            cursor: pointer;
        }
        .loading-text {
            position: absolute;
            top: 150px;
            color: #0077cc;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="image-side">
                <img src="Content/login-image.png" alt="Doctor" class="doctor-image" />
            </div>
            <div class="form-side">
                <!-- 3D modelin konteyneri -->
                <div id="model3DContainer"></div>
                <div id="loadingText" class="loading-text">3D Model yükleniyor...</div>
                
                <div class="login-box">
                    <h2>Hello !</h2>
                    <h2>Welcome Back</h2>
                    <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter Username" CssClass="form-input" />
                    <asp:TextBox ID="txtPassword" runat="server" placeholder="Enter Password" TextMode="Password" CssClass="form-input" />
                    
                    <asp:Label ID="lblError" runat="server" CssClass="error-message" />
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />
                </div>
            </div>
        </div>
    </form>

    <script>
        // Three.js değişkenleri
        let scene, camera, renderer, controls;
        let loadingManager = new THREE.LoadingManager();

        // Yükleme işlemi bittiğinde tetiklenecek fonksiyon
        loadingManager.onLoad = function () {
            document.getElementById('loadingText').style.display = 'none';
        };

        // Yükleme hatası durumunda
        loadingManager.onError = function (url) {
            document.getElementById('loadingText').textContent = '3D Model yüklenemedi!';
            console.error('Model yüklenirken hata oluştu:', url);
        };

        // Üç boyutlu sahneyi başlat
        init();
        animate();

        function init() {
            // Sahne oluştur
            scene = new THREE.Scene();

            // Kamera oluştur
            camera = new THREE.PerspectiveCamera(75, 1, 0.1, 1000);
            camera.position.z = 5;

            // Renderer oluştur (sahnedeki 3D objeleri ekrana çizecek)
            const container = document.getElementById('model3DContainer');
            renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
            renderer.setClearColor(0x000000, 0); // Şeffaf arkaplan
            renderer.setSize(container.clientWidth, container.clientHeight);
            container.appendChild(renderer.domElement);

            // OrbitControls ekle (fare ile döndürme, yakınlaştırma için)
            controls = new THREE.OrbitControls(camera, renderer.domElement);
            controls.enableDamping = true; // Daha yumuşak animasyonlar için
            controls.dampingFactor = 0.25;
            controls.enableZoom = false; // Yakınlaştırmayı kapatabilirsiniz
            controls.autoRotate = true; // Otomatik dönme efekti
            controls.autoRotateSpeed = 3.0;

            // Işıklar ekle (3D modelinizi aydınlatmak için gerekli)
            // Ortam ışığı
            const ambientLight = new THREE.AmbientLight(0xffffff, 0.7);
            scene.add(ambientLight);

            // Yön ışığı
            const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
            directionalLight.position.set(1, 1, 1);
            scene.add(directionalLight);

            // 3D Modeli yükle
            const loader = new THREE.GLTFLoader(loadingManager);
            loader.load(
                'Content/mymodel.glb',  // 3D model dosya yolu - bunu kendi modelinize göre değiştirin
                function (gltf) {
                    const model = gltf.scene;

                    // Modeli uygun boyuta getir
                    const box = new THREE.Box3().setFromObject(model);
                    const size = box.getSize(new THREE.Vector3()).length();
                    const scale = 7.5 / size;  // Bu sayıyı modelin boyutuna göre ayarlayabilirsiniz

                    model.scale.set(scale, scale, scale);

                    // Modeli merkeze yerleştir
                    const offset = box.getCenter(new THREE.Vector3()).multiplyScalar(-1);
                    model.position.copy(offset);

                    // Sahneye ekle
                    scene.add(model);
                },
                // Yükleme durumunu göster
                function (xhr) {
                    const percentComplete = Math.round((xhr.loaded / xhr.total) * 100);
                    document.getElementById('loadingText').textContent = `3D Model yükleniyor... ${percentComplete}%`;
                },
                // Hata durumunu işle
                function (error) {
                    console.error('Model yüklenirken hata oluştu:', error);
                    document.getElementById('loadingText').textContent = '3D Model yüklenemedi!';
                }
            );

            // Sayfa yeniden boyutlandığında 3D görünümü ayarla
            window.addEventListener('resize', onWindowResize, false);
        }

        function animate() {
            requestAnimationFrame(animate);

            // Controls'u güncelle
            controls.update();

            // Sahneyi render et
            renderer.render(scene, camera);
        }

        function onWindowResize() {
            const container = document.getElementById('model3DContainer');
            camera.aspect = container.clientWidth / container.clientHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(container.clientWidth, container.clientHeight);
        }
    </script>
</body>
</html>