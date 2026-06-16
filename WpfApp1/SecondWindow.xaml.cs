using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace WpfApp1
{
    /// <summary>
    /// Логика взаимодействия для SecondWindow.xaml
    /// </summary>
    public partial class SecondWindow : Window
    {
        public SecondWindow()
        {
            InitializeComponent();
        }
        // Метод для запуска анимации тряски
        public void StartShakeAnimation()
        {
            // Создаём два параллельных таймлайна для тряски по X и Y
            var storyboard = new Storyboard();

            var shakeX = new DoubleAnimation
            {
                From = 0,
                To = 10,
                Duration = TimeSpan.FromMilliseconds(50),
                AutoReverse = true,
                RepeatBehavior = new RepeatBehavior(5) // 5 раз туда-сюда
            };
            Storyboard.SetTarget(shakeX, ShakeTransform);
            Storyboard.SetTargetProperty(shakeX, new PropertyPath("X"));

            var shakeY = new DoubleAnimation
            {
                From = 0,
                To = 10,
                Duration = TimeSpan.FromMilliseconds(50),
                AutoReverse = true,
                RepeatBehavior = new RepeatBehavior(5)
            };
            Storyboard.SetTarget(shakeY, ShakeTransform);
            Storyboard.SetTargetProperty(shakeY, new PropertyPath("Y"));

            storyboard.Children.Add(shakeX);
            storyboard.Children.Add(shakeY);

            // Заодно помигаем фоном
            var flashAnimation = new ColorAnimation
            {
                From = Colors.DarkRed,
                To = Colors.Black,
                Duration = TimeSpan.FromMilliseconds(100),
                AutoReverse = true,
                RepeatBehavior = new RepeatBehavior(3)
            };
            Storyboard.SetTarget(flashAnimation, this);
            Storyboard.SetTargetProperty(flashAnimation, new PropertyPath("Background.Color"));
            storyboard.Children.Add(flashAnimation);

            storyboard.Begin(this);
        }
    }
}
