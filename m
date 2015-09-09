From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid1 resync stuck
Date: Wed, 09 Sep 2015 15:48:45 -0400
Message-ID: <wrfj8u8fxtk2.fsf@redhat.com>
References: <wrfjmvwvz9ke.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjmvwvz9ke.fsf@redhat.com> (Jes Sorensen's message of "Wed, 09
	Sep 2015 15:17:37 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: majianpeng@gmail.com, linux-raid <linux-raid@vger.kernel.org>, nate.dailey@stratus.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Neil,
>
> We're chasing a case where the raid1 code gets stuck during resync. Nate
> is able to reproduce it much more reliably than me - so attaching his
> reproducing script. Basically run it on an existing raid1 with internal
> bitmap on rotating disk.
>
> Nate was able to bisect it to 79ef3a8aa1cb1523cc231c9a90a278333c21f761,
> the original iobarrier rewrite patch, and it can be reproduced in
> current Linus' top of trunk a794b4f3292160bb3fd0f1f90ec8df454e3b17b3.
>
> In Nate's analysis it hangs in raise_barrier():
>
> static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
> {
> 	spin_lock_irq(&conf->resync_lock);
>
> 	/* Wait until no block IO is waiting */
> 	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
> 			    conf->resync_lock);
>
> 	/* block any new IO from starting */
> 	conf->barrier++;
> 	conf->next_resync = sector_nr;
>
> 	/* For these conditions we must wait:
> 	 * A: while the array is in frozen state
> 	 * B: while barrier >= RESYNC_DEPTH, meaning resync reach
> 	 *    the max count which allowed.
> 	 * C: next_resync + RESYNC_SECTORS > start_next_window, meaning
> 	 *    next resync will reach to the window which normal bios are
> 	 *    handling.
> 	 * D: while there are any active requests in the current window.
> 	 */
> 	wait_event_lock_irq(conf->wait_barrier,
> 			    !conf->array_frozen &&
> 			    conf->barrier < RESYNC_DEPTH &&
> 			    conf->current_window_requests == 0 &&
> 			    (conf->start_next_window >=
> 			     conf->next_resync + RESYNC_SECTORS),
> 			    conf->resync_lock);
>
> crash> r1conf 0xffff882028f3e600 | grep -e array_frozen -e barrier -e start_next_window -e next_resync
>   barrier = 0x1,                      (conf->barrier < RESYNC_DEPTH)
>   array_frozen = 0x0,                 (!conf->array_frozen)
>   next_resync = 0x3000,
>   start_next_window = 0x3000,
>
> ie. next_resync == start_next_window, which will never wake up since
> start_next_window is smaller than next_resync + RESYNC_SECTORS.
>
> Have you seen anything like this?
>
> Cheers,
> Jes

Grrr - doing too many things in parallel :( I knew I forgot something -
here is Nate's script.

Jes

--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=md_stuck_resync.sh

#!/bin/bash

wait_idle() {
    while [ "$(cat /sys/block/$sysmd/md/sync_action)" != "idle" ] ; do
	sleep 10s
    done
}

[ $# -ne 1 ] && echo "usage: $0 <md>" && exit 1
sysmd=$1
devmd="/dev/$(udevadm info -q name --path=/sys/block/$sysmd)"
[ ! -b "$devmd" ] && echo "failed to find md devnode" && exit 1

devsd=
for m in /sys/block/$sysmd/md/dev-*
{
    realpath=$(cd $m/block && pwd -P)
    devsd="/dev/$(udevadm info -q name --path=$realpath)"
    break
}
[ ! -b "$devsd" ] && echo "failed to find member disk devnode" && exit 1

iter() {
    echo
    echo "Remove $devsd"
    mdadm -f $devmd $devsd
    sleep 1s
    mdadm -r $devmd $devsd

    echo "Start 1GB IO"
    dd if=/dev/urandom of=$devmd bs=1M count=1024 &

    for j in 1 2 3 4 5
    {
	sleep 15s

	echo
	echo "$j: Add $devsd"
	mdadm -a $devmd $devsd
	sleep 1s

	echo
	echo "$j: Remove $devsd"
	mdadm -f $devmd $devsd
	echo "idle" > /sys/block/$sysmd/md/sync_action
	sleep 1s
	mdadm -r $devmd $devsd
    }

    echo
    echo "Add $devsd"
    mdadm -a $devmd $devsd

    echo
    echo "Wait for $sysmd recovery..."
    wait_idle
}

i=1
while [ 1 ] ; do
    echo "$(date) ********** Iteration $i **********"
    iter
    i=$(($i + 1))
done

--=-=-=--
