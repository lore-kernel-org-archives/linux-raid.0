From: Russell Coker <russell@coker.com.au>
Subject: Re: write-intent bitmaps
Date: Mon, 28 Jan 2008 02:12:20 +1100
Message-ID: <200801280212.25381.russell@coker.com.au>
References: <200801272134.57690.russell@coker.com.au> <18332.26941.370395.885100@notabene.brown>
Reply-To: russell@coker.com.au
Mime-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18332.26941.370395.885100@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, pkg-mdadm-devel@lists.alioth.debian.org
List-Id: linux-raid.ids

On Sunday 27 January 2008 22:21, Neil Brown <neilb@suse.de> wrote:
> On Sunday January 27, russell@coker.com.au wrote:
> > http://lists.debian.org/debian-devel/2008/01/msg00921.html
> >
> > Are they regarded as a stable feature?  If so I'd like to see
> > distributions supporting them by default.  I've started a discussion in
> > Debian on this topic, see the above URL for details.
>
> Yes, it is regarded as stable.

Thanks for that information.

> However it can be expected to reduce write throughput.  A reduction of
> several percent would not be surprising, and depending in workload it
> could probably be much higher.

It seems to me that losing a few percent of performance all the time is better 
than a dramatic performance loss for an hour or two when things go wrong.

> It is quite easy to add or remove a bitmap on an active array, so
> making it a default would probably be fine providing it was easy for
> an admin to find out about it and remove the bitmap is they wanted the
> extra performance.

I hadn't realised that.  So having this in the installer is not as important 
as I previously thought.

-- 
russell@coker.com.au
http://etbe.coker.com.au/          My Blog

http://www.coker.com.au/sponsorship.html Sponsoring Free Software development
