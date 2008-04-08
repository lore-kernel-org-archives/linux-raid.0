From: dean gaudet <dean@arctic.org>
Subject: Re: soft-lockup in raid5 / 2.6.24
Date: Mon, 7 Apr 2008 17:46:56 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0804071746310.7751@twinlark.arctic.org>
References: <alpine.DEB.1.10.0804070806300.7751@twinlark.arctic.org> <e9c3a7c20804071543l6d9df2dbkc86bec6388da3f77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20804071543l6d9df2dbkc86bec6388da3f77@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Apr 2008, Dan Williams wrote:

> On Mon, Apr 7, 2008 at 8:22 AM, dean gaudet <dean@arctic.org> wrote:
> > while my system was doing its monthly check (debian) i bumped into
> >  soft-lockups in the raid5 code.  i must mention this is a rather mature
> >  system, the disks are 3.5 years old at this point... so i'm not surprised
> >  that the check will find some bad sectors which will take the
> >  device/driver a while to read/correct.
> >
> >  all SMART events in this log are on disks which are part of /dev/md4 which
> >  is a raid5.  the controller is a 3ware 7508, the disks are seagate
> >  ST3400832A.
> >
> >  apparently no errors propagated all the way up to raid5, but based on the
> >  SMART events i'm pretty sure several sectors took a long time to finish
> >  being read and were probably corrected by the drive itself.
> >
> >  this is debian kernel image 2.6.24-1-686 version 2.6.24-4 which contains
> >  upstream 2.6.24.2.
> >
> >  -dean
> >
> >  root@neemlark:~# cat /sys/block/md4/md/mismatch_cnt
> >  0
> >
> 
> This does not look like the hang that is set to be fixed in 2.6.24.5.
> Does /proc/mdstat show that the resync is progressing, or does it
> appear to be stalled?

it finished...

neemlark:~% cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md4 : active raid5 sdc1[0] sdg1[5](S) sdh1[4] sde1[3] sdf1[2] sdd1[1]
      1562834944 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
      bitmap: 0/746 pages [0KB], 256KB chunk, file: /bitmap.md4

md_d1 : active raid1 sda2[0] sdb2[1]
      4156928 blocks [2/2] [UU]

md0 : active raid1 sdb1[0] sda1[1]
      250368 blocks [2/2] [UU]

md3 : active raid1 sdb4[0] sda4[1]
      73769856 blocks [2/2] [UU]
      bitmap: 0/141 pages [0KB], 256KB chunk

unused devices: <none>

-dean
