From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Sat, 3 Jan 2009 13:39:36 +0000
Message-ID: <20090103133936.0f6a3d2c@lxorguk.ukuu.org.uk>
References: <495E01E3.9060903@sm7jqb.se>
	<alpine.DEB.1.10.0901020741200.11852@p34.internal.lan>
	<20090102213007.GA4349@lanczos.q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090102213007.GA4349@lanczos.q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, bengt@remove.sm7jqb.se, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2 Jan 2009 22:30:07 +0100
Bernd Schubert <bs@q-leap.de> wrote:

> Hello Bengt,
> 
> sil3114 is known to cause data corruption with some disks. 

News to me. There are a few people with lots of SI and other devices
jammed into the same mainboard who had problems but that doesn't appear
to be an SI problem as far as I can tell.

There are some incompatibilities between certain silicon image chips and
Nvidia chipsets needing BIOS workarounds according to the errata docs.

Alan
