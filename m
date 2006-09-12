From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: access array from knoppix
Date: Tue, 12 Sep 2006 09:29:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0609120928560.19418@p34.internal.lan>
References: <200609121352.08834.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609121352.08834.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

fdisk -l

then you have to assemble the array

mdadm --assemble /dev/md0 /dev/hda1 /dev/hdb1 # i think, man mdadm

On Tue, 12 Sep 2006, Dexter Filmore wrote:

> When running Knoppix on my file server, I can't mount /dev/md0 simply because
> it isn't there.
> Am I guessing right that I need to recreate the array?
> How do I gather the necessary parameters?
>
> -- 
> -----BEGIN GEEK CODE BLOCK-----
> Version: 3.12
> GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
> w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@
> b++(+++) DI+++ D- G++ e* h>++ r* y?
> ------END GEEK CODE BLOCK------
>
> http://www.stop1984.com
> http://www.againsttcpa.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
