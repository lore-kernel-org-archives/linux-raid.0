From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 16:54:13 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0602021651370.19057@lion.drogon.net>
References: <43E19FAB.4000603@cogweb.net> <pan.2006.02.02.16.17.03.859560@smurf.noris.de>
 <Pine.GSO.4.62.0602021726010.14030@shaka.acc.umu.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.62.0602021726010.14030@shaka.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2 Feb 2006, Mattias Wadenstein wrote:

> Yes, but then you (probably) lose hotswap. A feature here was to use the
> 3ware hw raid for the raid1 pairs and use the hw-raid hotswap instead of
> having to deal with linux hotswap (unless both drives in a raid1-set
> dies).

I'm not familiar with the 3ware controller, (other than knowing the name),
is it SCSI, SATA, or PATA? But ...

I've actually had very good results hot swapping  SCSI drives on a live
linux system though. I guess you do run the risk of something crowbarring
the SCSI bus for a few cycles when the drive is unplugged or plugged in,
but it's all parity/checksummed, isn't it?

Anyone tried SATA drives yet?

Gordon
