From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why is my raid 1 boot/root not working with autodetect?
Date: Thu, 18 Jun 2009 10:21:41 +0200
Message-ID: <87zlc67y0a.fsf@frosties.localdomain>
References: <Pine.LNX.4.64.0906101828150.10333@deimos.nu>
	<Pine.LNX.4.64.0906111019350.9820@deimos.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0906111019350.9820@deimos.nu> (Fredrik
	Pettersson's message of "Thu, 11 Jun 2009 10:44:44 +0200 (CEST)")
Sender: linux-raid-owner@vger.kernel.org
To: Fredrik Pettersson <freppe@deimos.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Fredrik Pettersson <freppe@deimos.nu> writes:

> I have done some more testing in an attempt to gather more data, and
> here is what I have seen when testing different kernel options.
>
> When booting with my normal kernel options I get the following md
> output during the boot:
>
> (raid=noautodetect md=0,/dev/sdb1,/dev/sdc1 md=d0,/dev/sdb2,/dev/sdc2)
> -----
> md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
> md: Loading md0: /dev/sdb1
> md: bind<sdb1>
> md: bind<sdc1>
> raid1: raid set md0 active with 2 out of 2 mirrors
>  md0: unknown partition table
>  md0: unknown partition table
> md: Loading md_d0: /dev/sdb2
> md: bind<sdb2>
> md: bind<sdc2>
> raid1: raid set md_d0 active with 2 out of 2 mirrors
>  md_d0: p1 p2 p3 p4
>  md_d0: p1 p2 p3 p4
> -----

I seem to remember something about partitionable raid not being able
to autodetect.

MfG
        Goswin

PS: why not use lvm?
