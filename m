From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: is raid compatible between 2.4.22 & 2.6.5 ?
Date: Sat, 12 Jun 2004 12:55:57 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16586.28861.88315.964028@cse.unsw.edu.au>
References: <1086974499.5186.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Lange on Friday June 11
To: John Lange <john.lange@bighostbox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 11, john.lange@bighostbox.com wrote:
> Is there some reason why a RAID 1 set built under 2.6.5 would not work
> under 2.4.22?

No, unless you are partitioning the array.

> 
> I build a machine (Slackware) with two RAID 1 mirrored drives under a
> 2.6.5 kernel.
> 
> I later discovered that I needed to drop back to a 2.4.22 kernel in
> order to do some clustering under openMosix and TKCluster so I
> downloaded the recommended TKCluster 2.4.22 kernel. This kernel is a
> standard kernel with patches for libata and openMosix.
> 
> I rebuilt the kernel including support for RAID and serial ATA (ICH5).
> 
> When I boot the 2.4.22 kernel it goes along nicely until it tries to
> mount the root partition. It then throws up a "modprobe" error.
> Something about char-major 9 I think? (I'm sorry but I am not near the
> console at the moment).

Precise message are always more helpful.

If it was actually "block-major 9", then maybe your kernel is compiled
without  support for md, as block-major 9 corresponds to the md
driver.

NeilBrown

