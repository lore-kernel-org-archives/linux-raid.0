From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Resync Question
Date: Thu, 23 Oct 2003 16:15:28 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F9836E0.5B2E8680@SteelEye.com>
References: <20031023194833.24958.qmail@web14508.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: donj@asaca.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Don Jessup wrote:
> 
>    Let me clarify,  I need to be able to start a resync, stop it and start
>    it back up were it left off.   Does this functionality exist?

Yes. The current 2.6 md driver has the ability to checkpoint its
recovery, to allow for restarting an aborted recovery. I don't know what
state it's in at this point, though...

--
Paul

> 
> --- Don Jessup <donj@asaca.com> wrote:
> >
> >
> >    I have a need to be able to start and stop a resync. Is there such
> >  a capability?  If not, would it be difficult to add such a feature?
> >
> >   I need to be able to do this on Creation and on Recovery.
> >
> >
> >
> >
> >
> >
> > =====
> > Don Jessup
> > Asaca/Shibasoku Corp. of America
> > 400 Corporate Circle, Unit G
> > Golden, CO  80401
> > 303-278-1111 X232
> > donj@asaca.com
> > http://www.asaca.com
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >
> >
> 
> =====
> Don Jessup
> Asaca/Shibasoku Corp. of America
> 400 Corporate Circle, Unit G
> Golden, CO  80401
> 303-278-1111 X232
> donj@asaca.com
> http://www.asaca.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
