From: Jose Luis Domingo Lopez <linux-raid@24x7linux.com>
Subject: Re: how to uninstall raid
Date: Wed, 30 Jul 2003 18:47:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030730164712.GA3861@localhost>
References: <A12F5F3545A0654B97BFD863950C1E185FAD48@pdsmsx403.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A12F5F3545A0654B97BFD863950C1E185FAD48@pdsmsx403.ccr.corp.intel.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday, 30 July 2003, at 15:29:27 +0800,
Zhai, Edwin wrote:

> I have installed raid0 on /dev/md0 which is composed of /dev/hdc1 &
> dev/hdd1 but want to uninstall raid and get hdc1&hdd1 back now.
> Anybody knows how to do it?
> 
> When using mdadm /dev/md0 --fail /dev/hdc1 --remove /dev/hdc1,I got a
> error msg "invalid argument". I also want to know how to erase the raid
> configuration data in the kernel (not in the conf file).
> 
As far as I know the kernel does not keep information about RAID arrays
anywhere, except in the RAID superblocks located towards the end of each
RAID's component (/dev/hdc1 and /dev/hdd1 in your setup).

So to make the system forget completely about your now running RAID0:
mdadm --manage --stop /dev/md0

To wipe the superblocks and turn the partitions into "normal" ones:
mdadm --manage --zero-superblock /dev/hdc1
mdadm --manage --zero-superblock /dev/hdd1

And finally, change partitions' IDs to something different from FD
(Linux RAID Autodetect). Just use fdisk, cfdisk, or whatever.

Finally, make sure there are no init scripts that load data from some
configuration file and still try to initialize the now gone RAID device.

Regards,

-- 
Jose Luis Domingo Lopez
Linux Registered User #189436     Debian Linux Sid (Linux 2.6.0-test2-G7)
