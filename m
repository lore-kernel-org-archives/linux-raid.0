From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] disable queue flag test in barrier check
Date: Thu, 26 Jun 2008 08:25:11 -0500
Message-ID: <486398B7.50306@sandeen.net>
References: <486307EA.7080007@sandeen.net> <48635284.3060001@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48635284.3060001@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, jeremy@sgi.comwe
List-Id: linux-raid.ids

Timothy Shimmin wrote:

> Also from memory, I believe Neil checked this removal into the SLES10sp1 tree
> and some sgi boxes started having slow downs
> (looking at Dave's email below - we were not wanting to tell them
> to use nobarrier but needed it to work by default - I forget now).

But that's an admin issue.

The way it is now, for example a home user of md raid1 (me!) can't run
barriers even if they wanted to.

Until there is a way to know if a write cache is non-volatile the only
safe option is to enable barriers when possible.

> 6.
>> Date: Wed, 25 Jun 2008 08:57:24 +1000
>> From: Dave Chinner <david@fromorbit.com>
>> To: Eric Sandeen <sandeen@sandeen.net>
>> Cc: LinuxRaid <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
>> Subject: Re: md raid1 passes barriers, but xfs doesn't use them?
>>
>> Yeah, the problem was that last time this check was removed was
>> that a bunch of existing hardware had barriers enabled on them when
>> not necessary (e.g. had NVRAM) and they went 5x slower on MD raid1
>> devices. Having to change the root drive config on a wide install
>> base was considered much more of support pain than leaving the
>> check there. I guess that was more of a distro upgrade issue than
>> a mainline problem, but that's the history. Hence I think we
>> should probably do whatever everyone else is doing here....
>>
>> Cheers,
>>
>> Dave.
> 
> So I guess my question is whether there are cases where we are
> going to be in trouble again.
> Jeremy, do you see some problems?

FWIW, the problem *I* foresee is that some people are going to slow down
when using the defaults, yes, because barriers will start working again.
 But I don't see any other safe way around it.

Education would be in order, I suppose.  :)

-Eric

> --Tim
> 
> 
> 

