From: Brad Campbell <brad@wasp.net.au>
Subject: Re: HighPoint Rocket 1540 hang driver load (Was: Re: Which raid card
 to buy for Sarge)
Date: Wed, 21 Apr 2004 15:44:34 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40865EA2.80504@wasp.net.au>
References: <40865AEC.8040604@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40865AEC.8040604@online.no>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Gaarden wrote:

> 
> IANA driver programmer, so I can't comment on the quality. But using
> that v111 from above compiled with NON_RAID=1 and some boot trickery
> (boot with no drives connected to the controller, so the BIOS on the
> card isn't loaded. Then connect drives before loading driver) seems to
> be the only way for me to make the card work properly.
> 
> Using the same trick with the hpt366 driver cause slow data rates
> and drive_cmd: status=0x58 { DriveReady SeekComplete DataRequest }
> status error: status=0x58 { DriveReady SeekComplete DataRequest }
> errors,
> 

Just my .02c worth. I was using 7 Maxtor SATA drives with 2 RocketRaid 1540's.
I tried all the available in-kernel drivers with many 2.4 and 2.6 kernels and resorted to using the 
hpt supplied drivers compiled from source with NON_RAID=1. I was using md raid-5 and with this combo 
and it was rock solid for months (Before I upgraded to Promise TX4 controllers). With the in-kernel 
hpt drivers I never managed more than 15mb/s to or from the disks. Slow as a wet week in may (In the 
southern hemisphere anyway).

Regards,
Brad
