From: raz ben jehuda <razb@bitband.com>
Subject: raid1 fault disk
Date: Wed, 08 Jun 2005 13:25:34 +0300
Message-ID: <1118226334.31330.17.camel@raz-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello to you all.
I am using 2 sata disk 250GB each with raid1 over linux-2.6.11.6. the 
mirror is composed of 3x2 partitions , two  partitions on two different 
disks that creates one mirror.
The "/" directory is one of the mirrors.
When I  detach one of the disks  a command such as  dmesg
hangs or any thing of that sort.  When  i return the disk  everything
goes back to place.
Anyone ?
-- 
Raz
Long Live The Penguin


