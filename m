From: Gordon Henderson <gordon@drogon.net>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 08:26:38 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310280749080.23689@unicorn.drogon.net>
References: <3F9DAD4C.3000002@verizon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F9DAD4C.3000002@verizon.net>
To: berk walker <berk.walker@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Oct 2003, berk walker wrote:

> The purpose of my going to raid is to ensure, short of a total
> meltdown/fire, etc, data loss prevention.  If my house and business
> burn, I'm hosed anyway.

Offsite backups...

> I am buying 4 maxtor 40 gb/200mb ultra 133 drives, and another promise
> board, to finally do swraid5 (after reading this list for a few months,
> it seems pretty scary in failure).

Good luck with your promise board (what type is it?) I've had a lot of
problems with them (kernels 2.4.20-22) They seem to work, but under heavy
load, I see processes getting stuck in "D" state (eg. nfsd or anything
doing lots of disk IO) Most of the time they recover, but I've load a disk
partition on more than one occasion (saved by raid, and it re-built OK
after a reboot). I've seen this in 2 different servers and tried both
Intel and AMD CPUs. Tonight I try a set of different PCI IDE controllers
in one server to see if that helps it.

It's hard to tell if it's a real hardware problem or a software one (the
Promise driver being fairly new, patched in at 2.4.20, included in 2.4.22)


> is there an advantage to >more< than 1 spare drive? .. more than 3
> drives in mdx?  why not cp old boot/root/whatever drive to mdx after
> booting on floppy?

The more drives you have in the RAID set, then less "wastage" there is.
Eg. with 3 drives, you get 2 drives worth of data storage, with 8 drives
you get 7 drives of storage.

> is there an advantage to having various mdx's allocated to various
> /directories?..ie: /home, var, /etc

Traditionally yes. I usually build a machine with 4 partitions, root,
swap, /usr and a data partition (may be /var or /home or something else,
depending on the use of the server) Traditionally this was to minimise
head movement between swap and /usr and help keep things separate should a
crash happen, or someone fills up the /home or /var, but these days I'm
not sure, but since I've been doing it that way for the past 18 years it
kinda sticks...

I don't bother with a /boot partition, (IIRC that was only needed in the
bad old >1024 cylinder days) just allocate about 256M to root.  Even thats
a lot more than needed if you have /var on a separate partition. So with 3
disks, I'd have identical partitions:

  0 - 256M
  1 - 1024
  2 - 2048
  3 - Rest of disk

Partitions 0 of the first 2 disks (masters on on-board controllers?) would
be in a RAID1 configuration so you can boot off them, the others in RAID5
configurations, partition 1 for swap, 2 for /usr and 3 for /var or /home
or whatever you need. Your swap partition might need to be differend size
- you'll want it twice the amount of RAM and then a bit more, or none at
all. Disk is cheap these days, but so is memory! With this setup, you'll
have single, spare partition of 256M, and in this case, I'd be happy to
just ignore it. In a 4 disk system, you can combie the 2 spare partitions
into a RAID one and use it for something - if you have use of a 256MB
partition! (but IDE drives are cheap, so generally don't bother, but I
have one server that uses the spare RAID1'd partition for the journal on
an XFS filesystem which seems to improve things a lot)

One interesting conundrum I had recently was with an 8-disk set I was
recycling. (2 SCSI busses, 4 on each bus if you were wondering) Do I put 2
partitions onto each disk and make 2 RAID sets over 8 disks, or use 4
disks in each set to achieve the same results? In the end, I went for 2
partitions on each disk to maximise data capacity (and it turned out to
benchmark slightly faster too) The disadvantage is that if a disk does
down it will mark both RAID sets as degraded, but I can live with that as
we have a cold spare ready to slot in should this ever happen. (and in the
past, this old array has suffered one failure - it's now nearly 5 years
old and has been in a Linux box with RAID5 for all that time, starting
with 2.2.10)

Gordon
