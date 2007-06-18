From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: resync to last 27h - usually 3. what's this?
Date: Mon, 18 Jun 2007 12:57:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706181256541.31683@p34.internal.lan>
References: <200706181659.32119.Dexter.Filmore@gmx.de> <4676A31E.8090902@dgreaves.com>
 <200706181826.51387.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200706181826.51387.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 18 Jun 2007, Dexter Filmore wrote:

> On Monday 18 June 2007 17:22:06 David Greaves wrote:
>> Dexter Filmore wrote:
>>> 1661 minutes is *way* too long. it's a 4x250GiB sATA array and usually
>>> takes 3 hours to resync or check, for that matter.
>>>
>>> So, what's this?
>>
>> kernel, mdadm verisons?
>>
>> I seem to recall a long fixed ETA calculation bug some time back...
>>
>
> 2.6.21.1, mdadm 2.5.3.
> First time I sync since upgrade from 2.6.17.
>
> Definetly no calc bug, only 4% progress in one hour.
>
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

Hi.

What is your stripe size?

What if you set this higher? By default it will use 1MB/s or so if you do 
not FORCE it to use more than the idle I/O on the box.

echo "Setting minimum and maximum resync speed to 30MB/s..."
echo 30000 > /sys/block/md0/md/sync_speed_min
echo 30000 > /sys/block/md0/md/sync_speed_max
echo 30000 > /sys/block/md1/md/sync_speed_min
echo 30000 > /sys/block/md1/md/sync_speed_max
echo 30000 > /sys/block/md2/md/sync_speed_min
echo 30000 > /sys/block/md2/md/sync_speed_max
echo 30000 > /sys/block/md3/md/sync_speed_min
echo 30000 > /sys/block/md3/md/sync_speed_max


