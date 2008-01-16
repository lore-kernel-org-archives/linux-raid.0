From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
Date: Wed, 16 Jan 2008 00:09:31 -0700
Message-ID: <e9c3a7c20801152309g28493cecx57efa8a8bba2fd21@mail.gmail.com>
References: <20080114123726.19968.patches@notabene>
	 <1080114014525.20337@suse.de>
	 <alpine.DEB.0.999999.0801152059170.9578@twinlark.arctic.org>
	 <20080115215425.b1fcba31.akpm@linux-foundation.org>
	 <alpine.DEB.0.999999.0801152157310.9578@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0801152157310.9578@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> heheh.
>
> it's really easy to reproduce the hang without the patch -- i could
> hang the box in under 20 min on 2.6.22+ w/XFS and raid5 on 7x750GB.
> i'll try with ext3... Dan's experiences suggest it won't happen with ext3
> (or is even more rare), which would explain why this has is overall a
> rare problem.
>

Hmmm... how rare?

http://marc.info/?l=linux-kernel&m=119461747005776&w=2

There is nothing specific that prevents other filesystems from hitting
it, perhaps XFS is just better at submitting large i/o's.  -stable
should get some kind of treatment.  I'll take altered performance over
a hung system.

--
Dan
