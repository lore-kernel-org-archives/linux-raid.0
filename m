From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 1 and grub
Date: Mon, 04 Feb 2008 07:31:49 +1300
Message-ID: <47A60895.2080905@sauce.co.nz>
References: <47A0F4DC.9030005@sauce.co.nz> <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com> <47A13379.50703@sauce.co.nz> <47A5E04E.4050403@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A5E04E.4050403@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:

> Have you actually tested this by removing the first hd and booting? 
> Depending on the BIOS I believe that the fallback drive will be called 
> hdc by the BIOS but will be hdd in the system. That was with RHEL3, but 
> worth testing.
> 

Hi Bill,

I did not try this particular combination. I shut the box down, removed 
the failed drive (hda) and installed it's replacement and proceeded from 
there.

Once I had discovered that hdc had no grub installed, after running:

grub> device (hd0) /dev/hdc

grub> root (hd0,0)

grub> setup (hd0)

I set the BIOS to boot from hdc and it all worked.

Regards,

Richard
