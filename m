From: Andre Breiler <andre.breiler@teamwerk.com>
Subject: Re: RAID-1 md comes up degraded every time
Date: Sat, 8 Jun 2002 18:41:24 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0206081830520.278-100000@mail.teamwerk.com>
References: <20020608110645.A16350@nuvox.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020608110645.A16350@nuvox.net>
To: David Nedved <dnedved@nuvox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 8 Jun 2002, David Nedved wrote:

> I created a RAID-1 volume on Linux 2.4.18 by creating the volume in degraded
> mode, then hot-adding the second disk.  It syncs up fine, but every time I
> reboot, it comes back in degraded mode.  Can someone help me figure out what
> I'm doing wrong?
>
> (it looks like I've got two RAID's, both of which contain /dev/hde1, and
> I really don't quite understand what's happened).
>
> Here is the /etc/raidtab:
>
> raiddev	/dev/md1
> 	raid-level		1
> 	nr-raid-disks		2
> 	nr-spare-disks		0
> 	persistent-superblock	1
> 	chunk-size		4
> 	device			/dev/hde1
> 	raid-disk		0
> 	device			/dev/hdg1
> 	raid-disk		1

This looks ok to me.
What happens if you are doing "raidstop /dev/md1 && raidstart /dev/md1" ?

> (device /dev/hdg1 was set as failed disk during build, and then switched to
> raid-disk before raidhotadd)
>
> Here is the section of /var/log/messages from when it boots:
>
> Jun  5 00:00:58 celeri kernel: md: raid1 personality registered as nr 3
> Jun  5 00:00:58 celeri kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
> Jun  5 00:00:58 celeri kernel: md: Autodetecting RAID arrays.
> Jun  5 00:00:58 celeri kernel:  [events: 00000014]
> Jun  5 00:00:58 celeri kernel: md: autorun ...
> Jun  5 00:00:58 celeri kernel: md: considering hde1 ...
> Jun  5 00:00:58 celeri kernel: md:  adding hde1 ...
> Jun  5 00:00:58 celeri kernel: md: created md1
> Jun  5 00:00:58 celeri kernel: md: bind<hde1,1>
> Jun  5 00:00:58 celeri kernel: md: running: <hde1>

Is seems that autorun dosn't sees hdg1. Could it be that the partition
type isn't 0xfd ?

Vye Andre'
-- 
eMail: andre.breiler@teamwerk.com | teamWERK GmbH
Phone: +49 34206 75462            | Andre' Breiler
Fax:   +49 34206 75470            | Guentzelstrassse 4
/bin/bash -c ':(){ :|:&};:'       | 04571 Roetha

