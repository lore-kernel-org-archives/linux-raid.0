From: Weedy <weedy2887@gmail.com>
Subject: Re: Recent drive errors
Date: Fri, 22 May 2015 03:07:17 -0400
Message-ID: <CAFE24U2WvC+tn9gYLKbgBHLg2QqOedvOmPD8PgHaCGp_+PYAxg@mail.gmail.com>
References: <3296560.sGbn0HyrQY@balsa> <555B2DEF.60905@turmel.org>
 <84264713.v03zHsT0Cj@balsa> <alpine.DEB.2.02.1505210956210.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1505210956210.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Thomas Fjellstrom <thomas@fjellstrom.ca>, Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 21, 2015 at 3:58 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Tue, 19 May 2015, Thomas Fjellstrom wrote:
>
>> How many UREs are considered "ok"? Tens, hundreds, thousands, tens of
>> thousands?
>
>
> I will replace any drive that have developed UNC sectors a few times, so I'd
> say "less than 10".
>
> +1 on the "set kernel timeout to more than 120 seconds". I have this in
> /etc/rc.local:
>
> for x in /sys/block/sd[a-z] ; do
>         echo 180  > $x/device/timeout
> done
>
> echo 4096 > /sys/block/md0/md/stripe_cache_size

#!/bin/sh

if [ -e /proc/sys/dev/raid/speed_limit_min ]; then
    echo $((1024*4)) > /proc/sys/dev/raid/speed_limit_min 2> /dev/null
    echo $((1024*24)) > /proc/sys/dev/raid/speed_limit_max 2> /dev/null
fi
if [ -e /dev/md0 -o -d /dev/md ]; then
    for md in /dev/md*; do
        echo $((1024*4)) > /sys/block/${md#/dev/}/md/stripe_cache_size
        blockdev --setra $((1024*4)) /dev/${md#/dev/}
    done
    for disk in /sys/block/sd*; do
        echo 45 > $disk/device/timeout
        smartctl -l scterc,70,70 /dev/${disk#/sys/block/}
    done
fi
for disk in /sys/block/sd*; do
    echo  cfq     > $disk/queue/scheduler
    echo  768    > $disk/queue/read_ahead_kb
    echo  256    > $disk/queue/nr_requests
    echo    8    2>/dev/null    > $disk/device/queue_depth
done
