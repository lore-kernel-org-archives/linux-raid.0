From: Mike Perry <mikepery@fscked.org>
Subject: Re: Hot adding active disk to RAID1?
Date: Tue, 10 Feb 2004 09:00:41 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040210150041.GA4868@fscked.org>
References: <20040207152948.GA17368@fscked.org> <20040207173716.GA10996@fscked.org> <1076178191.3328.32.camel@picard.intra.techwiz.ca> <20040210075406.GB15112@fscked.org> <16424.38075.333116.361351@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16424.38075.333116.361351@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thus spake Neil Brown (neilb@cse.unsw.edu.au):

> On Tuesday February 10, mikepery@fscked.org wrote:
> > 
> > I concur. The manpages really should clear up that raidhotadd (and mdadm
> > -a) only add spares. And they should further clarify that spares are
> > essentially useless and lie dormant.. The names of these
> > commands/options are very deceptive to the new user...
> 
> Patches are more that welcome.

Is there a preferred version/cvs repository that I should diff against? The
raidtools are kinda helter-skelter in their net presence, it seems..

> It is very hard for someone how knows the system "inside-out" to see
> which areas aren't explained well.

Heh, ok. I'll put it on the TODO pile.

-- 
Mike Perry
Mad Computer Scientist
fscked.org evil labs
