From: jim@bwns.be
Subject: RAID 10 problems, two disks marked as spare
Date: Fri, 28 Feb 2014 20:40:59 +0100
Message-ID: <4ae13e60b43f187d9409032854fb119e@bwns.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm having a bit of trouble with my NAS and I was hoping some of you=20
lads would be able to help my out.

=46irst of all my setup:

The NAS itself is an Iomega StorCenter ix4-200d. It has 4x 1TiB drives,=
=20
configured to use RAID10. I have already replaced one drive once. The=20
NAS itself doesn't come with shell access but it's fairly easy to 'root=
'=20
it anyway (which I did).

Several days ago the NAS send me an email that a certain drive was=20
degraded:

> The Iomega StorCenter device is degraded and data protection is at=20
> risk. A drive may have either failed or been removed from your Iomega=
=20
> StorCenter device. Visit the Dashboard on the management interface fo=
r=20
> details. To prevent possible data loss, this issue should be repaired=
=20
> as soon as possible.

I decided to first to try and reboot the device, maybe it was a simple=20
error. After reboot I received the following:

> Data protection is being reconstructed on your Iomega StorCenter devi=
ce

So I was happy until several hours later I received the following=20
messages (all at the same time)

> The Iomega StorCenter device has completed data protection=20
> reconstruction.

> The Iomega StorCenter device has failed and some data loss may have=20
> occurred. Multiple drives may have either failed or been removed from=
=20
> your storage system. Visit the Dashboard on the management interface=20
> for details.

> Drive number 4 encountered a recoverable error.

No data was accessible anymore. After that I opened a shell to the=20
device and try to trouble shout it. But I didn=E2=80=99t manage to get =
it=20
working. The only solution I currently see it to try and rebuild the=20
RAID array but as I have hardly any experience with the mdadm tool I=20
decided to ask the opinions of the people here.

Here is some information regarding the setup:

  root@BauwensNAS:/# mdadm -D /dev/md1
/dev/md1:
         Version : 01.00
   Creation Time : Mon Jan 24 20:57:43 2011
      Raid Level : raid10
   Used Dev Size : 974722176 (929.57 GiB 998.12 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Wed Feb 26 02:44:57 2014
           State : active, degraded, Not Started
  Active Devices : 2
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 2

          Layout : near=3D2, far=3D1
      Chunk Size : 64K

            Name : bwns:1
            UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
          Events : 133470

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        4       8       18        1      active sync   /dev/sdb2
        2       0        0        2      removed
        3       0        0        3      removed

        2       8       34        -      spare   /dev/sdc2
        3       8       50        -      spare   /dev/sdd2

As you can see, the two last drives are marked as spare. My multiple=20
attempts to get the drive running with all the disks have only been=20
failures (but I assume that's also due to me not having experience with=
=20
the tools).

Also, the disks themself appear to be fine (also because the md0 device=
=20
that hosts /boot works properly)

Some more info:

root@BauwensNAS:/# mdadm --examine /dev/sd[abcd]2
/dev/sda2:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x0
      Array UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
            Name : bwns:1
   Creation Time : Mon Jan 24 20:57:43 2011
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
      Array Size : 3898888704 (1859.14 GiB 1996.23 GB)
   Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
    Super Offset : 1949444640 sectors
           State : clean
     Device UUID : b05f4c40:819ddbef:76872d9f:abacf3c9

     Update Time : Wed Feb 26 02:44:57 2014
        Checksum : a94e1ae6 - correct
          Events : 133470

          Layout : near=3D2, far=3D1
      Chunk Size : 64K

     Array Slot : 0 (0, failed, empty, empty, 1)
    Array State : Uu__ 1 failed
/dev/sdb2:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x0
      Array UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
            Name : bwns:1
   Creation Time : Mon Jan 24 20:57:43 2011
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
      Array Size : 3898888704 (1859.14 GiB 1996.23 GB)
   Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
    Super Offset : 1949444640 sectors
           State : clean
     Device UUID : 6c34331a:0fda7f73:a1f76d41:a826ac1f

     Update Time : Wed Feb 26 02:44:57 2014
        Checksum : fed2165a - correct
          Events : 133470

          Layout : near=3D2, far=3D1
      Chunk Size : 64K

     Array Slot : 4 (0, failed, empty, empty, 1)
    Array State : uU__ 1 failed
/dev/sdc2:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x0
      Array UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
            Name : bwns:1
   Creation Time : Mon Jan 24 20:57:43 2011
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
      Array Size : 3898888704 (1859.14 GiB 1996.23 GB)
   Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
    Super Offset : 1949444640 sectors
           State : clean
     Device UUID : 773dbfec:07467e62:de7be59b:5c680df5

     Update Time : Wed Feb 26 02:44:57 2014
        Checksum : f035517e - correct
          Events : 133470

          Layout : near=3D2, far=3D1
      Chunk Size : 64K

     Array Slot : 2 (0, failed, empty, empty, 1)
    Array State : uu__ 1 failed
/dev/sdd2:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x0
      Array UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
            Name : bwns:1
   Creation Time : Mon Jan 24 20:57:43 2011
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
      Array Size : 3898888704 (1859.14 GiB 1996.23 GB)
   Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
    Super Offset : 1949444640 sectors
           State : clean
     Device UUID : dbd27546:6b623b53:8f887960:b7cbf424

     Update Time : Wed Feb 26 02:44:57 2014
        Checksum : 2f247322 - correct
          Events : 133470

          Layout : near=3D2, far=3D1
      Chunk Size : 64K

     Array Slot : 3 (0, failed, empty, empty, 1)
    Array State : uu__ 1 failed


Taking a look at the event count they seem to be synchronized, so I'm=20
not really sure what's going on here.

root@BauwensNAS:/# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]=20
[raid4]
md1 : inactive sda2[0] sdd2[3](S) sdc2[2](S) sdb2[4]
       3898888704 blocks super 1.0

md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
       2040128 blocks [4/4] [UUUU]

unused devices: <none>

Anyone have an idea how I could resolve this problem (hoping that I=20
don't have any data loss...)? Any help is greatly appreciated. I sure=20
regret rebooting the device without taking some extra backups.

TIA!
Jim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
