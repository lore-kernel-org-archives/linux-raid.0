From: "NeilBrown" <neilb@suse.de>
Subject: Re: Updated MDADM, array dies.
Date: Thu, 27 Nov 2008 09:18:07 +1100 (EST)
Message-ID: <8e5c241f1ae50a7d6aa5da15b10fd322.squirrel@neil.brown.name>
References: <29a863790811260840w2533f6dcy244ce58d81bbc27e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790811260840w2533f6dcy244ce58d81bbc27e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Thu, November 27, 2008 3:40 am, Greg Cormier wrote:
> I have a RAID5 array of 4 disks. Was working well. I did a "yum
> update" and noticed it updated mdadm to mdadm 2.6.7.1, amongst other
> things (new kernel 2.2.27 instead of .26) , and now my array won't
> mount.
>
> mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> mdadm: cannot open device /dev/sdb1: Device or resource busy
> mdadm: /dev/sdb1 has no superblock - assembly aborted
>
> [root@zeus ~]# cat /proc/mdstat
> Personalities :
> md_d0 : inactive sdb1[0](S) sdd1[2](S)
>       976766976 blocks
>
> unused devices: <none>
>
>
> Yet, if I examine, it looks okay?

Strange.
It looks like something else tried to assemble the array and only found
sdb1 and sdd1 so it couldn't assemble it completely.  But now those
devices appear "in use" so you cannot assemble the array.
One option would be
   mdadm -S /dev/md_d0
and try again.
Another which I would like you to try is
  mdadm --incremental /dev/sdc1
  mdadm --incremental /dev/sde1

That should add those devices to the array and start it.

You didn't say what distro you were using, though as you mention "yum"
I assume a redhat based distro.  I think they might be using "--incremental"
to start arrays these days.  Maybe something when wrong somewhere.

Doug Ledford might be interested in more details.

NeilBrown


