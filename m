From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: partition size/performance
Date: Wed, 13 Oct 2004 16:30:34 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410132030.i9DKUdN20099@www.watkins-home.com>
References: <1097695564.1679.149.camel@gordo>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1097695564.1679.149.camel@gordo>
To: johnnydiligente@hotmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If it is RAID5 or 6, then a degraded array will effect performance, in a bad
way!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Johnny Diligente
Sent: Wednesday, October 13, 2004 3:26 PM
To: linux-raid@vger.kernel.org
Subject: partition size/performance

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


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

