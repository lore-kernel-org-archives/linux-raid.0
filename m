From: Michael Tokarev <mjt@tls.msk.ru>
Subject: *terrible* direct-write performance with raid5
Date: Tue, 22 Feb 2005 20:39:41 +0300
Message-ID: <421B6E5D.6030004@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When debugging some other problem, I noticied that
direct-io (O_DIRECT) write speed on a software raid5
is terrible slow.  Here's a small table just to show
the idea (not numbers by itself as they vary from system
to system but how they relate to each other).  I measured
"plain" single-drive performance (sdX below), performance
of a raid5 array composed from 5 sdX drives, and ext3
filesystem (the file on the filesystem was pre-created
during tests).  Speed measurements performed with 8Kbyte
buffer aka write(fd, buf, 8192*1024), units a Mb/sec.

           write   read
   sdX      44.9   45.5
   md        1.7*  31.3
fs on md    0.7*  26.3
fs on sdX  44.7   45.3

"Absolute winner" is a filesystem on top of a raid5 array:
700 kilobytes/sec, sorta like a 300-megabyte ide drive some
10 years ago...

The raid5 array built with mdadm with default options, aka
Layout = left-symmetric, Chunk Size = 64K.  The same test
with raid0 or raid1 for example shows quite good performance
(still not perfect but *much* better than for raid5).

It's quite interesting how I/O speed is different for fs on md
vs fs on sdX case - with fs on sdX, filesystem code adds almost
nothing to the plain partition speed, while it makes alot of
difference when used on top of an md device.

Comments anyone? ;)

Thanks.

/mjt
