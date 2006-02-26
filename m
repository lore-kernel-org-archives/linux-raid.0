From: Andre Noll <maan@systemlinux.org>
Subject: Re: silent corruption with RAID1
Date: Sun, 26 Feb 2006 10:05:52 +0100
Message-ID: <20060226090552.GI7030@skl-net.de>
References: <20060225182714.F4550@fincher.users.accretive-networks.net> <20060226082209.GH7030@skl-net.de> <20060226005533.K4550@fincher.users.accretive-networks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060226005533.K4550@fincher.users.accretive-networks.net>
Sender: linux-raid-owner@vger.kernel.org
To: Moses Leslie <moses@flyingcroc.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 00:57, Moses Leslie wrote:
> On Sun, 26 Feb 2006, Andre Noll wrote:
> 
> > On 18:40, Moses Leslie wrote:
> > > 0000:00:0a.0 Unknown mass storage controller: Silicon Image, Inc.
> > > (formerly CMD Technology Inc) SiI 3112 [SATALink/SATARaid] Serial ATA
> > > Controller (rev 02)
> >
> > Do you have Seagate drives? Some models have problems with this controller..
> 
> They are indeed 300GB Seagate drives.
> 
> Are there any workarounds?  It seems odd that raid1 would be the only
> thing that has a problem.

You could add your drive to the blacklist just to see if that makes any
difference.

> The other two drives are western digitals, is there a blacklist somewhere
> I could check?

Just look at the top of drivers/scsi/sata_sil.c

Regards
Andre
-- 
The only person who always got his work done by Friday was Robinson Crusoe
