From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid 1 - md "Total Disks" question
Date: Mon, 20 Sep 2004 09:47:36 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16718.6808.294471.886458@cse.unsw.edu.au>
References: <019801c499ab$405f20d0$6800a8c0@Agus>
	<16710.16837.832998.503557@cse.unsw.edu.au>
	<1095374065.4196.22.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Thursday September 16
To: Doug Ledford <dledford@redhat.com>
Cc: =?ISO-8859-1?Q?Agust=EDn?= Ciciliani <agustin@maderonet.net.ar>, linux-raid@vger.kernel.org, Marcelo Tosatti <marcelo.tosatti@cyclades.com>
List-Id: linux-raid.ids

On Thursday September 16, dledford@redhat.com wrote:
> On Mon, 2004-09-13 at 20:56, Neil Brown wrote:
> > On Monday September 13, agustin@maderonet.net.ar wrote:
> > > Hi Everybody,
> > > 
> > > I was wondering if you could take a look to the following and give some advice... I just
> > > have TWO SATA WD800 disks and "mdadm" says I have "three" and one of
> > > them has "failed"!!!
> > 
> > It's just some odd accounting in the kernel.  Don't worry about it.
> 
> It is just some odd accounting stuff, but it's hardly something I would
> say "don't worry about it".  I had to chase a similar looking problem
> down in our RHEL3 product line.  In fact, it was raid1 where I was
> seeing this problem.  I've attached the email I sent about the problem
> to the internal kernel people, the patch I originally sent in for it,
> and the update patch that catches a couple spots I originally missed in
> my first patch (apologies if my mailer horks this up, haven't tried to
> send sent mail in exactly the way I'm trying it now).

Well, the accounting and the locking are really to separate issues,
but your patch looks good, thanks.

NeilBrown
