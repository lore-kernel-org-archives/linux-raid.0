From: alexander.weber@pta.de
Subject: Antwort: Re: Swap on RAID1?
Date: Tue, 14 Oct 2003 10:50:06 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <OFE364D22E.C14CB4FA-ONC1256DBF.00302B9C@pta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




Hermann Himmelbauer wrote:

> But what happens if a disk fails and the swap is on this disk? I assume
Linux
> would crash? Wouldn't a swap on a RAID prevent such a crash?

Yes and yes. One other possible alternative would be to fork out the
money for more RAM rather than a second disk for swap. And just don't
use swap, if you're worried about swap crashing the system...and
performance will be much better, too.

<snip>

And how about swap-partitions on both disks? So on disk crash, one swap
partition would survive.
This works, won't it?

(Don't make me worried ;-)

Alexander




**********************************************************************
http://www.pta.de
Mit 792 Erfahrungsberichten aus 34 Jahren erfolgreicher Projektarbeit!
**********************************************************************

