From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: Re: kernel panic under 2.6.2-rc1-mm2
Date: Sat, 24 Jan 2004 13:44:53 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.58.0401241336430.5108@denali.ccs.neu.edu>
References: <Pine.GSO.4.58.0401232041530.20252@denali.ccs.neu.edu>
 <20040123195811.6f974aba.akpm@osdl.org> <Pine.GSO.4.58.0401241044390.22456@denali.ccs.neu.edu>
 <20040124103303.28d0da2f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040124103303.28d0da2f.akpm@osdl.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sat, 24 Jan 2004, Andrew Morton wrote:

> Jim Faulkner <jfaulkne@ccs.neu.edu> wrote:
> >
> >
> > On Fri, 23 Jan 2004, Andrew Morton wrote:
> >
> > > And is 2.6.2-rc1 OK?
> >
> > Yes, 2.6.2-rc1 works fine.
>
> eek, don't trim emails that much: it sends me into cognitive panic trying
> to remember which of the past week's 7,000 email dicussions this pertains
> to.

Actually you were the one to trim the e-mail in your response. :)  I'll
make sure its clear what I'm talking about next time that happens.

Included below is my entire original e-mail.

> Ah-heh.  The md-* patches which were recently added to -mm might be bad,
> yes?

Looks like it to me.

thanks,
Jim Faulkner

original e-mail below
---------------------

2.6.2-rc1-mm2 kernel panics on my machine.  I believe that it is related
to software RAID based on the kernel output.

Unfortunately I do not have the complete output since it locked up at boot
time.  The kernel panic output ran off the screen.  Below is what was on
my screen from top to bottom (minus alot of numbers), and below that is my
current /proc/mdstat and /etc/raidtab.

thanks,
Jim Faulkner

my transcription of the kernel panic
-------------------------------------
printk
autorun_devices
printk
autostart_arrays
do_open
capable
md_ioctl
md_ioctl
blkdev_open
dentry_open
filp_open
md_ioctl
blkdev_ioctl
sys_ioctl
md_run_setup
prepare_namespace
init
init
kernel_thread_helper

Code: (a bunch of numbers)

Kernel Panic: Attempted to kill init!

my /proc/mdstat
---------------

Personalities : [linear] [raid0]
md2 : active raid0 md0[1] hdc1[0]
      123539392 blocks 4k chunks

md1 : active raid0 hde1[1] hda1[0]
      234436352 blocks 8k chunks

md0 : active linear hdh1[1] hdg1[0]
      63512704 blocks 128k rounding

unused devices: <none>


my /etc/raidtab
---------------

raiddev /dev/md0
        raid-level linear
        nr-raid-disks 2
        chunk-size 128
        persistent-superblock 1
        device /dev/hdg1
        raid-disk 0
        device /dev/hdh1
        raid-disk 1

raiddev /dev/md1
        raid-level 0
        nr-raid-disks 2
        chunk-size 8
        persistent-superblock 1
        device /dev/hda1
        raid-disk 0
        device /dev/hde1
        raid-disk 1

raiddev /dev/md2
        raid-level 0
        nr-raid-disks 2
        chunk-size 4
        persistent-superblock 1
        device /dev/hdc1
        raid-disk 0
        device /dev/md0
        raid-disk 1

