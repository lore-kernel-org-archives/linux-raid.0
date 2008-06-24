From: Jin Suh <jinssuh@yahoo.com>
Subject: Re: md/Software RAID ATA/RAID (software RAID)
Date: Tue, 24 Jun 2008 11:25:34 -0700 (PDT)
Message-ID: <666979.12622.qm@web34402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jin Suh <jinssuh@yahoo.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Sorry my mistake. The kernel I am using is 2.6.22.2.

Jin


----- Original Message ----
From: Jin Suh <jinssuh@yahoo.com>
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de; Jin S Suh <jinssuh@yahoo.com>
Sent: Tuesday, June 24, 2008 12:50:05 PM
Subject: md/Software RAID ATA/RAID (software RAID)

Hello RAID community,

I need an urgent help from you guys.
I've been testing RAID0 and 1 on my Intel mother board. It has an Intel Matrix Storage Manager ROMv6.1.0.002 ICH8R w/ RAID5. From this RAID BIOS, I created a RAID1 using two 80GB SATA disks. I have a custom Linux custom boot CD with 2.6.24.2. After booting the system, I calculated MD5sum values with 2GB chunks and noticed that the hash value of the the last segment is different. I did not mount or read any data after the boot. Now every time I booted the machine and noticed the md5 values of the last segment got changed. I think something like a device mapper try to read these disks as a RAID and update something at the end of each disk (RAID metadata). I did not even run mdadm or dmraid command to activate the RAID. I also tested a RAID0 w/ two disks and got same things (the md5sum of the
  last segment gets changed). 

Another test: from a none RAID BIOS machine:
I also created a Windows Dynamic Disk (SFS) with mirror and spanned from Vista. On linux, I ran "mdadm --build /dev/md0 --level raid0 -n /dev/sda1 /dev/sdb1" something like that. I don't remember the exact command but this also changes the last segment's md5sum on both raid0 and 1.

This is very odd. Does anyone notice this problem? Am I doing something wrong? How can I fix this problem? Please help!

Thanks,
Jin

