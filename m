From: Raul Dias <raul@dias.com.br>
Subject: Re: Replace RAID devices without resorting to degraded mode?
Date: Wed, 12 Mar 2014 09:23:32 -0300
Message-ID: <CAE6VuKFxqRET=tQoSvbHFd7iiKeXBPJZTBUgTTwMpzOnrPEmbg@mail.gmail.com>
References: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>
	<53202503.10901@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53202503.10901@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Scott D'Vileskis <sdvileskis@gmail.com>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2014-03-12 6:12 GMT-03:00 David Brown <david.brown@hesbynett.no>:
...
>
> If you want to safely replace the disks in a raid5 array, the easiest
> way is to add a new disk (this can be an external USB disk if necessary)
> and re-shape to an asymmetric raid6 with parity Q on the new disk.  Now
> you have an extra redundancy for safety.  (Use asymmetric raid6 to avoid
> re-striping the existing disks.)

Is there a solution for other RAID setups? 1,0,6,10?

thanks
