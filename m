From: Steven Dake <sdake@mvista.com>
Subject: Re: multipath - stable ?
Date: Mon, 15 Dec 2003 15:00:32 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1071525632.4768.28.camel@persist.az.mvista.com>
References: <200312121552.02975.franc@tech.sirca.org.au>
	 <1071250518.13240.32.camel@persist.az.mvista.com>
	 <200312131035.43175.franc@tech.sirca.org.au>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200312131035.43175.franc@tech.sirca.org.au>
To: Franc Carter <franc@tech.sirca.org.au>
Cc: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The SCSI layer should retries a failed I/O 5 times, and have 30 second
timeouts per I/O.  The card itself my return the I/O as failed before
the 30 second timeout, which would improve your failover times.  That
gives 3 minutes as a maximum.

Thanks
-steve

On Fri, 2003-12-12 at 16:35, Franc Carter wrote:
> Thanks, 
> 
> can you give me a ballpark on 'high' >5 minutes ?
> 
> cheers
> 
> On Sat, 13 Dec 2003 04:35 am, Steven Dake wrote:
> > The multipath code is simple and seems pretty stable to me.
> > 
> > There is one issue, in that failover can sometimes take a long time
> > because of the SCSI layer's insistence upon executing error recovery. 
> > In the case of multipath I/O's, there is no need to error recover before
> > processing the I/O.  Instead, once error is detected, failover, then
> > start error recovery.
> > 
> > The SCSI layer doesn't do this currently, so failover times are high.
> > 
> > Thanks
> > -steve
> > 
> > 
> > On Thu, 2003-12-11 at 21:52, Franc Carter wrote:
> > > Hi,
> > > 
> > > I've been using linux sofwtare raid for years and had no problems.
> > > We are about to install some disk systems that have dual contollers
> > > and am wondering wether multipath is as stable as the rest of software
> > > raid ?
> > > 
> > > thanks
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 

