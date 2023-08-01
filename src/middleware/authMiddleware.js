const jwt = require('jsonwebtoken');
const Account = require('../models/Account');

const requireAuth = (req, res, next) => {
    const token = req.cookies.jwt;

    if (token) {
        jwt.verify(token, 'information of user', (err, decodedToken) => {
            if (err) {
                console.log(err.message);
                res.redirect('/login');
            }
            else {
                console.log(decodedToken);
                next();
            }
        })
    }
    else {
        res.redirect('/login');
    }
}

// prevent login again
const preventLoginAgain = (req, res, next) => {
    const token = req.cookies.jwt;

    if (token) {
        jwt.verify(token, 'information of user', (err, decodedToken) => {
            if (err) {
                console.log(err.message);
                // res.redirect('/login');
                next();
            }
            else {
                // console.log(decodedToken);
                res.redirect('/');
            }
        })
    }
    else {
        next();
    }
}

// check current user
const checkUser = (req, res, next) => {
    const token = req.cookies.jwt;

    if (token) {
        jwt.verify(token, 'information of user', async (err, decodedToken) => {
            if (err) {
                console.log(err.message);
                res.locals.user = null;
                next();
            }
            else {
                console.log(decodedToken);
                let user = await Account.findById(decodedToken.id);
                res.locals.user = user;
                next();
            }
        })
    }
    else {
        res.locals.user = null;
        next();
    }
}

module.exports = {requireAuth, checkUser, preventLoginAgain}