From: Pallai Roland <dap@mail.index.hu>
Subject: media error but no I/O error
Date: Wed, 12 Mar 2008 02:19:24 +0100
Message-ID: <200803120219.25391.dap@mail.index.hu>
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

I've some unreadable sector on a Samsung SATA disk. The output 
of "smartctl -a -d ata /dev/sdc" shows 2 pending sectors:

197 Current_Pending_Sector  0x0012   100   100   000    Old_age   
Always       -       2

the offline smart test also logged the error:

Num  Test_Description    Status                  Remaining  LifeTime(hours)  
LBA_of_first_error
# 1  Short offline       Completed: read failure       90%      2835         
54754753

and I got the following kernel message if I try to read the sector with "dd 
if=/dev/sdc skip=27377376 bs=1024 count=1":
kernel: res 51/40:00:c1:7d:43/23:00:03:00:00/40 Emask 0x409 (media error) <F>

But there's no buffer error, I always get the content of the sector after 
6 "media error"! The disk is member of a raid5 array, but I cannot force the 
re-write of this sector, cause there's no read error. The array is slow when 
the read runs into this sector and I'm not sure that the content what I get 
is correct. What should I do? Should I fail and re-add the disk?

kernel 2.6.24
intel AHCI sata ctrl.
SAMSUNG HD501LJ disk


thanks,
--
 d

