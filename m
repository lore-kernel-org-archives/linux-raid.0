From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 000 of 2] Introduction
Date: Thu, 17 Nov 2005 16:12:01 +1100
Message-ID: <17276.4385.566615.373265@cse.unsw.edu.au>
References: <20051115125442.9317.patches@notabene>
	<Pine.LNX.4.64.0511150859360.15915@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Tuesday November 15
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday November 15, babydr@baby-dragons.com wrote:
>  	Hello Neil ,
> 
> On Tue, 15 Nov 2005, NeilBrown wrote:
> > +
> > +---------------------------
> > +
> > +What:  START_ARRAY ioctl for md
> > +When:  July 2006
> > +Files: drivers/md/md.c
> > +Why:   Not reliable by design - can fail when most needed.
> > +       Alternatives exist
> > +Who:   NeilBrown <neilb@suse.de>
> 
>  	Would some please update Documentation/md.txt with the alternates
>  	that exist to replace START_ARRAY ?  Or for that matter any kernel
>  	related document that covers the md driver &/or its tools .
>  		Tia ,  JimL
> 

Are you just asking "What are the 'Alternatives' that are claimed to
exist?"?
If so, then it is  'mdadm -A'.  I guess I could make that more
explicit.

Or are you asking something else?

NeilBrown

