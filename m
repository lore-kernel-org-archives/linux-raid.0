From: "Luke Odom" <luke@lukeodom.com>
Subject: Re: dmadm question
Date: Mon, 15 Sep 2014 07:07:53 -0700
Message-ID: <56516488c20b6b78729f14731fe8aecf.squirrel@webmail.lukeodom.com>
References: <661E720A-B65C-4C24-B6A4-A4439596DEB9@lukeodom.com>
    <20140915103154.59bc7293@notabene.brown>
Reply-To: luke@lukeodom.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140915103154.59bc7293@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Luke Odom <luke@lukeodom.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Drive is exact same model as old one. Output of requested commands:

# mdadm --manage /dev/md127 --remove /dev/sdb
mdadm: hot removed /dev/sdb from /dev/md127
# mdadm --zero /dev/sdb
# mdadm --manage /dev/md127 --add /dev/sdb
mdadm: added /dev/sdb
# ps aux | grep mdmon
root      1937  0.0  0.1  10492 10484 ?        SLsl 14:04   0:00 mdmon =
md127
root      2055  0.0  0.0   2420   928 pts/0    S+   14:06   0:00 grep m=
dmon

md: unbind<sdb>
md: export_rdev(sdb)
md: bind<sdb>



On Sun, September 14, 2014 5:31 pm, NeilBrown wrote:
> On 12 Sep 2014 18:49:54 -0700 Luke Odom <luke@lukeodom.com> wrote:
>
>>   I had a raid1 subarray running within an imsm container. One of th=
e
>> drives died so I replaced it. I can get the new drive into the imsm
>> container but I can=E2=80=99t add it to the raid1 array within that
>> container. I=E2=80=99ve read the man page and can=E2=80=99t see to f=
igure it out.
>> Any help would be greatly appreciated. Using mdadm 3.2.5 on debian
>> squeeze.=C2=A0
>
> This  should just happen automatically.  As soon as you add the devic=
e to
> the
> container, mdmon notices and adds it to the raid1.
>
> However it appears not to have happened...
>
> I assume the new drive is exactly the same size as the old drive?
> Try removing the new device from md127, run "mdadm --zero" on it, the=
n add
> it
> back again.
> Do any messages appear in the kernel logs when you do that?
>
> Is "mdmon md127" running?
>
> NeilBrown
>
>
>>
>>
>>
>>
>> root@ds6790:~# cat /proc/mdstat
>> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>> md126 : active raid1 sda[0]
>> =C2=A0 =C2=A0 =C2=A0 976759808 blocks super external:/md127/0 [2/1] =
[U_]
>>
>>
>>
>>
>> md127 : inactive sdb[0](S) sda[1](S)
>> =C2=A0 =C2=A0 =C2=A0 4901 blocks super external:imsm
>>
>>
>>
>>
>> unused devices: <none>
>>
>>
>>
>>
>>
>>
>> root@ds6790:~# mdadm --detail /dev/md126
>> /dev/md126:
>> =C2=A0 =C2=A0 =C2=A0 Container : /dev/md127, member 0
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid1
>> =C2=A0 =C2=A0 =C2=A0Array Size : 976759808 (931.51 GiB 1000.20 GB)
>> =C2=A0 Used Dev Size : 976759940 (931.51 GiB 1000.20 GB)
>> =C2=A0 =C2=A0Raid Devices : 2
>> =C2=A0 Total Devices : 1
>>
>>
>>
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : active, degraded=C2=A0
>> =C2=A0Active Devices : 1
>> Working Devices : 1
>> =C2=A0Failed Devices : 0
>> =C2=A0 Spare Devices : 0
>>
>>
>>
>>
>>
>>
>>
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 1be60edf:5c16b945:86=
434b6b:2714fddb
>> =C2=A0 =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice Sta=
te
>> =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active syn=
c =C2=A0
>> /dev/sda
>> =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0removed
>>
>>
>>
>>
>>
>>
>> root@ds6790:~# mdadm --examine /dev/md127
>> /dev/md127:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : Intel Raid ISM Cfg Sig.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.1.00
>> =C2=A0 =C2=A0 Orig Family : 6e37aa48
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Family : 6e37aa48
>> =C2=A0 =C2=A0 =C2=A0Generation : 00640a43
>> =C2=A0 =C2=A0 =C2=A0Attributes : All supported
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : ac27ba68:f8a3618d:38=
10d44f:25031c07
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 513ef1f6 correct
>> =C2=A0 =C2=A0 MPB Sectors : 1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Disks : 2
>> =C2=A0 =C2=A0RAID Devices : 1
>>
>>
>>
>>
>> =C2=A0 Disk00 Serial : 9XG3RTL0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : active
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Id : 00000002
>> =C2=A0 =C2=A0 Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
>>
>>
>>
>>
>> [Volume0]:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 1be60edf:5c16b945:86=
434b6b:2714fddb
>> =C2=A0 =C2=A0 =C2=A0RAID Level : 1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Members : 2
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Slots : [U_]
>> =C2=A0 =C2=A0 Failed disk : 1
>> =C2=A0 =C2=A0 =C2=A0 This Slot : 0
>> =C2=A0 =C2=A0 =C2=A0Array Size : 1953519616 (931.51 GiB 1000.20 GB)
>> =C2=A0 =C2=A0Per Dev Size : 1953519880 (931.51 GiB 1000.20 GB)
>> =C2=A0 Sector Offset : 0
>> =C2=A0 =C2=A0 Num Stripes : 7630936
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 64 KiB
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Reserved : 0
>> =C2=A0 Migrate State : idle
>> =C2=A0 =C2=A0 =C2=A0 Map State : degraded
>> =C2=A0 =C2=A0 Dirty State : dirty
>>
>>
>>
>>
>> =C2=A0 Disk01 Serial : XG3RWMF
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : failed
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Id : ffffffff
>> =C2=A0 =C2=A0 Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
>>
>>
>>
>>
>>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
