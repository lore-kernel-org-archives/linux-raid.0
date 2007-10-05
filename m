From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 20:33:31 +0100
Message-ID: <20071005203331.68580b8e@alpha.digital-domain.net>
References: <20071003105321.06943824@zeus.pccl.info>
	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
	<20071003211910.439ded54@alpha.digital-domain.net>
	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
	<20071004150831.6edbf926@zeus.pccl.info>
	<Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
	<Pine.LNX.4.64.0710041009530.8275@p34.internal.lan>
	<20071004154441.31addcfe@zeus.pccl.info>
	<Pine.LNX.4.64.0710041219240.25506@p34.internal.lan>
	<20071004192653.25eb333b@alpha.digital-domain.net>
	<Pine.LNX.4.64.0710050621350.8433@p34.internal.lan>
	<20071005115719.4a71ab89@zeus.pccl.info>
	<Pine.LNX.4.64.0710050707490.8433@p34.internal.lan>
	<20071005135312.04856211@zeus.pccl.info>
	<20071005143023.2bce96e9@zeus.pccl.info>
	<Pine.LNX.4.64.0710051006370.21185@p34.internal.lan>
	<20071005171008.3e8a664d@zeus.pccl.info>
	<Pine.LNX.4.64.0710051215220.26741@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710051215220.26741@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andrew Clayton <andrew@pccl.info>, David Rees <drees76@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 5 Oct 2007 12:16:07 -0400 (EDT), Justin Piszcz wrote:

> 
> Hm, unfortunately at this point I think I am out of ideas you may
> need to ask the XFS/linux-raid developers how to run blktrace during
> those operations to figure out what is going on.

No problem, cheers.
 
> BTW: Last thing I can think of, did you make any changes to
> PREEMPTION in the kernel, or do you disable it (SERVER)?

I normally have it disabled, but did try with voluntary preemption, but
with no effect.

> Justin.


Andrew
