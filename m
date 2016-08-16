From: Chris Murphy <lists@colorremedies.com>
Subject: Re: read errors with md RAID5 array
Date: Tue, 16 Aug 2016 12:25:49 -0600
Message-ID: <CAJCQCtRf7mO+uZ=_EZ7m29aHA1t15kaD12D9O6ACGujgPmYLpA@mail.gmail.com>
References: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
 <20160815145937.dsjtzpjdnwfpmxyv@metamorpher.de> <d1ccb93d-6856-4b07-04ea-3c4ff9541d60@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d1ccb93d-6856-4b07-04ea-3c4ff9541d60@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 16, 2016 at 5:40 AM, Tim Small <tim@buttersideup.com> wrote:

> # for i in a c d ; do mdadm --examine-badblocks  /dev/sd${i}2 ; done
> Bad-blocks on /dev/sda2:
>           2321554488 for 512 sectors
>           2321555000 for 512 sectors
>           2321555512 for 152 sectors
> Bad-blocks on /dev/sdc2:
>              1656848 for 128 sectors
>             28490768 for 512 sectors
>             28491280 for 392 sectors
>             28572344 for 120 sectors
>             32760864 for 128 sectors
>           2321554488 for 512 sectors
>           2321555000 for 512 sectors
>           2321555512 for 152 sectors
> Bad-blocks on /dev/sdd2:
>              1656848 for 128 sectors
>             28490768 for 512 sectors
>             28491280 for 392 sectors
>             28572344 for 120 sectors
>             32760864 for 128 sectors
>           2321554488 for 512 sectors
>           2321555000 for 512 sectors
>           2321555512 for 152 sectors

Does this actually jive with what the drive is reporting? I would only
expect bad blocks to get populated if there's a write error, and the
user would only opt in to using a bad blocks list if they're basically
saying they refuse (on mainly economic grounds) that they will/can not
replace a drive that has no reserve sectors remaining for remapping.

I'm with Andreas on this aspect that silently accumulating a list of
bad sectors is specious. But I also can't tell if that's a factor in
this. But this is suggesting f'n ass tons of bad sectors. The sdd2
partition alone has over 2000 bad sectors? What? If that were true
it's a disqualified drive.







>
> I didn't know about the bad block functionality in md.  The mdadm manual
> page doesn't say much, so is this the canonical document?
>
> http://neil.brown.name/blog/20100519043730
>
> Until recently, two of the drives (sda, sdc) were running a firmware
> version which (as far as I can work out) made them occasionally lock up
> and disappear from the OS (requiring a power cycle), this firmware has
> now been updated, so hopefully they'll now behave.

There are user reports of firmware updates causing latent problems
that persist until data is overwritten. I personally always do ATA
Secure Erase, or Enhanced Secure Erase, using hdparm, anytime a drive
gets a firmware update. Unless I simply don't care about the data on
the drive.


> Degraded array reporting was also broken on this machine for a couple of
> weeks due to an email misconfiguration (now fixed), so last week I found
> it with sda (ML0220F30ZE35D) apparently missing from the machine, and
> also with pending sectors on sdb (ML0220F31085KD).  The array rebuilt
> quite quickly from the bitmap, and then I turned to trying to resolve
> the pending sectors...

It's worth checking alignment to make sure writes are for sure
happening on 4KiB boundaries. It's sorta old news, but sometimes old
tools were not using aligned values (parted and fdisk frequently
started the first partition at LBA 34 for example, which is not
aligned). This causes internal RMW in the drive, where any write is
actually treated by the drive first as a read, and can produce a
persistent read error that never gets fixed. To avoid the write being
treated as a RMW, it must be a complete 4KiB write to the aligned 512
byte based LBA. Kinda annoying...



> I'm not really sure from the blog post, under what circumstances a bad
> block entry would end up being written to multiple devices in the array,
> and under what circumstances it might be written to all devices in an
> array?  There are no entries on these array members which appear on only
> one array member, and some are present on all three drives - which seems
> strange to me.

Yes, strange. But even if it's cross reference bad sectors across all
drives, 2000+ bad sectors across 3 drives is too many.


> FWIW, what I'd like to do in the future with this array, is to reshape
> it into a 4 drive RAID6, and then grow it to a 5 drive RAID6, and
> possibly replace one or both of sda (ML0220F30ZE35D) and sdc
> (ML0220F31085KD).

Well I would defer to most anyone on this list, but given the state of
things, I have serious doubts about the array. I personally would
qualify five new drives with badblocks -w using the default 5 rounds
of destructive write-read-verify, making sure to change -b to 4096,
and then make a new raid6 array and migrate the data over.

The current state of the array I consider sufficiently fragile that a
reshape risks all the data. So only if you have a current backup that
you're prepared to need to use would I do a reshape then grow (that's
true anyway even if healthy, but in particular with an array that's in
a weak state).


> In the meantime I'm trying to work out what data (if any) is now
> inaccessible.  This is made slightly more interesting because this array
> has 'bcache' sitting in front of it, so I might have good data in the
> cache on the SSD which is marked bad/inaccessible on the raid5 md device.

OK that's a whole separate ball of wax now.  Do you realize that
bcache is orphaned? For all we know you're running into bcache related
bugs at this point.

If your use case really benefits from an SSD cache, you should look at
lvmcache. And in that case you probably ought to evaluate if it makes
more sense to manage the RAID using LVM entirely rather than mdadm.
It's the same md kernel code, but it's created, managed, monitored all
by LVM tools and metadata. So you get things like per logical volume
RAID levels. The feature set of LVM is really incredibly vast and
often overwhelming, and yet on the RAID front mdadm still has more to
offer and I think is easier to use. But for your use case it might be
easier in the long run to consolidate on one set of tools.


-- 
Chris Murphy
