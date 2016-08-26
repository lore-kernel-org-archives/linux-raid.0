From: travis+ml-linux-raid@subspacefield.org
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 25 Aug 2016 20:11:16 -0700
Message-ID: <20160826031116.GP32250@subspacefield.org>
References: <20160823050947.GL32250@subspacefield.org>
 <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
 <20160825062501.GN32250@subspacefield.org>
 <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
 <e75dcc05-f0c2-2152-9d24-5ff42ea02657@turmel.org>
 <CAJCQCtQyqH2eOmyqmpz0sZzD9ia4Q8RsA8eb+6inuDY6QP+Tyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJCQCtQyqH2eOmyqmpz0sZzD9ia4Q8RsA8eb+6inuDY6QP+Tyg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 08:48:24PM -0600, Chris Murphy wrote:
> Right, so something like GPT on /dev/sda and /dev/sdb to create sda1
> and sdb1, then mdadm -C /dev/md0 --metadata=1.0 ... /dev/sda1
> /dev/sdb1, and then create a GPT on /dev/md0. The result is /dev/md0,
> /dev/sda1, and /dev/sda2 will all appear to have the same GPT on them.
> 
> I would say that's probably a bad idea, I know some tools allow it,
> but it creates an ambiguity. It could be argued to be inconsistent
> with the UEFI spec. The only nesting it describes is MBR on a GPT
> partition, not GPT nested in a GPT partition. This is probably also
> better done using LVM. Otherwise we get nutty things...

We had similar ambiguities in MBR-land, if you set the active flag on
more than one partition, or if you have more than one extended
partition.

Since the behavior in those cases is undefined, it seems wise to avoid
creating them.

Better if the specification avoids these situations - that no
combination of bits can create an ambiguous interpretation - but in
the occasional cases where that can't be avoided you're best off not
creating those situations.
-- 
http://www.subspacefield.org/~travis/ | if spammer then john@subspacefield.org
"Computer crime, the glamor crime of the 1970s, will become in the
1980s one of the greatest sources of preventable business loss."
John M. Carroll, "Computer Security", first edition cover flap, 1977
