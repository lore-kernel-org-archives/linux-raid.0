From: Drew <drew.kay@gmail.com>
Subject: Re: WD "RED" drives - are they any good for mdadm?
Date: Fri, 8 Feb 2013 14:31:24 -0800
Message-ID: <CACJz6QvUX12rJXrFhxg6FVO3e5qzO8t7UxM8+j=a2qhL215LeQ@mail.gmail.com>
References: <50CF2112.1090406@gmail.com> <5115727E.9050601@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5115727E.9050601@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: maurice <mhilarius@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> No, they're available big and cheap, but I confess that I don't see why a
> drive series (red) is needed for NAS use, as opposed to cabled (eSATA)
> connection. Not sure how the drive use would be different, but they are, as
> noted, big and cheap.

It makes sense to me at least.

The big differentiators between the Red & Green/Blue series is
ERC/TLER and the warranty terms. The drives come equipped with TLER
set, which is helpful if you run RAID sets, the reasons for which this
group is well versed in. The drives are also warrantied for 3yrs (as
opposed to 2yrs) *and* specifically allow for use in enclosures of up
to 4 bays. Apparently the Green & Blues aren't covered if use in
enclosures.

I think at the end of the day the addition of Red's was market driven
as a lot of people purchase these little home RAID boxes and find out
the warrany on cheap drives doesn't cover that use, but at the same
time, won't speend several hundred dollars *each* on enterprise
drives.

I personally have used a 4 pack of these hung off a LSI 9204 raid
controller and performance is okay but not spectacular. That'd be
because of the drives supposedly vary from 5400 to 7200 rpm depending
on load. I treat them like 5400rpm drives and the benchmarks seem to
bear that out. Good for bulk storage in home use, not so good for bulk
storage in commercial use, except perhaps in 3rd or 4th tier storage
where who cares how fast they are, what I call legal drives. (As in,
we only keep them around for data the auditors & legal types may
want.)


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
