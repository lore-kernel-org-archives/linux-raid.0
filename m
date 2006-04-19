From: =?iso-8859-2?Q?Jaros=B3aw?= Tabor <jarek@srv.pl>
Subject: RAID - automatic repair
Date: Wed, 19 Apr 2006 14:17:28 +0200
Message-ID: <1145449048.7271.20.camel@jarek.macro.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello! 

    Is there any way to force mdadm to automatically recover parition
kicked-off because it is non-fresh ? 

    I've found few times, that all second drives from mirror, are
kicked-off from array, after kernel upgrade, unexpected power failure
or  after boot from some bootable-cd (i.e. knoppix). 
Every time I need to do manually mdadm -a /dev/md? /dev/hd? 
I think, it shuold be possible to do it automatically. 
(Of course I know, that I can write some script...) 

Jarek

