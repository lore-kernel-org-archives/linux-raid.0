From: Fabien Salvi <fabien.salvi@epfl.ch>
Subject: Read RAID1 drive member without 3ware RAID controller
Date: Tue, 20 Sep 2005 10:15:59 +0200
Message-ID: <dgogg0$je1$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've very strange troubles with 3ware 8006 RAID controllers using Maxtor 
hard disks (maybe because of that ?).
It's the fourth problem I have with 3ware RAID using Maxtor HD !
(4 workstations on 12 that have troubles like this, that's a lot, isn't 
it ?)

I got some file corruption errors under Windows on one workstation, 
"Incomplete drive" status reported by the RAID controller (just after 
the reboot) on another workstation  running linux where I lost months of 
data because the RAID controller shows the the host drive in June's 
state !! Yes, it sounds amazing, but it's true :(

So, I would like to read this "incomplete" hard disk that 3ware RAID 
controller can't do anything of it (except erasing it).

I tried to connect this hard disk to the standard serial ATA port of the 
motherboard. But, I can't see any partition on it, because of a Data 
disk format used by the RAID controller...
3ware told me to use some specific windows tool to recover it, but these 
tools only works for ext2 filesystem and I have reiserfs.

Does anyone know how to read the hard disk ?
I supposed they just use some blocks to store meta-informations at the 
beginning of the hard disk or something like that.
So, maybe with a good ofset, I would be able to read the filesystem...
Any linux tool to do that ?

Thanks a lot for your help !

-- 
Fabien

