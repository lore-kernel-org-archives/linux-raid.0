From: Alexander Schreiber <als@thangorodrim.de>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 22:08:15 +0100
Message-ID: <20110129210815.GC15784@mordor.angband.thangorodrim.de>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
 <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
 <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
 <20110129133457.GB15784@mordor.angband.thangorodrim.de>
 <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Denis <denismpa@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Mikael Abrahamsson <swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 29, 2011 at 12:23:14PM -0200, Denis wrote:
> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>
> 
> >
> > plain disk performance for writes, while reads should be reasonably
> > close to the plain disk performance - drbd optimizes reads by just reading
> > from the local disk if it can.
> >
> >
>  However, I have not used it with active-active fashion. Have you? if yes,
> what is your overall experience?

We are using drbd to provide mirrored disks for virtual machines running
under Xen. 99% of the time, the drbd devices run in primary/secondary
mode (aka active/passive), but they are switched to primary/primary
(aka active/active) for live migrations of domains, as that needs the
disks to be available on both nodes. From our experience, if the drbd
device is healthy, this is very reliable. No experience with running
drbd in primary/primary config for any extended period of time, though
(the live migrations are usually over after a few seconds to a minute at
most, then the drbd devices go back to primary/secondary).

Kind regards,
          Alex.
-- 
"Opportunity is missed by most people because it is dressed in overalls and
 looks like work."                                      -- Thomas A. Edison
