import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mypadding = EdgeInsets.symmetric(vertical: 10.0);
    return Scaffold(
      appBar: AppBar(
        title: Text("about us"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text("Hello!"),
              Text("I'm H, the creator of this app, qdfitnessdiary. "),
              Subtitle(text: "me"),
              Padding(
                padding: mypadding,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                  radius: 50,
                ),
              ),
              Text(
                  "     I'm 18 years old, going into my first year at the University of Toronto for a double major in life science and computer science. In my spare time, I like to read, spend time with my family, eat (probably ) ;D"),
              Subtitle(text: "the app"),
              Padding(
                padding: mypadding,
                child: Image(image: AssetImage('assets/images/wakeup.jpg')),
              ),
              Text(
                  "     This is an easy, straightforward app to record the everyday things of your life. You can use it as a fitness tracker, a food/exercise diary, a simple notes app, or all in one! NOTE: There are other apps out there for more in depth calorie analysis. The purpose of this app is to provide a very simple, hassle free overview to keep track of what I was eating and how much I was exercising on a regular basis. As I started creating the app, I realized the utility of a 'thought' optiion as well to just jot down random thoughts during the day."),
              Subtitle(text: "note about the calorie tracker"),
              Padding(
                padding: mypadding,
                child: Image(image: AssetImage('assets/images/future.jpg')),
              ),
              Text(
                  "    (in the works; may work for some foods and fail for others TT) As someone who is not good at sticking to complex routines, I chose to forego searches with hundreds of options such as 'ex. Bibigo Mini Wontons' for a simple automated stat for 'wonton'. The pros and cons of this decision are evident, trading in detail and accuracy for time and ease of use. In short, this is a very simplified calorie tracker that should be used as an estimate only. While not completely accurate, it shouldn’t deviate enormously between foods and is meant as a fun little supplement to your everyday food/exercise tracking routine. There are many existing apps out there for calorie tracking in greater depth and detail, that you can use instead (or in complement) with this app if that is what you are looking for."),
              Subtitle(text: "what's next?"),
              Padding(
                padding: mypadding,
                child: Image(image: AssetImage('assets/images/future.jpg')),
              ),
              Text(
                  "     Currently, this is a completely free text based food/exercise/daily tracker. I would like to add the option for uploading images as well in the future, but due to server costs, this may or may not be a premium feature. In the meantime, if you are enjoying this app and would like to support the creator (aka me) in keeping it ad-free, feel free to donate to my Patreon. Finally, a quick review on google play store is always very very appreciated. "),
              Subtitle(
                text: "and that's it!",
              ),
              Text('have a wonderful day <3'),
              Padding(
                padding: mypadding,
                child: Image(image: AssetImage('assets/images/dog.jpg')),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "p.s. if you have any problems/feedback feel free to message me @qdfitness@gmail.com or leave a message on our instagram @qdfitness",
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Subtitle extends StatelessWidget {
  final String text;
  Subtitle({this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
