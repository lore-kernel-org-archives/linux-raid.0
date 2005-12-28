From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: raid1: All my data completely vanished into the void
Date: Wed, 28 Dec 2005 16:52:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0512281649150.18011-100000@coffee.psychology.mcmaster.ca>
References: <200512280030.51387.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200512280030.51387.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> What does doing
> mdadm -Cv -n2 -l1 /dev/md0 /dev/sda /dev/sdb
> do to the partition tables??? 

overwrites them.  then again, there's nothing critical about 
partition tables - they're just a convention for slicing up 
the disk, not necessary in any sense.

in fact, it can be quite handy to avoid partitions - I have one 
cluster where /dev/hda is an ext3 filesystem, mainly to avoid the 
bios bug of trying to boot the disk (in preference to PXE) even 
if there are no active partitions.

the only downside to your "messed up" config is that the kernel won't
autostart the raids.

