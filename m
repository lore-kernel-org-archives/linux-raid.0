From: jtroan@jt-sw.com
Subject: Re: Resurrecting a Dirty RAID-5
Date: Sun, 12 Jul 2015 11:01:54 -0400
Message-ID: <OF4E023A92.1624DC91-ON85257E80.0051B769-85257E80.005287C5@jt-sw.com>
References: <OFC233BA12.DDED55A2-ON85257E7C.00420655-85257E7C.0043331F@jt-sw.com> <559D2374.7040208@turmel.org> <OF71F1F6CD.C562AA57-ON85257E7D.000FAD79-85257E7D.0010311B@jt-sw.com> <alpine.DEB.2.02.1507120756020.11810@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1507120756020.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> On Wed, 8 Jul 2015, jtroan@jt-sw.com wrote:
>
> > I'm also thinking about adding a fourth drive and try to config it as a

> > hot-spare, giving me some extra margin for failure.
>
> I would recommend you turn your raid5 into raid6 instead of having a
> raid5+spare. This can be done with a fairly simple command, without
> downtime.
>

I like the idea of using RAID-6 for / (for all the VMs under /var).  (I
figure I'll probably still have to do a spare on my RAID-1 device
for /boot .)

What's the (mdadm?) command to convert an MD from RAID-5 to RAID-6?

Thanks.....

=======================================================================
John M. Troan  <jtroan@jt-sw.com>
Maintainer: Football Site @ JT-SW.com
  http://www.jt-sw.com/football
Chief of Computer Operations
  U.S.S. Kitty Hawk / NCC-1659
=======================================================================

