From: Marco <jjletho67-diar@yahoo.it>
Subject: raid1 performance
Date: Sun, 25 Jul 2010 14:58:37 +0000 (GMT)
Message-ID: <443220.14357.qm@web28508.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
I'm posting again the same message because I have had some problem subscribing 
the list so i'm not sure it has been received:

doing a simple performance tests i obtained some very unexpected results: if i 
issue hdparm -t /dev/md2 i obtain 61 - 65 MB/s while issuing the same test 
directly on the partitions which compose md2 (/dev/sda3 and /dev/sdb3) i obtain 
84 - 87 MB/s. I didn't expect a so big difference between md2 and one of its 
member. What can cause  this difference ? 

I'm running the test on a Centos 5.4, /dev/md2 is a mounted and used block 
device (lvm on top of md2 and the root partion on the lvm volume group), but the 

machine was quite idle during the tests. The controller is an Intel ICH9 with 
AHCI enabled.

thank you in advance!


Marco



      
