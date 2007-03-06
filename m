From: dean gaudet <dean@arctic.org>
Subject: Re: Replace drive in RAID5 without losing redundancy?
Date: Mon, 5 Mar 2007 23:37:04 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0703052315250.27855@twinlark.arctic.org>
References: <37643E71-0FD9-4F8A-AE68-A8565FEB0247@bj-ig.de>
 <17900.39356.684798.56121@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17900.39356.684798.56121@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 6 Mar 2007, Neil Brown wrote:

> On Monday March 5, ralf@bj-ig.de wrote:
> > 
> > Is it possible to mark a disk as "to be replaced by an existing spare",
> > then migrate to the spare disk and kick the old disk _after_ migration
> > has been done? Or not even kick - but mark as new spare.
> 
> No, this is not possible yet.
> You can get nearly all the way there by:
> 
>   - add an internal bitmap.
>   - fail one drive
>   - --build a raid1 with that drive (and the other missing)
>   - re-add the raid1 into the raid5
>   - add the new drive to the raid1
>   - wait for resync

i have an example at 
<http://arctic.org/~dean/proactive-raid5-disk-replacement.txt>... plus 
discussion as to why this isn't the best solution.

-dean
