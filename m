From: mjstumpf <mjstumpf@cotse.net>
Subject: Re: where to buy very very large cases
Date: Mon, 28 Jul 2003 11:24:40 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bWpzdHVtcGY=.c555e301cab7cf1f7ca1bd0c68590108@1059405880.cotse.net>
References: <bWpzdHVtcGY=.14a9e78b52177716d8df11d88fc1d02c@1059398282.cotse.net>
        <20030728145146.GA22549@willow.seitz.com>
        <Pine.LNX.4.56.0307281109490.15708@router.windsormachine.com>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0307281109490.15708@router.windsormachine.com>
To: mdresser_l@windsormachine.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> Funny things happen over time though - our 120G array of IBM 16G
>> deskstars was easily replaced by two disks, LOL.
>
> I was going to suggest him doing this if he had small drives, but there
> might be a case where a lot of spindles is what he wants.  (database
> access, or something)

Only care about capacity--not spindles.  Currently at 6 80-gig + 4
120-gig.  Would like to not toss out perfectly good drives of reasonable
size (waste of money), plus, I want to keep raid-5 arrays no smaller than
4 drives for efficiency reasons (lower % of drive space wasted in parity).

That's kinda why the sweet spot needs to be more drives, ~20 I think, to
provide both flexibility (migrate files in LVM, remove 1 of 4 raid arrays,
replace it with new bigger one) and optimal use of resource.

Still have to figure out what to do with the leftover 80 gig drives
somewhere down the line.  They aren't chump change yet :-(


