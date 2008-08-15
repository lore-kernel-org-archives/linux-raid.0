From: Jan Wagner <jwagner@kurp.hut.fi>
Subject: single RAID slower than aggregate multi-RAID?
Date: Fri, 15 Aug 2008 16:55:07 +0300 (EEST)
Message-ID: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

at work we have been experimenting with SATA-II port multipliers and SATA 
controllers (FIS-based). For some reason the RAID-0 performance is 
relatively awful.

We have one 4xeSATA controller card ADSA3GPX8-4E, twelve SpinPoint F1 
disks that handle ~110MB/sec, and four port Addonics port multiplier 
boxes. Ubuntu, kernel 2.6.24-19-generic x86_64, 2 x AMD2212 Opteron on an 
Asus L1N64-SLI WS.

We did two sequential writing tests. One test with all 12 disks 
behind the controller placed into one mdadm RAID-0, 512k..2048k 
chunksize. We get ~475 MB/s.

The second test used four "mdadm --create"'s to reassign the 12 drives 
into four RAID-0 with 3 disks in each. All four raids were simultaneously 
written to. We get ~250 MB/s/raid and 1000 MB/s aggregate.

So the controller can handle at least 1000 MB/s.

My question is why is the single RAID setup more than half slower? Any 
ideas?

Is there some kernel per-device bandwidth throttling?

I already tried: O_DIRECT, posix_fadvise(), madvise(), pdflush tuning, 
different test programs, using a raw /dev/md{0,1,2,3} vs testing 
the xfs filesystem. None of them get the single RAID performance over 475 
MB/s. CPU load isn't a likely problem either. To check I wrote a threaded 
program[1] that has threads writing in-sequence into the same output file. 
All 4 cores loaded very evenly and are >=60% idle. But the rate is still 
475 MB/s. Puzzling and frustrating :-)

Is there still something that a desperate person could try to tune to get 
this lousy mdadm raid throughput improved?? :-)

Thanks in advance,

  - Jan

[1] http://www.metsahovi.fi/~jwagner/tmp/wr-nexgen-threaded.c

