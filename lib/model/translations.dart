
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dil extends Translations{
  static const varsayilan = Locale("en","US");
  static final diller = [
   Locale("tr","TR"),
   Locale("en","US"),
   Locale("ru","RU")
  ];
 @override
 Map<String, Map<String,String>> get keys =>{
  'en_US':{
    'title': 'Login',
    'password': 'Password:',
    'rememberMe': 'Remember Me',
    'forgetPass':'Forget Password',
    'youNew': 'New to TurizmUyg?',
    'register': 'Register',
    'name': 'Name :',
    'surname': 'Surname :',
    'youSignIn': 'Already have an account?',
    'nameReq': 'Enter your name',
    'surnameReq': 'Enter your surname',
    'emailReq': 'Email address is required',
    'emailInvalid': 'Invalid Email',
    'passwordReq': 'Enter your password',
    'passwordLength': 'Your password must be at least 8 characters long',
    'registerSuccess': 'Registration Successful',
    'registerFail':'Register Fail : ',
    'loginSuccess': 'Login Successful',
    'loginIncorrect': 'Incorrect Email or Password',
    'error':'Error',
    'welcome': 'Welcome',
    'lokasyonSearch':'Location Search',
    'search':'Search...',
    'discover':'Discover Turkey',
    'MyFavorite':'My Favorite Locations',
    'MyComments':'My Comments',
    'MyAccount':'My Account',
    'SignOut':'Sign-Out', 
    'emailTitle':'Email Vertification',
    'verification':'Verification',
    'verificationCode':'Your verification code',
    'verdes':' enter the 6-digit code sent to your email address in this field.',
    'code':'6 digit code:',
    'validateInvalid':'invalid verification code',
    
  },
  'tr_TR':{
    'title':'Giriş Yap',
    'password':'Şifre:',
    'rememberMe':'Beni Hatırla',
    'forgetPass':'Şifremi Unuttum',
    'youNew':'Turizm-Uyg yeni misin?',
    'register':'Kayıt Ol',
    'name':'İsim :',
    'surname':'Soyisim :',
    'youSignIn':'Daha önceden hesap oluşturdun mu?',
    'nameReq':'İsmizini Girin',
    'surnameReq':'Soyisminizi Girin',
    'emailReq':'EMail adresi zorunlu',
    'emailInvalid':'Geçersiz E-Mail',
    'passwordReq':'Şifrenizi Girin',
    'passwordLength':'Şifreniz En az 8 karakter İçermeli',
    'registerSuccess':'Kayıt Başarılı',
    'registerFail':'Kayıt Başarısız : ',
    'loginSuccess':'Giriş Başarılı',
    'loginIncorrect':'Email veya Şifreniz Hatalı',
    'error':'Hata',
    'welcome':'Hoşgeldin',
    'lokasyonSearch': 'Lokasyon Ara',
    'search': 'Ara...',
    'discover': 'Türkiyeyi Keşfet',
    'MyFavorite': 'Favori Lokasyonlarım',
    'MyComments': 'Yorumlarım',
    'MyAccount': 'Hesabım',
    'SignOut': 'Çıkış Yap',
    'emailTitle':'Email Doğrulama',
    'verification':'Doğrula',
    'verificationCode':'Doğrulama Kodunuz : ',
    'verdes':' email adresinde gönderilmiş 6 haneli kodu bu alana girin',
    'code':'6 haneli kod :',
    'validateInvalid':'Geçersiz Doğrulama Kodu'
  },
  'ru_RU':{
    'title': 'Войти',
    'password': 'Пароль:',
    'rememberMe': 'Запомнить меня',
    'forgetPass': 'Я забыла пароль',
    'youNew': 'Вы новенький в TurizmUyg?',
    'register': 'Регистрация',
    'name': 'Имя : ',
    'surname': 'Фамилия : ',
    'youSignIn': 'Уже есть аккаунт?',
    'nameReq': 'Введите ваше имя',
    'surnameReq': 'Введите вашу фамилию',
    'emailReq': 'Требуется адрес электронной почты',
    'emailInvalid': 'Неверный адрес электронной почты',
    'passwordReq': 'Введите ваш пароль',
    'passwordLength': 'Ваш пароль должен содержать не менее 8 символов',
    'registerSuccess': 'Регистрация успешна',
    'registerFail':'Регистрация не удалась : ',
    'loginSuccess': 'Вход выполнен успешно',
    'loginIncorrect': 'Неверный адрес электронной почты или пароль',
    'error':'ошибка',
    'welcome': 'Добро пожаловать',
    'lokasyonSearch': 'Поиск местоположения',
    'search': 'Поиск...',
    'discover': 'Откройте для себя Турцию',
    'MyFavorite': 'Мои любимые места',
    'MyComments': 'Мои комментарии',
    'MyAccount': 'Мой аккаунт',
    'SignOut': 'Выйти',
    'emailTitle':'Подтверждение электронной почты',
    'verification':'проверка',
    'verificationCode':'Ваш код подтверждения : ',
    'verdes':' Введите в это поле шестизначный код, отправленный на ваш адрес электронной почты.',
    'code':'6-значный код :',
    'validateInvalid':'неверный код подтверждения'
  }

 };
 
}