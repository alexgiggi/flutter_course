import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/auth.dart';
import '../ui_elements/adaptive_progress_indicator.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin{
  // String _emailValue;
  // String _passwordValue;
  // bool _acceptTerms = false;

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthMode _authMode = AuthMode.Login;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  void initState(){
    _controller =AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation =Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  DecorationImage _buildBackgroungImage(){
    return DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
            image: AssetImage('assets/background.jpg'));
  }

// Widget _buildEmailTextField(){
//   return TextField(
//               decoration: InputDecoration(labelText: 'E-Mail', filled: true, fillColor: Colors.white),
//               keyboardType: TextInputType.emailAddress,
//               onChanged: (String value) {
//                 setState(() {
//                   _emailValue = value;
//                 });
//               },
//             );
// }

// Widget _buildPasswordTextField(){
//   return TextField(
//               decoration: InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.white),
//               obscureText: true,
//               onChanged: (String value) {
//                 setState(() {
//                   _passwordValue = value;
//                 });
//               },
//             );
// }

 Widget _buildEmailTextField() {
    return TextFormField(initialValue: 'apupita@gmail.com',
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  final TextEditingController _passwordTextController = TextEditingController();


  Widget _buildPasswordConfirmTextField() {
    return 
      FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      child: SlideTransition( 
      position: _slideAnimation,
      child: TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value && _authMode ==AuthMode.Signup) {
          return 'Password do not match';
        }
      },
      // onSaved: (String value) {
      //   _formData['password'] = value;
      // },
    )),);
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      // initialValue: 'iniziale',
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          //return 'Password invalid';
            value = 'iniziale';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }


Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

void _submitForm(Function authenticate) async{

    // if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
    //   return;
    // }
    
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    
    if (_formData['password'] == null || _formData['password'] == '')
      _formData['password'] = 'iniziale';

    successInformation = await authenticate(_formData['email'], _formData['password'], _authMode);

    if (successInformation['success']){
      print('ok.. ' + successInformation['message']);
      // Navigator.pushReplacementNamed(context, '/'); --> authenticate tira su l'evento che poi viene catturato dalla main.dart che poi instrada verso altre pagine post-login
    }
    else{
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(title: Text('An error ocourred'), content: Text(successInformation['message']), actions: <Widget>[
          FlatButton(child: Text('Ok'), onPressed: (){
            Navigator.of(context).pop();
          },)
        ],);
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500 : deviceWidth * 0.95;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroungImage()
          ),
        // margin: EdgeInsets.all(10.0), // --> Margin definisce lo spazio esterno
        padding: EdgeInsets.all(10.0), //  --> Padding definisce lo spazio interno
        // child:Center(child: ListView(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
          child: Container(
            // width: 200.0,
            width: targetWidth ,
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
            _buildEmailTextField(),
            SizedBox(height: 10.9,),
            _buildPasswordTextField(),
            //_authMode == AuthMode.Signup ? _buildPasswordConfirmTextField() : Container(),
             SizedBox(height: 10.0,),
            _buildPasswordConfirmTextField(),
            _buildAcceptSwitch(),
            
            // SizedBox(height: 10.0,),

            FlatButton(child: Text('Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'), onPressed: (){
              
                if(_authMode == AuthMode.Login){
                  setState(() {    
                    _authMode = AuthMode.Signup;
                  });
                  _controller.forward();
                } else{
                  setState(() {    
                    _authMode = AuthMode.Login;
                  });
                  _controller.reverse();
                }

                //_authMode = _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login; // switch auth mode                

            },),
            SizedBox(
              height: 10.0,
            ),
            ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
              return model.isLoading ? AdaptiveProgressIndicator() : RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text(_authMode==AuthMode.Login ? 'LOGIN':'SIGN UP'),
              onPressed: ()=> _submitForm(model.authenticate),
            );
            },) ,
          ],
        ),
            )
          ,) 
        ),
        ),
      ),
    );
  }

}