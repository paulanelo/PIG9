module.exports = function (req, res, next) {
    if (!req.session.usuario) {
      res.redirect('/home');
    }
    next();
  };