From: Johnny Diligente <johnnydiligente@hotmail.com>
Subject: partition size/performance
Date: Wed, 13 Oct 2004 15:26:04 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097695564.1679.149.camel@gordo>
Reply-To: johnnydiligente@hotmail.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

thanks to Doug Ledford and Michael Tokarev for helping me get raid up
while keeping my data!

However array seems slow, my questions now

Does file/partition size effect performance? 
Does a "missing" drive effect performance?


mobo: 	tyan tiger 133  UDMA 66
cpu: 	2x 800mhz PIII
kernel:	2.6.8.1 SMP using MD driver built into kernel
raid: 	raid-1,2disk,reiserfs (degraded only 1 disk running)
disk1:	maxtor maxline plus II IDE 250g, 1 250G partition
disk2: 	maxtor maxline II IDE 250g- ntfs, future disk2 for array  

copy 54M file from array to array:
	real    0m8.886s
	user    0m0.004s
	sys     0m5.854s

copy 5G folder from ntfs partition to arrary
	real    74m12.121s
	user    0m1.115s
	sys     6m41.242s

is my partition too large? 
is it the degraded array? 
is it my IDE bus?

jd


