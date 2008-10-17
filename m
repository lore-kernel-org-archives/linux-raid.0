From: c.baegert-listes@lixium.fr
Subject: RAID 0, disks swapped ?
Date: Fri, 17 Oct 2008 13:18:12 +0200
Message-ID: <200810171318.12654.c.baegert-listes@lixium.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had a RAID 10, crashed since a few days, made with a soft RAID 0 (/dev/md5) 
of 2 soft RAID 1 (/dev/md3 and /dev/md4). I'm using default kernel on Debian 
Etch.

I had to recreate the main RAID 0 (mdadm --create), I thought that the order 
of /dev/md3 and /dev/md4 was not important (mdadm is known to find the good 
order automatically), but it seems it took the 2 arrays in the wrong order : 
when I tried to mount it, it failed, with the message "you need to 
reiserfsck", so I made a fsck, it said "you have to rebuild-tree", I did it 
and now all my files are messed up, and it seems theye are sliced !!!

I asked for a Reiserfs specialist who said my whole partition has an offset of 
64K. And it's the chunk size of my RAID 0 !

So do you think that the order of my sub-arrays REALLY changed in the RAID 0 ? 
and do you think possible to reorder that, before retrying higher level tools 
like fsck ?

Thank you for your help !

Regards,
-- 
 
Christophe
