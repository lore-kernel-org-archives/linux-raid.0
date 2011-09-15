From: Alex <mysqlstudent@gmail.com>
Subject: Re: Converting RAID1 to RAID5
Date: Thu, 15 Sep 2011 19:50:08 -0400
Message-ID: <CAB1R3siia=7u0fa=9Z02kXANW6z=KzRD2Fqfz9+e6=1Q5F9HPw@mail.gmail.com>
References: <CAB1R3si_QAtOwfzmYkrUz=+xPO7zSMoZEpO5+oEdXvbUnR1zzw@mail.gmail.com>
	<20110911055703.73deb44d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110911055703.73deb44d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Last week you were helping me with trying to convert a RAID1 volume to
RAID5. I've put together a server to test, and have made some
progress, but have a few questions.

> =A0then try some things. e.g.
>
> =A0mdadm /dev/md0 --add /dev/loop2
> =A0mdadm --grow /dev/md0 --level=3D5 --raid-devices=3D3
>
> =A0Try failing a device during the reshape. =A0Check if the data is s=
till OK.
> =A0Try it as two separate steps and see if it makes a difference.

I partitioned a third disk in the same way as the other two, and
successfully added them to their existing respective volumes as
spares.

I was able to grow md0, which is mounted on /boot, and it resynced it
and successfully converted it to RAID5.

When I try to grow the other two partitions (/ and /home), it fails
with device busy:

# mdadm --grow /dev/md2 --level=3D5 --raid-devices=3D3
mdadm: level of /dev/md2 changed to raid5
mdadm: Need to backup 128K of critical section..
mdadm: Cannot set device shape for /dev/md2: Device or resource busy
       Bitmap must be removed before shape can be changed
mdadm: aborting level change

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md2 : active raid1 sdc3[2](S) sda3[0] sdb3[1]
      186366908 blocks super 1.1 [2/2] [UU]
      bitmap: 1/2 pages [4KB], 65536KB chunk

md1 : active raid1 sdc2[2](S) sda2[0] sdb2[1]
      51198908 blocks super 1.1 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md0 : active raid5 sdc1[2] sda1[0] sdb1[1]
      1023976 blocks super 1.0 level 5, 4k chunk, algorithm 2 [3/3] [UU=
U]

unused devices: <none>

/dev/md2 (/home) isn't mounted.

When the conversion to RAID5 is complete, how can I regenerate the
mdadm.conf to properly reflect the change?

Thanks,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
