From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: raid6 check/repair
Date: Fri, 7 Dec 2007 18:34:34 +0100
Message-ID: <20071207173434.GB5689@boogie.lpds.sztaki.hu>
References: <474431BF.30103@ph.tum.de> <18244.64972.172685.796502@notabene.brown> <4745B375.4030500@ph.tum.de> <18254.21949.441607.134763@notabene.brown> <474F4880.8080300@eyal.emu.id.au> <47502140.1080601@ph.tum.de> <1196650421.14411.10.camel@elara.tcw.local> <47546019.5030300@ph.tum.de> <18261.49547.588360.436369@base.ty.sabi.co.UK> <47570A92.1090307@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47570A92.1090307@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 05, 2007 at 03:31:14PM -0500, Bill Davidsen wrote:

> BTW: if this can be done in a user program, mdadm, rather than by code in 
> the kernel, that might well make everyone happy. Okay, realistically "less 
> unhappy."

I start to like the idea. Of course you can't repair a running array
from user space (just think about something re-writing the full stripe
while mdadm is trying to fix the old data - you can get the data disks
containing the new data but the "fixed" disks rewritten with the old
data).

We just need to make the kernel not to try to fix anything but merely
report that something is wrong - but wait, using "check" instead of
"repair" does that already.

So the kernel is fine as it is, we just need a simple user-space utility
that can take the components of a non-running array and repair a given
stripe using whatever method is appropriate. Shouldn't be too hard to
write for anyone interested...

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
