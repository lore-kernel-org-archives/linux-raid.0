From: Gordon Henderson <gordon@drogon.net>
Subject: Re: It is safe to stop Raid being reshaped
Date: Thu, 29 Dec 2011 11:21:37 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.1112291119250.10295@unicorn.drogon.net>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com> <4EFB67CC.7010500@shiftmail.org> <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com> <4EFBCA47.9010401@shiftmail.org>
 <CAK90R-A9BmfjO4DtA+n+pXvv9ud39G8QqkvNOJ6c0Mo3aaBNow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK90R-A9BmfjO4DtA+n+pXvv9ud39G8QqkvNOJ6c0Mo3aaBNow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 28 Dec 2011, Jeremy Thompson wrote:

> I checked the temperature of one of the drives, the reason I say
> drives is because as soon as I wrote this email, a couple more drives
> started throwing the same errors.  What boggles me is that I can't
> have that many possible bad SATA cables? Can I?  The cables being used
> are brand new, some off brand I know that but they are brand new.

They're not WDC drives are they?

> [77832.251754] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x280000 action 0x0
> [77832.261281] ata3.00: BMDMA2 stat 0x696d0009
> [77832.271043] ata3: SError: { 10B8B BadCRC }
> [77832.280933] ata3.00: failed command: READ DMA EXT
> [77832.290523] ata3.00: cmd 25/00:00:78:0f:c0/00:04:5b:00:00/e0 tag 0
> dma 524288 in
> [77832.290526]          res 51/04:6f:78:0f:c0/00:00:00:00:00/f0 Emask
> 0x1 (device error)
> [77832.308903] ata3.00: status: { DRDY ERR }
> [77832.318246] ata3.00: error: { ABRT }
> [77832.408077] ata3.00: configured for UDMA/100
> [77832.408142] ata3: EH complete

I've had very similar errors from a pair of WDC drives - bought at the 
same time, from the same batch... They didn't show any surface defects or 
sector remaps, just lots of DMA errors in both the Linux logs and the 
SMART logs in the devices.

> Anything else you'd like me to check out?  I'd also like to know how
> can I correlate between which drive is ata3, ata5, and ata6?  So ata6
> could be /dev/sda for instance.
>
> Here is what I get for the temperature from smartctl -a /dev/sdg:
>
> 190 Airflow_Temperature_Cel 0x0022   047   032   045    Old_age
> Always   In_the_past 53 (77 0 55 36)
> 194 Temperature_Celsius     0x0022   053   068   000    Old_age
> Always       -       53 (0 21 0 0)
>
> I included both of those lines because I'm not sure which ones you
> wanted to look at.

They're running at 53C. Is that good or bad? Who knows - you'll need to 
check the manufacturers specs.

Gordon
