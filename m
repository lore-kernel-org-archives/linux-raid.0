From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 01 Feb 2011 16:05:23 -0600
Message-ID: <4D4883A3.6030605@hardwarefreak.com>
References: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>	<20110131192858.GD27952@www2.open-std.org>	<4D4718E1.9040607@hardwarefreak.com>	<20110131203725.GB2283@www2.open-std.org>	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>	<AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>	<20110131225235.GA11775@www2.open-std.org>	<ii8lcv$3jg$1@dough.gmane.org> <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Nelson put forth on 2/1/2011 7:50 AM:

> The performance will not be the same because. Whenever possible, md
> reads from the outermost portion of the disk -- theoretically the
> fastest portion of the disk (by 2 or 3 times as much as the inner
> tracks) -- and in this way raid10,f2 can actually be faster than
> raid0.

Faster in what regard?  I assume you mean purely sequential read, and not random
IOPS.  The access patterns of the vast majority of workloads are random, so I
don't see much real world benefit, if what you say is correct.  This might
benefit MythTV or similar niche streaming apps.

-- 
Stan
