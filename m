From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
Date: Wed, 18 Jul 2007 07:38:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707180738070.7659@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
 <20070718110525.GF13772@boogie.lpds.sztaki.hu> <Pine.LNX.4.64.0707180718000.7659@p34.internal.lan>
 <469DF8D3.8020908@theendofthetunnel.de> <Pine.LNX.4.64.0707180732140.7659@p34.internal.lan>
 <469DFB6B.2000103@theendofthetunnel.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469DFB6B.2000103@theendofthetunnel.de>
Sender: linux-raid-owner@vger.kernel.org
To: Hannes Dorbath <light@theendofthetunnel.de>
Cc: Gabor Gombas <gombasg@sztaki.hu>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 18 Jul 2007, Hannes Dorbath wrote:

> On 18.07.2007 13:32, Justin Piszcz wrote:
>> Yes I agree here, but I guess my question is why is SW RAID5 so slow on the 
>> 3ware card?
>
> I think the controller does disable the drives write cache when exported 
> unconfigured. It does always disable, unless you put the drive in a unit  and 
> explicit set the profile to `Performance'.
>
>
> -- 
> Regards,
> Hannes Dorbath
>

Ahh, that could explain it!

