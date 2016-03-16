From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Raid server Motherboard recommendation.
Date: Wed, 16 Mar 2016 17:38:14 -0500
Message-ID: <56E9E056.7000204@gmail.com>
References: <5643FD4A.4070709@gmail.com> <20151112122908.0406d170@natsu>
 <56449EE5.3010002@gmail.com> <20151112151105.GA32385@EIS>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151112151105.GA32385@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Roman Mamedov <rm@romanrm.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/12/2015 09:11 AM, Andreas Klauer wrote:
> On Thu, Nov 12, 2015 at 08:15:01AM -0600, Ram Ramesh wrote:
>>     Thanks. I did see that. But, in newegg, there are reviews dated much
>> later than above complaining about ubuntu 14.04 installs failing with
>> ASMedia enabled. So, I concluded that it is iffy. I could not see any
>> consistent message of positive result.
> I use ASMedia controllers myself, onboard and as standalone card.
> They were cheap (much cheaper than getting a board with additional
> ports using the same chipset really) and I don't need the PCIe slots
> for anything else.
>
> They work fine in AHCI mode for HDD, with mdadm software raid.
>
> If you have a CD drive hooked to it the kernel will crash.
> Until you add libata.atapi_passthru16=0 to your cmdline.
>
> Regards
> Andreas
Andreas

If you don't mind, could you share with me the standalone card that you 
use?

I used SYBA SI-PEX40064 
(http://www.newegg.com/Product/Product.aspx?Item=N82E16816124064)
and under load (mkfs.ext4 -c -c on just one drive) it drops the drives 
and a reboot
is required to get them back. This means I cannot put raid component on this
without risking degrading the array. I believe SYBA based on Marvell 
88SE9215.

BTW, have you stressed your card through a rebuild/checkarray?

Thanks
Ramesh


