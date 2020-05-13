From: Wolfgang Denk <wd@denx.de>
Subject: Re: raid6check extremely slow ?
Date: Wed, 13 May 2020 08:13:58 +0200
Message-ID: <20200513061358.20C84240E1A@gemini.denx.de>
References: <20200510120725.20947240E1A@gemini.denx.de> <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com> <20200511064022.591C5240E1A@gemini.denx.de> <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com> <20200511153937.GA3225@lazy.lzy> <20200512073747.645CE240E1A@gemini.denx.de> <20200512161731.GE7261@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20200512161731.GE7261@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20200512161731.GE7261@lazy.lzy> you wrote:
>
> > This still does not really explain what is so slow here.  I mean,
> > even if the locking was an expenive operation code-wise, I would
> > expect to see at least one of the CPU cores near 100% then - but
> > botch CPU _and_ I/O are basically idle, and disks are _all_ and
> > _always_ really close at a trhoughput of 400 kB/s - this looks like
> > some intentional bandwith limit - I just can't see where this can be
> > configured?
>
> The code has 2 functions: lock_stripe() and
> unlock_all_stripes().
>
> These are doing more than just lock / unlock.
> First, the memory pages of the process will
> be locked, then some signal will be set to
> "ignore", then the strip will be locked.
>
> The unlock does the opposite in the reverse
> order (unlock, set the signal back, unlock
> the memory pages).
> The difference is that, whatever the reason,
> the unlock unlocks *all* the stripes, not
> only the one locked.
>
> Not sure why.

It does not matter how omplex the operation is - I wonder why it is
taking so long: it cannot be CPU bound, as then I would expect to
see any significant CPU load, but none of the cores shows more than
5...6% usage, ever.  Or it is I/O bound, then I would expect to see
I/O wait, but this is also never more than 0.2...0.3%.

And why are all disks running at pretty exaclty 400 kB/s read rate,
all the time?  this looks like some intentinal bandwith limit, but I
cannot find any knob to change it.



Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Be careful what you wish for. You never know who will be listening.
                                      - Terry Pratchett, _Soul Music_
