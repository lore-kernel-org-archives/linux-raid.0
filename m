From: Jim Bauwens <jim@bwns.be>
Subject: Re: RAID 10 problems, two disks marked as spare
Date: Thu, 6 Mar 2014 11:11:11 +0100
Message-ID: <75121A0D-1A74-46B6-B535-5AC71DC58A8F@bwns.be>
References: <4ae13e60b43f187d9409032854fb119e@bwns.be>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ae13e60b43f187d9409032854fb119e@bwns.be>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I decided to take the plunge and recreate the array with "mdadm --creat=
e --assume-clean --level=3D10 --raid-devices=3D4 --size=3D974722176 /de=
v/md1 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2=94. The array is working =
correctly again, however for now I mounted it read only and I=92m going=
 to take some backups to another raid system just in case something ter=
ribly goes wrong (I have to reboot the device so that the Iomega NAS sy=
stem can detect the drives again).

Greetings and thanks,
Jim



On 28 Feb 2014, at 20:40, jim@bwns.be wrote:

> Hi all,
>=20
> I'm having a bit of trouble with my NAS and I was hoping some of you =
lads would be able to help my out.
>=20
> First of all my setup:
>=20
> The NAS itself is an Iomega StorCenter ix4-200d. It has 4x 1TiB drive=
s, configured to use RAID10. I have already replaced one drive once. Th=
e NAS itself doesn't come with shell access but it's fairly easy to 'ro=
ot' it anyway (which I did).
>=20
> Several days ago the NAS send me an email that a certain drive was de=
graded:
>=20
>> The Iomega StorCenter device is degraded and data protection is at r=
isk. A drive may have either failed or been removed from your Iomega St=
orCenter device. Visit the Dashboard on the management interface for de=
tails. To prevent possible data loss, this issue should be repaired as =
soon as possible.
>=20
> I decided to first to try and reboot the device, maybe it was a simpl=
e error. After reboot I received the following:
>=20
>> Data protection is being reconstructed on your Iomega StorCenter dev=
ice
>=20
> So I was happy until several hours later I received the following mes=
sages (all at the same time)
>=20
>> The Iomega StorCenter device has completed data protection reconstru=
ction.
>=20
>> The Iomega StorCenter device has failed and some data loss may have =
occurred. Multiple drives may have either failed or been removed from y=
our storage system. Visit the Dashboard on the management interface for=
 details.
>=20
>> Drive number 4 encountered a recoverable error.
>=20
> No data was accessible anymore. After that I opened a shell to the de=
vice and try to trouble shout it. But I didn=92t manage to get it worki=
ng. The only solution I currently see it to try and rebuild the RAID ar=
ray but as I have hardly any experience with the mdadm tool I decided t=
o ask the opinions of the people here.
>=20
> Here is some information regarding the setup:
>=20
> root@BauwensNAS:/# mdadm -D /dev/md1
> /dev/md1:
>        Version : 01.00
>  Creation Time : Mon Jan 24 20:57:43 2011
>     Raid Level : raid10
>  Used Dev Size : 974722176 (929.57 GiB 998.12 GB)
>   Raid Devices : 4
>  Total Devices : 4
> Preferred Minor : 1
>    Persistence : Superblock is persistent
>=20
>    Update Time : Wed Feb 26 02:44:57 2014
>          State : active, degraded, Not Started
> Active Devices : 2
> Working Devices : 4
> Failed Devices : 0
>  Spare Devices : 2
>=20
>         Layout : near=3D2, far=3D1
>     Chunk Size : 64K
>=20
>           Name : bwns:1
>           UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
>         Events : 133470
>=20
>    Number   Major   Minor   RaidDevice State
>       0       8        2        0      active sync   /dev/sda2
>       4       8       18        1      active sync   /dev/sdb2
>       2       0        0        2      removed
>       3       0        0        3      removed
>=20
>       2       8       34        -      spare   /dev/sdc2
>       3       8       50        -      spare   /dev/sdd2
>=20
> As you can see, the two last drives are marked as spare. My multiple =
attempts to get the drive running with all the disks have only been fai=
lures (but I assume that's also due to me not having experience with th=
e tools).
>=20
> Also, the disks themself appear to be fine (also because the md0 devi=
ce that hosts /boot works properly)
>=20
> Some more info:
>=20
> root@BauwensNAS:/# mdadm --examine /dev/sd[abcd]2
> /dev/sda2:
>          Magic : a92b4efc
>        Version : 1.0
>    Feature Map : 0x0
>     Array UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
>           Name : bwns:1
>  Creation Time : Mon Jan 24 20:57:43 2011
>     Raid Level : raid10
>   Raid Devices : 4
>=20
> Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
>     Array Size : 3898888704 (1859.14 GiB 1996.23 GB)
>  Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
>   Super Offset : 1949444640 sectors
>          State : clean
>    Device UUID : b05f4c40:819ddbef:76872d9f:abacf3c9
>=20
>    Update Time : Wed Feb 26 02:44:57 2014
>       Checksum : a94e1ae6 - correct
>         Events : 133470
>=20
>         Layout : near=3D2, far=3D1
>     Chunk Size : 64K
>=20
>    Array Slot : 0 (0, failed, empty, empty, 1)
>   Array State : Uu__ 1 failed
> /dev/sdb2:
>          Magic : a92b4efc
>        Version : 1.0
>    Feature Map : 0x0
>     Array UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
>           Name : bwns:1
>  Creation Time : Mon Jan 24 20:57:43 2011
>     Raid Level : raid10
>   Raid Devices : 4
>=20
> Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
>     Array Size : 3898888704 (1859.14 GiB 1996.23 GB)
>  Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
>   Super Offset : 1949444640 sectors
>          State : clean
>    Device UUID : 6c34331a:0fda7f73:a1f76d41:a826ac1f
>=20
>    Update Time : Wed Feb 26 02:44:57 2014
>       Checksum : fed2165a - correct
>         Events : 133470
>=20
>         Layout : near=3D2, far=3D1
>     Chunk Size : 64K
>=20
>    Array Slot : 4 (0, failed, empty, empty, 1)
>   Array State : uU__ 1 failed
> /dev/sdc2:
>          Magic : a92b4efc
>        Version : 1.0
>    Feature Map : 0x0
>     Array UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
>           Name : bwns:1
>  Creation Time : Mon Jan 24 20:57:43 2011
>     Raid Level : raid10
>   Raid Devices : 4
>=20
> Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
>     Array Size : 3898888704 (1859.14 GiB 1996.23 GB)
>  Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
>   Super Offset : 1949444640 sectors
>          State : clean
>    Device UUID : 773dbfec:07467e62:de7be59b:5c680df5
>=20
>    Update Time : Wed Feb 26 02:44:57 2014
>       Checksum : f035517e - correct
>         Events : 133470
>=20
>         Layout : near=3D2, far=3D1
>     Chunk Size : 64K
>=20
>    Array Slot : 2 (0, failed, empty, empty, 1)
>   Array State : uu__ 1 failed
> /dev/sdd2:
>          Magic : a92b4efc
>        Version : 1.0
>    Feature Map : 0x0
>     Array UUID : 43a1e240:956c3131:df9f6e66:bd9a071e
>           Name : bwns:1
>  Creation Time : Mon Jan 24 20:57:43 2011
>     Raid Level : raid10
>   Raid Devices : 4
>=20
> Avail Dev Size : 1949444384 (929.57 GiB 998.12 GB)
>     Array Size : 3898888704 (1859.14 GiB 1996.23 GB)
>  Used Dev Size : 1949444352 (929.57 GiB 998.12 GB)
>   Super Offset : 1949444640 sectors
>          State : clean
>    Device UUID : dbd27546:6b623b53:8f887960:b7cbf424
>=20
>    Update Time : Wed Feb 26 02:44:57 2014
>       Checksum : 2f247322 - correct
>         Events : 133470
>=20
>         Layout : near=3D2, far=3D1
>     Chunk Size : 64K
>=20
>    Array Slot : 3 (0, failed, empty, empty, 1)
>   Array State : uu__ 1 failed
>=20
>=20
> Taking a look at the event count they seem to be synchronized, so I'm=
 not really sure what's going on here.
>=20
> root@BauwensNAS:/# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md1 : inactive sda2[0] sdd2[3](S) sdc2[2](S) sdb2[4]
>      3898888704 blocks super 1.0
>=20
> md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
>      2040128 blocks [4/4] [UUUU]
>=20
> unused devices: <none>
>=20
> Anyone have an idea how I could resolve this problem (hoping that I d=
on't have any data loss...)? Any help is greatly appreciated. I sure re=
gret rebooting the device without taking some extra backups.
>=20
> TIA!
> Jim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
