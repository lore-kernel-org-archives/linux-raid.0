From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25 kernel
Date: Thu, 05 Aug 2004 17:26:50 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87657ycaf9.fsf@enki.rimspace.net>
References: <ceq7ij$vj7$1@sea.gmane.org>
	<27897.194.60.85.4.1091613610.squirrel@194.60.85.4>
	<cesjcm$9da$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5 Aug 2004, Jens Benecke wrote:
> Robin Bowes wrote:
>
>> On Wed, August 4, 2004 9:42, Jens Benecke said:

[...]

> see subject (Debian). I've looked at SuSE though, it seems with their setup
> RAID and ReiserFS is much easier to handle. 

The upcoming release of Debian will feature MD and LVM device creation
at install time, but is not yet stable; the current stable release does
not support either of them.

I usually do a minimal install on one "missing" disk in a RAID set, then
copy that to the RAID, reboot and add back the missing disk. Painful,
but possible.

[...]

> Hm... I thought LVM did mirroring and striping as well? I didn't think you
> can or should use them together. Wouldn't that degrade performance as
> well?

It can, if you want it to, but it doesn't have to.  I usually just use
MD devices created over partitions, because that is supported by
in-kernel detection, and because it avoids the LVM ... instability of
the last few years.

I am told that LVM is much more stable these days, though. :)

>>> Does MD or LVM2 do hot sync, i.e. if one drive fails will I be able to
>>> stick in a replacement, and stop worrying? Or do I need to repartition
>>> the new disk exactly as the old one, before being able to sync?
>>
>> I'm not sure about this. My understanding is that you will need to
>> shutdown the system to replace the bad disk and partition the new disk
>> manually before md will resync, but this could be wrong.
>
> What I mean is, will md resync automatically or would I have to initiate
> this manually?

MD will resync if there is a hot-spare available, but will not
automatically suck a replacement disk into place. You need to partition
(if you use them), then manually add the new disk to the RAID set.

With mirroring, of course, I can't see the point in using a hot-spare
over having additional devices in the mirror set, except for PCI and
disk bus bandwidth.

For most servers they cost less than the risk that using hot-spare disks
implies. :)

[...]

>>> The goal is to have as "stress free" a system as possible - i.e. with as
>>> little manual configuration, and in event of emergencies, as little work
>>> to do, as possible.
>>
>> If you want stress free, buy a Netapps storage appliance ;o)
>
> If they do all the rest that I need (smtp, web, file server, ftp server,
> mysql, spamassassin, etc etc etc) fine. If not, I'd need to set up another
> box anyway, so I wouldn't see the advantage.

If you can afford them then they are one of the most stress free ways to
get a lot of disk space. They are not a substitute for standard storage,
though, and they do cost a bit...

        Daniel
-- 
To lie about a far country is easy.
        -- Amharic proverb

