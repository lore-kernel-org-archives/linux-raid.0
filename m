From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_nv and RAID1
Date: Tue, 14 Jun 2005 20:08:47 -0400
Message-ID: <42AF718F.5060404@pobox.com>
References: <200506111613.42962.dvadell@lantech.com.ar>	 <20050611192606.GA4055@pentafluge.infradead.org>	 <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com>	 <42AD74BD.8050704@tls.msk.ru> <62b0912f05061414116f7afedc@mail.gmail.com> <42AF4E17.2040900@tls.msk.ru> <42AF55D3.1090704@lantech.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AF55D3.1090704@lantech.com.ar>
Sender: linux-raid-owner@vger.kernel.org
To: "Diego M. Vadell" <dvadell@lantech.com.ar>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Diego M. Vadell wrote:
> Michael Tokarev wrote:
> 
>>
>> I for one don't care (for now) about SATA and hot[un]plug for
>> harddrives.  
> 
> 
> Hi Michael,
>   Why don't you care? Is it so unlikely to get a hard disk as broken as 
> if it looked the same as if it were unplugged? I mean, am I worrying too 
> much.

The ATA drivers handle errors.  Just not hotplug and hotunplug, which 
are very different beasts.

	Jeff


