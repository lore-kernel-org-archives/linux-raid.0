From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid1 running fine for years .. and then
Date: Tue, 13 Oct 2009 19:51:24 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.0910131950220.29143@p34.internal.lan>
References: <alpine.DEB.2.00.0910072350440.30153@p34.internal.lan> <20091012160040.GE17021@aurora.pimp.org.za> <alpine.DEB.2.00.0910121320160.2020@p34.internal.lan> <20091013114552.GC11085@aurora.pimp.org.za>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091013114552.GC11085@aurora.pimp.org.za>
Sender: linux-raid-owner@vger.kernel.org
To: Michael-John Turner <mj@mjturner.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 13 Oct 2009, Michael-John Turner wrote:

> On Mon, Oct 12, 2009 at 01:20:55PM -0400, Justin Piszcz wrote:
>> Drive is a 150GB raptor:
>>
>> Device Model:     WDC WD1500ADFS-00SLR5
>> Firmware Version: 21.07QR5
>
> Hmm.... Doesn't seem drive related then. What kernel and SATA controller?
> I'm using 2.6.26 and an ICH9R, with NCQ enabled.
>
> -mj
> -- 
> Michael-John Turner
> mj@mjturner.net      <>     http://mjturner.net/
>

Hi,

Found the issue, it was the drive.  I recently bought a new motherboard & 
another 3ware raid card.  As soon as it began initializing the drive, the 
re-allocated sectors started to shoot up.

When I connected it back to the system board temporarily and ran a dd 
against it-- it started erroring more.  In this case, it was a bad drive.

Justin.
