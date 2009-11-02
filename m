From: Christian Pernegger <pernegger@gmail.com>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 2 Nov 2009 19:51:50 +0100
Message-ID: <bb145bd20911021051u177bbd7di17dd0d5d57ccd950@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	 <4AEEF29C.10309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AEEF29C.10309@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> It is really slow, recent kernels seem to be unsuitable for use as large
> file servers, as the performance is, as you described it, "unbelievably
> bad."

Is this raid6 specific? Because FWIW md performance has been fine (not
great, but fine) on my little raid5/10 file servers. As soon as I add
dm-crypt to the mix it all goes to hell, though.

Maybe it's a device-mapper thing? Is everybody affected using LVM?

C.
