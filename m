From: David Reniau <david.reniau@gmail.com>
Subject: Re: My Thecus RAID-0 filesystem unmountable with mdadm. Please help.
Date: Thu, 27 May 2010 03:03:57 +0200
Message-ID: <AANLkTimDAbGPqen2dW7wtpxMjSup0IK8kcdNEnskibw-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Linux-RAID gurus,

Thank you to all of you for your patience, courage, and for your
precious answers who help me focus on the important things.


@Michael Evans, John Robinson:
-----------------------------

From the RAID recovery wiki:

- I am trying not to get into panik :-/... since February 2010...

- In Feb. 2010, I (manually) performed the 4!=24 RAID disk
permutations to create the RAID array via the loop procedure:

* check mdadm.conf deleted > USB disks powered off > PC reboot > disks
sequentially powered on: 1, 2, 3, 4,
followed by:

* sudo mdadm --create /dev/md0 --level=raid0 --raid-devices=4
/dev/sd[diskpermut1] /dev/sd[diskpermut2] /dev/sd[diskpermut3]
/dev/sd[diskpermut4]

* sudo mount /dev/md0 /media/mylostraid

This procedure was a failure: no combination worked to mount the RAID
filesystem. Only combinations starting with DISK 1 as the first
ordered disk, seemed to return so-called "consistent" error messages.
I empirically concluded that it is likely that order = DISK 1, 2, 3, 4
is probably correct, but so far, I must admit I cannot certify it.



@Luca Berra:
-----------

From above, yes, you read correctly, I used mdadm --create several
times. I am (now) aware this usage has altered the original RAID
superblocks information, which could be one of the causes of this
issue.

As far as I remember (manipulations performed in Feb 2010), I
nevertheless (wrongly?) felt I had no better choice at that time;
indeed, I could not get the array assembled from these 4
fresh-extracted NAS disks under Linux with a straight mdadm
--assemble. The only way had to consist of performing a
--zero-superblocks first, then of using the mdadm --create option to
somehow force the superblocks re-generation. This is my understanding
of what happened in the backstage...

It seemed to work: with potential RAID information loss? Impact(s)?


@John Robinson:
--------------

"...It's also possible that Thecus used a non-default metadata type..."

In my case, passing either 0.90 or a newer version for the metadata
did not change anything... But I should anyway pay attention to that
point the next times I will assemble the array with Ubuntu 10.04.

"...then don't go trying any new create lines, there may be valuable
information available in the RAID superblocks"

Err... From above comments to Luca, I am affraid all of my original
RAID info's gone, right?


@Neil Brown:
-----------
Your scenario asumptions confirm what I was more or less thinking of,
and helped me minimize my initial concerns about this 201 MB
partition, and about the mdadm -E reports.

Following your suggestion:

$ sudo tune2fs -l /dev/md0

tune2fs 1.41.9 (22-Aug-2009)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          7db2aaee-1830-4f1f-8f1b-fd97a6d48a54
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      ext_attr filetype sparse_super large_file
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         not clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              195264512
Block count:              390515200
Reserved block count:     19525760
Free blocks:              88837799
Free inodes:              64986461
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         16384
Inode blocks per group:   512
Last mount time:          Sat Feb 13 05:44:45 2010
Last write time:          Wed May 26 18:53:25 2010
Mount count:              53
Maximum mount count:      27
Last checked:             Wed Jun 28 00:13:42 2006
Check interval:           15552000 (6 months)
Next check after:         Sun Dec 24 23:13:42 2006
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          128

How can I exploit this information?

Repair test fsck -a /dev/md0. I will give it a try probably during the
week-end on the disk images. Since my disks images may be definitively
lost afterwards + about 15 boring hours to recreate them, I will try
to perform other (non destructive) tests on them before... Anyhow,
this manipulation is in the pipe...


@John Robinson, Mikael Abrahamsson, Neil Brown, Michael Evans:
-------------------------------------------------------------

OKay. Therefore, I should not exclude that Thecus may make use of
proprietary and/or of non standard RAID parameters to build a RAID
array. Thinking about it, this assumption is actually quite likely
considering that the ways RAID is managed from one Thecus model to
another seems to vary. Christophe Grenier (testdisk author) suggested
that Thecus may -- why not? -- make use of a patched kernel to read
the raid fs of the Thecus N4100.


Therefore, my first priority BEFORE proceeding to misc. tests and
analysis MUST be collecting all possible accurate information about
Thecus N4100's RAID creation and configuration parameters, in
particular:

- Chunk size,
- RAID metadata version,
- Disk assembling order
- Exact type/features of the RAID filesystem: ext2, ext3, some
proprietary fs, etc.

After reading your emails:

- I opened a ticket to Thecus support requesting all the technical
details about the RAID management parameters internally used in a
Thecus N4100. I am now expecting their answer.
- I also backed-up the contents of this info request to the concerned
Thecus forums. Quicker?
- Within the next days, I will reconnect the Thecus (diskless), and I
will try to investigate its logs and config files (provided I can
access them) in order to find more about this point.


@Michael Evans:
--------------

I will use the the hexdump technique you suggested. Having read about
the crucial need to know about the original RAID parameters, wouldn't
it make sense to use this technique _after_ I could first figure out
and apply the exact Thecus N4100's RAID params to my disks via mdadm?
Be it only to guarantee that the hexdumps I would extract would be
consistent and reliable?


@Neil Brown, John Robinson:
--------------------------

Similarly, IF the default chunk size (64K) i've been using so far with
mdadm happens to be different from the Thecus', would the above
tune2fs -l /dev/md0 command deliver results identical to the above
ones with the corrected Thecus chunk size applied via mdadm
--assemble? Could this parameter modification be sufficient to get my
RAID filesystem back and mountable?


Kind regards,

David
