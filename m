From: Jens =?iso-8859-1?q?K=FCbler?= <cleanerx@au.hadiko.de>
Subject: Raid5 resync freezes system
Date: Wed, 16 Apr 2003 23:22:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304162322.46555.cleanerx@au.hadiko.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello there
Here is what I got:

Abit KT7 Raid 
First IDE Controller is a Via
Second IDE controller is a HPT370 just using the ide part and NOT THE RAID 
PART of it
Duron 750
192MB RAM (fully tested using memtest)
Western Digital WDC WD1200BB-00CAA1 (120GB)
Maxtor 4D080H4 (80GB)
Maxtor 96147H6 (60GB)
Maxtor 5T060H6 (60GB)

using Mandrake 9.1 with Kernel 2.4.21-00
before this Mandrake 9.0 with kernel 2.4.19

Each disk parts with 60GB in the software raid5 array.

If I create the array, the system starts to resync the four disks. After an 
arbitrary time the resync freezes the system. I have tried to create an array 
with only three of the disks to exclude any damaged hd, I have switched ide 
ports and there was still no effect. Then I played a bit with the 
/proc/sys/dev/raid/  values and lowered the max_value as I thought this could 
be due to heavy IO load which was at 12MB. First I reduced it to 5MB/s but it 
was still crashing. The test with 2MB/s is currently underway.
During these many resyncs I've seen so far the speed sometimes stayed at 4MB/s 
without having any IO on the system. 
The computer itself is well cooled espacially the harddisks.

If the system does not crash during boot (it is also starting the resync 
there) I will shut down the device and the system is stable even if I create 
some heavy IO load.

The reiserfs I created seems to have nothing to do with these crashes as they 
occured with and without the created file system.

In hope of help.

Jens
