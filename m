From: "Peter Kovari" <peter@kovari.priv.hu>
Subject: RE: RAID5 -> RAID6 conversion, please help
Date: Wed, 11 May 2011 02:08:00 +0200
Message-ID: <002e01cc0f6f$7da2ceb0$78e86c10$@priv.hu>
References: <002a01cc0f68$1c851180$558f3480$@priv.hu> <20110511093155.5b1a203e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511093155.5b1a203e@notabene.brown>
Content-Language: hu
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Wednesday, May 11, 2011 1:32 AM
> To: Peter Kovari
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID5 -> RAID6 conversion, please help

> You have a RAID6 array in a non-standard config where there Q block (the
> second parity block) is always on the last device rather than rotated
around
> the various devices.

> The array is simply recovering that 6th drive to the spare.
> When it finished you will have a perfectly functional RAID6 array with
full
> redundancy.  It might perform slightly differently to a standard layout -
> I've never performed any measurements to see how differently.
> If you want to (after the recovery completes) you could convert to a
regular
> RAID6 with
>   mdadm -G /dev/md0 --layout=normalise
--backup=/some/file/on/a/different/device
> but you probably don't have to.

Thank you Neil, this explains everything. 

I suppose the layout difference mostly affects - if affects - write
performance. Since this is a media server, with mostly read operations, I
probably will leave it as it is.

> The old meta on sdd will not have been a problem.
> What version of mdadm did you use to try to start the reshape?

$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 10.04.2 LTS
Release:        10.04
Codename:       lucid

$ mdadm --version
mdadm - v3.1.4 - 31st August 2010

$ uname -a
Linux FileStation 2.6.34-020634-generic #020634 SMP Mon May 17 19:27:49 UTC
2010 x86_64 GNU/Linux

Cheers,
Peter



