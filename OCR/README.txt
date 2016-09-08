1、本程序实现给定检测后的字母图片，实现对A B C 三个字母的识别

2、其中：
	letter_numbers 文件夹为模板图片
	test_img 为测试图像

3、运行方式：
    首先运行create_templates.m 产生模板文件templates.mat
	然后，直接运行OCR.m即可

	输出结果为：result.txt.  格式为：字母  置信度（-1~1）
	可根据置信度判断是字母还是非字母，非字母一般置信度小于0
