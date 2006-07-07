From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Can't get md array to shut down cleanly
Date: Fri, 7 Jul 2006 11:25:08 +0200
Message-ID: <bb145bd20607070225q7d6f943cx134815d004ad0d78@mail.gmail.com>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
	 <17581.35566.273512.814844@cse.unsw.edu.au>
	 <bb145bd20607061807m7d3a2395hd75b5b338b86e259@mail.gmail.com>
	 <17582.4876.14646.245791@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17582.4876.14646.245791@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning!

> That patch was against latest -mm.... For earlier kernels you want to
> test 'ro'.

Ok. Was using stock 2.6.17.

> > Done unmounting local file systems.
> > *md: md0 stopped
> > *md: unbind <sdf>
> > *md: export_rdev<sdf>
> > *[last two lines for each disk.]
> > *Stopping RAID arrays ... done (1 array(s) stopped).
> > Mounting root filesystem read-only ... done
>
> That isn't good. You've stopped the array before the filesystem is
> readonly.  Switching to readonly could cause a write which won't work
> as the array doesn't exist any more...

I don't have root on the md, just a regular fs, which is unmounted
just before that first line above.

> That really should cause the array to be clean.  Once the md thread
> gets SIGKILL (it ignores SIGTERM) it will mark the array as 'clean'
> the moment there are no pending writes.

After digging a little deeper it seems that the md thread(s) might not
get their SIGKILL after all. The relevant portion from S20sendsigs is
as follows:

do_stop () {
        # Kill all processes.
        log_action_begin_msg "Sending all processes the TERM signal"
        killall5 -15
        log_action_end_msg 0
        sleep 5
        log_action_begin_msg "Sending all processes the KILL signal"
        killall5 -9
        log_action_end_msg 0
}

Apparently killall5 excludes kernel threads. I tried regular killall
but that kills the shutdown script as well :) What do other distros
use? I could file a bug but I highly doubt it would be seen as such.

S40umountfs unmounts non-root filesystems
S50mdadm-raid tries to stop arrays (and maybe succeeds, with patch)
via mdadm --stop.
S90halt halts the machine.

I'd really feel better if I didn't have to rely on userspace at all to
shut down my arrays, though. At least for people with root-on-RAID the
shutdown just before halt / reboot will have to work, anyway.

Any idea what could keep the mddev->active above 2?

Happy to help with bughuntiung -- I can't use the box properly anyway
until I can be sure this is solved.

Thanks,

C.
