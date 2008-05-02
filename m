From: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 02 May 2008 03:39:19 +0200
Message-ID: <1209692359.16523.2.camel@localhost>
References: <771640.4981.qm@web50209.mail.re2.yahoo.com>
	 <alpine.DEB.1.10.0805010849380.20043@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0805010849380.20043@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alex Davis <alex14641@yahoo.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2008-05-01 at 08:50 -0400, Justin Piszcz wrote:
> 
> On Thu, 1 May 2008, Alex Davis wrote:
> 
> > Is this a bad thing? I'm guessing that it is, but I want independent
> > confirmation before I spoke to someone I know who's doing this.
> >
> > Thanks
> >
> >
> >      ____________________________________________________________________________________
> > Be a better friend, newshound, and
> > know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> What is the use case, why would you want to do that?
> I have seen people on the list do it before, for example are you going to 
> be utilizing both raids at the same time?  If so, I would advise against 
> it.
> 
> What is the reasoning?

I do this!

is this really bad? i would surely like a list of reasons why..

I do it because.. well.. first off, it allows me to have /boot on
different raidlevel than / or /home without extra disks.
secondly, it allows me to with the same disks use different
filesystems.. for instance, it allows me to have /home encrypted with
dm-crypt, while still raided.. Not that i would mind encrypting /
and /home as 1 partition, but it creates a whole slew of issues with
having to create initrd and stuff..

I realize that performance probably suffers abit from this, but well..
is there any stability or security wise risk? i mostly use raid1 and
raid5 only..

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

