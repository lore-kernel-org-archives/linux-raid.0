From: Emery Guevremont <emery.guevremont@gmail.com>
Subject: Re: On RAID5 read error during syncing - array .A.A
Date: Tue, 9 Dec 2014 07:00:01 -0500
Message-ID: <CAB_L8sZ9AUe2gM1mfcOfvwDZ0g2p4DzoNtDQbveTRY=G5OnN5g@mail.gmail.com>
References: <20141206185600.GA2343@cthulhu.home.robinhill.me.uk>
	<CAB_L8sYkWFO0hC-rUHednzy=BWZoBaVS_DhoBedg-viPnTdU-g@mail.gmail.com>
	<20141208094841.GA8530@cthulhu.home.robinhill.me.uk>
	<CAB_L8sYfFNaeUNiCFhidGVuRtMOP1XjJ4e=edsXp1bqe-FYBww@mail.gmail.com>
	<20141208151419.GB8530@cthulhu.home.robinhill.me.uk>
	<CAB_L8sZNxNDO_f0X_uXwLuM8kcRgT=p+f8+-wtYDhEQPy_dX5Q@mail.gmail.com>
	<20141208165535.GC8530@cthulhu.home.robinhill.me.uk>
	<CAB_L8sYdbgzZ=fAzoTELnutOG0ge+TcYifJwKjD=W0n2uKVhNw@mail.gmail.com>
	<20141208181619.GA8104@cthulhu.home.robinhill.me.uk>
	<CAB_L8sY5eFjGOFBD+Kyrc-uoGUbNQdMz6rG1F4rnLY2TEwD8VQ@mail.gmail.com>
	<20141209090114.GA30324@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141209090114.GA30324@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Emery Guevremont <emery.guevremont@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You're right! I just changed it to sdd3 sdb3 sdc3 missing and fsck -n
/dev/md0 detected everything said it was clean.

Thanks a lot. I will backup my important files and write back a quick
summary of what we did to fix this situation.

On Tue, Dec 9, 2014 at 4:01 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> On Tue Dec 09, 2014 at 12:35:14AM -0500, Emery Guevremont wrote:
>> >> >> >> On Mon, Dec 8, 2014 at 4:48 AM, Robin Hill <robin@robinhill.me.uk> wrote:
>> >> >> >> > On Sat Dec 06, 2014 at 03:49:10PM -0500, Emery Guevremont wrote:
>> >> >> >> >> > On Sat Dec 06, 2014 at 01:35:50pm -0500, Emery Guevremont wrote:
>> >> >> >> >> >
>> >> >> >> >> >> The long story and what I've done.
>> >> >> >> >> >>
>> >> >> >> >> >> /dev/md0 is assembled with 4 drives
>> >> >> >> >> >> /dev/sda3
>> >> >> >> >> >> /dev/sdb3
>> >> >> >> >> >> /dev/sdc3
>> >> >> >> >> >> /dev/sdd3
>> >> >> >> >> >>
>> >> >> >> >> >> 2 weeks ago, mdadm marked /dev/sda3 as failed. cat /proc/mdstat showed
>> >> >> >> >> >> _UUU. smarctl also confirmed that the drive was dying. So I shutdown
>> >> >> >> >> >> the server and until I received a replacement drive.
>> >> >> >> >> >>
>> >> >> >> >> >> This week, I replaced the dying drive with my new drive. Booted into
>> >> >> >> >> >> single user mode and did this:
>> >> >> >> >> >>
>> >> >> >> >> >> mdadm --manage /dev/md0 --add /dev/sda3  a cat of /proc/mdstat
>> >> >> >> >> >> confirmed the resyncing process. The last time I checked it was up to
>> >> >> >> >> >> 11%. After a few minutes later, I noticed that the syncing stopped. A
>> >> >> >> >> >> read error message on /dev/sdd3 (have a pic of it if interested)
>> >> >> >> >> >> appear on the console. It appears that /dev/sdd3 might be going bad. A
>> >> >> >> >> >> cat /proc/mdstat showed _U_U. Now I panic, and decide to leave
>> >> >> >> >> >> everything as is and to go to bed.
>> >> >> >> >> >>
>> >> >> >> >> >> The next day, I shutdown the server and reboot with a live usb distro
>> >> >> >> >> >> (Ubuntu rescue remix). After booting into the live distro, a cat
>> >> >> >> >> >> /proc/mdstat showed that my /dev/md0 was detected but all drives had
>> >> >> >> >> >> an (S) next to it. i.e. /dev/sda3 (S)... Naturally I don't like the
>> >> >> >> >> >> looks of this.
>> >> >> >> >> >>
>> >> >> >> >> >> I ran ddrescue to copy /dev/sdd onto my new replacement disk
>> >> >> >> >> >> (/dev/sda). Everything, worked, ddrescue got only one read error, but
>> >> >> >> >> >> was eventually able to read the bad sector on a retry. I followed up
>> >> >> >> >> >> by also cloning with ddrescue, sdb and sdc.
>> >> >> >> >> >>
>> >> >> >> >> >> So now I have cloned copies of sdb, sdc and sdd to work with.
>> >> >> >> >> >> Currently running mdadm --assemble --scan, will activate my array, but
>> >> >> >> >> >> all drives are added as spares. Running mdadm --examine on each
>> >> >> >> >> >> drives, shows the same Array UUID number, but the Raid Devices is 0
>> >> >> >> >> >> and raid level is -unknown- for some reason. The rest seems fine and
>> >> >> >> >> >> makes sense. I believe I could re-assemble my array if I could define
>> >> >> >> >> >> the raid level and raid devices.
>> >> >> >> >> >>
>> >> >> >> >> >> I wanted to know if there are a way to restore my superblocks from the
>> >> >> >> >> >> examine command I ran at the beginning? If not, what mdadm create
>> >> >> >> >> >> command should I run? Also please let me know if drive ordering is
>> >> >> >> >> >> important, and how I can determine this with the examine output I'll
>> >> >> >> >> >> got?
>> >> >> >> >> >>
>> >> >> >> >> >> Thank you.
>> >> >> >> >> >>
>> >> >> >> >> You'll see from the examine output, raid level and devices aren't
>> >> >> >> >> defined and notice the role of each drives. The examine output (I
>> >> >> >> >> attached 4 files) that I took right after the read error during the
>> >> >> >> >> synching process seems to show a more accurate superblock. Here's also
>> >> >> >> >> the output of mdadm --detail /dev/md0 that I took when I got the first
>> >> >> >> >> error:
>> >> >> >> >>
>> >> >> >> >> ARRAY /dev/md/0 metadata=1.2 UUID=cf9db8fa:0c2bb553:46865912:704cceae
>> >> >> >> >> name=runts:0
>> >> >> >> >>    spares=1
>> >> >> >> >>
>> >> >> >> >>
>> >> >> >> >> Here's the output of how things currently are:
>> >> >> >> >>
>> >> >> >> >> mdadm --assemble --force /dev/md127 /dev/sdb3 /dev/sdc3 /dev/sdd3
>> >> >> >> >> mdadm: /dev/md127 assembled from 0 drives and 3 spares - not enough to
>> >> >> >> >> start the array.
>> >> >> >> >>
>> >> >> >> >> dmesg
>> >> >> >> >> [27903.423895] md: md127 stopped.
>> >> >> >> >> [27903.434327] md: bind<sdc3>
>> >> >> >> >> [27903.434767] md: bind<sdd3>
>> >> >> >> >> [27903.434963] md: bind<sdb3>
>> >> >> >> >>
>> >> >> >> >> cat /proc/mdstat
>> >> >> >> >> root@ubuntu:~# cat /proc/mdstat
>> >> >> >> >> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
>> >> >> >> >> [raid1] [raid10]
>> >> >> >> >> md127 : inactive sdb3[4](S) sdd3[0](S) sdc3[5](S)
>> >> >> >> >>       5858387208 blocks super 1.2
>> >> >> >> >>
>> >> >> >> >> mdadm --examine /dev/sd[bcd]3
>> >> >> >> >> /dev/sdb3:
>> >> >> >> >>           Magic : a92b4efc
>> >> >> >> >>         Version : 1.2
>> >> >> >> >>     Feature Map : 0x0
>> >> >> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >> >> >> >>            Name : runts:0
>> >> >> >> >>   Creation Time : Tue Jul 26 03:27:39 2011
>> >> >> >> >>      Raid Level : -unknown-
>> >> >> >> >>    Raid Devices : 0
>> >> >> >> >>
>> >> >> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>     Data Offset : 2048 sectors
>> >> >> >> >>    Super Offset : 8 sectors
>> >> >> >> >>           State : active
>> >> >> >> >>     Device UUID : b2bf0462:e0722254:0e233a72:aa5df4da
>> >> >> >> >>
>> >> >> >> >>     Update Time : Sat Dec  6 12:46:40 2014
>> >> >> >> >>        Checksum : 5e8cfc9a - correct
>> >> >> >> >>          Events : 1
>> >> >> >> >>
>> >> >> >> >>
>> >> >> >> >>    Device Role : spare
>> >> >> >> >>    Array State :  ('A' == active, '.' == missing)
>> >> >> >> >> /dev/sdc3:
>> >> >> >> >>           Magic : a92b4efc
>> >> >> >> >>         Version : 1.2
>> >> >> >> >>     Feature Map : 0x0
>> >> >> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >> >> >> >>            Name : runts:0
>> >> >> >> >>   Creation Time : Tue Jul 26 03:27:39 2011
>> >> >> >> >>      Raid Level : -unknown-
>> >> >> >> >>    Raid Devices : 0
>> >> >> >> >>
>> >> >> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>     Data Offset : 2048 sectors
>> >> >> >> >>    Super Offset : 8 sectors
>> >> >> >> >>           State : active
>> >> >> >> >>     Device UUID : 390bd4a2:07a28c01:528ed41e:a9d0fcf0
>> >> >> >> >>
>> >> >> >> >>     Update Time : Sat Dec  6 12:46:40 2014
>> >> >> >> >>        Checksum : f69518c - correct
>> >> >> >> >>          Events : 1
>> >> >> >> >>
>> >> >> >> >>
>> >> >> >> >>    Device Role : spare
>> >> >> >> >>    Array State :  ('A' == active, '.' == missing)
>> >> >> >> >> /dev/sdd3:
>> >> >> >> >>           Magic : a92b4efc
>> >> >> >> >>         Version : 1.2
>> >> >> >> >>     Feature Map : 0x0
>> >> >> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >> >> >> >>            Name : runts:0
>> >> >> >> >>   Creation Time : Tue Jul 26 03:27:39 2011
>> >> >> >> >>      Raid Level : -unknown-
>> >> >> >> >>    Raid Devices : 0
>> >> >> >> >>
>> >> >> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>     Data Offset : 2048 sectors
>> >> >> >> >>    Super Offset : 8 sectors
>> >> >> >> >>           State : active
>> >> >> >> >>     Device UUID : 92589cc2:9d5ed86c:1467efc2:2e6b7f09
>> >> >> >> >>
>> >> >> >> >>     Update Time : Sat Dec  6 12:46:40 2014
>> >> >> >> >>        Checksum : 571ad2bd - correct
>> >> >> >> >>          Events : 1
>> >> >> >> >>
>> >> >> >> >>
>> >> >> >> >>    Device Role : spare
>> >> >> >> >>    Array State :  ('A' == active, '.' == missing)
>> >> >> >> >>
>> >> >> >> >> and finally kernel and mdadm versions:
>> >> >> >> >>
>> >> >> >> >> uname -a
>> >> >> >> >> Linux ubuntu 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:41:14 UTC
>> >> >> >> >> 2012 i686 i686 i386 GNU/Linux
>> >> >> >> >>
>> >> >> >> >> mdadm -V
>> >> >> >> >> mdadm - v3.2.3 - 23rd December 2011
>> >> >> >> >
>> >> >> >> >> /dev/sda3:
>> >> >> >> >>           Magic : a92b4efc
>> >> >> >> >>         Version : 1.2
>> >> >> >> >>     Feature Map : 0x0
>> >> >> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >> >> >> >>            Name : runts:0  (local to host runts)
>> >> >> >> >>   Creation Time : Mon Jul 25 23:27:39 2011
>> >> >> >> >>      Raid Level : raid5
>> >> >> >> >>    Raid Devices : 4
>> >> >> >> >>
>> >> >> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
>> >> >> >> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>     Data Offset : 2048 sectors
>> >> >> >> >>    Super Offset : 8 sectors
>> >> >> >> >>           State : clean
>> >> >> >> >>     Device UUID : b2bf0462:e0722254:0e233a72:aa5df4da
>> >> >> >> >>
>> >> >> >> >>     Update Time : Tue Dec  2 23:15:37 2014
>> >> >> >> >>        Checksum : 5ed5b898 - correct
>> >> >> >> >>          Events : 3925676
>> >> >> >> >>
>> >> >> >> >>          Layout : left-symmetric
>> >> >> >> >>      Chunk Size : 512K
>> >> >> >> >>
>> >> >> >> >>    Device Role : spare
>> >> >> >> >>    Array State : A.A. ('A' == active, '.' == missing)
>> >> >> >> >
>> >> >> >> >> /dev/sdb3:
>> >> >> >> >>           Magic : a92b4efc
>> >> >> >> >>         Version : 1.2
>> >> >> >> >>     Feature Map : 0x0
>> >> >> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >> >> >> >>            Name : runts:0  (local to host runts)
>> >> >> >> >>   Creation Time : Mon Jul 25 23:27:39 2011
>> >> >> >> >>      Raid Level : raid5
>> >> >> >> >>    Raid Devices : 4
>> >> >> >> >>
>> >> >> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
>> >> >> >> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>     Data Offset : 2048 sectors
>> >> >> >> >>    Super Offset : 8 sectors
>> >> >> >> >>           State : clean
>> >> >> >> >>     Device UUID : 92589cc2:9d5ed86c:1467efc2:2e6b7f09
>> >> >> >> >>
>> >> >> >> >>     Update Time : Tue Dec  2 23:15:37 2014
>> >> >> >> >>        Checksum : 57638ebb - correct
>> >> >> >> >>          Events : 3925676
>> >> >> >> >>
>> >> >> >> >>          Layout : left-symmetric
>> >> >> >> >>      Chunk Size : 512K
>> >> >> >> >>
>> >> >> >> >>    Device Role : Active device 0
>> >> >> >> >>    Array State : A.A. ('A' == active, '.' == missing)
>> >> >> >> >
>> >> >> >> >> /dev/sdc3:
>> >> >> >> >>           Magic : a92b4efc
>> >> >> >> >>         Version : 1.2
>> >> >> >> >>     Feature Map : 0x0
>> >> >> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >> >> >> >>            Name : runts:0  (local to host runts)
>> >> >> >> >>   Creation Time : Mon Jul 25 23:27:39 2011
>> >> >> >> >>      Raid Level : raid5
>> >> >> >> >>    Raid Devices : 4
>> >> >> >> >>
>> >> >> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
>> >> >> >> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>     Data Offset : 2048 sectors
>> >> >> >> >>    Super Offset : 8 sectors
>> >> >> >> >>           State : clean
>> >> >> >> >>     Device UUID : 390bd4a2:07a28c01:528ed41e:a9d0fcf0
>> >> >> >> >>
>> >> >> >> >>     Update Time : Tue Dec  2 23:15:37 2014
>> >> >> >> >>        Checksum : fb20d8a - correct
>> >> >> >> >>          Events : 3925676
>> >> >> >> >>
>> >> >> >> >>          Layout : left-symmetric
>> >> >> >> >>      Chunk Size : 512K
>> >> >> >> >>
>> >> >> >> >>    Device Role : Active device 2
>> >> >> >> >>    Array State : A.A. ('A' == active, '.' == missing)
>> >> >> >> >
>> >> >> >> >> /dev/sdd3:
>> >> >> >> >>           Magic : a92b4efc
>> >> >> >> >>         Version : 1.2
>> >> >> >> >>     Feature Map : 0x0
>> >> >> >> >>      Array UUID : cf9db8fa:0c2bb553:46865912:704cceae
>> >> >> >> >>            Name : runts:0  (local to host runts)
>> >> >> >> >>   Creation Time : Mon Jul 25 23:27:39 2011
>> >> >> >> >>      Raid Level : raid5
>> >> >> >> >>    Raid Devices : 4
>> >> >> >> >>
>> >> >> >> >>  Avail Dev Size : 3905591472 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>      Array Size : 5858385408 (5586.99 GiB 5998.99 GB)
>> >> >> >> >>   Used Dev Size : 3905590272 (1862.33 GiB 1999.66 GB)
>> >> >> >> >>     Data Offset : 2048 sectors
>> >> >> >> >>    Super Offset : 8 sectors
>> >> >> >> >>           State : clean
>> >> >> >> >>     Device UUID : 4156ab46:bd42c10d:8565d5af:74856641
>> >> >> >> >>
>> >> >> >> >>     Update Time : Tue Dec  2 23:14:03 2014
>> >> >> >> >>        Checksum : a126853f - correct
>> >> >> >> >>          Events : 3925672
>> >> >> >> >>
>> >> >> >> >>          Layout : left-symmetric
>> >> >> >> >>      Chunk Size : 512K
>> >> >> >> >>
>> >> >> >> >>    Device Role : Active device 1
>> >> >> >> >>    Array State : AAAA ('A' == active, '.' == missing)
>> >> >> >> >
>> >> >> >> > At least you have the previous data anyway, which should allow
>> >> >> >> > reconstruction of the array. The device names have changed between your
>> >> >> >> > two reports though, so I'd advise double-checking which is which before
>> >> >> >> > proceeding.
>> >> >> >> >
>> >> >> >> > The reports indicate that the original array order (based on the device
>> >> >> >> > role field) for the four devices was (using device UUIDs as they're
>> >> >> >> > consistent):
>> >> >> >> >     92589cc2:9d5ed86c:1467efc2:2e6b7f09
>> >> >> >> >     4156ab46:bd42c10d:8565d5af:74856641
>> >> >> >> >     390bd4a2:07a28c01:528ed41e:a9d0fcf0
>> >> >> >> >     b2bf0462:e0722254:0e233a72:aa5df4da
>> >> >> >> >
>> >> >> >> > That would give a current device order of sdd3,sda3,sdc3,sdb3 (I don't
>> >> >> >> > have the current data for sda3, but that's the only missing UUID).
>> >> >> >> >
>> I had forgotten that I took a pic of the read error message, which
>> also contained an output of /proc/mdstat, so I was able to determine
>> the ordering and I ran this command:
>>
> What did that indicate, and how did you map it to the device order below?
>
>> root@ubuntu:~# mdadm -v --create --assume-clean --level=5 --chunk=512
>> --size=1952795136 --raid-devices=4 /dev/md0 /dev/sdd3 /dev/sdb3
>> missing /dev/sdc3
>> mdadm: layout defaults to left-symmetric
>> mdadm: layout defaults to left-symmetric
>> mdadm: /dev/sdd3 appears to be part of a raid array:
>>     level=raid5 devices=4 ctime=Tue Dec  9 05:17:53 2014
>> mdadm: layout defaults to left-symmetric
>> mdadm: /dev/sdb3 appears to be part of a raid array:
>>     level=raid5 devices=4 ctime=Tue Dec  9 05:17:53 2014
>> mdadm: layout defaults to left-symmetric
>> mdadm: /dev/sdc3 appears to be part of a raid array:
>>     level=raid5 devices=4 ctime=Tue Dec  9 05:17:53 2014
>> Continue creating array? y
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md0 started.
>>
>> I did mdadm -E and everything seemed to be consistent with the
>> original output of the examine command. So I ran fsck -n
>>
>> root@ubuntu:~# fsck -n /dev/md0
>> fsck from util-linux 2.20.1
>> e2fsck 1.42 (29-Nov-2011)
>> fsck.ext4: Group descriptors look bad... trying backup blocks...
>> Error writing block 1 (Attempt to write block to filesystem resulted
>> in short write).  Ignore error? no
>>
>> Error writing block 2 (Attempt to write block to filesystem resulted
>> in short write).  Ignore error? no
>>
>> Error writing block 3 (Attempt to write block to filesystem resulted
>> in short write).  Ignore error? no
>>
>> Error writing block 4 (Attempt to write block to filesystem resulted
>> in short write).  Ignore error? no
>>
>> Error writing block 5 (Attempt to write block to filesystem resulted
>> in short write).  Ignore error? no
>>
>> Error writing block 6 (Attempt to write block to filesystem resulted
>> in short write).  Ignore error? no
>> ...
>> ...
>> Error writing block 343 (Attempt to write block to filesystem resulted
>> in short write).  Ignore error? no
>>
>> Error writing block 344 (Attempt to write block to filesystem resulted
>> in short write).  Ignore error? no
>>
>> fsck.ext4: Device or resource busy while trying to open /dev/md0
>> Filesystem mounted or opened exclusively by another program?
>>
>>
>> I believe I made some progress. But before I continue, I wanted to
>> know if I was on the right track?
>>
>> I tried to mount /dev/md0 but got this:
>>
>> root@ubuntu:~# mount -t ext4 /dev/md0 /mnt/
>> mount: wrong fs type, bad option, bad superblock on /dev/md0,
>>        missing codepage or helper program, or other error
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail  or so
>>
>> Am I at a point to run fsck to repair the ext4 superblock?
>>
> No, that output would definitely suggest you have the wrong order.
> That looks to be far too many errors for a normal unclean shutdown
> situation.
>
>> I also tried a different ordering to see what fsck -n would give and I got:
>>
>> root@ubuntu:~# fsck -n /dev/md0
>> fsck from util-linux 2.20.1
>> e2fsck 1.42 (29-Nov-2011)
>> fsck.ext4: Filesystem revision too high while trying to open /dev/md0
>> The filesystem revision is apparently too high for this version of e2fsck.
>> (Or the filesystem superblock is corrupt)
>>
>>
>> The superblock could not be read or does not describe a correct ext2
>> filesystem.  If the device is valid and it really contains an ext2
>> filesystem (and not swap or ufs or something else), then the superblock
>> is corrupt, and you might try running e2fsck with an alternate superblock:
>>     e2fsck -b 8193 <device>
>>
>> Which seems to confirm my first attempt at the ordering was good.
>>
> No, it confirms that the first device was correct - the filesystem
> superblock will be entirely within the first chunk, so only the first
> disk needs to be correct for that to be readable.
>
> Have you tried running it in the order I advised (sdd3, sda3, sdc3,
> missing) or in the order of the UUIDs (if the device order has changed)?
>      92589cc2:9d5ed86c:1467efc2:2e6b7f09
>      4156ab46:bd42c10d:8565d5af:74856641
>      390bd4a2:07a28c01:528ed41e:a9d0fcf0
>      b2bf0462:e0722254:0e233a72:aa5df4da
>
> If not, please do so first and see whether the fsck output is any
> better.
>
> Cheers,
>     Robin
> --
>      ___
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |
