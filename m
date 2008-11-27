From: Jody McIntyre <scjody@sun.com>
Subject: Re: [RFC patch 1/1] Track raid5/6 statistics.
Date: Thu, 27 Nov 2008 13:29:12 -0500
Message-ID: <20081127182912.GE29919@clouds>
References: <20081126190452.775333692@sun.com>
 <20081126190854.813151413@sun.com>
 <20081127114748.GE14570@boogie.lpds.sztaki.hu> <20081127135248.GD29919@clouds>
 <20081127171535.GL14570@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20081127171535.GL14570@boogie.lpds.sztaki.hu>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Thu, Nov 27, 2008 at 06:15:35PM +0100, Gabor Gombas wrote:

> /proc contains a lot of legacy junk but nowadays the trend is that you
> should not add new files under /proc that are not process-related.

Agreed.  I'm not proposing that at all.

> Changing /proc/mdstat is IMHO out of question since it is part of the
> user visible ABI and breaking that is a big no-no. So if you want all
> info in a single file that pretty much leaves only debugfs.

AFAICT it was last changed on 2005-09-09 (appearing in 2.6.14).  This
suggests we can change it given a sufficiently good reason.

debugfs isn't a good idea since ordinary systems won't (or shouldn't)
have it mounted.  In case I wasn't clear: some of these statistics _are_
useful to administrators with sufficient RAID knowledge.  For example,
if "out of stripes" is large and you have lots of memory, increasing
stripe_cache_size will likely be useful.

Cheers,
Jody

> Gabor
> 
> -- 
>      ---------------------------------------------------------
>      MTA SZTAKI Computer and Automation Research Institute
>                 Hungarian Academy of Sciences
>      ---------------------------------------------------------
