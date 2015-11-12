From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Raid server Motherboard recommendation.
Date: Thu, 12 Nov 2015 16:11:05 +0100
Message-ID: <20151112151105.GA32385@EIS>
References: <5643FD4A.4070709@gmail.com>
 <20151112122908.0406d170@natsu>
 <56449EE5.3010002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56449EE5.3010002@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Nov 12, 2015 at 08:15:01AM -0600, Ram Ramesh wrote:
>    Thanks. I did see that. But, in newegg, there are reviews dated much 
> later than above complaining about ubuntu 14.04 installs failing with 
> ASMedia enabled. So, I concluded that it is iffy. I could not see any 
> consistent message of positive result.

I use ASMedia controllers myself, onboard and as standalone card. 
They were cheap (much cheaper than getting a board with additional 
ports using the same chipset really) and I don't need the PCIe slots 
for anything else.

They work fine in AHCI mode for HDD, with mdadm software raid.

If you have a CD drive hooked to it the kernel will crash.
Until you add libata.atapi_passthru16=0 to your cmdline.

Regards
Andreas
