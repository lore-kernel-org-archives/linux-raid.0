From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 14:30:29 -0400
Message-ID: <yq1zm2ttb22.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<467273AB.9010202@argo.co.il>
	<18035.3009.568832.785308@notabene.brown>
	<20070618045759.GD85884050@sgi.com>
	<18041.59628.370832.633244@notabene.brown>
	<Pine.GSO.4.64.0706211417180.15647@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0706211417180.15647@montezuma.acc.umu.se> (Mattias Wadenstein's message of "Thu, 21 Jun 2007 14:40:44 +0200 (MEST)")
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Neil Brown <neilb@suse.de>, David Chinner <dgc@sgi.com>, Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Mattias" == Mattias Wadenstein <maswan@acc.umu.se> writes:

Mattias> In theory, that's how storage should work. In practice,
Mattias> silent data corruption does happen. If not from the disks
Mattias> themselves, somewhere along the path of cables, controllers,
Mattias> drivers, buses, etc. If you add in fcal, you'll get even more
Mattias> sources of failure, but usually you can avoid SANs (if you
Mattias> care about your data).

Oracle cares a lot about people's data 8).  And we've seen many cases
of silent data corruption.  Often the problem goes unnoticed for
months.  And by the time you find out about it you may have gone
through your backup cycle so the data is simply lost.

The Oracle database in combination with certain high-end arrays
supports a technology called HARD (Hardware Assisted Resilient Data)
which allows the array front end to verify the integrity of an I/O
before committing it to disk.  The downside to HARD is that it's
proprietary and only really high-end customers use it (many
enterprises actually mandate HARD).

A couple of years ago some changes started to trickle into the SCSI
Block Commands spec.  And as some of you know I've been working on
implementing support for this Data Integrity Field in Linux.

What DIF allows you to do is to attach some integrity metadata to an
I/O.  We can attach this metadata all the way up in the userland
application context where the risk of corruption is relatively small.
The metadata passes all the way through the I/O stack, gets verified
by the HBA firmware, through the fabric, gets verified by the array
front end and finally again by the disk drive before the change is
committed to platter.  Any discrepancy will cause the I/O to be
failed.  And thanks to the intermediate checks you also get fault
isolation.

The DIF integrity metadata contains a CRC of the data block as well as
a reference tag that (for Type 1) needs to match the target sector on
disk.  This way the common problem of misdirected writes can be
alleviated.

Initially, DIF is going to be offered in the FC/SAS space.  But I
encourage everybody to lean on their SATA drive manufacturer of choice
and encourage them to provide a similar functionality on consumer or
at the very least nearline drives.


Note there's a difference between FS checksums and DIF.  Filesystem
checksums (plug: http://oss.oracle.com/projects/btrfs/) allows the
filesystem to detect that it read something bad.  And as discussed
earlier we can potentially retry the read from another mirror or
reconstruct in the case of RAID5/6.

DIF, however, is a proactive technology.  It prevents bad stuff from
being written to disk in the first place.  You'll know right away when
corruption happens, not 4 months later when you try to read the data
back.

So DIF and filesystem checksumming go hand in hand in preventing data
corruption...

-- 
Martin K. Petersen	Oracle Linux Engineering

