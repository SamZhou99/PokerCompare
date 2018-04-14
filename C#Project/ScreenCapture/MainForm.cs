/*
 * 由SharpDevelop创建。
 * 用户： sam.z 45636987@qq.com
 * 日期: 2017/9/26
 * 时间: 11:42
 *
 * 要改变这种模板请点击 工具|选项|代码编写|编辑标准头文件
 */
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using System.Net;
using System.Net.Sockets;
using System.IO;
using System.Drawing.Imaging;
using System.Text;
using System.Threading;
using System.Runtime.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;




namespace TestSocket
{
	/// <summary>
	/// Description of MainForm.
	/// </summary>
	public partial class MainForm : Form
	{
		private string HOST = "127.0.0.1";
		private int PORT = 8887;
		private int indexCount = 0;
		private bool isImgTimering = false, isSocketTimering = false;
		private Bitmap bmpFullScreen, bmpMin;
		private Socket clientSocket;
		private JObject jsonObj;
		private Rectangle rectMax, rectMin;
		private Point maxPoint, minPoint;
		private Size maxSize, minSize;
		private MainForm main;
		
		public MainForm()
		{
			InitializeComponent();
			
			main = this;
			
			jsonObj = JsonConvert.DeserializeObject<JObject>(getFileJson(@"../../../../bin/config.json"));
			HOST = (string)jsonObj["ConfigAir"]["SocketServer"]["IP"];
			PORT = (int)jsonObj["ConfigAir"]["SocketServer"]["Port"];
			
			maxPoint = new Point((int)jsonObj["ConfigExe"]["Image1"]["x"], (int)jsonObj["ConfigExe"]["Image1"]["y"]);
			minPoint = new Point((int)jsonObj["ConfigExe"]["Image2"]["x"], (int)jsonObj["ConfigExe"]["Image2"]["y"]);
			maxSize = new Size(new Point((int)jsonObj["ConfigExe"]["Image1"]["width"], (int)jsonObj["ConfigExe"]["Image1"]["height"]));
			minSize = new Size(new Point((int)jsonObj["ConfigExe"]["Image2"]["width"], (int)jsonObj["ConfigExe"]["Image2"]["height"]));
			rectMax = new Rectangle(maxPoint.X, maxPoint.Y, maxSize.Width, maxSize.Height);
			rectMin = new Rectangle(minPoint.X, minPoint.Y, minSize.Width, minSize.Height);
			main.maxImgNumX.Value = maxPoint.X;
			main.maxImgNumY.Value = maxPoint.Y;
			main.minImgNumX.Value = minPoint.X;
			main.minImgNumY.Value = minPoint.Y;
			
			initSocket();
			initTimer();
		}
		
		
		//初始化Socket
		private void initSocket(){
			IPHostEntry ipHostInfo = Dns.Resolve(HOST);//Dns.GetHostEntry(HOST);
            IPAddress ipAddress = ipHostInfo.AddressList[0];
            IPEndPoint remoteEP = new IPEndPoint(ipAddress, PORT);
			
			clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
			
			try {
				textOut("Start Connect ..." + remoteEP.ToString());
                clientSocket.Connect(remoteEP);
				textOut("Connect Success!");
				isSocketTimering = true;
				this.socketTimer.Stop();
            } catch (ArgumentNullException ane) {
                textOut("ArgumentNullException : " + ane.ToString());
            } catch (SocketException se) {
                textOut("SocketException : " + se.ErrorCode.ToString());
                reConnect();
            } catch (Exception e) {
                textOut("Unexpected exception : " + e.ToString());
            }
		}
		//重联
		private void reConnect(){
			isSocketTimering = false;
            this.socketTimer.Start();
		}
		//发送消息
		private void sendMsg(){
			screenImage();
			if(clientSocket == null) return ;
			if(!clientSocket.Connected) return ;
			//byte[] msg = getStringToArray("This is a test<EOF>");
			byte[] img = getBmpToArray(bmpMin);
			byte[] len = BitConverter.GetBytes(img.Length);
            byte[] msg = new byte[img.Length+len.Length];
            Array.Copy(len, 0, msg, 0, len.Length);
            Array.Copy(img, 0, msg, len.Length, img.Length);
            textOut("1 img.Length:"+img.Length);
            textOut("1 len.Length:"+len.Length);
            textOut("1 msg.Length:"+msg.Length);
            try{
            	int bytesSent = clientSocket.Send(msg);
            }catch(Exception e){
            	textOut("sendMsg exception : " + e.ToString());
            	closeSocket();
            	reConnect();
            }
            
		}
		//断开链接
		private void closeSocket(){
			textOut("Socket Close ...");
			if(clientSocket == null) return ;
			clientSocket.Shutdown(SocketShutdown.Both);
            clientSocket.Close();
            clientSocket = null;
		}
		
		
		
		
		
		
		
		
		
		//截屏
		private void screenImage(){
			if(!isSocketTimering) return ;
			
			Size size = new Size(new Point(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height));
			
			if(bmpFullScreen != null) bmpFullScreen.Dispose();
			bmpFullScreen = new Bitmap(size.Width, size.Height/2);
			Graphics g = Graphics.FromImage(bmpFullScreen as Image);
			g.CopyFromScreen(new Point(0,0), new Point(0,0), size);
			
			if(bmpMin != null) bmpMin.Dispose();
			bmpMin = new Bitmap(rectMax.Width, rectMax.Height);
			Graphics gMin = Graphics.FromImage(bmpMin as Image);
			//位置 大图片 和 小图片
			rectMax.X = (int)main.maxImgNumX.Value;
			rectMax.Y = (int)main.maxImgNumY.Value;
			gMin.DrawImage(bmpFullScreen as Image, 0, 0, rectMax, GraphicsUnit.Point);
			
			rectMin.X = (int)main.minImgNumX.Value;
			rectMin.Y = (int)main.minImgNumY.Value;
			gMin.DrawImage(bmpFullScreen as Image, 0, 0, rectMin, GraphicsUnit.Point);
			
			this.pictureBox1.Image = bmpMin;
			
			g.Dispose();
			gMin.Dispose();
			bmpFullScreen.Dispose();
		}
		
		
		//读取json文件
		private string getFileJson(string filepath, string enCode = "utf-8"){
		    string json = string.Empty;
		    using (FileStream fs = new FileStream(filepath, FileMode.Open, System.IO.FileAccess.Read, FileShare.ReadWrite)){
		        using (StreamReader sr = new StreamReader(fs, Encoding.GetEncoding(enCode))){
		            json = sr.ReadToEnd().ToString();
		        }
		    }
		    return @json;
		}
		
		//String To byteArray
		private byte[] getStringToArray(string text){
			return Encoding.UTF8.GetBytes(text);
		}
		//Image To byteArray
		private byte[] getBmpToArray(Bitmap bmp){
			MemoryStream mStr = new MemoryStream();
			bmp.Save(mStr, ImageFormat.Png);
			byte[] buffer = mStr.ToArray();
			mStr.Close();
			mStr.Dispose();
			return buffer;
		}
		
		//输入到 textBox
		private void textOut(string text){
			main.textBox1.AppendText(text+"\r\n");
		}
		
		
		
		
		
		
		//初始化定时器 定时截图 定时重联Socket
		private void initTimer(){
			this.imgTimer.Interval = 1000;
			this.imgTimer.Tick += new EventHandler(onImgTimerEvent);
			this.socketTimer.Interval = 3000;
			this.socketTimer.Tick += new EventHandler(onSocketTimerEvent); 
		}
		private void onImgTimerEvent(object clientSocket, EventArgs e){
			indexCount++;
			this.button1.Text = "Click Stop, index:" + indexCount;
			sendMsg();
		}
		private void onSocketTimerEvent(object clientSocket, EventArgs e){
			if(isSocketTimering) return ;
			textOut("重新联机Socket...");
			initSocket();
		}
		
		//按钮点击
		private void Button1Click(object clientSocket, EventArgs e)
		{
			if(isImgTimering){
				this.imgTimer.Stop();
				this.button1.Text = "Click Start, Index:" + indexCount;
			}
			else{
				this.imgTimer.Start();
				this.button1.Text = "Click Stop, Index:" + indexCount;
			}
			isImgTimering = !isImgTimering;
		}
		
	}
}
