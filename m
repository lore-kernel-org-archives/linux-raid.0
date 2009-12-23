From: "spren.gm@gmail.com" <spren.gm@gmail.com>
Subject: about faulty spare-disk interrupts synchronization
Date: Wed, 23 Dec 2009 19:51:33 +0800
Message-ID: <200912231951301400282@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
Is it intended that when a spare disk status gets faulty (detached from raid or really faulty) 
synchronization is interrupted ? We found that case several days ago with kernel version of 2.6.24, 
after we unplugged a spare disk of a raid5 which had bitmap and was recovering, the spare disk 
status became faulty  and synchronization restarted from 0%. 

Looking into the md code, i find that in md/md.c/md_error(), it doesn't make a difference between 
spare disks and normal disks. Should we make a faulty spare disk not interrupt raid synchronization ?
Disks nowadays have become much larger, and recovering one disk may cost several hours or even longer.

--------------
spren.gm@gmail.com
2009-12-23

