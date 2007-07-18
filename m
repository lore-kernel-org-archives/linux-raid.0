From: Hannes Dorbath <light@theendofthetunnel.de>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
Date: Wed, 18 Jul 2007 13:37:15 +0200
Message-ID: <469DFB6B.2000103@theendofthetunnel.de>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan> <20070718110525.GF13772@boogie.lpds.sztaki.hu> <Pine.LNX.4.64.0707180718000.7659@p34.internal.lan> <469DF8D3.8020908@theendofthetunnel.de> <Pine.LNX.4.64.0707180732140.7659@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707180732140.7659@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Hannes Dorbath <light@theendofthetunnel.de>, Gabor Gombas <gombasg@sztaki.hu>, linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org
List-Id: linux-raid.ids

On 18.07.2007 13:32, Justin Piszcz wrote:
> Yes I agree here, but I guess my question is why is SW RAID5 so slow on 
> the 3ware card?

I think the controller does disable the drives write cache when exported 
unconfigured. It does always disable, unless you put the drive in a unit 
  and explicit set the profile to `Performance'.


-- 
Regards,
Hannes Dorbath
