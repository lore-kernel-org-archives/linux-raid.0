From: Andrew Clayton <andrew@pccl.info>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 15:32:29 +0100
Message-ID: <20071005153229.2c5406b0@zeus.pccl.info>
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

It's a Tyan Thunder K8S Pro S2882. No PCIe. Though given the fact that
simply patching the kernel (on the RAID fs) when there's no other
disk activity slows to a crawl which I'm fairly sure it didn't used,
certainly these app stalls are new. The only trouble is I don't have
any iostat profile from say a year ago when everything was OK. So I
can't be 100% sure the current thing of spikes of iowait and await etc
didn't actually always happen and it's actually something else that's
wrong.
 
> Justin.

Andrew
