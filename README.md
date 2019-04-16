# fayes-mobile
Naive Bayes Facial Feature Analysis Application


## Abstract:
In my investigation, I applied learning techniques to data collected by Apple’s CoreImage facial detection. CoreImage was able to detect 3 facial feature coordinates, and I translated those coordinates into distances after performing appropriate triangulation methods. Then these distances were able to yield their appropriate ratios. These ratios were then compared to the training set. The machine learning algorithm that I applied was the Naive Bayes Classifier, and I was able to successfully predict the gender of a user with an accuracy of 62% from only 4 ratios.


## Methods and Data:
In order to use the Naive Bayes Classifier, it is first necessary to have a large training set so that the program can determine what traits are more significant and which class contains this data more often. So to develope my training set, I first started with 100 head on images of random human faces, 50% male and 50% female.

I then was able to place points on these locations and apply Delaunay Triangulation, as shown in figure 1, to this set of points. The triangulation is named after Boris Delaunay for his work on this topic from 1934. In mathematics and computational geometry, a Delaunay triangulation for a set P of points in a plane is a triangulation DT(P) such that no point in P is inside the circumcircle of any triangle in DT(P).

Delaunay triangulations maximize the minimum angle of all the angles of the triangles in the triangulation; they tend to avoid skinny triangles. This is important when mapping from 2D images to 3D images, because a 3D image tends to not produce this kind of triangles.

After I was able to apply Delaunay Triangulation to each of the 100 faces I then calculated the distances between these points, as shown in table 1.


![Example of proper Delaunay Triangulation](https://mathmunch.files.wordpress.com/2013/05/delaunay-triangulation.png)
Figure 1: Example of proper Delaunay Triangulation.



| Count | Gender | LE-RE  | LE-M   | RE-M   | ME-M   |
|-------|--------|--------|--------|--------|--------|
| 1     | Female | 178.01 | 224.80 | 226.93 | 200.64 |
| 2     | Female | 110.00 | 133.02 | 135.57 | 121.00 |
| 3     | Female | 183.07 | 217.00 | 217.57 | 196.09 |
| 4     | Female | 123.26 | 147.26 | 146.29 | 136.18 |
| 5     | Female | 55.04  | 66.64  | 68.15  | 58.03  |
| 6     | Female | 67.07  | 79.16  | 80.23  | 71.01  |
| 7     | Female | 91.24  | 118.77 | 127.75 | 114.35 |
| 8     | Female | 134.36 | 159.56 | 157.34 | 144.83 |
| 9     | Female | 129.02 | 151.64 | 150.79 | 137.03 |
| 10    | Female | 68.18  | 82.87  | 83.24  | 74.03  |
| 11    | Female | 165.03 | 200.63 | 199.52 | 181.60 |
| 12    | Female | 90.01  | 103.79 | 104.65 | 98.02  |
| 13    | Female | 38.11  | 48.79  | 48.17  | 44.46  |
| 14    | Female | 35.47  | 37.95  | 40.21  | 35.65  |
| 15    | Female | 78.24  | 95.40  | 98.75  | 88.50  |
| 51    | Male   | 169.52 | 213.35 | 221.03 | 204.87 |
| 52    | Male   | 54.41  | 64.12  | 64.61  | 60.82  |
| 53    | Male   | 101.49 | 128.50 | 132.70 | 118.29 |
| 54    | Male   | 94.28  | 106.26 | 110.53 | 101.22 |
| 55    | Male   | 200.01 | 228.08 | 228.12 | 202.09 |
| 56    | Male   | 280.34 | 369.80 | 349.40 | 344.89 |
| 57    | Male   | 185.69 | 231.86 | 229.14 | 210.99 |
| 58    | Male   | 45.84  | 59.05  | 56.40  | 52.37  |
| 59    | Male   | 190.79 | 239.43 | 229.87 | 217.58 |
| 60    | Male   | 89.00  | 110.49 | 109.38 | 101.08 |
| 61    | Male   | 67.38  | 77.05  | 77.35  | 69.73  |
| 62    | Male   | 79.24  | 93.17  | 92.14  | 86.86  |
| 63    | Male   | 113.09 | 136.23 | 140.28 | 127.44 |
| 64    | Male   | 63.97  | 85.66  | 85.87  | 77.78  |
| 65    | Male   | 80.96  | 103.04 | 103.56 | 94.09  |

Table 1: Distance data for the first 15 male and female faces.

I was able to calculate the four distinct distance fields: distance from left eye to right eye, distance from left eye to the center of the mouth, the distance from the right eye to the mouth, and the distance from the midpoint between the eye to the center of the mouth. Once all 100 distances were calculated I needed to establish the ratios between these distances. I found the ratios between all the distances, this gave 6 ratio fields. For the sake of efficiency I reduced that set down to the best 4.
I was able to determine the better and worse ratios by first calculating the female, male, and total average value for each ratio field. I then calculated the difference between the male and female average, and then divided that range by the average. As shown in equation 1 and table 2.

![f_{Range:Average}(x) = \frac{(\bar{x}_{F}-\bar{x}_{M})}{\bar{x}_{Total}}](http://mathurl.com/render.cgi?f_%7BRange%3AAverage%7D%28x%29%20%3D%20%5Cfrac%7B%28%5Cbar%7Bx%7D_%7BF%7D-%5Cbar%7Bx%7D_%7BM%7D%29%7D%7B%5Cbar%7Bx%7D_%7BTotal%7D%7D%5Cnocache)

| LE-RE:ME-M     | LE-M:RE-M      | LE-M:ME-M      | RE-M:ME-M      |
|----------------|----------------|----------------|----------------|
| Female Average | Female Average | Female Average | Female Average |
| 0.8923         | 0.9957         | 1.0871         | 1.0921         |
|                |                |                |                |
| Male Average   | Male Average   | Male Average   | Male Average   |
| 0.8724         | 0.9980         | 1.0691         | 1.0713         |
|                |                |                |                |
| Total Average  | Total Average  | Total Average  | Total Average  |
| 0.8824         | 0.9968         | 1.0781         | 1.0817         |
|                |                |                |                |
| Range          | Range          | Range          | Range          |
| 0.0199         | 0.0023         | 0.0180         | 0.0208         |
|                |                |                |                |
| Range:Average  | Range:Average  | Range:Average  | Range:Average  |
| 0.0226         | 0.0023         | 0.0167         | 0.0192         |

