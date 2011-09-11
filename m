From: NeilBrown <neilb@suse.de>
Subject: Re: Converting RAID1 to RAID5
Date: Sun, 11 Sep 2011 05:57:03 +0200
Message-ID: <20110911055703.73deb44d@notabene.brown>
References: <CAB1R3si_QAtOwfzmYkrUz=+xPO7zSMoZEpO5+oEdXvbUnR1zzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3si_QAtOwfzmYkrUz=+xPO7zSMoZEpO5+oEdXvbUnR1zzw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 10 Sep 2011 23:38:09 -0400 Alex <mysqlstudent@gmail.com> wrote:

> Hi,
> I have a a few two-disk RAID1 partitions that I'd like to convert to
> three-disk RAID5 partitions using fedora15 with ext4. I've read a few
> docs online, but none that are authoritative or current. Some even say
> to zero the superblock first, which doesn't sound safe at all.
> 
> The partitions were created using v1.0 with mdadm-3.2.2:
> 
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 1.0
>   Creation Time : Sat Jan  1 13:07:37 2011
>      Raid Level : raid1
>      Array Size : 511988 (500.07 MiB 524.28 MB)
>   Used Dev Size : 511988 (500.07 MiB 524.28 MB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Sep 10 23:11:23 2011
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>            Name : localhost.localdomain:0
>            UUID : a7af0eec:2bf1bb46:a6afa7a4:6e61d731
>          Events : 181
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       17        1      active sync   /dev/sdb1
> 
> I've read the man page, and it seems to indicate to use the --grow
> option, but it's still a little unclear. I've read that the arrays
> should be stopped first, but the man page seems to indicate it should
> be performed on a running array.
> 
> Is the general process to first convert the RAID1 to a two-disk RAID5,
> then --add the third disk?

I strongly suggest that you create a couple of loop-back devices and
experiment.
ie.

 for i in 0 1 2
 do
    dd if=/dev/zero of=/tmp/file$i bs=1M count=100
    losetup /dev/loop$i /tmp/file$i
 done

 mdadm -C /dev/md0 -l1 -n2 -e 1.0 /dev/loop0 /dev/loop1
 mkfs /dev/md0
 mount /dev/md0 /mnt
 cp -r /lib /mnt

 then try some things. e.g.

 mdadm /dev/md0 --add /dev/loop2
 mdadm --grow /dev/md0 --level=5 --raid-devices=3

 Try failing a device during the reshape.  Check if the data is still OK.
 Try it as two separate steps and see if it makes a difference.


Experimenting will give you a lot more confidence than any mount of
authoritative statements about what it should do.

There was once a tool called raidreconf which would reshape an array while it
is offline.  That isn't supported anymore.
mdadm and the kernel md driver does reshaping while the array is online.  You
don't need to stop it first.

NeilBrown
