From: jeffunit <jeff@jeffunit.com>
Subject: Re: a problem with mdadm 2.6.9
Date: Thu, 20 Aug 2009 20:41:33 -0700
Message-ID: <20090821034131749.XDCC29812@cdptpa-omta01.mail.rr.com>
References: <20090821020132421.QHAV6077@cdptpa-omta04.mail.rr.com>
 <d3efa87188ee29c0b3347459276f4faf.squirrel@neil.brown.name>
 <20090821025204000.WAVG29812@cdptpa-omta01.mail.rr.com>
 <ff1870ee87cc6fab6c09c63d7fca56bd.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ff1870ee87cc6fab6c09c63d7fca56bd.squirrel@neil.brown.name>
References: <20090821020132421.QHAV6077@cdptpa-omta04.mail.rr.com>
 <d3efa87188ee29c0b3347459276f4faf.squirrel@neil.brown.name>
 <20090821025204000.WAVG29812@cdptpa-omta01.mail.rr.com>
 <ff1870ee87cc6fab6c09c63d7fca56bd.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 08:19 PM 8/20/2009, NeilBrown wrote:
>On Fri, August 21, 2009 12:52 pm, jeffunit wrote:
> > At 07:23 PM 8/20/2009, NeilBrown wrote:
> >>On Fri, August 21, 2009 12:01 pm, jeffunit wrote:
> >> > I had a computer that was running mdadm with no problems.
> >> > Then the motherboard failed, while the array was in the process of
> >> > rebuilding.
> >> > I replaced the motherboard with a new motherboard,
> >> > and I an trying to rebuild my raid array.
> >> >
> >> > I am running mandriva 2009.1 spring (the latest). The kernel is
> >> 2.6.29.6
> >> > I have a 7 drive raid 5 array.
> >> > I said
> >> > mdadm --assemble /dev/md0 /dev/sd[bcdefgh]
> >> >
> >> > I got the error
> >> > mdadm cannot open device: /dev/sdb device or resouce busy
> >> > mdadm device /dev/md0 has no superblock - assembly aborted
> >> >
> >> > I then tried to make a degraded array
> >> > mdadm --assemble /dev/sd[cdefgh] --force
> >> > That seemed to work, and the array was degraded.
> >> >
> >> > I decided to reboot to see if I could get /dev/sdb online.
> >> > I did, and it didn't help.
> >> >
> >> > What can I do to recover my array?
> >>
> >>
> >>You need to find out why sdb is busy.
> >>Maybe look in /sys/block/sdb/holders.
> >>Maybe some filesystem on it go automagically mounted by mistake
> >>or something.
> >>Maybe send:
> >>   cat /proc/mounts /proc/swaps /proc/mdstat /proc/partitions
> >>   find -H /sys/block/sdb -ls
> >>
> >>and we can see if there are any hints.
> >>Maybe send full kernel logs from the boot sequence as well.
> >
> > The 7 drives are dedicated to raid. I checked /etc/fstab, and none of
> > the raid drives are there.
> > I have included everything but the kernel logs.
> > Does any of this help with a path forward?
> >
> > thanks,
> > jeff
> >
> > /sys/block/sdb/holders has:
> > 0 lrwxrwxrwx 1 root root 0 2009-08-20 19:49 md_d125 ->
> > ../../../../../../../../.
> > ./../virtual/block/md_d125/
> >
> > (I don't understand this, but I suspect it is the problem, and I
> > don't know how to fix it)
>
>I suspect you are right !!
>
>
> > # cat /proc/mdstat
> > Personalities :
> > md_d121 : inactive sdh[6](S)
> >        732574464 blocks
> >
> > md_d122 : inactive sdd[2](S)
> >        732574464 blocks
> >
> > md_d123 : inactive sde[3](S)
> >        732574464 blocks
> >
> > md_d124 : inactive sdc[1](S)
> >        732574464 blocks
> >
> > md_d125 : inactive sdb[0](S)
> >        732574464 blocks
> >
> > md_d126 : inactive sdf[4](S)
> >        732574464 blocks
> >
> > md_d127 : inactive sdg[5](S)
> >        732574464 blocks
> >
>
>It looks like the boot scripts tried running "mdadm --incremental" on
>each device and it didn't do the right thing for some reason.
>This is easy enough to fix in the short term:
>
>   mdadm -Ss
>   mdadm -A /dev/md0 /dev/sd[bcdefg]
>
>You might find that it assembles degraded, and that you need to
>   mdadm /dev/md0 --add /dev/sdb
>or similar to get it to rebuild.
>
>Longer term, you want to make sure it does the right thing at boot
>time.  Maybe you just need to change something in /etc/mdadm.conf.
>I have no idea how mandriva organised md assembly at boot time so
>I cannot offer you concrete advice.

I did
#mdadm -Ss

mdadm: stopped /dev/md/d122
mdadm: stopped /dev/md/d123
mdadm: stopped /dev/md/d124
mdadm: stopped /dev/md/d125
mdadm: stopped /dev/md/d126
mdadm: stopped /dev/md/d127

I did
# mdadm -A /dev/md0 /dev/sd[bcdefgh]

mdadm: /dev/md0 assembled from 6 drives - not enough to start the 
array while no
t clean - consider --force.

Should I use --force ?

I know how to deal with the startup issue, once the array is working.

thanks again,
jeff

