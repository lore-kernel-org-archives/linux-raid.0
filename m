From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 009 of 11] md: Support stripe/offset mode in raid10
Date: Mon, 8 May 2006 17:17:29 +1000
Message-ID: <17502.61577.874881.753541@cse.unsw.edu.au>
References: <20060501152229.18367.patches@notabene>
	<200605021938.45254.a1426z@gawab.com>
	<17495.62433.136481.543828@cse.unsw.edu.au>
	<200605030700.23515.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Al Boldi on Wednesday May 3
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 3, a1426z@gawab.com wrote:
> Neil Brown wrote:
> > On Tuesday May 2, a1426z@gawab.com wrote:
> > > NeilBrown wrote:
> > > > The "industry standard" DDF format allows for a stripe/offset layout
> > > > where data is duplicated on different stripes. e.g.
> > > >
> > > >   A  B  C  D
> > > >   D  A  B  C
> > > >   E  F  G  H
> > > >   H  E  F  G
> > > >
> > > > (columns are drives, rows are stripes, LETTERS are chunks of data).
> > >
> > > Presumably, this is the case for --layout=f2 ?
> >
> > Almost.  mdadm doesn't support this layout yet.
> > 'f2' is a similar layout, but the offset stripes are a lot further
> > down the drives.
> > It will possibly be called 'o2' or 'offset2'.
> >
> > > If so, would --layout=f4 result in a 4-mirror/striped array?
> >
> > o4 on a 4 drive array would be
> >
> >    A  B  C  D
> >    D  A  B  C
> >    C  D  A  B
> >    B  C  D  A
> >    E  F  G  H
> >    ....
> 
> Yes, so would this give us 4 physically duplicate mirrors?

It would give 4 devices each containing the same data, but in a
different layout - much as the picture shows....


> If not, would it be possible to add a far-offset mode to yield such
> a layout?

Exactly what sort of layout do you want?


> 
> > > Also, would it be possible to have a staged write-back mechanism across
> > > multiple stripes?
> >
> > What exactly would that mean?
> 
> Write the first stripe, then write subsequent duplicate stripes based on idle 
> with a max delay for each delayed stripe.
> 
> > And what would be the advantage?
> 
> Faster burst writes, probably.

I still don't get what you are after.
You always need to wait for writes of all copies to complete before
acknowledging the write to the filesystem, otherwise you risk
corruption if there is a crash and a device failure.
So inserting any delays (other than the per-device plugging which
helps to group adjacent requests) isn't going to make things go
faster.

NeilBrown
