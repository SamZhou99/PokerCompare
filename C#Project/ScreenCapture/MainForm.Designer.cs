/*
 * 由SharpDevelop创建。
 * 用户： sam.z
 * 日期: 2017/9/26
 * 时间: 11:42
 * 
 * 要改变这种模板请点击 工具|选项|代码编写|编辑标准头文件
 */
namespace TestSocket
{
	partial class MainForm
	{
		/// <summary>
		/// Designer variable used to keep track of non-visual components.
		/// </summary>
		private System.ComponentModel.IContainer components = null;
		
		/// <summary>
		/// Disposes resources used by the form.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing) {
				if (components != null) {
					components.Dispose();
				}
			}
			base.Dispose(disposing);
		}
		
		/// <summary>
		/// This method is required for Windows Forms designer support.
		/// Do not change the method contents inside the source code editor. The Forms designer might
		/// not be able to load this method if it was changed manually.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			this.button1 = new System.Windows.Forms.Button();
			this.pictureBox1 = new System.Windows.Forms.PictureBox();
			this.imgTimer = new System.Windows.Forms.Timer(this.components);
			this.textBox1 = new System.Windows.Forms.TextBox();
			this.maxImgNumX = new System.Windows.Forms.NumericUpDown();
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.maxImgNumY = new System.Windows.Forms.NumericUpDown();
			this.label3 = new System.Windows.Forms.Label();
			this.minImgNumY = new System.Windows.Forms.NumericUpDown();
			this.label4 = new System.Windows.Forms.Label();
			this.minImgNumX = new System.Windows.Forms.NumericUpDown();
			this.socketTimer = new System.Windows.Forms.Timer(this.components);
			((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.maxImgNumX)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.maxImgNumY)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.minImgNumY)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.minImgNumX)).BeginInit();
			this.SuspendLayout();
			// 
			// button1
			// 
			this.button1.Font = new System.Drawing.Font("Consolas", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.button1.Location = new System.Drawing.Point(12, 12);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(480, 40);
			this.button1.TabIndex = 1;
			this.button1.Text = "Click Start Screen Capture";
			this.button1.UseVisualStyleBackColor = true;
			this.button1.Click += new System.EventHandler(this.Button1Click);
			// 
			// pictureBox1
			// 
			this.pictureBox1.BackColor = System.Drawing.Color.Black;
			this.pictureBox1.Location = new System.Drawing.Point(12, 58);
			this.pictureBox1.Name = "pictureBox1";
			this.pictureBox1.Size = new System.Drawing.Size(480, 360);
			this.pictureBox1.TabIndex = 2;
			this.pictureBox1.TabStop = false;
			// 
			// imgTimer
			// 
			this.imgTimer.Interval = 1000;
			// 
			// textBox1
			// 
			this.textBox1.Location = new System.Drawing.Point(12, 472);
			this.textBox1.Multiline = true;
			this.textBox1.Name = "textBox1";
			this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
			this.textBox1.Size = new System.Drawing.Size(480, 65);
			this.textBox1.TabIndex = 3;
			// 
			// maxImgNumX
			// 
			this.maxImgNumX.Location = new System.Drawing.Point(115, 422);
			this.maxImgNumX.Maximum = new decimal(new int[] {
									99999999,
									0,
									0,
									0});
			this.maxImgNumX.Name = "maxImgNumX";
			this.maxImgNumX.Size = new System.Drawing.Size(60, 21);
			this.maxImgNumX.TabIndex = 6;
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(12, 424);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(111, 12);
			this.label1.TabIndex = 7;
			this.label1.Text = "第一个图片位置X：";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(96, 448);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(27, 12);
			this.label2.TabIndex = 9;
			this.label2.Text = "Y：";
			// 
			// maxImgNumY
			// 
			this.maxImgNumY.Location = new System.Drawing.Point(115, 446);
			this.maxImgNumY.Maximum = new decimal(new int[] {
									99999999,
									0,
									0,
									0});
			this.maxImgNumY.Name = "maxImgNumY";
			this.maxImgNumY.Size = new System.Drawing.Size(60, 21);
			this.maxImgNumY.TabIndex = 8;
			// 
			// label3
			// 
			this.label3.Location = new System.Drawing.Point(399, 448);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(27, 12);
			this.label3.TabIndex = 13;
			this.label3.Text = "Y：";
			// 
			// minImgNumY
			// 
			this.minImgNumY.Location = new System.Drawing.Point(432, 446);
			this.minImgNumY.Maximum = new decimal(new int[] {
									99999999,
									0,
									0,
									0});
			this.minImgNumY.Name = "minImgNumY";
			this.minImgNumY.Size = new System.Drawing.Size(60, 21);
			this.minImgNumY.TabIndex = 12;
			// 
			// label4
			// 
			this.label4.Location = new System.Drawing.Point(314, 424);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(112, 12);
			this.label4.TabIndex = 11;
			this.label4.Text = "第二个图片位置X：";
			// 
			// minImgNumX
			// 
			this.minImgNumX.Location = new System.Drawing.Point(432, 422);
			this.minImgNumX.Maximum = new decimal(new int[] {
									99999999,
									0,
									0,
									0});
			this.minImgNumX.Name = "minImgNumX";
			this.minImgNumX.Size = new System.Drawing.Size(60, 21);
			this.minImgNumX.TabIndex = 10;
			// 
			// socketTimer
			// 
			this.socketTimer.Interval = 1000;
			// 
			// MainForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.BackColor = System.Drawing.Color.White;
			this.ClientSize = new System.Drawing.Size(504, 548);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.minImgNumY);
			this.Controls.Add(this.label4);
			this.Controls.Add(this.minImgNumX);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.maxImgNumY);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.maxImgNumX);
			this.Controls.Add(this.textBox1);
			this.Controls.Add(this.pictureBox1);
			this.Controls.Add(this.button1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.Name = "MainForm";
			this.Text = "屏幕截图";
			((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.maxImgNumX)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.maxImgNumY)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.minImgNumY)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.minImgNumX)).EndInit();
			this.ResumeLayout(false);
			this.PerformLayout();
		}
		private System.Windows.Forms.Timer socketTimer;
		private System.Windows.Forms.NumericUpDown minImgNumX;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.NumericUpDown minImgNumY;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.NumericUpDown maxImgNumY;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.NumericUpDown maxImgNumX;
		private System.Windows.Forms.TextBox textBox1;
		private System.Windows.Forms.Timer imgTimer;
		private System.Windows.Forms.PictureBox pictureBox1;
		private System.Windows.Forms.Button button1;
	}
}
