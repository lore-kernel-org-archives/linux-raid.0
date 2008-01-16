From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
Date: Thu, 17 Jan 2008 08:54:26 +1100
Message-ID: <18318.32018.271377.148440@notabene.brown>
References: <20080114123726.19968.patches@notabene>
	<1080114014525.20337@suse.de>
	<alpine.DEB.0.999999.0801152059170.9578@twinlark.arctic.org>
	<20080115215425.b1fcba31.akpm@linux-foundation.org>
	<alpine.DEB.0.999999.0801152157310.9578@twinlark.arctic.org>
	<e9c3a7c20801152309g28493cecx57efa8a8bba2fd21@mail.gmail.com>
	<20080115231504.4df1b739.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Tuesday January 15
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 15, akpm@linux-foundation.org wrote:
> On Wed, 16 Jan 2008 00:09:31 -0700 "Dan Williams" <dan.j.williams@intel.com> wrote:
> 
> > > heheh.
> > >
> > > it's really easy to reproduce the hang without the patch -- i could
> > > hang the box in under 20 min on 2.6.22+ w/XFS and raid5 on 7x750GB.
> > > i'll try with ext3... Dan's experiences suggest it won't happen with ext3
> > > (or is even more rare), which would explain why this has is overall a
> > > rare problem.
> > >
> > 
> > Hmmm... how rare?
> > 
> > http://marc.info/?l=linux-kernel&m=119461747005776&w=2
> > 
> > There is nothing specific that prevents other filesystems from hitting
> > it, perhaps XFS is just better at submitting large i/o's.  -stable
> > should get some kind of treatment.  I'll take altered performance over
> > a hung system.
> 
> We can always target 2.6.25-rc1 then 2.6.24.1 if Neil is still feeling
> wimpy.

I am feeling wimpy.  There've been a few too many raid5 breakages
recently and it is very hard to really judge the performance impact of
this change.  I even have a small uncertainty of correctness - could
it still hang in some other way?  I don't think so, but this is
complex code...

If it were really common I would have expected more noise on the
mailing list.  Sure, there has been some, but not much.  However maybe
people are searching the archives and finding the "increase stripe
cache size" trick, and not reporting anything .... seems unlikely
though.

How about we queue it for 2.6.25-rc1 and then about when -rc2 comes
out, we queue it for 2.6.24.y?  Any one (or any distro) that really
needs it can of course grab the patch them selves...

??

NeilBrown
