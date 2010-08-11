From: Tim Small <tim@seoss.co.uk>
Subject: Re: debian dist-upgrade etch -> squeeze broke my mdadm RAID1
Date: Wed, 11 Aug 2010 09:16:20 +0100
Message-ID: <4C625C54.5060000@seoss.co.uk>
References: <201008111527.37009.Doug.duBoulay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201008111527.37009.Doug.duBoulay@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug <doug.duboulay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/08/10 06:27, Doug wrote:
> After the upgrade and installation of a new 2.6.32 kernel, the kernel
>    

I believe Debian only supports upgrading between major versions, so you 
should have gone 4.0.x (etch) -> 5.0.x (lenny) -> 6.0-pre (squeeze).  If 
you didn't then that'll explain the problem you're seeing which is 
really Debian-specific, and relates (I believe) to the change in device 
naming with the switch to udev which occured between etch and lenny (and 
is presumably taken into account when upgrading between those two).

HTH,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

