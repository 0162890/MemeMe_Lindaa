# MemeMe Application

 카메라, 앨범으로 부터 얻은 사진의 상, 하단에 텍스트를 추가해서Meme를 만든 후 저장, 공유 등의 이벤트를 사용할 수 있는 앱

## Basic Functions

- 카메라, 앨범으로 부터 이미지를 가져오기

- 이미지의 상, 하단에 텍스트 추가

- Meme 저장, 공유

- 만든 Meme를 table view와 collection view로 목록화

- 목록에서 Meme를 클릭하면 detail을 볼 수 있고, 수정한 후 새로 저장 가능

- Table view의 목록에서 swipe로 Meme 삭제 가능

- Screenshots
  - Make meme, Detail Meme, Delete Meme

  ![make meme](https://github.com/BoostCamp/MemeMe_Lindaa/blob/master/Screenshots/1makememe.jpg?raw=true)

  ​

  - Table view, Collection view (Portrait)

  ![portrait](https://github.com/BoostCamp/MemeMe_Lindaa/blob/master/Screenshots/2port.jpg?raw=true)

  ​

  - Table view, Collection view (Landscape)

  ![landscape](https://github.com/BoostCamp/MemeMe_Lindaa/blob/master/Screenshots/3land2.jpg?raw=true)



## KICK (Additional Feature)

- Stepper를 이용하여 텍스트 사이즈 조절 기능

  - Meme를 만들 때, Stepper를 이용해서 선택한 텍스트의 사이즈 조절 가능
  - 텍스트의 사이즈 Minimum : 25, Maximum : 60
  - 수정할 때도 저장되었던 텍스트의 크기를 유지하기 위해서 Meme 구조체에 텍스트의 사이즈도 저장

    ```swift
    struct Meme {
        var topText:String!
        var bottomText:String!
        var originalImage:UIImage!
        var memedImage:UIImage!

        //add font size
        var topTextFontSize : CGFloat!
        var bottomTextFontSize : CGFloat!
    }
    ```
  - Screenshot
    - 변경된 텍스트의 사이즈

    ![stepper](https://github.com/BoostCamp/MemeMe_Lindaa/blob/master/Screenshots/4stepper.jpg?raw=true)




## Video
[![MemeMe_Linda](http://img.youtube.com/vi/JE-1ghZDXkw/0.jpg)](https://youtu.be/JE-1ghZDXkw)

## Info

- Author : Hayeon Kim(Linda)
- BoostCamp 2nd assignment
- Udacity 'UIKit Fundamentals - MemeMe
- Environment
  - iOS version : 10.2
  - Xcode version : 8.2.1
