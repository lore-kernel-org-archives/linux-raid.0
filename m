From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Hot adding active disk to RAID1?
Date: Wed, 11 Feb 2004 09:30:45 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16425.23445.174722.587863@notabene.cse.unsw.edu.au>
References: <20040207152948.GA17368@fscked.org>
	<20040207173716.GA10996@fscked.org>
	<1076178191.3328.32.camel@picard.intra.techwiz.ca>
	<20040210075406.GB15112@fscked.org>
	<16424.38075.333116.361351@notabene.cse.unsw.edu.au>
	<20040210150041.GA4868@fscked.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Perry on Tuesday February 10
To: Mike Perry <mikepery@fscked.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 10, mikepery@fscked.org wrote:
> Thus spake Neil Brown (neilb@cse.unsw.edu.au):
> 
> > On Tuesday February 10, mikepery@fscked.org wrote:
> > > 
> > > I concur. The manpages really should clear up that raidhotadd (and mdadm
> > > -a) only add spares. And they should further clarify that spares are
> > > essentially useless and lie dormant.. The names of these
> > > commands/options are very deceptive to the new user...
> > 
> > Patches are more that welcome.
> 
> Is there a preferred version/cvs repository that I should diff against? The
> raidtools are kinda helter-skelter in their net presence, it seems..

Sorry, I should have been more specific.
Patches *against mdadm* are welcome.
I have no interest in "raid-tools" - it seems to be unmaintained.
Patches against the lastest source tar-ball are fine.

NeilBrown
