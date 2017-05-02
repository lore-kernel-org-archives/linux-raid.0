From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: Re: [RndTbl] Big-endian RAID5 recovery problem
Date: Tue, 2 May 2017 02:29:26 -0500
Message-ID: <20170502022926.20938dd5@pog.tecnopolis.ca>
References: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Thompson <athompso@athompso.net>
Cc: Continuation of Round Table discussion <roundtable@muug.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017-05-01 Adam Thompson wrote:
> The problem is that the disks use the v0.90 metadata format, and they 
> came from a big-endian system, not a little-endian system.  MD 
> superblocks *since* v0.90 are endian-agnostic, but back in v0.90, the 
> superblock was byte-order specific.

This may sound crazy, but conceivably you could (using the md source
code) find where the superblock lives (just the first copy should be
enough), hex edit the superblock and (again using the source) swap
bytes around to change the endian-ness.  Then make sure any future
mdadm commands are just using the first superblock (which I think is
the default).

If there's some kind of checksum involved, then the endian-ness may
affect it (??), and fudging that may be quite difficult (compared to
finding a big-endian box out there to borrow instead!).

No matter what you do, I would instantly dd each real disk into files
in your own big fs and work on the copies.  No reason to ever write to
the originals, keep them as backups.  I *think* you can use mdadm on
plain files(??) otherwise I guess you could subpartition a big disk.
Ya, it will be cheesy to run RAID5 all off of 1 disk, but in this case
performance won't be critical.

Lastly, I would make sure to start the array in such a way that for
sure it won't resync, so either get all 3 preset perfectly, or leave 1
as missing, or I think there's a command to not start if it would
result in a dirty array.
