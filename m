From: Pallai Roland <dap@mail.index.hu>
Subject: Re: major performance drop on raid5 due to context switches caused by small max_hw_sectors [partially resolved]
Date: Sun, 22 Apr 2007 11:52:18 +0200
Message-ID: <200704221152.18747.dap@mail.index.hu>
References: <200704202306.14880.dap@mail.index.hu> <200704220242.42285.dap@mail.index.hu> <Pine.LNX.4.64.0704220446530.10830@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704220446530.10830@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sunday 22 April 2007 10:47:59 Justin Piszcz wrote:
> On Sun, 22 Apr 2007, Pallai Roland wrote:
> > On Sunday 22 April 2007 02:18:09 Justin Piszcz wrote:
> >>
> >> How did you run your read test?
> >>
> >
> > I did run 100 parallel reader process (dd) top of XFS file system, try
> > this: for i in `seq 1 100`; do dd of=$i if=/dev/zero bs=64k 2>/dev/null;
> > done for i in `seq 1 100`; do dd if=$i of=/dev/zero bs=64k 2>/dev/null &
> > done
> >
> > and don't forget to set max_sectors_kb below chunk size (eg. 64/128Kb)
> > /sys/block# for i in sd*; do echo 64 >$i/queue/max_sectors_kb; done
> >
> > I also set 2048/4096 readahead sectors with blockdev --setra
> >
> > You need 50-100 reader processes for this issue, I think so. My kernel
> > version is 2.6.20.3
> >
>
> In one xterm:
> for i in `seq 1 100`; do dd of=$i if=/dev/zero bs=64k 2>/dev/null; done
>
> In another:
> for i in `seq 1 100`; do dd if=/dev/md3 of=$i.out bs=64k & done

Write and read files top of XFS, not on the block device. $i isn't a typo, you 
should write into 100 files and read back by 100 threads in parallel when 
done. I've 1Gb of RAM, maybe you should use mem= kernel parameter on boot.

1. for i in `seq 1 100`; do dd of=$i if=/dev/zero bs=1M count=100 2>/dev/null; 
done
2. for i in `seq 1 100`; do dd if=$i of=/dev/zero bs=64k 2>/dev/null & done


--
 d

