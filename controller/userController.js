const { json } = require('body-parser')
const fs = require('fs')
const bcrypt = require('bcrypt')
const path = require('path')

module.exports.showCadastro = function (req, res) {
    res.render('cadastro', {title: 'Cadastro usuário',
      error: {},
      content: {},
    });
  };

module.exports.criarUsuario = async (req, res) => {
    const userForm = req.body

    const usuario = await buscarUsuario(userForm.emailUsuario)
    
    if (usuario) {
        res.render('cadastro', {title: 'Cadastro usuário',
            error: {
                emailUsuario: 'Email já cadastrado'},
                content: req.body,
        
      });
    } 

    if (userForm.senhaUsuario !== userForm.confsenhaUsuario) {
        res.render('cadastro', {title: 'Cadastro usuário',
          error: {
            senhaUsuario: 'Senhas incompativeis'},
            content: req.body,
        
      });
    } else {
    
        req.body.senhaUsuario = await criptografarSenha(req.body.senhaUsuario)
        delete req.body.confsenhaUsuario
        salvarUser(userForm)
        req.session.nomeUsuario = userForm.nomeUsuario
        req.session.estaAutenticado = true  
        res.render('dashboard', {
          user: req.session.nomeUsuario
        });
    }    
};

module.exports.formUsuario = (req, res) => {
    res.render('cadastro',{title: 'Cadastro usuário'});
}

module.exports.loginUsuario = async (req, res) => {
    const login = req.body
    const usuario = buscarUsuario(login.emailUsuario)
    if (!usuario) {
        res.send('erro aqui')
      } else {
        if (await validarSenha(login.senhaUsuario, usuario.senhaUsuario)) {
          req.session.nomeUsuario = usuario.nomeUsuario
          console.log(usuario.nomeUsuario)
          req.session.estaAutenticado = true  
          res.render('dashboard', {
            user: req.session.nomeUsuario,
          })
        } else {
          res.render('home',{
            error: {
              email: 'Email ou senha incorreta',
            },
          })
        }
      }
    }

module.exports.atualizaUsuario = (req, res) => {
    res.send('USUARIO ATUALIZADO')
}

module.exports.deletaUsuario = (req, res) => {
    res.send('USUARIO DELETADO')
}

/* Salva Usuarios no arquivo user.json*/
function salvarUser(objeto) {
    const usersCriados = require('../user.json')
    usersCriados.push(objeto)
    const str = JSON.stringify(usersCriados)
    fs.writeFileSync('user.json', str)
}

/* criando hash da senha*/
async function criptografarSenha(senha) {
    const salt = await bcrypt.genSalt(5)
    return await bcrypt.hash(senha, salt)
}

/* validando a senha com o hash*/
async function validarSenha(senha,hashSenha) {
    return await bcrypt.compareSync(senha, hashSenha)
}


function buscarUsuario(email) { 
    const usuarios = lerNoDisco()
    return usuarios.find(function(user){
        return user.emailUsuario===email
    })
}

function lerNoDisco() {
    const str = fs.readFileSync(path.join(__dirname, '../user.json'))
    const obj = JSON.parse(str)
    return obj
}    
