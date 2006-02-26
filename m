From: Moses Leslie <moses@flyingcroc.net>
Subject: Re: silent corruption with RAID1
Date: Sun, 26 Feb 2006 00:57:04 -0800 (PST)
Message-ID: <20060226005533.K4550@fincher.users.accretive-networks.net>
References: <20060225182714.F4550@fincher.users.accretive-networks.net>
 <20060226082209.GH7030@skl-net.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060226082209.GH7030@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 26 Feb 2006, Andre Noll wrote:

> On 18:40, Moses Leslie wrote:
> > 0000:00:0a.0 Unknown mass storage controller: Silicon Image, Inc.
> > (formerly CMD Technology Inc) SiI 3112 [SATALink/SATARaid] Serial ATA
> > Controller (rev 02)
>
> Do you have Seagate drives? Some models have problems with this controller..

They are indeed 300GB Seagate drives.

Are there any workarounds?  It seems odd that raid1 would be the only
thing that has a problem.

The other two drives are western digitals, is there a blacklist somewhere
I could check?

Thanks for the reply,

Moses
