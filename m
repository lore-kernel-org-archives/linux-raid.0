From: Maarten <maarten@ultratux.net>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Mon, 15 Sep 2008 18:57:53 +0200
Message-ID: <48CE9411.4060201@ultratux.net>
References: <48CE250C.8000603@ultratux.net> <18638.16613.435533.269946@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18638.16613.435533.269946@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:
>> This weekend I promoted my new 6-disk raid6 array to
>> production use and was busy copying data to it overnight. The
>> next morning the machine had crashed, and the array is down
>> with an (apparent?) 4-disk failure, [ ... ]
> 
> Multiple drive failures are far more common than people expect,
> and the problem lies in people's expectations, because they don't
> do common mode analysis (what's what? many will think).

It IS more common indeed. I'm on my seventh or eight raid-5 array now, 
the first was a 4-disk raid5 40(120) GB array. I've had 4 or 5 two-disk 
failures happen to me over the years, invariably during rebuild, indeed.
This is why I'm switching over to raid-6, by the way.

I did not, at any point, lose the array with the two-disk failures 
though. I intelligently cloned bad drives with dd_rescue and reassembled 
those degraded arrays using the new disks and thus got my data back.
But still, such events tend to keep me busy for a whole weekend, which 
is not too pleasant.

> They typically happen all at once at power up, or in short
> succession (e.g. 2nd drive fails while syncing to recover from
> 1st failure).
> 
> The typical RAID has N drives from the same manufacturer, of the
> same model, with nearly contiguous serial numbers, from the same
> shipping carton, in an enclosure where they all are started and
> stopped at the same time, run on the same power circuit, at the
> same temperature, on much the same load, attached to the same
> host adapter or N of the same type. Expecting as many do to have
> uncorrelated failures is rather comical.

This is true. However, since I know this fact I tend to take care to not 
make it too vulnerable; the system is incredibly well cooled, it has 8 
80mm fans that cool the 16(!) disks, I buy disks in batches of 2, from 
different brands and vendors. It indeed has just one PSU, but I chose a 
good one, I think it's a Tagan 550 Watt unit.

In fact -this is my home system- since I cannot afford a DLT drive for 
this much data I practically have no backup, so I really spend a lot of 
effort making sure the array stays ok. Yes, I know, this not a good 
idea, but how do I economically backup 3 TB ?
In practice I have older disks and/or decommisioned arrays with 
"backups" but this is of course not up to date at all.

> 1) Is my analysis correct so far ?
> 
> Not so sure :-). Consider this interesting discrepancy:
> 
>   /dev/sda1:
>   [ ... ]
>       Raid Devices : 7
>      Total Devices : 6
>   [ ... ]
>     Active Devices : 5
>   Working Devices : 5
> 
>   /dev/sdb1:
>   [ ... ]
>       Raid Devices : 7
>      Total Devices : 6
>   [ ... ]
>     Active Devices : 6
>   Working Devices : 6
> 
> Also note that member 0, 'sdk1' is listed as "removed", but not
> faulty, in some member statuses. However you have been able to
> actually get the status out of all members, including 'sdk1',
> which reports itself as 'active', like all other drives as of
> 5:16. Then only 2 drives report themselves as 'active' as of
> 5:17, and those think that the array has 5 'active'/'working'
> devices at that time. What happened between 5:16 and 5:17?

Don't know, I was asleep ;-)
Seriously, the system experienced a hard crash. Not even the keyboard 
responded to the capslock key/led anymore. Logs are empty.

> You should look at your system log to figure out what really
> happened to your drives and then assess what the cause of the
> failure was and its impact.

Syslogs are empty. Not one line nor even a hint at that time.

> 3) Should I say farewell to my ~2400 GB of data ? :-(
> 
> Surely not -- you have a backup of those 2400GB, as obvious from
> "busy copying data to it". RAID is not backup anyhow :-).

Yes I have most of the data. What I'd lose is ~20 GB, which is less than 
one percent ;-).  But still, it's a lot of bytes...

> 4) If it was only a one-drive failure, why did it kill the array ?
> 
> The MD subsystem marked as bad more than one drive. Anyhow doing
> a 5+2 RAID6 and then loading it with data with a checksum drive
> missing and at the same time as it syncing seems a bit too clever
> to me. Right now the array is running in effect in RAID0 mode, so
> I would not trust it even if you are able to restart it.

Just bought a seventh/replacement disk...  But if the array is lost that 
is of little use.  I'll try to reassemble later tonight...

Thanks,
Maarten

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

