From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: question regarding a raid-1 set
Date: Tue, 26 Aug 2003 12:11:37 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F4B86B9.A1125164@SteelEye.com>
References: <200308261637.08588.jbaten@i2rs.nl> <yq13cfov4g7.fsf@wilson.mkp.net> <3F4B8076.5CF468D5@SteelEye.com> <200308261800.28078.jbaten@i2rs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jeroen Baten <jbaten@i2rs.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeroen Baten wrote:
 
> Well.... If you really like to know (I would really apreciate it!) this is the
> bootlog (bare in mind there are 3 raid-1 arrays):

Looks like md is confused because sdb6 is in slot 1. So the hot-remove,
hot-add should get you back up and running (hot-add will put the disk
back in slot 2, which should make md happy).

--
Paul


> <6>md:  adding sdb6 ...
> <6>md:  adding sda6 ...
> <6>md: created md2
> <6>md: bind<sda6,1>
> <6>md: bind<sdb6,2>
> <6>md: running: <sdb6><sda6>
> <6>md: sdb6's event counter: 00000028
> <6>md: sda6's event counter: 00000028
> <6>md: RAID level 1 does not need chunksize! Continuing anyway.
> <6>md2: max total readahead window set to 508k
> <6>md2: 1 data-disks, max readahead per data-disk: 508k
> <3>raid1: disabled mirror sdb6 (not in sync)
> <6>raid1: device sda6 operational as mirror 0
> <1>raid1: md2, not all disks are operational -- trying to recover array
> <6>raid1: raid set md2 active with 1 out of 2 mirrors
> <6>md: recovery thread got woken up ...
> <3>md2: no spare disk to reconstruct array! -- continuing in degraded mode
> <6>md: recovery thread finished ...
