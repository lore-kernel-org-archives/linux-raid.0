From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid5 missing disks during chunk size grow
Date: Mon, 22 Sep 2014 14:59:19 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1409221458120.14735@uplift.swm.pp.se>
References: <374D34B3-E7F5-48AD-9A22-23C76AA0A60F@senebald.de> <alpine.DEB.2.02.1409221342090.14735@uplift.swm.pp.se> <719BBDB5-4E57-49D9-AFA2-0552141D7C41@senebald.de> <alpine.DEB.2.02.1409221400070.14735@uplift.swm.pp.se>
 <2146127B-50ED-46E6-AE63-BAC9DA35DBDC@senebald.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2146127B-50ED-46E6-AE63-BAC9DA35DBDC@senebald.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Senebald <martin@senebald.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 22 Sep 2014, Martin Senebald wrote:

> I just forgot :)
>
> 	Debian 3.2.60-1+deb7u3 x86_64

You still didn't provide mdadm version.

I would suggest you look into getting a more recent kernel version and 
mdadm version, because I would guess you have a non-recent mdadm with your 
debian dist.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
