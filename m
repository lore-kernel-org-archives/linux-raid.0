From: Stephane Morand <Stephane.Morand@polytechnique.fr>
Subject: Raid-1 booting problem
Date: Mon, 3 Jun 2002 17:23:11 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0206031722420.24915-100000@polux.polytechnique.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hi,

I installed a Raid 1 linux system on our server, using the RedHat 7.2 
utility raid system.
Everything is mirrored on this disk (/, /boot, /usr, /tmp..)

I need to change one of these disks (the ibm is not working anymore). I 
partitioned a new disk (exactly the same as the original) and then plugged 
it in the computer. I used raidhotadd /dev/mdx /dev/hdcx to add the second 
 disk. Everything worked fine, but if I unplugged the first disk I am not 
able to boot anymore on the second, I guess there is a problem with lilo 
trying to write on the MBR.

I didn't find anything about it on the HowTos.. out of date. Can someone 
tells me how to make the second disk bootable ?

Thanks,

-Stephan




