From: =?ISO-8859-1?Q?paul_k=F6lle?= <paul@subsignal.org>
Subject: Cannot boot from initrd into RAID1
Date: Wed, 01 Jun 2005 21:56:53 +0200
Message-ID: <d7l3mj$o1j$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

well, I won't bother you with the whole story, so just the important
facts. I have to use initrd because I need to preload the module for the
 SATA Controller (4port Marvell). I have 4 disks with /<root> and a few
other partitions on RAID1 and others on RAID5. I made a raidtab config
and build the arrays with no problems, created fstab an can mount all
partitions from my boot/rescue system just fine. The problem is booting
the system. After loading the SATA module, linuxrc tries to mount
/dev/md0 (which is supposed to be /<root>) and fails with input/output
error. ^D -> rescue shell let me do cat /proc/mdstat wich shows
something like:
<identities>  [raid1 raid5]

but no arrays. I wonder if I need a statically built binary of mdadm or
thelike in initrd to initialize the arrays or should a proper configured
kernel just do fine?

thanks
 Paul

