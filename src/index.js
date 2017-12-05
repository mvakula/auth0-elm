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
      removeProfileData()
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

webAuth.parseHash({ hash: window.location.hash }, handleAuthResult)

function handleAuthResult (err, authResult) {
  if (err) {
    return console.error(err)
  }
  if (authResult) {
    const token = authResult.accessToken
    webAuth.client.userInfo(token, handeProfileData.bind(null, token))
    window.location.hash = ''
  }
}

function handeProfileData (token, err, profile) {
  if (err) {
    console.log(err)
  } else {
    const data = { profile: profile, token: token }
    console.info(profile)
    setProfileData(data)
    // Send data to Elm
  }
}

function setProfileData ({ profile, token }) {
  localStorage.setItem('profile', JSON.stringify(profile))
  localStorage.setItem('token', token)
}

function removeProfileData () {
  localStorage.removeItem('profile')
  localStorage.removeItem('token')
}
