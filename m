From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Ok to go ahead with this setup?
Date: Thu, 22 Jun 2006 23:25:13 -0400
Message-ID: <449B5F19.4070707@tmr.com>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:

> Hi list!
>
> Having experienced firsthand the pain that hardware RAID controllers
> can be -- my 3ware 7500-8 died and it took me a week to find even a
> 7508-8 -- I would like to switch to kernel software RAID.
>
> Here's a tentative setup:
>
> Intel SE7230NH1-E mainboard
> Pentium D 930
> 2x1GB Crucial 533 DDR2 ECC
> Intel SC5295-E enclosure
>
> Promise Ultra133 TX2 (2ch PATA)
>   - 2x Maxtor 6B300R0 (300GB, DiamondMax 10) in RAID1
>
> Onboard Intel ICH7R (4ch SATA)
>   - 4x Western Digital WD5000YS (500GB, Caviar RE2) in RAID5
>
> * Does this hardware work flawlessly with Linux?
>
> * Is it advisable to boot from the mirror?
>  Would the box still boot with only one of the disks?


Let me say this about firmware mirror: while virtually every BIOS will 
boot the "next" disk if the first fails, some will not fail over if the 
first drive is returning a parity but still returning data. Take that 
data any way you want, drive failure at power cycle is somewhat more 
likely than failure while running.

>
> * Can I use EVMS as a frontend?
>  Does it even use md or is EVMS's RAID something else entirely?
>
> * Should I use the 300s as a single mirror, or span multiple ones over
> the two disks?
>
> * Am I even correct in assuming that I could stick an array in another
> box and have it work?
>
> Comments welcome
>
> Thanks,
>
> Chris
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

