From: Alexander Schreiber <als@thangorodrim.de>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 14:34:57 +0100
Message-ID: <20110129133457.GB15784@mordor.angband.thangorodrim.de>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
 <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
 <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 29, 2011 at 04:44:05AM -0200, Roberto Spadim wrote:
> faster than nbd?

I don't know how drbd compares in speed to ndb, but drbd is obviously
slower than plain disks, especially if you care about your data. In the
only sensible operating mode (synchronous writes to the underlying block
devices), the speed (both bandwidth and latency) depends on your disks
and your network connection (so you better get at least a Gigabit link).
Depending on your particular setup, you'll probably get 50-60% of the
plain disk performance for writes, while reads should be reasonably
close to the plain disk performance - drbd optimizes reads by just reading
from the local disk if it can.

Kind regards,
          Alex.
-- 
"Opportunity is missed by most people because it is dressed in overalls and
 looks like work."                                      -- Thomas A. Edison
