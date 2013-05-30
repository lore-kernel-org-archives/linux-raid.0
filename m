From: Dominic Raferd <dominic@timedicer.co.uk>
Subject: SSD + Rust as raid1
Date: Thu, 30 May 2013 22:23:59 +0100
Message-ID: <51A7C36F.4030605@timedicer.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am wanting to (re)set up my raid1 array with 1 SSD partition 
(/dev/sda2) and 1 'rust' drive partition (/dev/sdb1) , both 240GB. SSD 
will also have a very small ext2 partition mounted as /mnt/sda1 (to hold 
the write-intent bitmap file).

To get the full speed of the SSD for reads and to maximise speed for 
writes I plan to use these settings:

mdadm -C /dev/md0 --level=raid1 -n 2 /dev/sda2 --write-mostly 
--write-behind=16384 --bitmap=/mnt/sda1/write-intent-bitmap.file 
--bitmap-chunk=256M dev/sdb1

Will this work and be optimal? I am not too bothered about the 
write-intent bitmap file but it is not optional I think, hence I set a 
large chunk size, could or should it be even larger (or smaller)? 
Similarly I have tried to set a high write-behind to speed up writes as 
much as possible - is 16384 the maximum allowed?

My system has mdadm 3.2.3 and kernel 3.2.26.

Any suggestions gratefully received.

Dominic
