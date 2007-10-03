From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: RAID 5 performance issue.
Date: Wed, 3 Oct 2007 21:48:23 +0100
Message-ID: <20071003214823.3541841f@alpha.digital-domain.net>
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

> > # xfs_db -c frag -f /dev/md0
> > actual 1828276, ideal 1708782, fragmentation factor 6.54%
> >
> > Good or bad?
> 
> Not bad, but not that good, either. Try running xfs_fsr into a nightly
> cronjob. By default, it will defrag mounted xfs filesystems for up to
> 2 hours. Typically this is enough to keep fragmentation well below 1%.

Worth a shot.

> -Dave

Andrew
