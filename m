From: "Michael Daskalov" <MDaskalov@technologica.biz>
Subject: unable to stop /dev/md1 where root is mounted on 2.4.19.SuSE-246
Date: Tue, 22 Apr 2003 16:38:35 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15F26D0D9E18E24583D912511D668FF8027230@exchange.ad.tlogica.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi all, 
I have the following situation. I have my root partition on RAID1 (/dev/hda5 and /dev/sda5) - /dev/md1. 

I have two partitions for boot, which are also in raid1 configuration. 
/dev/md0 (/dev/hda1, /dev/sda1). 

On system reboot or shutdown the md device is not stopped (a clean record is not written on it), 
And after system reboot it always starts reconstructing. 

Which is the correct way to setup the situation? 



I'm activating the raid devices through initrd's linuxrc, where I'm loading a 
1) hpt302.o driver, 
2) raid1.o, raid5.o - The raid personality modules, and then I run 
3)raidstart --all. 



On shutdown I see messages that 
/dev/md2, /dev/md3, /dev/md4 are also stopped. 

I see a message saying /dev/md0 is put in read-only mode. 

Only /dev/md1 where is my rootfs is not stopped. 
I see the following message: 
md: md1 is still active 

The problem occurs on SuSE 7.2 with kernel 2.4.19.

I didn't have this problem with 2.4.4 kernel on SuSE 7.1

For me this looks like a bug in the kernel shutdown (reboot) functionality, but I know too little to say.

Best regards and 10x for any help, 
Mihail Daskalov 
