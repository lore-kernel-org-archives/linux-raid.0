From: Antonio Perez <ap23563m@gmx.com>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Wed, 14 Oct 2009 03:45:21 -0400
Message-ID: <hb3vij$j47$1@ger.gmane.org>
References: <hb1udb$6t1$1@ger.gmane.org> <20091013152304.GA19668@cthulhu.home.robinhill.me.uk>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:

> On Tue Oct 13, 2009 at 09:13:13AM -0400, Antonio Perez wrote:
[snip]
>> However, and this I don't know, those sda[2..4] are not really different
>> devices (spindles) and reads to one md would conflict (or not?) with
>> reads to the other mds.

> Any reads to the same disk will conflict - whether they're on separate
> arrays or within a single array shouldn't make any difference

Perfect, you understood exactly what I was asking, thanks.

> (the IO elevator is set on the disk rather than the array, so I assume
> it will gather requests across all arrays).  md itself knows that the
> arrays share disks, so will ensure any maintenance tasks (resyncs, etc)
> only run on a single array at a time.

Clear explanation, thanks.

Then, the two consequences of dividing disks in several md are correct:

1.- Will improve rebuild time, as each md is smaller.
2.- Will allow to control if the md is in the outside (faster) disk area.

Am I understanding you correctly?

>> 2.- On the Raid 1: How many sectors to copy? 63?
>> On an update of grub code, core.img could change, which means that the
>> first 63 sectors (to be on the safe side) of the disk which gets the
>> update should be copied to the other 3 disks.
>> Or is it that the md code would mirror sectors 1-62 and only the MBR
>> needs to be manually mirroed?

> Not sure what you mean here.  If you have /boot on a RAID1 array then
> it's mirrored, so the stage1.5 and stage2 bootloaders get mirrored via
> that.  The stage1 bootloader is usually installed into the MBR, so only
> that needs replicating separately.

There are two areas of interest:

1.- The "Boot disk area" including the MBR.:
On the usual (at least for me) partition scheme, the first cylinder*, 
Sectors (LBA) 0-62 [CHS 0/0/1 to 0/0/63] of the disk are left empty, except 
for sector 0, a.k.a. MBR. That is called the disk boot area.
Grub uses the sector 0 as the MBR and several sectors following it to embed 
the booting code: core.img.

2.- The "partition boot area":
There is also an empty space at the beginning of each partition of 63 
sectors. The first partition uses (LBA) 63-125 [CHS 0/1/0 to 0/1/63] for the 
"partition boot area" therefore restoring alignment on the disk heads.
Next partitions repeat this setup.
This area is used to boot if grub is installed to sda1 instead of sda

So, I assume that a RAID1 on "sd[a..d]1" will mirror the "Area 2" but will 
not touch any of the "Area 1".

Is this assumption correct?


* note: it really feels ugly to speak of cylinders on this day and age, but 
thats how the PC-style scheme works.

>> 2.- Is there a recomended way to trigger the said copy of question 2?
>> Where should a call to copy the MBR should be placed? On update-grub?

> I always just rerun the grub install for each disk manually (see
> http://lists.us.dell.com/pipermail/linux-poweredge/2003-July/008898.html
> for example).

That's the usual procedure on a first install, correct.

> Automating it will depend on your distribution - if
> update-grub is what's called after a grub update (and it isn't
> overwritten by the update) then this would seem the logical place to do
> it.

I'll have to dig deeper to make any intelligent question, Thanks.

> HTH,
>     Robin

It did a lot, thanks again!

-- 
Antonio Perez

