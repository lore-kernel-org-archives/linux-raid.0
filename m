From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: suggestions for inexpensive linux jbod?
Date: Mon, 18 Jun 2007 12:56:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706181255540.31683@p34.internal.lan>
References: <f566d2$84u$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f566d2$84u$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike <mikee@mikee.ath.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 18 Jun 2007, Mike wrote:

> I'm creating a larger backup server that uses bacula (this
> software works well). The way I'm going about this I need
> lots of space in the filesystem where temporary files are
> stored. I have been looking at the Norco (link at the bottom),
> but there seem to be some grumblings that the adapter card
> does not play well with linux.
>
> Has anyone used this device or have another suggestion? I'm
> looking at something that will present lots of disk to the
> linux box (fedore core 5, kernel 2.6.20) that I will put
> under md/RAID and LVM. I want to have between 1.5TB and 3.0TB
> of usable space after all the RAID'ing.
>
> Mike
>
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816133001
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Get 3 Hitachi 1TB drives and use SW RAID5 on an Intel 965 motherboard OR 
use PCI-e cards that use the Silicon Image chipset.

04:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid 
II Controller (rev 01)

Justin.
