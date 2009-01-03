From: Bernd Schubert <bs@q-leap.de>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Sat, 3 Jan 2009 17:20:46 +0100
Message-ID: <20090103162046.GA29292@lanczos.q-leap.de>
References: <495E01E3.9060903@sm7jqb.se> <alpine.DEB.1.10.0901020741200.11852@p34.internal.lan> <20090102213007.GA4349@lanczos.q-leap.de> <20090103133936.0f6a3d2c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090103133936.0f6a3d2c@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, bengt@remove.sm7jqb.se, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 03, 2009 at 01:39:36PM +0000, Alan Cox wrote:
> On Fri, 2 Jan 2009 22:30:07 +0100
> Bernd Schubert <bs@q-leap.de> wrote:
> 
> > Hello Bengt,
> > 
> > sil3114 is known to cause data corruption with some disks. 
> 
> News to me. There are a few people with lots of SI and other devices

No no, you just forgot about it, since you even reviewed the patches ;)

http://lkml.org/lkml/2007/10/11/137

> jammed into the same mainboard who had problems but that doesn't appear
> to be an SI problem as far as I can tell.
> 
> There are some incompatibilities between certain silicon image chips and
> Nvidia chipsets needing BIOS workarounds according to the errata docs.

Well, I already posted the the links to the discussion we had in the past.
The corruption issue is easily reproducible on Tyan S2882 with AMD-8111,
SiI 3114 and ST3250820AS disks. This is on a compute cluster, and we run into 
the problem, when a few ST3200822AS failed and got replaced by newer 250GB 
disks. The 200GB ST3200822AS work perfectly fine, while the 250GB ST3250820AS 
disks cause data corrution. 

Presently the cluster is empty, so if you want do help me, your help to 
properly solve the issue would be highly appreciated (*).


Cheers,
Bernd

PS: The patches I posted work fine on these systems, but they are not upstream 
and I really would prefer to find a way in vanilla linux to prevent this
data corruption.

PPS: Its a bit funny with this cluster, since it is located at my university 
group and I did and do many calculations on it myself.  But presently I work 
for the company we bought it from and which is responsible to maintain it... ;)
