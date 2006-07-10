From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 13:16:36 +0200
Message-ID: <62b0912f0607100416v51309355v693b5c83ee51fdbc@mail.gmail.com>
References: <loom.20060709T205013-455@post.gmane.org>
	 <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>
	 <loom.20060710T095111-275@post.gmane.org>
	 <44B213CD.5010907@idgmail.se>
	 <loom.20060710T112944-980@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20060710T112944-980@post.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Karl Voit <news@karl-voit.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Karl Voit wrote:
> > > 443: root <at> ned ~ # mdadm --examine /dev/sd[abcd]
> >
> > Shows that all 4 devices are ACTIVE SYNC....
>
> Please note that there is no "1" behind sda up to sdd!

Yes, you're right.

Seems you've created an array/superblocks on both sd[abcd] (line 443
onwards), and on sd[abcd]1 (line 66 and onward).

I'm unsure why 'pvscan' says there is an LVM PV on sda1 (line
118/119).  Probably it's a misfeature in LVM, causing it to find the
PV inside the MD volume if the array has not been started (since it
says that the PV is ~700 GB).


> > Running zero-superblock on "sd[abcd]" and then assembling the array
> > from "sd[abcd]_1_" sounds odd to me.
>
> Well this is because of the false(?) superblocks of sda-sdd in comparison to
> sda1 to sdd1.

Yes ok, I missed that part of the story.
In that case it sounds sane to zero the superblocks on sd[abcd],
seeing that 'pvscan' and 'lvscan' finds live data that you could
backup on the array consisting of sd[abcd]1.


> root@ned ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1\
>  /dev/sdc1 /dev/sdd1
> mdadm: cannot open device /dev/sda1: Device or resource busy
> mdadm: /dev/sda1 has no superblock - assembly aborted

Odd message.  Does "lsof | grep sda" show anything using /dev/sda(1)?


> I should have mentioned that I did not use the whole hard drive space for
> sd[abcd]1. I thought that if I have to replace one of my Samsungs with another
> drive that has not the very same capacity, I'd better use exactly 250GB
> partitions and forget the last approx. 49MB of the drives.

Good idea.


> The problem seems to be the superblocks.

Which ones, those on sd[abcd]1 ?
You've probably destroyed them by syncing the array consisting of sd[abcd].


> Can I repair them?

No, but you can recreate them without touching your data.
I think the suggestion from Andreas Gredler sounds sane.

I'm unsure if hot-adding a device will recreate a superblock on it.
Therefore I'd probably run --create on all four devices and use sysfs
to force a repair, instead of (as Andreas suggests) creating the array
with one 'missing' device.

Do remember to zero the superblocks on sd[abcd] first, to prevent mishaps...
