From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Crooked raid
Date: Wed, 16 Nov 2005 07:41:11 -0800
Message-ID: <200511161541.jAGFfBjZ027253@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Look at:
>>   mdadm -E /dev/hdc
>> If it has a superblock, zero it with 'mdadm --zero-superblock /dev/hdc'
> > Same for hdg

>I did this, rebooted and the system wouldn't reboot. Yikes! I was 
>however able to boot with giving root=/dev/hdc2 to the kernel.

I didn't realize we were talking about your root filesystem else I would have
been more cautious (or maybe just kept my mouth shut). Glad you got it to boot!
Do you recall why it didn't want to boot? What are the kernel command line args?

Did you check for a bootup script somewhere screwing things up?
  egrep -i 'raid|mdadm' /etc/rc.d/* /etc/rc.d/init.d/* /etc/*

And did you already say that you don't have a mdadm.conf file?

You might need to pick which mirror (hdc2 or hdg2) you trust more as your root
filesystem (since they may be different now) and then start over and follow the
HowTo for making a normal root filesystem into a raided one.

But if you can't find out why the system is still looking at hdc then it might
all happen again...

>Here's the relevant part of dmesg:
>device-mapper: 4.1.1-ioctl (2004-04-07) initialised: dm-devel@redhat.com
>md: can not import ide/host0/bus1/target0/lun0/part2, has active inodes!

I guess this is because you booted from it as hdc2 so its busy and mdadm
won't try to use it?

Do you know why the system sometimes says ide/host0/bus1/target0/lun0/part2 and
sometimes says hd[cg]2 ? Its confusing...

>md0 : active raid1 ide/host2/bus1/target0/lun0/part2[0]
>       77508032 blocks [2/1] [U_]

>/dev/md0:
>    Raid Devices : 2
>   Total Devices : 2
>           State : active, degraded
>  Active Devices : 1
>Working Devices : 1
>  Failed Devices : 1
>        0      34        2        0      active sync   /dev/hdg2
>        1       0        0        1      faulty removed

>mdadm: No super block found on /dev/hdc (Expected magic a92b4efc, got 
>00000000)
>mdadm: No super block found on /dev/hdg (Expected magic a92b4efc, got 
>00000000)

Those two results are good

>/dev/hdc2:
..
>this     1      22        2        1      active sync   /dev/hdc2
>    0     0      34        2        0      active sync   /dev/hdg2
>    1     1      22        2        1      active sync   /dev/hdc2

>/dev/hdg2:
..
>this     0      34        2        0      active sync   /dev/hdg2
>    0     0      34        2        0      active sync   /dev/hdg2
>    1     1       0        0        1      faulty removed

I still don't see where hdc comes from. Sorry!

Any other raid superblocks around?
  for dev in /dev/hd? /dev/hd??; do mdadm -E $dev; done

And any raid autodetect partitions around?
  fdisk -l | grep raid


