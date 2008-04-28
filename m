From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Mon, 28 Apr 2008 19:01:25 +1200
Message-ID: <48157645.7090309@sauce.co.nz>
References: <48025B8D.2030803@harddata.com>	<alpine.DEB.1.10.0804131529300.11311@p34.internal.lan>	<4802AFEB.9020006@tmr.com> <480F7105.9030405@harddata.com>	<alpine.DEB.1.10.0804231453390.4441@p34.internal.lan>	<480F8830.6020207@harddata.com>	<alpine.DEB.1.10.0804231525140.4441@p34.internal.lan>	<alpine.LFD.1.10.0804271758360.18247@www.karsites.net>	<4814D3EF.30703@sauce.co.nz> <alpine.LFD.1.10.0804280625160.16431@www.karsites.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804280625160.16431@www.karsites.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keith Roberts wrote:

> Reading the documentation for smartmontools I got the impression that it 
> cannot work with RAID controllers, apart from 3ware and some Highpoint. 
> Maybe I'm getting mixed up with hardware raid?

Hardware controllers are a different story, (you can add to LSI to the 
above). There are no problems with md RAID.

> So is it safe to use all features of smartmontools, including running 
> tests, on a Linux software RAID1 array?

No problems at all that I am aware of. I run smartd and perform long 
self checks weekly on all drives I have in live RAID 1 and 5 arrays.

Regards,

Richard
