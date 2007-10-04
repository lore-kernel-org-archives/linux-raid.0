From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: RAID 5 performance issue.
Date: Thu, 4 Oct 2007 15:08:31 +0100
Message-ID: <20071004150831.6edbf926@zeus.pccl.info>
References: <20071003105321.06943824@zeus.pccl.info>
	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
	<20071003211910.439ded54@alpha.digital-domain.net>
	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 3 Oct 2007 13:36:39 -0700, David Rees wrote:

> Not bad, but not that good, either. Try running xfs_fsr into a nightly
> cronjob. By default, it will defrag mounted xfs filesystems for up to
> 2 hours. Typically this is enough to keep fragmentation well below 1%.

I ran it last night on the raid array, it got the fragmentation down
to 1.07%. Unfortunately that doesn't seemed to have helped.
 
> -Dave

Cheers,

Andrew
