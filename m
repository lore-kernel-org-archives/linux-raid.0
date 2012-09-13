From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid5:bad sectors after lost power
Date: Thu, 13 Sep 2012 21:00:25 +0100
Message-ID: <20562.15193.654728.242936@tree.ty.sabi.co.UK>
References: <50519cb3.21bf440a.60ca.ffffa83b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50519cb3.21bf440a.60ca.ffffa83b@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I have a problem about raid5.  I created a raid5 [ 3+1 2TB
> with 128KiB chunks ... ] parallel write 150 files to the
> array, the speed of each is 1MB/s.

Your problem with RAID5 is that even writing at just 1MB/s per
file, writing 150 streams in parallel can mean a lot of arm
movement, and a RAID5 of just 4 consumer-class drives probably
can't deliver that many IOPS, unless your writes are pretty
large (e.g. every stream writes 1MB in one go every second).

It probably will mostly work, but with pretty tight margins.
Both because 4 disks are not that many for 150 even relatively
slow streams, and RAID5 writes are correlated because of having
to do full stripe writes (in your case 384KiB at least) to avoid
RMW.

> Unfortunately, the electricity went off suddenly at the
> time. when I turn on the device again, I found the raid5 is in
> recovery.  When the progress of the recovery went up to 98%,
> there was a write error occurred. [ ... ]

That's a bad situation for those disks, because a *write* error
means that there are no more spare sectors available in the
whole disk, because on a write the disk firmware on finding a
bad sector can always transparently substitute it, if there are
spare sectors available. That there are no spare sectors
available means that the firmware previously found a lot of bad
sectors.

=46rom this point onwards you no longer have a RAID issue, the MD
RAID has attempted its rebuild after finding the drives out of
sync, and it is now purely a hardware issue. It is bit offtopic,
but let's go over it without too many details, making obligatory
references to MD RAID aspects where appropriate.

The first one is a vastly misunderstood point about base RAID
systems like MD: they are not supposed to detect errors, they
are deliberately designed under the assumption that any and
every storage issue is discovered and reported to MD by the
block device layer and beneath.

So for example the purpose of parity is *reconstruction* of
data, once the block device layer has reported a device issue,
not the *detection* of corrupted data. It can also be used as an
aside for that, but a numver of optimizations in parity RAID
depend on not using parity to detect issues.

> used =E2=80=9CHDD_Regenerator=E2=80=9D to check if there were bad blo=
cks in
> the disks. The result of the output indicated that sda and sdb
> did have a bad sector.

They have many, but many/most are remapped to spares. The number
will be in the SMART attribute 'Reallocated_Sector_Ct'. The
output is that they have at least one *unspared* bad sector.

> These disks were used for the first time after purchased. Is
> it normal to have bad sectors?

It is quite normal to have bad sectors: a 2TB drive has 4
billion 512B sectors, or 0.5 billion 4KiB sectors, and *some*
percentage of that very large number must be defective.

MD note: since a small number (hundreds) usually flips to bad
over time, it is convenient to use MD sync-checking to *detect*
issues. Since this is an aside convenience, it must be used
explicitly (and if used it is usually VERY IMPORTANT to ensure
that SMART ERC is set for a short timeout).

Also it may be useful to run periodic SMART selftests. But both
MD sync-checking and SMART selftests consume IOPS and bandwidth.

But in your case probably the sudden power loss, perhaps
accompanied by a power surge, may have damaged in some way or
another, depending on the disk mechanics, electronics and
firmware, some significant chunk of the recording surface.

> Could you please help me?

If you want to use 'sda' and 'sdb' for production systems with
any degree of criticality I would say don't do it. If you are
them purely for testing I would suggest some steps that *might*
make them more useful again:

  * If available run SECURITY ERASE on the drives using recent
    versions of 'hdparm'. Many drive firmwares seem to combine
    SECURITY ERASE with refreshing and rebuilding the spared and
    spare sector lists.

  * Map the areas where there are unspared sectors using
    'badblocks' or 'dd_rescue', and then partition the disks
    (using GPT labelling) and create not-to-use partitions on
    those areas. You may have even 10% or more of the disk in
    bad sectors, but as long as the partition(s) you actually
    use don't cross a bad area, it is relatively safe to use
    them.  Some older filesystems can be given bad-sector lists
    and will not use them, but with RAID5 that becomes a bit
    complicated.

Note that often drives with many *spared* sectors can perform
badly because the spare sectors that subtitute for bad one can
be rather far away from them, causing sudden long seeks.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
