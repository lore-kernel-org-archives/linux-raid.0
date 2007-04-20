From: Pallai Roland <dap@mail.index.hu>
Subject: major performance drop on raid5 due to context switches caused by small max_hw_sectors
Date: Fri, 20 Apr 2007 23:06:14 +0200
Message-ID: <200704202306.14880.dap@mail.index.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi!

 I made a software RAID5 array from 8 disks top on a HPT2320 card driven by 
hpt's driver. max_hw_sectors is 64Kb in this proprietary driver. I began to 
test it with a simple sequental read by 100 threads with adjusted readahead 
size (2048Kb; total ram is 1Gb, I use posix_fadvise DONTNEED after reads). 
Bad news: I noticed very weak peformance on this array compared to an another 
array built from 7 disk on the motherboard's AHCI controllers. I digged 
deeper, and I found the root of the problem: if I lower max_sectors_kb on my 
AHCI disks, the same happen there too!

dap:/sys/block# for i in sd*; do echo 64 >$i/queue/max_sectors_kb; done

dap:/sys/block# vmstat 1
procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0 14      0   8216      0 791056    0    0 103304     0 2518 57340  0 41  0 
59
 3 12      0   7420      0 791856    0    0 117264     0 2600 55709  0 44  0 
56
thrashed readahead pages: 123363

dap:/sys/block# for i in sd*; do echo 512 >$i/queue/max_sectors_kb; done

dap:/sys/block# vmstat 1
procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0 100      0 182876      0 762560    0    0 350944     0 1299  1484  1 14  0 
86
 0 100      0 129492      0 815460    0    0 265864     0 1432  2045  0 10  0 
90
 0 100      0 112812      0 832504    0    0 290084     0 1366  1807  1 11  0 
89
thrashed readahead pages: 4605


 Is not possible to reduce the number of context switches here? Why context 
switches causes readahead thrashing? Why just the RAID5 suffers from the 
small max_sectors_kb, why don't happen if I run lot of 'badblocks'?


thanks,
--
 dap

