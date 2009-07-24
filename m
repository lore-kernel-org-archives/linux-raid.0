From: Drew <drew.kay@gmail.com>
Subject: Re: Question on RAID-5 growing
Date: Fri, 24 Jul 2009 06:03:08 -0700
Message-ID: <c268e4660907240603y12d25974kbbab1f7041741b37@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7CDEB@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7CDEB@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Is it legal to grow while RAID-5 recovery Is happening ?
>
>
> 1. mdadm -C /dev/md0 -z 1000000 -l 5 -n 3 /dev/sd[a-c]
> 2. mdadm -a /dev/md0 /dev/sdd
> 3. mdadm -G /dev/md- -n 4

Hi Marri,

One, If this is a live system I'm thinking it's safer to let the
recovery complete and then add the extra disk (after backing up the
data of course). Two, if this array isn't live yet (no data, lvm,
filesystem, etc yet) it'd probably be easier to halt the existing
RAID-5, and create the new array from scratch.

That said I'm sure Neil will chime in and correct me. :-)


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
