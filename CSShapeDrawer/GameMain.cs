using System;
using SwinGameSDK;

namespace MyGame
{
    public class GameMain
    {
        public static void Main()
        {
            //Open the game window
            SwinGame.OpenGraphicsWindow("GameMain", 800, 600);
            // SwinGame.ShowSwinGameSplashScreen();

            // initalise shapes
            Shape myShape = new Shape();
            //Run the game loop
            while (false == SwinGame.WindowCloseRequested())
            {
                //Fetch the next batch of UI interaction
                SwinGame.ProcessEvents();

                //Process Mouse
                if (SwinGame.MouseClicked(MouseButton.LeftButton))
                {
                    myShape.X = SwinGame.MouseX();
                    myShape.Y = SwinGame.MouseY();
                }

                //Process Keyboard
                if (SwinGame.KeyTyped(KeyCode.SpaceKey) && myShape.IsAt(SwinGame.MousePosition()))
                {
                    myShape.Color = SwinGame.RandomRGBColor(255);
                }

                //Clear the screen and draw the framerate
                SwinGame.ClearScreen(Color.White);
                SwinGame.DrawFramerate(0,0);

                //Draw Shapes
                myShape.Draw();

                //Draw onto the screen
                SwinGame.RefreshScreen(60);
            }
        }
    }
}