From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Help raid10 recovery from 2 disks removed
Date: Thu, 24 Oct 2013 10:54:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310241050290.1838@uplift.swm.pp.se>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net>
Sender: linux-raid-owner@vger.kernel.org
To: yuji_touya@yokogawa-digital.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 24 Oct 2013, yuji_touya@yokogawa-digital.com wrote:

> Hi all,
>
> Unfortunately my raid10 array (2TB x 4 disks, total 4TB) stopped working and
> mdadm command reports State "removed" and "faulty removed" disks are there.
> Could someone advise me how to recover the raid10 array?
>
> I read this page and jumped into here.
> https://raid.wiki.kernel.org/index.php/RAID_Recovery
>
> Your help is appreciated,
>
> # mdadm --examine /dev/sd[b-z] | egrep 'Event|/dev/sd'
> /dev/sdb:
>         Events : 34220
> this     0       8       16        0      active sync   /dev/sdb
>   0     0       8       16        0      active sync   /dev/sdb
>   2     2       8       48        2      active sync   /dev/sdd
>   3     3       8       64        3      active sync   /dev/sde
> /dev/sdc:
>         Events : 8
> this     1       8       32        1      active sync   /dev/sdc
>   0     0       8       16        0      active sync   /dev/sdb
>   1     1       8       32        1      active sync   /dev/sdc
>   2     2       8       48        2      active sync   /dev/sdd
>   3     3       8       64        3      active sync   /dev/sde
> /dev/sdd:
>         Events : 34224
> this     2       8       48        2      active sync   /dev/sdd
>   2     2       8       48        2      active sync   /dev/sdd
>   3     3       8       64        3      active sync   /dev/sde
> /dev/sde:
>         Events : 34224
> this     3       8       64        3      active sync   /dev/sde
>   2     2       8       48        2      active sync   /dev/sdd
>   3     3       8       64        3      active sync   /dev/sde

Try doing --stop and then do --assemble --force with sdb, sdd and sde. 
Whatever you do, don't include sdc because it looks like sdc has been out 
of the array for a long time (the event count is 8 when all the others are 
around 34220).

You need to figure out what happened to get sdb kicked out of the array, 
check logs and "dmesg". Also use smartctl to check sdb and see if it's 
failing.

From what I can see, sdc was kicked out a long time ago and you haven't 
hard redundancy for most of the lifetime of the array.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
