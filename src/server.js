// Require Module
const cookieParser = require('cookie-parser')
const express = require('express')
const mongoose = require('mongoose')
const bodyParser = require('body-parser')
const path = require('path')
const app = express()

// Require Routes
const authRoutes = require('./routes/authRoutes')
const profileRoutes = require('./routes/profileRoutes');
const { requireAuth, checkUser} = require('./middleware/authMiddleware')
const Account = require('./models/Account')

// Database connection
mongoose.connect('mongodb+srv://admin:123@happinovel.4zvtpnj.mongodb.net/HappiNovel?retryWrites=true&w=majority', {
    useNewUrlParser: true,
});
const db = mongoose.connection;
db.on("error", console.error.bind(console, "Connection error: "));
db.once("open", function () {
    console.log("Connected successfully");
});
// mongoose.connect('mongodb://0.0.0.0:27017/HappiNovel', {
//     useNewUrlParser: true,
// });

// Serve images from the Image folder
app.use('/images', express.static(path.join(__dirname, 'database/ProfileCover')));
app.use('/imagesAvatar', express.static(path.join(__dirname, 'database/Avatar')));

// Use and Set Module
app.use(express.static(path.join(__dirname, './public')))
app.set('views', path.join(__dirname, './views'))
app.set('view engine', 'ejs');
app.use(express.json())
app.use(cookieParser())
app.use(bodyParser.urlencoded({extended: true}))
app.use(authRoutes)
app.use(profileRoutes)


// Routes
app.get('*', checkUser);
app.get("/", (req, res) => res.render('home'));
app.get("/upload", requireAuth, (req, res) => res.render('upload'));
app.get("/profile", requireAuth, (req, res) => res.render('profile'));


// Listen
const port = 3000
app.listen(port, function(){
    console.log(`Server started on port ${port}`);
});