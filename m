From: Redeeman <redeeman@metanurb.dk>
Subject: Re: time limited error recovery and md raid
Date: Fri, 05 Dec 2008 22:07:46 +0100
Message-ID: <1228511266.16555.81.camel@localhost>
References: <1228510646.16555.73.camel@localhost>
	 <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-12-05 at 16:01 -0500, Justin Piszcz wrote:
> 
> On Fri, 5 Dec 2008, Redeeman wrote:
> 
> > Hello..
> >
> > Im going to be building a software raid6 setup with probably 8 disks,
> > and i've been looking at the wd gp disks, which comes in both standard
> > and raid edition, with the raid edition being much more expensive.
> >
> > I have searched around, and found that it is indeed possible to activate
> > tler on the "normal" disks, however, the setting has a parameter, more
> > specifically, how many seconds it should be limited to. Default is 7.
> >
> > So i was wondering, what should that be set to, to be optimal for linux
> > md raid? i havent been able to find any information about this.
> >
> >
> > Thanks.
> >
> >
> > mvh.
> > Kasper Sandberg
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> The exact time is a good question.
> 
> Something I have noticed is when TLER is off, the drives hang up when they 
> hit a bad sector and when TLER is on, the drives is kicked out of the 
> array immediately when it reports a bad sector.

First.. Does this happen with a degree of frequency on these disks? you
recommend other disks?

second, when tler is off, it hangs FOREVER? or just until it gives up?
when tler is on, why does linux not attempt to remap the sector?

> 
> Justin.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

