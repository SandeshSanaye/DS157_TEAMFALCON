const express = require('express')
const bodyParser = require('body-parser')
const cros = require('cors')
const morgan = require('morgan')

const app = express()
app.use(morgan('combine'))
app.use(bodyParser.json())
app.use(cros())
app.get('/status',(req,res)=>{
    res.send({
        message: 'Extract not implemented!!'
    })
})
app.listen(process.env.PORT || 8081)