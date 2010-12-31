From: Spelic <spelic@shiftmail.org>
Subject: Absymal performance of O_DIRECT write on parity raid
Date: Fri, 31 Dec 2010 05:35:06 +0100
Message-ID: <4D1D5D7A.6010804@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all linux raiders

on kernel 2.6.36.2, but probably others, performances of O_DIRECT are 
absymal on parity raid, compared to nonparity raid

And this is NOT due to the RMW apparently! (see below)

With dd bs=1M to the bare MD device, a 6-disk raid5 1024k chunk, I 
obtain 2.1MB/sec on raid5 while the same test onto a 4-disk raid10 goes 
at 160MB/sec (80 times faster).
even with stripe_cache_size to the max.
Nondirect writes to the arrays are at about 250MB/sec for raid5, and 
about 180MB/sec for raid10.
With bs=4k directio it's 205KB/sec on the raid5 vs 28MB/sec on the 
raid10 (136 times faster)

This does NOT seem due to the RMW, because from the second time on MD 
does *not* read from the disks anymore (checked with iostat -x 1)
(BTW how do you clear that cache? echo 3 > /proc/sys/vm/drop_cache does 
not appear to work)

It's so bad it looks like a bug. Could you please have a look at this?
There are many important stuff that use o_direct, in particular:
- LVM, I think, especially pvmove and mirror creation, which are 
impossibly slow on parity raid
- Databases (ok I understand we should use raid10 but the difference 
should not be SO great!)
- Virtualization. E.g. KVM wants bare devices for high performance, 
wants to do direct io. Go figure.

With such a bad worst-case for o_direct we seriously risk to need to 
abandon MD parity raid completely
Please have a look

Thank you
