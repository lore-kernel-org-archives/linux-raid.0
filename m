From: Andrew Clayton <andrew@pccl.info>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 17:10:08 +0100
Message-ID: <20071005171008.3e8a664d@zeus.pccl.info>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710051006370.21185@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andrew Clayton <andrew@digital-domain.net>, David Rees <drees76@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 5 Oct 2007 10:07:47 -0400 (EDT), Justin Piszcz wrote:

> Yikes, yeah I would get them off the PCI card, what kind of
> motherboard is it?  If you don't have a PCI-e based board it probably
> won't help THAT much but it still should be better than placing 3
> drives on a PCI card.

Moved the drives back onto the on board controller.

While I had the machine down I ran memtest86+ for about 5 mins, no
errors.

I also got the output of mkfs.xfs -f -N /dev/md0

meta-data=/dev/md0               isize=256    agcount=16, agsize=7631168 blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=122097920, imaxpct=25
         =                       sunit=64     swidth=128 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=524288 blocks=0, rtextents=0

> Justin.

Thanks for your help by the way.

Andrew
