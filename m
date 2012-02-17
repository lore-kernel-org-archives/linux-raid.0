From: pg@lxra2.sabi.co.UK (Peter Grandi)
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Fri, 17 Feb 2012 18:44:30 +0000
Message-ID: <20286.40974.897300.844651@tree.ty.sabi.co.UK>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
	<4F35E925.6000003@hardwarefreak.com>
	<CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
	<4F38FD5D.1010201@hardwarefreak.com>
	<CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
	<20120213230228.GA5822@www5.open-std.org>
	<4F39D9B2.3050305@hardwarefreak.com>
	<20120214113832.GA6157@www5.open-std.org>
	<4F3AEDEF.2000608@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3AEDEF.2000608@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> The results of the target workload should be interesting,
>>> given the apparent 7 spindles of stripe width of
>>> mdraid10,f2, and only 3 effective spindles with the linear
>>> array of mirror pairs, an apparent 4 spindle deficit.
[ ... ]
 
>>> raid10,f2 would have a more uniform performance as it gets
>>> filled, because read access to files would still be to the
>>> faster parts of the spindles.
[ ... ]
>> Well, I was talking for a given FS, including XFS. As
>> raid10,f2 limits the read access to the faster halves of the
>> spindles, reads will never go to the slower halves. [ ... ]

That's not how I understand the 'far' layout and its
consequences, as described in 'man 4 md':

  "The first copy of all data blocks will be striped across the
   early part of all drives in RAID0 fashion, and then the next
   copy of all blocks will be striped across a later section of
   all drives, always ensuring that all copies of any given
   block are on different drives.

   The 'far' arrangement can give sequential read performance
   equal to that of a RAID0 array, but at the cost of degraded
   write performance."


 and I understand this skepticism:

> Maybe I simply don't understand this 'magic' of the f2 and far
> layouts.  If you only read the "faster half" of a spindle,
> does this mean writes go to the slower half?  If that's the
> case, how can you read data that's never been written?

The 'f2' layout is based on the idea of splitting each disk in
two (mor more...), and putting the first copy of each chunk in
the first halves, and the second copy of each chunk in the
second halves (of the next disk to uncorrelate storage device
failures).

The main difference is not at all that reads become faster
because they happen in the first halves, but because they become
more parallel *for single threaded* reads, consider for example
for six drives in 3 pairs:

  * With 'n2', traditional RAID0 of RAID1, the maximum degree of
    parallelism is 6 chunks read in parallel only if *two
    threads* are reading, because while one thread can read 6
    chunks in parallel, half of those chunks are useless to that
    thread because they are copies.

  * With 'f2' a *single thread* can read 6 chunks in parallel
    because it can read 6 different chunks from all the first
    halves or all the second halves.

  * With 'f2' the main price to pay is that *peak* writing speed
    is lower because because each drive is shared between copies
    of two different chunks in the same stripe, not because of
    speed difference between outer and inner tracks. The issue
    is lower parallelism, plus extra arm seeking in many cases.
    Consider the case of writing two consecutive chunks at the
    beginning of a stripe:
    - With 'f2' the first chunk gets written to the top of drive
      1, and bottom of drive 2. Then the next chunk is written
      to the top of drive 2, and the bottom of drive 3. Drive 2
      writes must be serialized and arm must move half a disk.
    - With 'n2' the first chunk goes to drives 1 and 2, and the
      second to drives 3 and 4, so there is no serialization of
      writes and no arm movement.
    With 'f2' writing 2 chunks means spreading the writes to 3
    drives instead of 4, and this reduces the throughput, but
    the real issue is the extra seeking, which also increases
    latency.

Something very close to RAID10 'f2' is fairly easy to build
manually, for example for two drives:

  mdadm -C /dev/pair1 -l raid1 -n 2 /dev/sda1 /dev/sdb2
  mdadm -C /dev/pair2 -l raid1 -n 2 /dev/sdb1 /dev/sda2
  mdadm -C /dev/r10f2 -l raid0 -n 2 /dev/pair1 /dev/pair2

If one really wants for all reads to go preferentially to
'/dev/sda1' and '/dev/sdb1' one can add '-W' as in:

  mdadm -C /dev/pair1 -l raid1 -n 2 /dev/sda1 -W /dev/sdb2
  mdadm -C /dev/pair2 -l raid1 -n 2 /dev/sdb1 -W /dev/sda2
  mdadm -C /dev/r10f2 -l raid0 -n 2 /dev/pair1 /dev/pair2

The same effect can be obtained with an 'n2' over the same four
partitions, listing them in the appropriate order:

  mdadm -C /dev/r10f2 -n raid10 -n 4 \
    /dev/sda1 /dev/sdb2 \
    /dev/sdb1 /dev/sda2

With 3 mirrors on 3 drives:

  mdadm -C /dev/mirr1 -l raid1 -n 3 /dev/sda1 /dev/sdb2 /dev/sdc3
  mdadm -C /dev/mirr2 -l raid1 -n 3 /dev/sdb1 /dev/sdc2 /dev/sda3
  mdadm -C /dev/mirr3 -l raid1 -n 3 /dev/sdc1 /dev/sda2 /dev/sdb3
  mdadm -C /dev/r10f2 -l raid0 -n 3 /dev/mirr1 /dev/mirr2 /dev/mirr3

The 'f2' RAID10 layout is very advantageous with mostly-read
data, and in the 2-drive case where it is more like RAID10,
because the 'n2' layout in the 2-drive case is just RAID1.
