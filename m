From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFH] Partition table recovery
Date: Sat, 21 Jul 2007 19:54:14 +0200
Message-ID: <46A24846.7050803@gmail.com>
References: <200707200813.03553.a1426z@gawab.com> <200707201429.34419.a1426z@gawab.com> <20070720113914.GJ22998@lug-owl.de> <200707201522.17270.a1426z@gawab.com> <20070720160614.GG26752@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757536AbXGURzu@vger.kernel.org>
In-Reply-To: <20070720160614.GG26752@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 07/20/2007 06:06 PM, Theodore Tso wrote:

> It wouldn't be that hard to put a backup partition table at the beginning
> of an ext2/3 filesystem.  No one is currently using the space between
> offset 512 and 1023 bytes, and it would be an easy place to stash a
> backup copy of the partition table.  We wouldn't be able to use the MBR
> format, since information about extended partitions are stored scattered
> across the disk.

I was looking into this, but I'm afraid I believe it's not a very good idea.

> So for the sake of argument, I'll propose the following partition
> backup, starting at offset 512 and going for 512 bytes to byte #1023:
> 
> offset 
> from 512  Description
> -------   -----------
> 0..7      Signature ASCII: "PARTBAK1"
> 8..9      Part-type: 1=MBR

Not sure what you mean with this type field. You were suggesting to only 
backup "Plain Ol' Partition" tables anyway weren't you?

> 10	  # of heads
> 11	  # sectors

This is a problem. Today the CHS fields in the partition entries don't mean 
much of anything anymore and Linux happily ignores them but DOS and (hence) 
Windows 9x do not. From time to time I still have the Windows 98 install 
that's sitting in a corner of my disk throw a fit just by having set the 
BIOS from LBA to Large (meaning the geometry the BIOS pretends the disk has 
changes) for example. Old DOS installs that I keep around for the purpose of 
hardware testing with the originally supplied drivers make for even more of 
a "don't touch, don't touch!" thing -- various version of DOS throw fits for 
various reasons.

As such, really the only functional thing to do is backup _whatever_ is 
there in the CHS fields in the entries currently and unfortunately this can 
vary between entries, and certainly between runs of whatever program creates 
them. For example, the user may have adjusted the layout in the BIOS or some 
or all partitions may have been created while the disk was in a different 
machine all together. That is to say, really no attempt should be made at 
being smart about the CHS values -- a backup should just store the actual 
(16-byte) partition table entry.

> 12	  # of partitions in the backup
> 13..15    Reserved (must be zero)
> 16..31	  first part entry
> ...
> 496..511 31st partition entry

And this is the biggest problem. IDE for example allows 63 partitions and 
while in practice not many people will actually also have used that many, 31 
isn't hugely roomy either especially due to the way extended partitions are 
kept.

An extended partition is a partition with type (0x05 || 0x0F || 0x85) the 
first sector of which contains another partition table. That second-level 
partition table generally consists of two entries; the first for the logical 
(actual) partition and the second being yet another extended partition, 
where walking the list gets you all.

However, there can be more than just 1 extended partition on a disk and this 
isn't (or wasn't...) in fact uncommon. Windows 9x at least used to create 
multiple partitions as 1 primary and the rest (even if just 1 as well) as 
logicals inside one 0x05/0x0F extended. When you then installed Linux onto 
the same disk, needed more than the 3 MBR entries left, and wanted to make 
sure that Windows wouldn't trip over any non-fat entries in the list of 
extended partitions (which it did) you'd create 1 0x85 "Linux only" extended 
  in the MBR that Windows just ignores -- not a problem since it couldn't 
read any of the filesystems on them anyway.

This already means you need to keep more information that just the logicals 
(the actual partitions) since you can't reliably restore the tables from a 
list of them alone.

Moveover, the "generally consists of two entries" above isn't guaranteed 
either. The second-level table _can_ contain more than 1 logical. Linux 
never minded much of anything and back when I was experimenting with more 
operating systems (on one disk) they did -- I used to mostly create my 
partition tables with Norton Diskedit at the time...

A bullet-proof backup then has to really store these actual second-level 
tables verbatim again as you can't assume too much about them meaning you're 
going to be storing a complete 4-entry table for every logical which 
ofcourse eats space in the available 512 bytes / 31 entries _way_ too fast.

Moreover once more -- why stop at "normal" logicals? I for example have a 
MINIX 2 partition sitting on this disk and it uses a subpartitioning scheme 
through the same DOS-style second-level partition-table setup. First entry 
in the second-level table is generally used for / and third for /usr meaning 
two additional partitions. And if two aren't bad enough, from time to time 
(when after buying a new disk my ogg vorbis collection hasn't yet grown to 
fill it again yet) I keep a FreeBSD install around which means 6 or so 
additional "slices".

Ignoring those alien partitions is sort of okay, but as said, with only 512 
bytes to spare, this is all inevitable going to be a "sorta works most of 
the time perhaps" sort of solution. The best solution is a little program 
that backs things up verbatim to wherever you want (such as a floppy or USB 
stick for example).

sfdisk -d already works most of the time. Not as a verbatim tool (I actually 
semi-frequently use a "sfdisk -d /dev/hda | sfdisk" invocation as a way to 
_rewrite_ the CHS fields to other values after changing machines around on a 
disk) but something you'd backup on the FS level should, in my opinion, need 
to be less fragile than would be possible with just 512 bytes available.

Rene.
