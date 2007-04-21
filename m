From: Pallai Roland <dap@mail.index.hu>
Subject: Re: major performance drop on raid5 due to context switches caused by small max_hw_sectors [partially resolved]
Date: Sat, 21 Apr 2007 21:32:13 +0200
Message-ID: <200704212132.13775.dap@mail.index.hu>
References: <200704202306.14880.dap@mail.index.hu> <5d96567b0704202247s60e4f2f1x19511f790f597ea0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0704202247s60e4f2f1x19511f790f597ea0@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Saturday 21 April 2007 07:47:49 you wrote:
> On 4/21/07, Pallai Roland <dap@mail.index.hu> wrote:
> >  I made a software RAID5 array from 8 disks top on a HPT2320 card driven
> > by hpt's driver. max_hw_sectors is 64Kb in this proprietary driver. I
> > began to test it with a simple sequental read by 100 threads with
> > adjusted readahead size (2048Kb; total ram is 1Gb, I use posix_fadvise
> > DONTNEED after reads). Bad news: I noticed very weak peformance on this
> > array compared to an another array built from 7 disk on the motherboard's
> > AHCI controllers. I digged deeper, and I found the root of the problem:
> > if I lower max_sectors_kb on my AHCI disks, the same happen there too!
> >
> > dap:/sys/block# for i in sd*; do echo 64 >$i/queue/max_sectors_kb; done
> 
> 3. what is the raid configuration ? did you increase the stripe_cache_size
> ?
 Thanks! It's works fine if chunk size < max_hw_sectors! But if it's not true, 
the very high number of context switches kills the performance.


RAID5, chunk size 128k:

# mdadm -C -n8 -l5 -c128 -z 12000000 /dev/md/0 /dev/sd[ijklmnop]
 (waiting for sync, then mount, mkfs, etc)
# blockdev --setra 4096 /dev/md/0
# ./readtest &
procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
91 10      0 432908      0 436572    0    0 99788    40 2925 50358  2 36  0 63
 0 11      0 444184      0 435992    0    0 89996    32 4252 49303  1 31  0 68
45 11      0 446924      0 441024    0    0 88584     0 5748 58197  0 30  2 67
- context switch storm, only 10 of 100 processes are working, lot of thrashed 
readahead pages. I'm sure you can reproduce with 64Kb max_sectors_kb and 
2.6.20.x on *any* 8 disk-wide RAID5 array if chunk size > max_sectors_kb:
for i in `seq 1 100`; do dd of=$i if=/dev/zero bs=64k 2>/dev/null; done
for i in `seq 1 100`; do dd if=$i of=/dev/zero bs=64k 2>/dev/null & done


RAID5, chunk size 64k (equal to max_hw_sectors):

# mdadm -C -n8 -l5 -c64 -z 12000000 /dev/md/0 /dev/sd[ijklmnop]
 (waiting for sync, then mount, mkfs, etc)
# blockdev --setra 4096 /dev/md/0
# ./readtest &
procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
1 99      0 309260      0 653000    0    0 309620     0 4521  2897  0 17  0 82
1 99      0 156436      0 721452    0    0 258072     0 4640  3168  0 14  0 86
0 100     0 244088      0 599888    0    0 258856     0 4703  3986  1 17  0 82
- YES! It's MUCH better now! :)


All in all, I use 64Kb chunk now and I'm happy, but I think it's definitely a 
software bug. The sata_mv driver also doesn't give bigger max_sectors_kb on 
Marvell chips, so it's a performance killer for every Marvell user if they're 
using 128k or bigger chunks on RAID5. A warning should be printed by the 
kernel at least if it's not a bug, just a limitation.


bye,
--
 d

