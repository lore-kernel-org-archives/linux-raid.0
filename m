From: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>
Subject: RAID newbie, 1 vs 5, chunk sizes
Date: Sat, 14 Jun 2014 22:01:40 +0100
Message-ID: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Sorry if this is the wrong list. Most of the stuff out there seems
outdated, and i have some specific doubts.

I'm trying to decide how to best create a RAID array and what
configuration to use. This is a desktop system, nothing
mission-critical, but i'd like it to be reasonably tailored to the
hardware and intended usage, and have questions about default values.

Hardware:
    1x Toshiba DT01ACA100 - 32MB bus, 931.0 GiB (1 TB; 1000204886016 bytes)
    2x Seagate ST1000DM0003 - 64MB bus, 931.0 GiB (1 TB; 1000204886016 bytes)
and
    1x Maxtor 6G160E0 - 8MB bus, 149.1 GiB (160 GB; 160041885696 bytes)

The 3 1TB disks all show similar data using
# fdisk -l /dev/sda

    Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
    255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 4096 bytes
    I/O size (minimum/optimal): 4096 bytes / 4096 bytes

The Maxtor is different, of course. The system has 8GiB RAM and a
Phenom II quadcore, running Debian Wheezy (stable) at the moment. The
motherboard's an Asus M2nPV-VM. On top the the software RAID i intend
to put LVM and then XFS for the / partition. Then i'll want to use
Xen. One of the VMs will be my regular desktop, another may be a
Windows HVM, another for LAN streaming, other(s) for trying out
distros...

My first question is: does the disk cache size *significantly* affect
performance? Are there any caveats? I assume not (i've already used
another Seagate with maybe 32MB of cache and the Maxtor in a RAID1
159GB array) but i ask because i'm trying to decide between the 2
Seagates in RAID1 + the Toshiba *or* all 3 in RAID5.
I don't intend to put the system under heavy load, but that may be
relative if i want to run 2-3 VMs in Xen and doing some streaming or
running a webserver or what not. It seems to me the overhead RAID5 has
on a system is either irrelevant for this kind of light usage or not
so much an issue with modern hardware (although the motherboard's the
bottlebeck here).

Secondly, the chunks. How do they relate to sectors and why are they
different in fdisk output? From [1] the chunk size should be at least
4KiB, so 4096 bytes seems to match sector size. Am i making the right
assumptions? Or the wrong ones even if the conclusion may be correct?
Chunk size is irrelevant to RAID1, so i assume the 4 KiB value would
apply; but for RAID5 128 KiB are suggested[2], which seems a big
difference. Is there a formula for this? A rule of thumb?
If i go for RAID5 i'd have to consider stripes, which would be 3*4KiB
in size? Of should i use only 2*4KiB as the 3rd chunk is for parity?

The partition type will depend on the RAID type. I've used whole disks
for RAID1, but i'd probably use partitions slightly smaller if i go
for RAID5. I'm assuming binary units are the way to go here,
regardless of vendor usage (and other issues). I'll just have to get
used to the 931 GiB figure.

Sorry if this is a big message or miss-directed but i'd really like
some experienced suggestions before i go re/installing stuff and
creating VMs.

Thanks,
Nuno

[1] https://raid.wiki.kernel.org/index.php/Chunk_size
[2] https://raid.wiki.kernel.org/index.php/RAID_setup#RAID-5


-- 
"On the internet, nobody knows you're a dog."
