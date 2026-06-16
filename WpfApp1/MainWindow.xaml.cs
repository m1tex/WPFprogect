using System;
using System.Collections.Generic;
using System.Linq;
using System.Media;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WpfApp1
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }
        private Random random = new Random();
        private SecondWindow secondWindow;
        private void KnockButton_Click(object sender, RoutedEventArgs e)
        {
            // Открываем второе окно, если ещё не открыто
            if (secondWindow == null || !secondWindow.IsVisible)
            {
                secondWindow = new SecondWindow();
                secondWindow.Closed += (s, args) => secondWindow = null;
                secondWindow.Show();
            }

            // Генерируем случайное событие (0, 1 или 2)
            int scareType = random.Next(3);
            switch (scareType)
            {
                case 0:
                    PlayScream();
                    break;
                case 1:
                    StartScaryAnimation();
                    break;
                case 2:
                    ShowScaryMessage();
                    break;
            }
        }

        // 1. Крик – воспроизведение звука
        private void PlayScream()
        {
            try
            {
                // Путь к файлу крика (поместите scream.wav в папку с приложением)
                SoundPlayer player = new SoundPlayer("scream.wav");
                player.Play();
            }
            catch
            {
                // Если файла нет – просто пискнем
                SystemSounds.Beep.Play();
            }
        }

        // 2. Страшная анимация – тряска второго окна
        private void StartScaryAnimation()
        {
            if (secondWindow != null && secondWindow.IsVisible)
            {
                secondWindow.StartShakeAnimation();
            }
        }

        // 3. Сообщение
        private void ShowScaryMessage()
        {
            MessageBox.Show("Бууууу! Напугался? 👻", "СТРАШНО!",
                            MessageBoxButton.OK, MessageBoxImage.Warning);
        }
    }
}


