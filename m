From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: How about reversed (or offset) disk components?
Date: Wed, 12 Nov 2008 15:12:46 -0500
Message-ID: <491B38BE.6070309@hp.com>
References: <43d009740811111040x5e610582n9f9bd4354682ca16@mail.gmail.com> <62a7356ceb508b25c3951da7fc7d10b5.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62a7356ceb508b25c3951da7fc7d10b5.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: for.poige+linux@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> On Wed, November 12, 2008 5:40 am, Igor Podlesny wrote:
>> 	Hi!
>>
>> 	And I have one more idea: How about reversed (or offset) disk
>> components? -- It's known that linear read speed is decreasing when
>> reading from the beginning to end of HDD, thus leading to situation
>> when reading from RAID is good at its beginning and rather poor at its
>> ending. My suggestion (possibly) would make that speed almost constant
>> in despite of reading position. Examples:
>>
>> 	RAID5:
>>
>> 	disk1: 0123456789
>> 	disk2: 3456789012
>> 	disk3: 6789012345
>>
>> 	i. .e, the disk1's chunks aren't offseted at all, and disks' 2 and 3 are.
>>
>> 	RAID0:
>>
>> 	disk1: 0123456789
>> 	disk2: 9876543210
>>
>> 	Any drawbacks?
> 
> It is hard to be really sure without implementing the layout and making
> measurements.
> You could probably do this by partitioning each device into three partitions,
> combining those together with a linear array so they are in a different
> order, then combining the three linear arrays into a raid5.

I'm not quite sure I did _exactly_ this - but I have some graphs which
may help explain this a bit. Caveat Emptor: _one_ type of storage and
_one_set of results...

o  16-way AMD64 box (128GB RAM, Smart Array (CCISS) P800 w/ 24 300 GB disks)

o  Linux 2.6.28-rc3

o  Used 4 disks behind the P800: each was partitioned into 4 pieces:

# parted /dev/cciss/c2d0 print

Model: Compaq Smart Array (cpqarray)
Disk /dev/cciss/c2d0: 300GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      17.4kB  75.0GB  75.0GB               primary
 2      75.0GB  150GB   75.0GB               primary
 3      150GB   225GB   75.0GB               primary
 4      225GB   300GB   75.0GB               primary

==============================================================

First, I did some asynchronous direct I/Os for each of the partitions:
doing random (4KiB) / sequential (512KiB) reads & writes. The graphs are at:

http://free.linux.hp.com/~adb/2008-11-12/rawdisks.pnm

(Each disk is a separate color, and each bunch of vertical bars
represents a specific partition.)

It shows that for random I/Os there's a _slight_ tendency to go slower
as one gets to the latter parts of the disk (last partition), but not
much - and there's a lot of variability. [The seek times probably swamp
the I/O transfer times here.]

For sequential I/Os there's a noticeable decline in performance for all
4 disks as one proceeds towards the end - 25-30% drops for both reads &
writes between the first & last parts of the disk.

==============================================================

Next I did two sets of runs with MD devices made out of these
partitioned disks - see

http://free.linux.hp.com/~adb/2008-11-12/standard.pnm

("Standard") Made 4 MDs, increasing the partition with each MD - thus
/dev/md1 was constructed out of /dev/cciss/c2d[0123]p1, /dev/md2 out of
/dev/cciss/c2d[0123]p2, ..., /dev/md4 out of /dev/cciss/c2d[0123]p4.
(/dev/md1 out of the "fastest" partition on each disk, and /dev/md4 out
of the "slowest" partition on each disk.) [[These are the black bars in
the graphs.]]

("Offset") Made 4 MDs, staggering the partitions as Neil suggested -
thus /dev/md1 had /dev/cciss/c2d0p1 + /dev/cciss/c2d1p2 +
/dev/cciss/c2d2p3 + /dev/cciss/c2d3p4 and /dev/md2 had d0p2 + d1p3 +
d2p4 + d3p1 and so on. [[These are the red bars in the graphs.]]

Strange results came out of this - granted it was one set of runs, so
some variability is to be expected.

For random read/writes we again see seek stuff swamp I/O transfer
peculiarities. But nothing to show that doing an "Offset" configuration
helping out.

Anyways, the sequential read picture  makes great sense: With the
"Standard" set up we see decreasing performance of the RAID0 sets as we
utilize "slower" partitions : ~470MiB/sec down to ~350MiB/sec. With the
"Offset" partitions, we are truly gated by the slowest partition - so we
get consistency, but overall slower performance : ~350MiB/sec across the
board.

The sequential write picture is kind of messy - the "Offset"
configuration again shows somewhat gated performance (all around 325
MiB/second) but the "Standard" config goes up and down - I _think_ this
just may be an artifact of the write-caching on the P800?!? If need be,
I could disable that, and I'd _guess_ we'd see a picture more in line
with the sequential reads.

Alan
