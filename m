From: Nathan Lewis <nathapl@cs.okstate.edu>
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Fri, 13 Feb 2004 14:54:52 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.2.20040213145441.0290fdc8@a.cs.okstate.edu>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>
 <16411.35140.244946.630202@notabene.cse.unsw.edu.au>
 <6.0.1.1.2.20040212220348.0289ee48@a.cs.okstate.edu>
 <1076681910.1478.10.camel@dyn251.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1076681910.1478.10.camel@dyn251.ele.uri.edu>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>
 <16411.35140.244946.630202@notabene.cse.unsw.edu.au>
 <6.0.1.1.2.20040212220348.0289ee48@a.cs.okstate.edu>
 <1076681910.1478.10.camel@dyn251.ele.uri.edu>
To: mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, that looks like exactly what I was looking for.

At 08:18 AM 2/13/2004, Ming Zhang wrote:
>The new book Linux Kernel Development and
>http://lwn.net/Articles/driver-porting/
>
>may give u some help.
>
>
>ming
>
>On Thu, 2004-02-12 at 23:35, Nathan Lewis wrote:
> > Now that I've got working Reed Soloman code, I need to make a decision
> > really quickly on whether to use 2.4 or 2.6.  I've got both, and it does
> > look like the raid code is much cleaner in 2.6, and it also helps that
> > there is raid6 for 2.6, which shows me approximately where I'd need to
> > modify code to turn it into RS.  However, I really need some documentation
> > on the bio structure.  The bio.h file is sorely lacking comments, and, of
> > course, the Rubini book isn't going to help me.
> >
> > Can someone point me at some documentation for the bio structure?
> >
> >
> > >I strongly agree with Peter.  Base your work on 2.6, not 2.4.  The
> > >raid code is much cleaner in 2.6.
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

