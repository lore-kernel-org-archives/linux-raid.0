From: Keith Roberts <keith@karsites.net>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Mon, 28 Apr 2008 06:29:34 +0100 (BST)
Message-ID: <alpine.LFD.1.10.0804280625160.16431@www.karsites.net>
References: <48025B8D.2030803@harddata.com>
	<alpine.DEB.1.10.0804131529300.11311@p34.internal.lan>
	<4802AFEB.9020006@tmr.com> <480F7105.9030405@harddata.com>
	<alpine.DEB.1.10.0804231453390.4441@p34.internal.lan>
	<480F8830.6020207@harddata.com>
	<alpine.DEB.1.10.0804231525140.4441@p34.internal.lan>
	<alpine.LFD.1.10.0804271758360.18247@www.karsites.net>
	<4814D3EF.30703@sauce.co.nz>
Reply-To: Keith Roberts <keith@karsites.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4814D3EF.30703@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 28 Apr 2008, Richard Scobie wrote:

> To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
> From: Richard Scobie <richard@sauce.co.nz>
> Subject: Re: Question: how to identify failing disk in a RAID1
> 
> Keith Roberts wrote:
>
>> It would be nice to be able to use smartmontools to monitor the health 
>> of the drives in a RAID1 array. Get the best of both worlds then.
>
> I have been doing this for years.
>
> What problems are you seeing using smartd on a RAID1?
>
> Regards,
>
> Richard

Reading the documentation for smartmontools I got the 
impression that it cannot work with RAID controllers, apart 
from 3ware and some Highpoint. Maybe I'm getting mixed up 
with hardware raid?

So is it safe to use all features of smartmontools, 
including running tests, on a Linux software RAID1 array?

Kind Regards

Keith Roberts

-----------------------------------------------------------------
Websites:
http://www.php-debuggers.net
http://www.karsites.net
http://www.raised-from-the-dead.org.uk

All email addresses are challenge-response protected with
TMDA [http://tmda.net]
-----------------------------------------------------------------


