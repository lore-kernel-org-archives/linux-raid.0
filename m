From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: Re: New FAQ entry? (was IBM xSeries stop responding during RAID1 reconstruction)
Date: Thu, 22 Jun 2006 09:11:45 +0200
Message-ID: <20060622071145.GA718@rigacci.org>
References: <Pine.LNX.4.44.0606212219120.10004-100000@coffee.psychology.mcmaster.ca> <449A1E10.2050402@fooplanet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <449A1E10.2050402@fooplanet.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mark Hahn <hahn@physics.mcmaster.ca>
List-Id: linux-raid.ids

> > personally, I don't see any point to worrying about the default,
> > compile-time or boot time:
> > 
> > for f in `find /sys/block/* -name scheduler`; do echo cfq > $f; done

I tested this case:

- reboot as per power failure (RAID goes dirty)
- RAID start resyncing as soon as the kernel assemble it
- every disk activity is blocked, even DHCP failed!
- host services are unavailable

This is why I changed the kernel default.

-- 
Niccolo Rigacci
Firenze - Italy

Iraq, missione di pace: 38475 morti - www.iraqbodycount.net
