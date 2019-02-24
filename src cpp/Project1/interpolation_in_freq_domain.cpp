/**
* @brief You will learn how to remove periodic noise in the Fourier domain
* @author Karpushin Vladislav, karpushin@ngs.ru, https://github.com/VladKarpushin
*/
#include <iostream>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include "ImresizeInFreqFilter.hpp"

using namespace cv;
using namespace std;

//void imresizeInFreq(const Mat& inputImg, Mat& outputImg, Size dsize);
void imresizeInFreq(const Mat& inputImg, Mat& outputImg, int iScaleFactor);
void filter2DFreq(const Mat& inputImg, Mat& outputImg, const Mat& H);

int main()
{
    //Mat imgIn = imread("D:\\home\\programming\\vc\\new\\6_My home projects\\18_interpolation_in_freq_domain\\input\\avrFrame.jpg", IMREAD_GRAYSCALE);
	Mat imgIn = imread("D:\\home\\programming\\vc\\new\\6_My home projects\\18_interpolation_in_freq_domain\\input\\brother.jpg", IMREAD_GRAYSCALE);
    if (imgIn.empty()) //check whether the image is loaded or not
    {
        cout << "ERROR : Image cannot be loaded..!!" << endl;
        return -1;
    }
//! [main]
	const int k = 5;
	Mat imgOut;
	ImresizeInFreqFilter filter;
	filter.Process(imgIn, imgOut, k);

	normalize(imgIn, imgIn, 0, 255, NORM_MINMAX);
	normalize(imgOut, imgOut, 0, 255, NORM_MINMAX);
	
	imwrite("imgIn.jpg", imgIn);
	imwrite("result.jpg", imgOut);
	return 0;
}

//! [imresizeInFreq]
//void imresizeInFreq(const Mat& inputImg, Mat& outputImg, Size dsize)
// 	iScaleFactor - scale factor along the horizontal axis
void imresizeInFreq(const Mat& inputImg, Mat& outputImg, int iScaleFactor)
{
	Mat planes[2] = { Mat_<float>(inputImg.clone()), Mat::zeros(inputImg.size(), CV_32F) };
	Mat complexI;
	merge(planes, 2, complexI);
	dft(complexI, complexI, DFT_SCALE);

	Size dsize(inputImg.size()*iScaleFactor);
	outputImg = Mat(dsize, CV_32F, Scalar(0));

    int cx = inputImg.cols / 2;
    int cy = inputImg.rows / 2;
	Rect roi0 = Rect(0, 0, cx, cy);
	Rect roi1 = Rect(cx, 0, cx, cy);
	Rect roi2 = Rect(0, cy, cx, cy);
	Rect roi3 = Rect(cx, cy, cx, cy);
	
	Rect roi1New = Rect(dsize.width-cx, 0, cx, cy);
	Rect roi2New = Rect(0, dsize.height - cy, cx, cy);
	Rect roi3New = Rect(dsize.width - cx, dsize.height - cy, cx, cy);

	Mat complexINew = Mat(dsize, complexI.type(), Scalar(0));
	complexI(roi0).copyTo(complexINew(roi0));
	complexI(roi1).copyTo(complexINew(roi1New));
	complexI(roi2).copyTo(complexINew(roi2New));
	complexI(roi3).copyTo(complexINew(roi3New));

	idft(complexINew, complexINew);
	split(complexINew, planes);
	outputImg = planes[0];

	// filterrring check (start)
	Mat abs0 = abs(planes[0]);
	Mat abs1 = abs(planes[1]);
	double MaxReal, MinReal;
	minMaxLoc(abs0, &MinReal, &MaxReal, NULL, NULL);
	double MaxIm, MinIm;
	minMaxLoc(abs1, &MinIm, &MaxIm, NULL, NULL);
	cout << "MaxReal = " << MaxReal << "; MinReal = " << MinReal << endl;
	cout << "MaxIm = " << MaxIm << "; MinIm = " << MinIm << endl;
	// filterrring check (stop)
}
//! [imresizeInFreq]

//! [filter2DFreq]
void filter2DFreq(const Mat& inputImg, Mat& outputImg, const Mat& H)
{
    Mat planes[2] = { Mat_<float>(inputImg.clone()), Mat::zeros(inputImg.size(), CV_32F) };
    Mat complexI;
    merge(planes, 2, complexI);
    dft(complexI, complexI, DFT_SCALE);

    Mat planesH[2] = { Mat_<float>(H.clone()), Mat::zeros(H.size(), CV_32F) };
    Mat complexH;
    merge(planesH, 2, complexH);
    Mat complexIH;
    mulSpectrums(complexI, complexH, complexIH, 0);

    idft(complexIH, complexIH);
    split(complexIH, planes);
    outputImg = planes[0];
}
//! [filter2DFreq]