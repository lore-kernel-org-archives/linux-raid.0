From: Mitchell Laks <mlaks@verizon.net>
Subject: Need to upgrade to latest stable mdadm version?
Date: Sun, 22 Jan 2006 12:41:54 -0500
Message-ID: <200601221241.54689.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am running serveral Debian Sarge servers with crucial data and need to 
update (gulp) to the latest stable Linux kernel 2.6.15.1. :( I am terrified.

I would like to match the latest kernel to the latest stable mdadm. What can I 
do to make that match?  I thought that perhaps I should use mdadm 2.2: 
however I have been lurking reading the emails on this list and I see scary 
messages like

1) mdadm-2.2 SEGFAULT: mdadm --assemble --scan from 12-22 (see patches that 
are sent in)
2) mdadm-2.2 typo dated 1-12-06
 
How can I get the most current patched version?

Why am I doing this? I am running a few Debian Sarge servers. I would prefer 
to run everything from Sarge (including the kernel...).  However I will be 
using SATA controllers in my latest installs, and having  tried out a few, I 
discovered that the standard 2.6.8-2 debian Sarge kernel (nor even the 2.6.12 
testing) will not work with the SATA controllers I have (2.6.15 in sid does). 

I have a promise SATAII 150 TX4 sata controller card as well as a on board 
via VT8237 sata controller on my Asus A8v motherboard. I found that 
with the debian Sarge kernel 2.6.8-2: the sata_promise promise module is not 
working, 
and with the ETCH testing 2.6.12:  the sata_via module fails with

mdadm -Cv /dev/md0 -n2 -l1 /dev/sda1 /dev/sdb1
mkfs.ext3 /dev/md0

causing reproducible kernel error messages

ata1: status=0x51 { DriveReady SeekComplete Error }
ata1: error=0x84 { DriveStatusError BadCRC }
ata1: command 0x35 timeout, stat 0xd0 host_stat 0x0
ata1: status=0xd0 { Busy }
SCSI error : <0 0 0 0> return code = 0x8000002
sda: Current: sense key: Aborted Command
    Additional sense: Scsi parity error
end_request: I/O error, dev sda, sector 94109775
raid1: Disk failure on sda1, disabling device.
        Operation continuing on 1 devices
ATA: abnormal status 0xD0 on port 0xC007
ATA: abnormal status 0xD0 on port 0xC007
ATA: abnormal status 0xD0 on port 0xC007
ata1: command 0x35 timeout, stat 0xd0 host_stat 0x1
ata1: status=0xd0 { Busy }
SCSI error : <0 0 0 0> return code = 0x8000002
sda: Current: sense key: Aborted Command
    Additional sense: Scsi parity error
end_request: I/O error, dev sda, sector 94109783

Note these messages are not caused by the hard drive (reproduced on multiple 
hard drives which fine work with the Promise controller), nor is it the 
controller hardware (occurs with multiple asus A8v motherboards) - because it 
only happens when both the sata_via and sata_promise controller are loaded by 
the ETCH debian 2.6.12 kernel. If only sata_via is loaded, system works fine. 
Moreover it does not happen with the debian SID 2.6.15 kernel :).

So I have to compile my own 2.6.15 kernel. So what version of mdadm do I use? 
How shall I install it? 

Does it make sense to simply compile mdadm  2.2 and replace /sbin/mdadm with 
the new version?????? How can I get the best recent mdadm? I am using raid1.

Thank you all for all your help in the past!
Mitchell Laks


 
