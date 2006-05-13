From: =?ISO-8859-1?Q?Ra=FAl_G=F3mez?= Cabrera <raulgomezc@acm.org>
Subject: Removing a RAID 1 setting without loosing data
Date: Sat, 13 May 2006 10:45:25 -0400
Message-ID: <1147531525.6198.8.camel@nachus.raulgomez.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

I have a installed a system (mail server) wich had a RAID 1 (software)
with two SCSI Disk running on Linux. The sdb disk has failed a few month
ago and the system is still working as expected.

Since the failure of the disk I've looking for a replacement, but so far
I cannot find a new one to replace it.

My client (who owns the system) ask me to simply remove the failed disk
and the RAID settings, but I'm not sure if I just simply remove
the /dev/md0 from the fstab and from the bootloader and point the / to
the sda1 (a Linux RAID partition).

Anyone can help me with this situation???

Thanks in advance, I'll be waiting for your post...

Raul.


