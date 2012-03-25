From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Rescue md/6 array: advice please
Date: Sun, 25 Mar 2012 14:02:05 +0100
Message-ID: <20335.5965.847038.272149@tree.ty.sabi.co.UK>
References: <4F6E3E50.3010000@ivimey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F6E3E50.3010000@ivimey.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] my raid6 array died today when a controller died and
> took 3 of 5 disks out of the array. I think/hope the disks
> (1TB enterprise Seagate) are ok,

The details of =ABdied and took 3 of 5 disks out of the array=BB
matter, and what was running at the time.

One guess then is that you were using two host adapter chips,
perhaps one onboard and one in a PCI/PCIe slot, and IO continued
on the disks attached to one while the other was not working,
but none od the disks were faulty, 3 just went offline because
the host adapter chip stopped working.

In the ideal case the host adapter that died just died, in the
worst it did random writes at random places on the 3 drives
connected to it before stopping, so even if the 3 drives may be
physically fine, their contents may be damaged.

> but obviously the event counts are now different. [ ... ] The
> event count of the missing disk was about 20 events lower than
> the latest disk's count.

I guess that you know that then some stripes will likely be
"wrong".

While it is a bit worrying that MD continues to do IO to members
of a RAID set when some have gone offline below the level at
which the set is viable, it is not easy to see what MD could do
about it, as those writes could be just in the queues, and the IO
subsystem would not know that they are related.

> I do have a backup, but would prefer not to have to rely on
> it: if there is an error in restoring from the backup I don't
> have a third line of defence!

A bit improvident (I buy drives in fours, one active drive and 3
backups, 1 online and 2 offline duplicated over eSATA), but you
need to use the backup to at least verify as far as possible the
contents of the RAID set you are about to recover, if only to
check whether the host adapter that died didn't do really bad
random things.

> I believe the correct way forward is to force an mdadm
> assemble, with the failed-disk and readonly options, to build
> a minimal (3 of 5?)  array,

That sounds both sensible and cheating, but good cheating in your
case as it will get MD to not notice that some stripes are
inconsistent.

If you have time to spare you may want to put in all 5 drives (or
4) with '--assume-clean' and RO first and run scrubbing check
('man 4 md' has a specific section) to see the reported count of
innconsistencies. It may be a good time to verify against the
backup too.

> then assuming it works do an fsck to see if it checks out,

And I'll insist about the verify from backup for a double check
of the data contents, not just the metadata.

> then rotate for the best combination,

As a guess ideally the 3 disks with the smallest difference in
event counts among them, not necessarily those with the highest
counts.

As you report that 2 disks were attached to the host adapter
that didn't die, so they are "current", so your choices are:

  * Those 2 disks plus the most recent one from the 3 that went
    offline because of host adapter death.

  * If the host adapter died quickly and peacefully, the 3 drives
    connected to it will be (nearly or completely) consistent at
    least as MD goes, even if not current, as some in-page-cache
    data will not have made it to them.

> then rebuild without readonly, then add in the rest of the
> failed disks.

After zeroing the MD labels of the remaining two disks, because
they are going to be overwritten anyhow.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
