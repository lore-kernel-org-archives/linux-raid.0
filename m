From: Wolfgang Denk <wd@denx.de>
Subject: Re: raid6check extremely slow ?
Date: Tue, 12 May 2020 09:37:47 +0200
Message-ID: <20200512073747.645CE240E1A@gemini.denx.de>
References: <20200510120725.20947240E1A@gemini.denx.de> <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com> <20200511064022.591C5240E1A@gemini.denx.de> <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com> <20200511153937.GA3225@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20200511153937.GA3225@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20200511153937.GA3225@lazy.lzy> you wrote:
> >     while (length > 0) {
> >             lock_stripe -> write suspend_lo/hi node
> >             ...
> >             unlock_all_stripes -> -> write suspend_lo/hi node
> >     }
> > 
> > I think it explains the stack of raid6check, and maybe it is way that
> > raid6check works, lock
> > stripe, check the stripe then unlock the stripe, just my guess ...
>
> Yes, that's the way it works.
> raid6check lock the stripe, check it, release it.
> This is required in order to avoid race conditions
> between raid6check and some write to the stripe.

This still does not really explain what is so slow here.  I mean,
even if the locking was an expenive operation code-wise, I would
expect to see at least one of the CPU cores near 100% then - but
botch CPU _and_ I/O are basically idle, and disks are _all_ and
_always_ really close at a trhoughput of 400 kB/s - this looks like
some intentional bandwith limit - I just can't see where this can be
configured?

> This could be a way to test if the problem is
> really here.
> That is, remove the lock / unlock (I guess
> there should be only one pair, but better
> check) and check with the array in R/O mode.

I may try this again after this test completed ;-)

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
It's certainly  convenient  the  way  the  crime  (or  condition)  of
stupidity   carries   with   it  its  own  punishment,  automatically
admisistered without remorse, pity, or prejudice. :-)
         -- Tom Christiansen in <559seq$ag1$1@csnews.cs.colorado.edu>
