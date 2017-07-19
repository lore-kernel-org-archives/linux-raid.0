From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Advice please re failed Raid6
Date: Wed, 19 Jul 2017 13:36:56 +0100
Message-ID: <22895.21096.215892.928052@tree.ty.sabi.co.uk>
References: <9dca5b7a-b60e-0e93-41fd-49d092d8b27b@gmail.com>
        <22892.649.826246.644975@tree.ty.sabi.co.uk>
        <f79a45b9-590b-4d3c-d387-81abfb02743d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f79a45b9-590b-4d3c-d387-81abfb02743d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Did I do it right? (See below)

> root@keruru:~# mdadm --create --assume-clean --level=6 --raid-devices=4 
> --size=1953382912 /dev/md0 missing /dev/sdc /dev/sdd /dev/sde
> mdadm: /dev/sdc appears to be part of a raid array:
>      level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
> mdadm: /dev/sdd appears to be part of a raid array:
>      level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
> mdadm: /dev/sde appears to be part of a raid array:
>      level=raid6 devices=4 ctime=Tue Jul 11 17:33:12 2017
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.

This looks good, but is based on your original '--examine'
report as to the order of the devices, and whether they are
still bound to the same names 'sd[bcde]'.

> root@keruru:~# blkid /dev/md0

> root@keruru:~# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active (auto-read-only) raid6 sde[3] sdd[2] sdc[1]
>        3906765824 blocks super 1.2 level 6, 512k chunk, algorithm 2 
> [4/3] [_UUU]

> unused devices: <none>

The 'mdstat' actually looks good, but 'blkid' should have
worked.

As I was saying, it is not clear to me whether the 'mdadm' daemon
instance triggered a 'check' or a 'repair' (bad news). I hope
that you disabled that in the meantime while you try to fix the
mistake.

Trigger a 'check' and see if the set is consistent; if it is
consistent but the content cannot be read/mounted then 'repair'
rewrote it, if it is not consistent, try a different order or
3-way subset of 'sd[bcde]'.
