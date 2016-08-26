From: travis@subspacefield.org
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 25 Aug 2016 20:58:50 -0700
Message-ID: <20160826035850.GQ32250@subspacefield.org>
References: <20160823050947.GL32250@subspacefield.org>
 <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
 <20160825062501.GN32250@subspacefield.org>
 <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
 <20160826025012.GO32250@subspacefield.org>
 <CAJCQCtRwF1XCNQRxibFGZ0SVQ8=RKo1birv5ZWZBvZGpuu0ndQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJCQCtRwF1XCNQRxibFGZ0SVQ8=RKo1birv5ZWZBvZGpuu0ndQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 09:21:30PM -0600, Chris Murphy wrote:
> On Thu, Aug 25, 2016 at 8:50 PM,  <travis@subspacefield.org> wrote:
> 
> >
> >> So I'd say it's something else.
> >
> > Do you have any idea what that could be?
> 
> User error, you even suspect it yourself later...

Yeah, *when I created this disk layout* I might have created a GPT in
partition 1.

That was probably a year or more ago.

That has nothing to do with this crash, which is perhaps the fourth of
its kind.

I haven't touched the box in weeks before this happened, when I was
away on vacation.  Although, it could have lurked for some time,
and only been uncovered by a crash or kpanic.

> > Shorthand for "before partition 1".
> 
> Unreliable. By convention most tools used to start it at LBA 63 which
> *was* based on CHS, but that's the Pleistocene (again). It's been many
> years, maybe nearing a decade, since a tool would default to that.
> First, 62 sectors isn't big enough to embed a bootloader these days.
> Second, it's not 4096 byte aligned for 4K sector drives, which now
> pretty much every hard drive is, except some higher end SCSI/SAS
> drives come with the option of 512 byte physical sectors still. But
> these are quickly vanishing. Macs typically start the first partition
> at LBA 40, and on Windows and Linux these days it's usually LBA 2048
> (1MiB gap to the first partition).

Relax, it's just to save time.  I'm aware we don't use CHS addressing
any more.  I'm also aware that Kleenex is a brand name, even though I
use it to mean tissue.  GNU/Linux, not Linux.  I get it.  Let's move on.
-- 
http://www.subspacefield.org/~travis/ | if spammer then john@subspacefield.org
"Computer crime, the glamor crime of the 1970s, will become in the
1980s one of the greatest sources of preventable business loss."
John M. Carroll, "Computer Security", first edition cover flap, 1977
