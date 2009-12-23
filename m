From: "spren.gm@gmail.com" <spren.gm@gmail.com>
Subject: Re: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 21:13:44 +0800
Message-ID: <200912232113402967580@gmail.com>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>Dec 23 12:30:19 alfred kernel: md: bind<sdc1>
>Dec 23 12:30:19 alfred kernel: md: bind<sdd1>
>Dec 23 12:30:19 alfred kernel: md: running: <sdd1><sdc1><sdb1><sda1>
>Dec 23 12:30:19 alfred kernel: md: kicking non-fresh sda1 from array!
"non-fresh" is because of that "events" counter in superblock of sda1 is at least 2 lesser that others.

>Dec 23 12:30:19 alfred kernel: raid5: device sdc1 operational as raid disk 3
>Dec 23 12:30:19 alfred kernel: raid5: device sdb1 operational as raid disk 0
>Dec 23 12:30:19 alfred kernel: raid5: cannot start dirty degraded array for md0
here "dirty" results from system crash while writing data to the raid.
using "--froce" param with mdadm could start the raid, 
or md-mod has a param "start_dirty_degraded", if you load it with "start_dirty_degraded" set to 1, 
your raid5 could be started.
I think no more data would lose or corrupt if only doing raid start operation, but you should first get more 
replies and suggestion :)


