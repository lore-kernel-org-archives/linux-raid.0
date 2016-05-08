From: Shaohua Li <shli@kernel.org>
Subject: Re: Write to the degraded raid5 will trigger the call trace dump
 when skip_copy is enabled
Date: Sun, 8 May 2016 15:23:40 -0700
Message-ID: <20160508222340.GA8100@kernel.org>
References: <CAHvN=inPP5ubYK1YkNW_B1b9ouhqBo8qMMfVcGSjddMYekDEng@mail.gmail.com>
 <20160429211719.GA104659@kernel.org>
 <CAHvN=imVJgEtMmO6XtLCdQKCPiuVT2sCqpq_0qoMR-3aJ+ZzPw@mail.gmail.com>
 <CAHvN=intgqwK+Cw=sUb9wBSfF1wimGkbRBrxKOTtd_oZOH2M0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHvN=intgqwK+Cw=sUb9wBSfF1wimGkbRBrxKOTtd_oZOH2M0w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joey Liao <joeyliao@qnap.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 04, 2016 at 11:21:59AM +0800, Joey Liao wrote:
> Any suggestion for my question in the last e-mail?
> Should the WARN_ON() be exist or not?
> 
> It is also related to skip_copy feature and I think it seems make
> sense that maybe R5_UPTODATE should not be set in this case.
> But I'm not really sure if my thinking is correct or not.
> 
> However, if it does not have to exist, would you mind delete it as
> well or just modify the code?
> 
> 
> 
> 2016-05-02 22:45 GMT+08:00 Joey Liao <joeyliao@qnap.com>:
> > Hi Shaohua,
> >
> > Many thanks for your reply.
> >
> > How about the following WARN_ON() in handle_stripe_clean_event()???
> >
> > if (test_and_clear_bit(R5_SkipCopy, &dev->flags)) {
> >     WARN_ON(test_bit(R5_UPTODATE, &dev->flags));
> > }
> >
> > Sometimes it will be triggered as well but I can't find the exactly
> > way to reproduce it.
> > I would like to know if it is suitable to remove it as well or not.

This one isn't false alarm. If the dev->flags has R5_SkipCopy, we don't copy
data to stripe cache, so stripe cache shouldn't have R5_UPTODATE. So this
warning indicates a bug. If you can reproduce it, I'd be happy to debug.

Thanks,
Shaohua
