From: "David Lethe" <david@santools.com>
Subject: RE: detection/correction of corruption with raid6
Date: Wed, 17 Dec 2008 09:50:02 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C030D4913@34093-C3-EVS3.exchange.rackspace.com>
References: <1229464713.6159.16.camel@localhost.localdomain> <49491157.9060805@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <49491157.9060805@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Bill Davidsen
> Sent: Wednesday, December 17, 2008 8:49 AM
> To: Piergiorgio Sartor
> Cc: linux-raid@vger.kernel.org
> Subject: Re: detection/correction of corruption with raid6
> 
> Piergiorgio Sartor wrote:
> > Why a RAID system might have inconsistencies?
> > Why do we have a "check" command at all, to run weekly or monthly?
> >
> 
> Because alpha particles fly by, most systems don't have ECC memory, a
> passing truck and noisy jet create a beat frequency that causes a once
> in a century bit flip on a good cable connection, power line noise
> creeps in, or maybe an angel farts.
> 
> My question is why we don't use available techniques to fix this since
> we have the software to find it for us.
> 
> --
> Bill Davidsen <davidsen@tmr.com>
>   "Woe unto the statesman who makes war without a reason that will
> still
>   be valid when the war is over..." Otto von Bismark
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

EEtimes published results from a 10-year IBM study.  They found that
alpha particles created  a bit flip once a month per 256 MB of DRAM
alone at sea level.  I can't remember what it was in high altitude, but
I think it was twice as bad. If you have 4GB of RAM in your computer,
then even if you have parity memory, then you are going to have
undetectable bit flips several times a month.



