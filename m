From: "Christian Pernegger" <pernegger@gmail.com>
Subject: raid10 vs raid5 - strange performance
Date: Tue, 25 Mar 2008 22:33:06 +0100
Message-ID: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I did a few tests of raid10 on an old 3ware 7506-8 today (using 6
drives), both with the built-in raid 10 and md's n2 and chunk sizes
from 64KB to 1024KB.
- caches dropped before each test
- averages of three runs
- arrays in synced state
- dd tests: 6GB (3MB bs)


dd-reads:
single drive: 64 MB/s
3w: 104-114 MB/s
md: 113-115 MB/s

bonnie++-reads:
single drive: 36 MB/s
3w: 94-97 MB/s
md: 101-108 MB/s

The card unfortunately is in a regular PCI slot, not bad considering.

dd-writes:
single drive: 67 MB/s
3w: 42 MB/s
md: 42 MB/s

bonnie++-writes:
single drive: 36 MB/s
3w:  40-41 MB/s
md:  41 MB/s

3w and md speed are pretty much identical and just barely over that of
a single drive. If it's because md has to send the same data to
multiple disks 3w should have an advantage but it does not.

So I ran the same tests using a md-raid5 over the same disks just for
kicks (512KB chunks, no bitmap):

dd-reads: 115 MB/s
bonnie++-reads: 87  MB/s
dd-writes: 69 MB/s
bonnie++-writes: 62  MB/s

Writes are actually a lot better than any raid10 ... despite all the
hype it gets on the list. I wanted to go with raid10 for this box
because it's not mostly-read for a change.

Explanations welcome.

Chris
