import './main.css'
import auth0 from 'auth0-js'
import { Main } from './Main.elm'

const node = document.getElementById('root')
const app = Main.embed(node)

app.ports.toJS.subscribe(msg => {
  switch (msg.tag) {
    case 'ShowLock':
      webAuth.authorize()
      break

    case 'LogOut':
      localStorage.removeItem('profile')
      localStorage.removeItem('token')
      break

    default:
      break
  }
})

const webAuth = new auth0.WebAuth({
  domain: process.env.AUTH0_DOMAIN,
  clientID: process.env.AUTH0_CLIENT_ID,
  responseType: process.env.AUTH0_RESPONSE_TYPE,
  scope: process.env.AUTH0_SCOPE,
  redirectUri: window.location.href
})
