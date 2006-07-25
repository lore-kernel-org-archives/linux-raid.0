From: Sevrin Robstad <quack@online.no>
Subject: FIXED : brute-force my RAID 5 - just some fsck errors..
Date: Tue, 25 Jul 2006 23:39:03 +0200
Message-ID: <44C68F77.6020909@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I finally got my old RAID-5 up again, after bruteforcing the setup of 
it... (A Script that ran "mdadm --create --run -n 6 -l 5 /dev/md0 
/dev/1-5 missing;fsck -n -f /dev/md0;mdadm --stop /dev/md0;)
The first run didn't find anything that made sense, but desperately I 
ran the same script with -c xx from 4 to 256 and I finally hit jackpot 
with one combo and 256kb chunksize.

Most of the RAID is fine, and I'm backing up the whole 1 terrabyte. But 
there's some errors on it, fsck reports

"Illegal block #12 (xxx) in inode 95764590."

It's the same from block #12 to block #1035, and same inode.

There's also some multiply-claimed block(s) in some inodes, and some 
files that share Inode's.


will fsck fix if I run it without "-n"  ?  Or will it just we worse ? Or 
is it possible that I have done another mistake with some 
RAID-parametres ???


Thanx for all help anyway!


Sevrin
