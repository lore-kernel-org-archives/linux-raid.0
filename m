From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 and data safety?
Date: Tue, 29 Mar 2005 13:26:32 +0200
Message-ID: <8kqnh2-o1n.ln1@news.it.uc3m.es>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de> <6kjnh2-qn4.ln1@news.it.uc3m.es> <16969.10587.679662.55065@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Tuesday March 29, ptb@lab.it.uc3m.es wrote:
> > 
> > Don't put the journal on the raid device, then - I'm not ever sure why
> > people do that!  (they probably have a reason that is good - to them).
> 
> Not good advice.  DO put the journal on a raid device.  It is much
> safer there.

Two journals means two possible sources of unequal information - plus the
two datasets.  We have been through this before. You get the journal
you deserve.

Peter

