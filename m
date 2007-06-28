From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: XFS mount option performance on Linux Software RAID 5
Date: Thu, 28 Jun 2007 12:31:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706281230091.2402@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Still reviewing but it appears 8 + 256k looks good.

p34-noatime-logbufs=2-lbsize=256k,15696M,78172.3,99,450320,86.6667,178683,29,79808,99,565741,42.3333,610.067,0,16:100000:16/64,2362,19.6667,15751.7,46,3993.33,22,2545.67,24.3333,13976,41,3781.33,28.6667
p34-noatime-logbufs=8-lbsize=256k,15696M,78238,99,455532,86.6667,182382,30,79741.7,99,571631,43,597.633,0,16:100000:16/64,3421,29,12130,38.3333,5943.33,33,3671.33,35.6667,13521.3,41.3333,5162.33,38.3333
p34-noatime-logbufs=8-lbsize=default,15696M,77872,98.6667,438661,86.6667,179848,29.3333,79368,99,555999,42,632.733,0.333333,16:100000:16/64,2090,17.6667,11183,33,3922.67,23,2271.33,22.3333,11709,35,3391.33,26.3333
p34-noatime-only,15696M,77473,99,449689,86.6667,176960,29.3333,80186.3,99,568503,42.6667,592.633,0,16:100000:16/64,2102,18,15935.3,44.6667,3825.67,22.3333,2353,23.6667,9727.33,29.3333,3265,25.6667

http://home.comcast.net/~jpiszcz/chunk/logbufs.html

