From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: MD array keeps resyncing after rebooting
Date: Thu, 1 Aug 2013 15:28:09 +0200
Message-ID: <CAC9WiBhno9_42DhtDZqffSwYNVJNuL5CJ5wv+_80y1GKPTKNNQ@mail.gmail.com>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>
	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>
	<51EED0DA.3020901@arcor.de>
	<51EED102.4020503@arcor.de>
	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>
	<51EEF3D3.7020305@arcor.de>
	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com>
	<CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>
	<51F1754B.5000905@arcor.de>
	<CAC9WiBhgF_-Ya7GW8DW0DcOQ-UhpN503hr=6_=46W5nbK04FTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBhgF_-Ya7GW8DW0DcOQ-UhpN503hr=6_=46W5nbK04FTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Wed, Jul 31, 2013 at 9:36 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello Martin,
>
> I finally managed to get more information.
>
> After the resync finished I have the following state:
>
> partial content of /sys/block/md126/md:
> --------------------------------------
> array_size           default
> array_state          active
> chunk_size           65536
> component_size       975585280
> degraded             0
> layout               0
> level                raid1
> max_read_errors      20
> metadata_version     external:/md127/0
> mismatch_cnt         0
> raid_disks           2
> reshape_position     none
> resync_start         none
> safe_mode_delay      0.000
> suspend_hi           0
> suspend_lo           0
> sync_action          idle
> sync_completed       none
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md126 : active raid1 sdb[1] sda[0]
>       975585280 blocks super external:/md127/0 [2/2] [UU]
>
> md127 : inactive sdb[1](S) sda[0](S)
>       2354608 blocks super external:ddf
>
> unused devices: <none>
>
> # mdadm -E /dev/sda | egrep "GUID|state"
> Controller GUID : 4C534920:20202020:FFFFFFFF:FFFFFFFF:FFFFFFFF:FFFFFFFF
>  Container GUID : 4C534920:20202020:80861D6B:10140432:3F14FDAD:5271FC67
>       VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2A56A7:00001450
>         state[0] : Optimal, Not Consistent
>    init state[0] : Fully Initialised
>
> Same for /dev/sdb
>
> As you noticed the state is "Not Consistent". In my understanding it
> becomes "Consistent" when  the array is stopped.
>
> I checked during the shudown process that the array is correctly
> stopped since at that point I got:
>
> # mdadm -E /dev/sda | egrep "state"
>         state[0] : Optimal, Consistent
>    init state[0] : Fully Initialised
>
> After rebooting, it appears that the BIOS changed a part of VD
> GUID[0]. I'm not sure if that can confuse the kernel and if it's the
> reason why the kernel shows:

To be more accurate, I stopped during the initramfs execution before
udev is started, therefore I'm pretty sure that no mdadm commands have
been issued.

And at this point, the kernel message "md/raid1:md126: not clean --
starting background
reconstruction" has not been emitted and I can see this:

# mdadm -E /dev/sda | egrep "state"
        state[0] : Optimal, Consistent
   init state[0] : Not Initialised

So the "init state[0]" has been changed from "Initialised" to "Not Initialised".

How is this possible ?

Help much appreciated.
-- 
Francis
