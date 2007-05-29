From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: RAID SB 1.x autodetection
Date: Tue, 29 May 2007 21:15:38 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705292036400.11140@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,


from your post at 
http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07384.html I 
read that autodetecting arrays with a 1.x superblock is currently 
impossible. Does it at least work to force the kernel to always assume a 
1.x sb? There are some 'broken' distros out there that still don't use 
mdadm in initramfs, and recreating the initramfs each time is a bit 
cumbersome...


	Jan
-- 
