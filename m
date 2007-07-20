From: "Dan Williams" <dan.j.williams@intel.com>
Subject: [RFT] 2.6.22.1-iop1 for improved sequential write performance (stripe-queue)
Date: Thu, 19 Jul 2007 17:17:36 -0700
Message-ID: <e9c3a7c20707191717s4809eab1s4966f7e0c21c6424@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

Per Bill Davidsen's request I have made available a 2.6.22.1 based
kernel with the current raid5 performance changes I have been working
on:
1/ Offload engine acceleration (recently merged for the 2.6.23
development cycle)
2/ Stripe-queue, an evolutionary change to the raid5 queuing model (take4)

The offload engine work only helps platforms with offload engines and
should not affect performance otherwise.  The stripe-queue work is an
attempt to increase sequential write performance and should benefit
most platforms.

The patch series is available on the Xscale(r) IOP SourceForge page:
	http://downloads.sourceforge.net/xscaleiop/patches-2.6.22.1-iop1-x86fix.tar.gz

Use quilt to apply the series on top of a fresh 2.6.22.1 source tree:
$ wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
$ tar xjf linux-2.6.22.1.tar.bz2
$ cd linux-2.6.22.1
$ tar xzvf patches-2.6.22.1-iop1.tar.gz
$ cp patches/series.x86 patches/series
$ quilt push -a

Configure and build the kernel as normal, there are no configuration
options for stripe-queue.

Any feedback, bug report, fix, or suggestion is welcome.

Thanks,
Dan
