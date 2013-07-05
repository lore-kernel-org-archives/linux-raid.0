From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: question about the best suited RAID level/layout
Date: Thu, 04 Jul 2013 20:12:17 -0500
Message-ID: <51D61D71.5090406@hardwarefreak.com>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372978687.5249.52.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/4/2013 5:58 PM, Christoph Anton Mitterer wrote:

> I'd have even one more question here: Has anyone experience with my idea
> of intentionally running devices of different vendors (Seagate, WD,
> HGST)... for resilience reasons?... Does it work out as I plan, or are
> there any hidden caveats I can't see which make the resilience (not the
> performance) worse?

1.  You'll need to use partitions underneath md because the drives will
all be slightly difference capacity.  You'll need to identify the
capacity of the smallest drive and create partitions a few MiB smaller
than this on all drives.  This should assure that any replacement drive
which is slightly smaller will be usable in the array.

Screwing around with all of this is a PITA.  When I build arrays I use
identical drives and put identical spares in storage.  I don't leave
hot/warm/cold spares in the chassis.  This simply degrades performance.
Hot swap was invented for a reason.  Some folks prefer online spares an
unattended auto rebuild.  Not every time a drive is kicked is a rebuild
required.  I wanna look things over before I start a rebuild.


2.  HGST is a brand created due to Western Digital's acquisition of
Hitachi Data System's disk drive unit.  The drives are Hitachi's final
production units relabeled with a different name and serial number.
Three years from now when that HGST drive fails, Western Digital will
replace it with a Western Digital produced drive.

There are now currently only 3 hard disk drive vendors on the planet
AFAIK:  Seagate, Toshiba, and Western Digital.  In the not too distance
future Toshiba's disk drive unit will probably be acquired by one of the
other two and we'll have two drive vendors.  At that point the lack of
entropy will make this type of "game plan" useless.  You'll have to pick
drives from different lines in each vendors' lineup, which means a mix
of consumer and enterprise models.  Then you'll lose ERC/TLER on some
drives.

IMO the practical disadvantages of using dissimilar drives outweighs the
theoretical benefits.

-- 
Stan

