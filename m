From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH md 1 of 2] Add interface to md driver for userspace monitoring of events.
Date: Tue, 7 Sep 2004 12:45:34 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040907104534.GA5511@lst.de>
References: <20040903122034.15346.patches@notabene> <E1C33nX-00040i-9v@notabene.cse.unsw.edu.au> <20040903031920.11e31d3f.akpm@osdl.org> <16699.47090.307180.958993@cse.unsw.edu.au> <20040906140233.GB20941@lst.de> <16700.60002.246730.450275@cse.unsw.edu.au> <20040906160738.368c20f3.akpm@osdl.org> <16701.1683.847311.155379@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16701.1683.847311.155379@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Andrew Morton <akpm@osdl.org>, hch@lst.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 07, 2004 at 10:53:39AM +1000, Neil Brown wrote:
> On Monday September 6, akpm@osdl.org wrote:
> > Neil Brown <neilb@cse.unsw.edu.au> wrote:
> > >
> > > > poll on procfs is defintily abuse, even in categories of the use procfs
> > >  > every times.
> > >  > 
> > > 
> > >  Oh well..  If you gain more from the patch not going in than I gain
> > >  from it going in, so be it.
> > 
> > That's not the point.  Sure, the code works and is useful.  But it takes a
> > crappy interface and makes it crappier.
> 
> I'm sorry, but I don't see the "crap".

IF you want poll/select do a character device.

