const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const bodyparser = require('body-parser');
const session = require('express-session');

const indexRouter = require('./routes/index');
const usersRouter = require('./routes/users');
const transactionsRouter = require('./routes/transactions');
const plansRouter = require('./routes/plans');
const homeRouter = require('./routes/home');
const dashboardRouter = require('./routes/dashboard');
const { dirname } = require('path');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
app.set('sidebar', './partials/sidebar')

app.use(
  session({
    secret: 'PIG9',
  })
);

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));


app.use('/', indexRouter);
app.use('/cadastro', usersRouter);
app.use('/home', homeRouter);

// rotas abaixo precisam estar autenticadas
app.use((req, res, next) => {
  if(!req.session.estaAutenticado) {
      res.redirect('/home');
      return
  }
  next()
})

app.use('/planejamento', plansRouter);
app.use('/transacoes', transactionsRouter);
app.use('/dashboard', dashboardRouter);
// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
