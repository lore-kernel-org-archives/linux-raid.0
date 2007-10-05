From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 15:02:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710051502060.32758@p34.internal.lan>
References: <20071003105321.06943824@zeus.pccl.info>
 <Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
 <20071003211910.439ded54@alpha.digital-domain.net>
 <72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
 <20071004150831.6edbf926@zeus.pccl.info> <Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
 <Pine.LNX.4.64.0710041009530.8275@p34.internal.lan> <20071004154441.31addcfe@zeus.pccl.info>
 <Pine.LNX.4.64.0710041219240.25506@p34.internal.lan>
 <20071004192653.25eb333b@alpha.digital-domain.net>
 <Pine.LNX.4.64.0710050621350.8433@p34.internal.lan> <20071005115719.4a71ab89@zeus.pccl.info>
 <Pine.LNX.4.64.0710050707490.8433@p34.internal.lan> <20071005135312.04856211@zeus.pccl.info>
 <20071005143023.2bce96e9@zeus.pccl.info> <Pine.LNX.4.64.0710051006370.21185@p34.internal.lan>
 <20071005171008.3e8a664d@zeus.pccl.info> <4706896F.2060503@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4706896F.2060503@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 6 Oct 2007, Richard Scobie wrote:

> Have you had a look at the smartctl -a outputs of all the drives?
>
> Possibly one drive is being slow to respond due to seek errors etc. but I 
> would perhaps expect to be seeing this in the log.
>
> If you have a full backup and a spare drive, I would probably rotate it 
> through the array.
>
> Regards,
>
> Richard
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Forgot about that, yeah post the smartctl -a output for each drive please.

