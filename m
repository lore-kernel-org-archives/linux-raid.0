From: dean gaudet <dean@arctic.org>
Subject: Re: md/mdadm fails to properly run on 2.6.15 after upgrading from
 2.6.11
Date: Tue, 11 Apr 2006 14:13:44 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0604111412010.25252@twinlark.arctic.org>
References: <4438FFA9.4030907@debruin.org> <Pine.LNX.4.64.0604090736170.4668@twinlark.arctic.org>
 <443A0F3A.90104@debruin.org> <Pine.LNX.4.64.0604100843370.29514@twinlark.arctic.org>
 <443A9DDC.10601@debruin.org> <Pine.LNX.4.64.0604101128290.29514@twinlark.arctic.org>
 <443AC897.50206@debruin.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <443AC897.50206@debruin.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Marc L. de Bruin" <marc@debruin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 10 Apr 2006, Marc L. de Bruin wrote:

> dean gaudet wrote:
> > On Mon, 10 Apr 2006, Marc L. de Bruin wrote:
> > 
> > > However, all "preferred minor"s are correct, meaning that the output is in
> > > sync with what I expected it to be from /etc/mdadm/mdadm.conf.
> > > 
> > > Any other ideas? Just adding /etc/mdadm/mdadm.conf to the initrd does not
> > > seem
> > > to work, since mdrun seems to ignore it?!
> 
> > it seems to me "mdrun /dev" is about the worst thing possible to use in an
> > initrd.
> 
> :-)
> 
> I guess I'll have to change to yaird asap then. I can't think of any other
> solid solution...

yeah i've been yaird... it's not perfect -- take a look at 
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=351183> for a patch i 
use to improve the ability of a yaird initrd booting when you've moved 
devices or a device has failed.

-dean
