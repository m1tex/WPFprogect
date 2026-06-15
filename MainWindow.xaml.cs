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

namespace pr7._1
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

        private void btnStart_Click(object sender, RoutedEventArgs e)
        {
            Random rnd = new Random();
            switch (rnd.Next(0, 3))
            {
                case 0:
                    PlayScream();
                    break;
                case 1:
                    ShowAnimation();
                    break;
                case 2:
                    ShowMessage();
                    break;
            }
        }
        private void PlayScream()
        {
            SoundPlayer player = new SoundPlayer();
        }
        private void ShowAnimation()
        {

        }
        private void ShowMessage()
        {
            MessageBox.Show("БУУУУ! Испугался?", "Страх", MessageBoxButton.OK, MessageBoxImage.Warning);
        }
    }
}
