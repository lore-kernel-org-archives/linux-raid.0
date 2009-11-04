From: CoolCold <coolthecold@gmail.com>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Wed, 4 Nov 2009 17:43:54 +0300
Message-ID: <f19d625d0911040643v5fc1747ei10bbb56fe3d40fb8@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	 <200911011241.40735.tfjellstrom@shaw.ca>
	 <da6356c80d046663baad24dd41b6e989.squirrel@neil.brown.name>
	 <200911011647.41259.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911011647.41259.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: NeilBrown <neilb@suse.de>, Andrew Dunn <andrew.g.dunn@gmail.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>, pernegger@gmail.com
List-Id: linux-raid.ids

I'm expiriencing MD lockups problems on Debian 2.6.26 kernel, while
2.6.28.8 looks not to have such problems.
This problem occurs when doing raid check, which is scheduled on 1st
Sunday of every month in Debian. Lock looks like - md resync speed
(really check speed) goes to 0 and all processes which access that
/dev/md are hunging like:

coolcold@tazeg:~$ cat /proc/mdstat
Personalities : [raid1]
md3 : active raid1 sdd3[0] sdc3[1]
290720192 blocks [2/2] [UU]
[>....................] resync =3D 0.9% (2906752/290720192)
finish=3D5796.8min speed=3D825K/sec


Nov 1 07:09:19 tazeg kernel: [2986195.439183] INFO: task xfssyncd:3099
blocked for more than 120 seconds.
Nov 1 07:09:19 tazeg kernel: [2986195.439218] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 1 07:09:19 tazeg kernel: [2986195.439264] xfssyncd D
0000000000000000 0 3099 2
Nov 1 07:09:19 tazeg kernel: [2986195.439301] ffff81042c451ba0
0000000000000046 0000000000000000 ffffffff802285b8
Nov 1 07:09:19 tazeg kernel: [2986195.439353] ffff81042dc5c990
ffff81042e5c3570 ffff81042dc5cc18 0000000500000001
Nov 1 07:09:19 tazeg kernel: [2986195.439403] 0000000000000282
0000000000000000 00000000ffffffff 0000000000000000
Nov 1 07:09:19 tazeg kernel: [2986195.439442] Call Trace:
Nov 1 07:09:19 tazeg kernel: [2986195.439497] [<ffffffff802285b8>]
__wake_up_common+0x41/0x74
Nov 1 07:09:19 tazeg kernel: [2986195.439532] [<ffffffffa0107371>]
:raid1:wait_barrier+0x87/0xc8
Nov 1 07:09:19 tazeg kernel: [2986195.439562] [<ffffffff8022c32f>]
default_wake_function+0x0/0xe
Nov 1 07:09:19 tazeg kernel: [2986195.439594] [<ffffffffa0108db4>]
:raid1:make_request+0x73/0x5af
Nov 1 07:09:19 tazeg kernel: [2986195.439625] [<ffffffff80229850>]
update_curr+0x44/0x6f
Nov 1 07:09:19 tazeg kernel: [2986195.439656] [<ffffffff8031eeab>]
__up_read+0x13/0x8a
Nov 1 07:09:19 tazeg kernel: [2986195.439686] [<ffffffff8030d7c4>]
generic_make_request+0x2fe/0x339
Nov 1 07:09:19 tazeg kernel: [2986195.439720] [<ffffffff80273970>]
mempool_alloc+0x24/0xda
Nov 1 07:09:19 tazeg kernel: [2986195.439748] [<ffffffff8031b105>]
__next_cpu+0x19/0x26
Nov 1 07:09:19 tazeg kernel: [2986195.439777] [<ffffffff80228e5a>]
find_busiest_group+0x254/0x6f5
Nov 1 07:09:19 tazeg kernel: [2986195.439810] [<ffffffff8030eb83>]
submit_bio+0xd9/0xe0
Nov 1 07:09:19 tazeg kernel: [2986195.439863] [<ffffffffa02878a7>]
:xfs:_xfs_buf_ioapply+0x206/0x231
Nov 1 07:09:19 tazeg kernel: [2986195.439915] [<ffffffffa0287908>]
:xfs:xfs_buf_iorequest+0x36/0x61
Nov 1 07:09:19 tazeg kernel: [2986195.439963] [<ffffffffa0270be1>]
:xfs:xlog_bdstrat_cb+0x16/0x3c
Nov 1 07:09:19 tazeg kernel: [2986195.440017] [<ffffffffa0271ae5>]
:xfs:xlog_sync+0x20a/0x3a1
Nov 1 07:09:19 tazeg kernel: [2986195.440068] [<ffffffffa027277a>]
:xfs:xlog_state_sync_all+0xb6/0x1c5
Nov 1 07:09:19 tazeg kernel: [2986195.440102] [<ffffffff8023d21a>]
lock_timer_base+0x26/0x4b
Nov 1 07:09:19 tazeg kernel: [2986195.440155] [<ffffffffa0272cce>]
:xfs:_xfs_log_force+0x58/0x67
Nov 1 07:09:19 tazeg kernel: [2986195.440187] [<ffffffff8042adf2>]
schedule_timeout+0x92/0xad
Nov 1 07:09:19 tazeg kernel: [2986195.440238] [<ffffffffa0272ce8>]
:xfs:xfs_log_force+0xb/0x2a
Nov 1 07:09:19 tazeg kernel: [2986195.440287] [<ffffffffa027e50b>]
:xfs:xfs_syncsub+0x33/0x226
Nov 1 07:09:19 tazeg kernel: [2986195.440337] [<ffffffffa028c7f7>]
:xfs:xfs_sync_worker+0x17/0x36
Nov 1 07:09:19 tazeg kernel: [2986195.440385] [<ffffffffa028d42d>]
:xfs:xfssyncd+0x133/0x187
Nov 1 07:09:19 tazeg kernel: [2986195.440433] [<ffffffffa028d2fa>]
:xfs:xfssyncd+0x0/0x187
Nov 1 07:09:19 tazeg kernel: [2986195.440466] [<ffffffff80246413>]
kthread+0x47/0x74
Nov 1 07:09:19 tazeg kernel: [2986195.440497] [<ffffffff8023030b>]
schedule_tail+0x27/0x5b
Nov 1 07:09:19 tazeg kernel: [2986195.440529] [<ffffffff8020cf28>]
child_rip+0xa/0x12
Nov 1 07:09:19 tazeg kernel: [2986195.440563] [<ffffffff802463cc>]
kthread+0x0/0x74
Nov 1 07:09:19 tazeg kernel: [2986195.440594] [<ffffffff8020cf1e>]
child_rip+0x0/0x12


The same was in 2.6.25.5, but additionally it has XFS issues ;)

On Mon, Nov 2, 2009 at 2:47 AM, Thomas Fjellstrom <tfjellstrom@shaw.ca>=
 wrote:
>
> On Sun November 1 2009, NeilBrown wrote:
> > On Mon, November 2, 2009 6:41 am, Thomas Fjellstrom wrote:
> > > On Sun November 1 2009, Andrew Dunn wrote:
> > >> Are we to expect some resolution in newer kernels?
> > >
> > > I assume all of the new per-bdi-writeback work going on in .33+ w=
ill
> > > have a
> > > large impact. At least I'm hoping.
> > >
> > >> I am going to rebuild my array (backup data and re-create) to mo=
dify
> > >> the chunk size this week. I hope to get a much higher performanc=
e when
> > >> increasing from 64k chunk size to 1024k.
> > >>
> > >> Is there a way to modify chunk size in place or does the array n=
eed to
> > >> be re-created?
> > >
> > > This I'm not sure about. I'd like to be able to reshape to a new =
chunk
> > > size
> > > for testing.
> >
> > Reshaping to a new chunksize is possible with the latest mdadm and
> > =A0kernel, but I would recommend waiting for mdadm-3.1.1 and 2.6.32=
=2E
> > With the current code, a device failure during reshape followed by =
an
> > unclean shutdown while reshape is happening can lead to unrecoverab=
le
> > data loss. =A0Even a clean shutdown before the shape finishes in th=
at case
> > might be a problem.
>
> That's good to know. Though I'm stuck with 2.6.26 till the performanc=
e
> regressions in the io and scheduling subsystems are solved.
>
> > NeilBrown
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>
>
> --
> Thomas Fjellstrom
> tfjellstrom@shaw.ca
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
