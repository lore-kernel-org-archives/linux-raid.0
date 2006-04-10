From: dean gaudet <dean@arctic.org>
Subject: Re: md/mdadm fails to properly run on 2.6.15 after upgrading from
 2.6.11
Date: Mon, 10 Apr 2006 11:35:50 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0604101128290.29514@twinlark.arctic.org>
References: <4438FFA9.4030907@debruin.org> <Pine.LNX.4.64.0604090736170.4668@twinlark.arctic.org>
 <443A0F3A.90104@debruin.org> <Pine.LNX.4.64.0604100843370.29514@twinlark.arctic.org>
 <443A9DDC.10601@debruin.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <443A9DDC.10601@debruin.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Marc L. de Bruin" <marc@debruin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 10 Apr 2006, Marc L. de Bruin wrote:

> However, all "preferred minor"s are correct, meaning that the output is in
> sync with what I expected it to be from /etc/mdadm/mdadm.conf.
> 
> Any other ideas? Just adding /etc/mdadm/mdadm.conf to the initrd does not seem
> to work, since mdrun seems to ignore it?!

yeah it looks like "mdrun /dev" just seems to assign things in the order 
they're discovered without consulting the preferred minor.

it seems to me "mdrun /dev" is about the worst thing possible to use in an 
initrd.

i opened a bug yesterday 
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=361674> ... it seems 
really they should stop using mdrun entirely... when i get a chance i'll 
try updating the bug (or go ahead and add your own experiences to it).

oh hey take a look at this bug for debian mdadm package 
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=354705> ... he intends 
to deprecate mdrun.

-dean
