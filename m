From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Raid server Motherboard recommendation.
Date: Thu, 12 Nov 2015 19:51:20 -0600
Message-ID: <56454218.7000603@gmail.com>
References: <5643FD4A.4070709@gmail.com> <20151112122908.0406d170@natsu> <56449EE5.3010002@gmail.com> <20151112151105.GA32385@EIS>
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
Andreas,

   Thanks a lot. Now I feel a lot more confident trying out extreme6. I 
usually put all my boot related (cd, primary sdd) on intel any way. So, 
CD drive should not be a problem.

Ramesh

