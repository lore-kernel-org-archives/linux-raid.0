From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Reshape speed
Date: Wed, 14 Jan 2009 00:05:32 +0000
Message-ID: <C592DCCC.C013%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've recently assembled a new RAID 6.

When I assembled it, I had 3 disks and one missing.

I then added two disks.

The first disk was used to recover the originally missing disk.

The second disk is being used to grow the array.

The recovery went at about 45MB/s but the reshape is only around 11MB/s.

CPU usage is as follows:
 12.8   1398    root     [md1_raid5]
 2.0    7996    root     [md1_reshape]

Memory usage is as follows:
Type                    Percent Capacity    Free        Used        Size
Physical Memory         18%                 2.97 GB     661.03 MB   3.62 GB
- Kernel + applications 6%                              218.21 MB
- Buffers               0%                              7.67 MB
- Cached                12%                             435.14 MB
Disk Swap               0%                  0.00 KB     0.00 KB     0.00 KB
Disk Swap               0%                  0.00 KB     0.00 KB     0.00 KB

#uname -a
Linux edna 2.6.24-etchnhalf.1-amd64 #1 SMP Tue Dec 2 17:21:26 UTC 2008
x86_64 GNU/Linux

Why is the reshape so much slower? Where's the bottleneck?

Also, would it have been possible to do both these operations in one step?

-- 
Thanks in advance,

Iain

P.S. The reason the array was assembeled with a disk missing is explained in
other thread "RAID 6 recovery (it's not looking good)" which isn't finished
yet.


