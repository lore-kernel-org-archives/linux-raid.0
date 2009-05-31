From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Events?
Date: Sat, 30 May 2009 20:37:13 -0500
Message-ID: <20090531013717425.YKVV5991@cdptpa-omta01.mail.rr.com>
References: <18977.43320.811246.171065@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18977.43320.811246.171065@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Saturday, May 30, 2009 4:47 PM
> To: lrhorer@satx.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Events?
> 
> On Saturday May 30, lrhorer@satx.rr.com wrote:
> >
> > What does the "Events" field reported by -Dt signify, and why does the
> > number sometimes decrease?  I've seen the number change, but I don't see
> > anything in any of the system logs corresponding to something that would
> > seem to relate.
> 
> Changes just as device failure and adding or removing a device.
> Also transitions from 'active' to 'clean' and back.

OK, but shouldn't these transitions at least be logged somewhere?

> Sometimes the dirty->transition causes the event counter to retreat if
> md is use the new 'clean' state is indistinguishable from the old
> 'clean' state.  This allows us not to always be waking up spare drives
> just to tell them about clean->active->clean transitions.

That makes sense, but I think the admin should be able to inspect the
details of the transactions.

