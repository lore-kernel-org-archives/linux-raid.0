From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: Re: Scsi adapters and software raid...
Date: Thu, 19 Feb 2004 14:33:52 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0402191427580.6370@umi.cfht.hawaii.edu>
References: <Pine.GSO.4.33.0402191508420.28488-100000@sweetums.bluetronic.net>
 <1077228261.30431.5.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1077228261.30431.5.camel@south.rosestar.lan>
To: Bob Hillegas <bobhillegas@houston.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Bob,

All the Adaptec non-RAID SCSI controllers work nicely. The ones based
on the 79xx and newer chips require the newer kernel module. The 78xx
and older ones are all supported by the old module. They are generally
stable, compatible and offer good performance.

Their SCSI _hardware_ RAID controllers are a different story. Steer
clear of those.


-Kanoa


On Thu, 19 Feb 2004, Bob Hillegas wrote:

> It's been interesting reading these comments about adapters to avoid.
>
> My question is... what SCSI adapter works WELL with software raid
> (mdadm) and doesn't get in the way?
