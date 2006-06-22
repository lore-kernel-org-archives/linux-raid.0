From: Gil <gil@fooplanet.com>
Subject: Re: New FAQ entry? (was IBM xSeries stop responding during RAID1
 reconstruction)
Date: Wed, 21 Jun 2006 21:35:28 -0700
Message-ID: <449A1E10.2050402@fooplanet.com>
References: <Pine.LNX.4.44.0606212219120.10004-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0606212219120.10004-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>> There's much easier/simpler way to set default scheduler.  As
> 
> personally, I don't see any point to worrying about the default,
> compile-time or boot time:
> 
> for f in `find /sys/block/* -name scheduler`; do echo cfq > $f; done

I agree -- if you're talking about changing the io scheduler for the
duration of a resync you should take this approach rather than
changing kernels or rebooting.

--Gil
