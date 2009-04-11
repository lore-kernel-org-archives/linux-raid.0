From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 22:29:59 -0700
Message-ID: <019701c9ba66$aeed5630$0a00a8c0@vorg>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: "CoolCold" <coolthecold@gmail.com>

> Yes, he should provide correct /etc/mdadm/mdadm.conf and
> update-initramfs -u on md boot, smth like
> chroot /mnt/md0
> update-initramfs -u

How would this help in a system that doesn't ramdisk built in to the kernel or as a module? Or does it change some other stuff?


I started looking at the stuff that was copied to md0 and /md0/dev is empty. Looking through the guides I found a few things. One
said that using cp had to be from root or not everything would get coppied. I used sudo but I know some things require you to root.
Also this:
===============================
# rsync -avHhx --progress / /mnt/raid-md0

    * If the system wasn't previously in single user mode, move to single user mode and update the data that changed during the
first copy:
(--delete flag tells rsync to delete files from the destination which do not exist on the source):

# rsync -avHhx --progress --delete / /mnt/raid-md0

    * Create needed device nodes:

# cd /mnt/raid-md0/dev/ && MAKEDEV generic
===============================
Using rsync from single user mode still left /mnt/md0/dev empty. I read up in "makedev generic" and it seems to be a shotgun fix
adding way more then is needed. Is there a way to create just what is in /dev?

