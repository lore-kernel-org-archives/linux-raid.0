From: jeffunit <jeff@jeffunit.com>
Subject: Re: a problem with mdadm 2.6.9
Date: Thu, 20 Aug 2009 19:52:02 -0700
Message-ID: <20090821025204000.WAVG29812@cdptpa-omta01.mail.rr.com>
References: <20090821020132421.QHAV6077@cdptpa-omta04.mail.rr.com>
 <d3efa87188ee29c0b3347459276f4faf.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d3efa87188ee29c0b3347459276f4faf.squirrel@neil.brown.name>
References: <20090821020132421.QHAV6077@cdptpa-omta04.mail.rr.com>
 <d3efa87188ee29c0b3347459276f4faf.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 07:23 PM 8/20/2009, NeilBrown wrote:
>On Fri, August 21, 2009 12:01 pm, jeffunit wrote:
> > I had a computer that was running mdadm with no problems.
> > Then the motherboard failed, while the array was in the process of
> > rebuilding.
> > I replaced the motherboard with a new motherboard,
> > and I an trying to rebuild my raid array.
> >
> > I am running mandriva 2009.1 spring (the latest). The kernel is 2.6.29.6
> > I have a 7 drive raid 5 array.
> > I said
> > mdadm --assemble /dev/md0 /dev/sd[bcdefgh]
> >
> > I got the error
> > mdadm cannot open device: /dev/sdb device or resouce busy
> > mdadm device /dev/md0 has no superblock - assembly aborted
> >
> > I then tried to make a degraded array
> > mdadm --assemble /dev/sd[cdefgh] --force
> > That seemed to work, and the array was degraded.
> >
> > I decided to reboot to see if I could get /dev/sdb online.
> > I did, and it didn't help.
> >
> > What can I do to recover my array?
>
>
>You need to find out why sdb is busy.
>Maybe look in /sys/block/sdb/holders.
>Maybe some filesystem on it go automagically mounted by mistake
>or something.
>Maybe send:
>   cat /proc/mounts /proc/swaps /proc/mdstat /proc/partitions
>   find -H /sys/block/sdb -ls
>
>and we can see if there are any hints.
>Maybe send full kernel logs from the boot sequence as well.

The 7 drives are dedicated to raid. I checked /etc/fstab, and none of 
the raid drives are there.
I have included everything but the kernel logs.
Does any of this help with a path forward?

thanks,
jeff

/sys/block/sdb/holders has:
0 lrwxrwxrwx 1 root root 0 2009-08-20 19:49 md_d125 -> 
../../../../../../../../.
./../virtual/block/md_d125/

(I don't understand this, but I suspect it is the problem, and I 
don't know how to fix it)

# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / ext4 rw,relatime,barrier=1,data=ordered 0 0
/dev /dev tmpfs rw,mode=755 0 0
/proc /proc proc rw 0 0
/sys /sys sysfs rw 0 0
/proc/bus/usb /proc/bus/usb usbfs rw,devgid=43,devmode=664 0 0
none /dev/pts devpts rw,mode=620 0 0
none /dev/shm tmpfs rw 0 0
/dev/sda7 /home ext4 rw,relatime,barrier=1,data=ordered 0 0
/dev/sda1 /mnt/windows fuseblk 
rw,user_id=0,group_id=0,default_permissions,allow
_other,blksize=4096 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
none /sys/fs/fuse/connections fusectl rw 0 0
gvfs-fuse-daemon /home/jdeifik/.gvfs fuse.gvfs-fuse-daemon 
rw,nosuid,nodev,user_
id=500,group_id=500 0 0


# cat /proc/swaps
Filename                                Type            Size    Used 
   Priority
/dev/sda6                               partition       1028120 0       -1

# cat /proc/mdstat
Personalities :
md_d121 : inactive sdh[6](S)
       732574464 blocks

md_d122 : inactive sdd[2](S)
       732574464 blocks

md_d123 : inactive sde[3](S)
       732574464 blocks

md_d124 : inactive sdc[1](S)
       732574464 blocks

md_d125 : inactive sdb[0](S)
       732574464 blocks

md_d126 : inactive sdf[4](S)
       732574464 blocks

md_d127 : inactive sdg[5](S)
       732574464 blocks

unused devices: <none>


# cat /proc/partitions
major minor  #blocks  name

    8        0   19938240 sda
    8        1    8193118 sda1
    8        2          1 sda2
    8        5    6152863 sda5
    8        6    1028128 sda6
    8        7    4562428 sda7
    8       16  732574584 sdb
    8       32  732574584 sdc
    8       48  732574584 sdd
    8       64  732574584 sde
    8       80  732574584 sdf
    8       96  732574584 sdg
    8      112  732574584 sdh

# find -H /sys/block/sdb -ls
   7851    0 drwxr-xr-x   6 root     root            0 Aug 20 12:33 
/sys/block/sd
b
   7852    0 -rw-r--r--   1 root     root         4096 Aug 20 12:33 
/sys/block/sd
b/uevent
   7853    0 -r--r--r--   1 root     root         4096 Aug 20 12:33 
/sys/block/sd
b/dev
   7855    0 lrwxrwxrwx   1 root     root            0 Aug 20 12:33 
/sys/block/sd
b/subsystem -> ../../../../../../../../../../class/block
   7857    0 lrwxrwxrwx   1 root     root            0 Aug 20 19:33 
/sys/block/sd
b/device -> ../../../2:0:0:0
   7858    0 -r--r--r--   1 root     root         4096 Aug 20 19:33 
/sys/block/sd
b/range
   7859    0 -r--r--r--   1 root     root         4096 Aug 20 19:49 
/sys/block/sd
b/ext_range
   7860    0 -r--r--r--   1 root     root         4096 Aug 20 12:33 
/sys/block/sd
b/removable
   7861    0 -r--r--r--   1 root     root         4096 Aug 20 19:49 
/sys/block/sd
b/ro
   7862    0 -r--r--r--   1 root     root         4096 Aug 20 19:33 
/sys/block/sd
b/size
   7863    0 -r--r--r--   1 root     root         4096 Aug 20 19:49 
/sys/block/sd
b/capability
   7864    0 -r--r--r--   1 root     root         4096 Aug 20 19:49 
/sys/block/sd
b/stat
   7865    0 drwxr-xr-x   2 root     root            0 Aug 20 19:49 
/sys/block/sd
b/power
   7866    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/power/wakeup
   7868    0 drwxr-xr-x   2 root     root            0 Aug 20 19:49 
/sys/block/sd
b/holders
  10874    0 lrwxrwxrwx   1 root     root            0 Aug 20 19:49 
/sys/block/sd
b/holders/md_d125 -> ../../../../../../../../../../virtual/block/md_d125
   7869    0 drwxr-xr-x   2 root     root            0 Aug 20 19:49 
/sys/block/sd
b/slaves
   7870    0 drwxr-xr-x   3 root     root            0 Aug 20 19:49 
/sys/block/sd
b/queue
   7871    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/nr_requests
   7872    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/read_ahead_kb
   7873    0 -r--r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/max_hw_sectors_kb
   7874    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/max_sectors_kb
   7875    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/scheduler
   7876    0 -r--r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/hw_sector_size
   7877    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/rotational
   7878    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/nomerges
   7879    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/rq_affinity
   7880    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iostats
   7881    0 drwxr-xr-x   2 root     root            0 Aug 20 19:53 
/sys/block/sd
b/queue/iosched
   7882    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iosched/quantum
   7883    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iosched/fifo_expire_sync
   7884    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iosched/fifo_expire_async
   7885    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iosched/back_seek_max
   7886    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iosched/back_seek_penalty
   7887    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iosched/slice_sync
   7888    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iosched/slice_async
   7889    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iosched/slice_async_rq
   7890    0 -rw-r--r--   1 root     root         4096 Aug 20 19:53 
/sys/block/sd
b/queue/iosched/slice_idle
   7921    0 lrwxrwxrwx   1 root     root            0 Aug 20 19:53 
/sys/block/sd
b/queue/bsg -> ../../../bsg/2:0:0:0
   7900    0 lrwxrwxrwx   1 root     root            0 Aug 20 19:49 
/sys/block/sd
b/bdi -> ../../../../../../../../../virtual/bdi/8:16


