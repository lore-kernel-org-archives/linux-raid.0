From: <pg_mh@mh.to.sabi.co.UK>
Subject: the '--setra 65536' mistery, analysis and WTF?
Date: Wed, 5 Mar 2008 17:21:17 +0000
Message-ID: <18382.54925.354731.996508@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was recently testing a nice Dell 2900 with 2 MD1000 array
enclosure with 4-5 drives each (a mixture of SAS and SATA...)
attached to an LSI MegaRAID, but in a sw RAID10 4x(1+1) (with
'-p f2' to get extra read bandwidth at the expense of write
performance). Running RHEL4 (patched 2.6.9 kernel).

It was greatly perplexed to find that I could get 250MB/s clean
when writing, but usually only 50-70MB/s when reading, but then
sometimes 350-400MB/s. So I tested each disk individually and I
could get the expected 85MB/s (SATA) to 103MB/s (SAS).

Note: this doing very crude bulk sequential transfer tests with
  'dd bs=4k' (and the use of 'sysctl vm/drop_caches=3') or with
  Bonnie 1.4 (either with very large files or with '-o_direct').

Highly perplexing, and then I remembered some people reporting
that they had to do 'blockdev --setra 65536' to get good
streaming performance in similar circumstances, and indeed this
applied to my case too (when set on the '/dev/md0' device).

So I tried several combinations of 'dd' block size, 'blockdev'
read ahead, and disk and RAID device targets, and I noticed
these rather worrying combination of details:

* The 'dd' block size had really little influence on the
  outcome.

* A read-ahead up to 64 (32Kib) on the disk block device reading
  the individual disk resulted in an increasing transfer rate,
  and then the transfer rate reached the nominal top one for the
  disk with 64.

* A read head unless 65536 on '/dev/md0' resulted in increasing
  but erratic performance (the read-ahead on the individual
  disks seemed not to matter when reading from '/dev/md0').

* In both disk and '/dev/md0' cases I watched instantaneous
  transfer rates woith 'vmstat 1' and 'watch iostat 1 2'.

  I noticed that interrupts/s seemed exactly inversely
  proportional to read ahead, with lots of interrupts/s for
  small read-head, and few with large read-ahead.

  When reading from the '/dev/md0' the load was usually spread
  equally between the 8 array disks with 65536, but rather
  unevenly with the smaller values.

* Most revealingly, when I used values of read ahead which were
  powers of 10, the numbers of block/s reported by 'vmstat 1'
  was also a multiple of that power of 10.

All these (which happen also under 2.6.23 on my laptop's disk
and other workstations) seem to point to the following
conclusions:

* Quite astonishingly, the Linux block device subsystem does not
  do mailboxing/queueing of IO requests, but turns the
  read-ahead for the device into a blocking factor, and always
  issues read requests to the device driver for a strip of N
  blocks, where N is the read-ahead, then waits for completion
  of each strip before issuing the next request.

* This half-duplex logic with dire implications for performance
  is used even if the host adapter is capable of mailboxing and
  tagged queueing (verified also on a 3ware host adapter).

All this seems awful enough, because it results in streaming
pauses unless the read-ahead (thus the number of blocks read at
once from devices) is large, but it is more worrying that while
a read-ahead of 64 already results in infrequent enough pauses
for single disk drives, it does not for RAID block devices.

  For writes queueing and streaming seem to be happening
  naturally as written pages accumulate in the page cache.

The read-ahead on the RAID10 has to be a lot larger (apparently
32MiB) to deliver the expected level of streaming read speed.
This is very bad except for bulk streaming. It is hard to
imagine why that is needed, unless the calculation is wrong.
Also, with smaller values the read rates are erratic: sometimes
and for a while high, then slower.

I had a look at the code and in the block subsystem the code
dealing with 'ra_pages' is opaque but there is nothing that
screams that it is doing blocked reads instead of streaming
reads.

In 'drivers/md/raid10.c' there is one of the usual awful
practices of overriding the user's chosen value (to at least two
stripes) without actually telling the user ('--getra' does not
return the actual value used), but nothing overtly suspicious.

Before I do some debugging and tracing of where things go wrong,
it would be nice if someone more familiar with the vagaries of
the block subsystem and of the MD RAID code had a look to guess
at where the problem for the above arise...
