From: Steven Dake <sdake@mvista.com>
Subject: Re: multipath - stable ?
Date: Fri, 12 Dec 2003 10:35:19 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1071250518.13240.32.camel@persist.az.mvista.com>
References: <200312121552.02975.franc@tech.sirca.org.au>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200312121552.02975.franc@tech.sirca.org.au>
To: Franc Carter <franc@tech.sirca.org.au>
Cc: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The multipath code is simple and seems pretty stable to me.

There is one issue, in that failover can sometimes take a long time
because of the SCSI layer's insistence upon executing error recovery. 
In the case of multipath I/O's, there is no need to error recover before
processing the I/O.  Instead, once error is detected, failover, then
start error recovery.

The SCSI layer doesn't do this currently, so failover times are high.

Thanks
-steve


On Thu, 2003-12-11 at 21:52, Franc Carter wrote:
> Hi,
> 
> I've been using linux sofwtare raid for years and had no problems.
> We are about to install some disk systems that have dual contollers
> and am wondering wether multipath is as stable as the rest of software
> raid ?
> 
> thanks

