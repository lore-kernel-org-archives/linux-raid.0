From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID0 size over 2 TB
Date: Mon, 8 Sep 2014 09:21:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1409080920510.14735@uplift.swm.pp.se>
References: <20140906230928.BB645CEE@pobox.sk> <20140908170037.451e2376@notabene.brown> <20140908091811.1DD1140C@pobox.sk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140908091811.1DD1140C@pobox.sk>
Sender: linux-raid-owner@vger.kernel.org
To: azurIt <azurit@pobox.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 8 Sep 2014, azurIt wrote:

> I, of course, didn't use fdisk to create partitions - they were created using cgdisk, but it's graphical tool so i wasn't able to send output from it, so i get output from fdisk to prove, that partitions are large enough.
>
> # cat /proc/partitions
> major minor  #blocks  name
>
>   8       33 2147483647 sdc1
>   8       49 2147483647 sdd1

.... they're not.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
