From: Stephan Stachurski <ses1984@gmail.com>
Subject: Re: Can't re-assemble successfully after creation, initial sync and
	reboot
Date: Wed, 20 Jan 2010 08:24:22 -0500
Message-ID: <959332b61001200524j7a879f15u5281e03b1da2cd43@mail.gmail.com>
References: <959332b61001180933n638b9255k5aa540be024f2e6f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <959332b61001180933n638b9255k5aa540be024f2e6f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, I tried a couple of things, so far with no success.

I re-created the array, let it synchronize, then rebooted. When I
first created the array, the components devices looked like this:

md0 : active raid5 sda[0] sdb[1] sdc[2] sdd[3]

When I rebooted, it suddenly comes up like this, skipping component device 3:

md0 : active raid5 sda[0] sdd[4] sdb[1] sdc[2]

and it was automatically resyncing, destroying the last 6 hours I was
waiting for it to initially sync, and it changed my chunk size! Why do
I keep getting these problems?

On Mon, Jan 18, 2010 at 12:33 PM, Stephan Stachurski <ses1984@gmail.com> wrote:
> I'm having problems with an array that I just created. It's a raid
> level 5 with 4 devices using all of the default settings. I'm using
> the version of mdadm that's included in ubuntu 9.10 repositories.
>
> When I reboot the machine, /proc/mdstat shows this:
> md_d0 : inactive sdc[2](S)
>
> I can stop the device, and attempt the --assemble the array correctly,
> but something still is wrong:
>
> $ sudo mdadm --stop /dev/md_d0
> mdadm: stopped /dev/md_d0
> $ sudo mdadm --assemble /dev/md0 -fv /dev/sda /dev/sdb /dev/sdc /dev/sdd
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 3.
> mdadm: added /dev/sdb to /dev/md0 as 1
> mdadm: added /dev/sdc to /dev/md0 as 2
> mdadm: added /dev/sdd to /dev/md0 as 3
> mdadm: added /dev/sda to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 3 drives (out of 4).
> $ sudo cat /proc/mdstat
> md0: active raid5 sda[0] sdc[2] sdb[1]
> 2930287488 blocks level 5, 128k chunk, algorithm 2 [4/3] [UUU_]
>
> md_d0: inactive sdd[3](S)
> 976762496 blocks
>
> Why, if it correctly identifies the devices that are members of
> /dev/md0, and then adds them to /dev/md0, do I not get the complete
> array?
> --
> Stephan E Stachurski
>
