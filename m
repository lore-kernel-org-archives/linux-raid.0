From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Looking for the cause of poor I/O performance
Date: Fri, 3 Dec 2004 17:25:20 +0100
Message-ID: <20041203162520.GC32559@harddisk-recovery.nl>
References: <200412030630.51004.systemloc@earthlink.net> <20041203114635.GB21302@harddisk-recovery.com> <200412031009.23717.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200412031009.23717.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: TJ <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 03, 2004 at 10:09:23AM -0500, TJ wrote:
> I did not know that auto-sensing was part of the Gigabit standard. I don't 
> understand why you would think that performance would be worse with a 
> crossover than a straight cable, though. I assure you, the link 
> autonegotiates to a gigabit connection. The card driver reports this, the 
> card's light indicator reports this, and my benchmarking of throughput has 
> proven it.

That means you have a crossover cable with two wire pairs crossed and
two wire pairs straight, and guess what: gigE automatically detects
badly wired cables (to a certain extent), correct it and negotiate to
the correct speed: 1 Gbit/s. If you have a crossover cable using only
two crossed wire pairs and the other pairs not connected, the link will
negotiate to 100 Mbit/s.

> > The Intel gigE NICs are very good: good hardware, good driver, good
> > support. Gigabit ethernet switches are becoming rather cheap: 200 EUR
> > buys you an 8 port switch.
> 
> Yeah, I knew Intel made good NIC's, and I knew they were linux supported. I'm 
> only worried because this is the lowest end model in the line. I wonder if it 
> offloads work to the CPU, causing lower throughput on a busy link, while more 
> expensive versions handle more work on the card.

We use the dual ported PCI-X server adapters in the file servers (dual
Athlon and dual Opteron), but to be honest I haven't seen a difference
in performance with the desktop adapters when we replaced them. It's
just that they're 64 bit wide and have two NICs on a single board (and
hence only use one PCI slot). The other machines (about 10 or so) have
the cheaper desktop adapters.

> Also, I have read some traffic that the e1000 driver is better tuned
> for light duty connections, and could use some improvement under a
> heavy workload. If you knew about any documentation, or mailing lists
> on the topic of tuning this, I'd appreciate it.

I can't comment on that. We push several gigabytes/day through the
cards and I haven't seen any real problems. We had performance problems
with NatSemi gigE NICs; Broadcom gigE NICs looks like too much driver
hassle to me (judging from posts on linux-kernel). 

Documentation can be found on http://sourceforge.net/projects/e1000 ,
the appropriate mailing list is the networking list: netdev@oss.sgi.com .


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
| Data lost? Stay calm and contact Harddisk-recovery.com
