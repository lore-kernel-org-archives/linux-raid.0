From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: What layout with 6x2TB, Intel Atom?
Date: Mon, 4 Feb 2013 20:47:20 +0000
Message-ID: <CADNH=7EzArrs91MqiUcNjtqh4J4ApDSJaPdttPoKncn7QSgQVw@mail.gmail.com>
References: <CADNH=7EUc7z-E=uo74-QqaKEUcrZiAYKaZqtSfFVbLKpfvt7og@mail.gmail.com>
	<CADNH=7FxeF1qjYVpGcU1rW6LYDx=6e_LRa5+AUJqyV-hZ2K=XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7FxeF1qjYVpGcU1rW6LYDx=6e_LRa5+AUJqyV-hZ2K=XQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4 February 2013 20:29, Mathias Bur=C3=A9n <mathias.buren@gmail.com> =
wrote:
> On 4 February 2013 20:27, Mathias Bur=C3=A9n <mathias.buren@gmail.com=
> wrote:
>> Hi list,
>>
>> I've an Intel Atom 330 running 32-bit Ubuntu, ~3.5GB RAM. The intent
>> is to store large media files (>4GB) for streaming by maximum 3
>> clients at any time. Very read heavy.
>> 6x 2TB HDDs are available, the crux is that 3 HDDs are on the on-boa=
rd
>> SATA controller, the other 3 are on a Marvel PCI-E adapter
>>

I was clearly not thinking when doing this. Now it's a 6 disk RAID10
with far layout, 2 copies. Is the default chunk size of 512 a good
option here?

$ sudo mdadm --verbose --create md0 --level=3D10 --layout=3Df2
--raid-devices=3D6 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sd=
g
mdadm: chunk size defaults to 512K
mdadm: size set to 1953382912K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/md0 started.


$ cat /proc/mdstat
Personalities : [raid10] [raid0]
md127 : active raid10 sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
      5860147200 blocks super 1.2 512K chunks 2 far-copies [6/6] [UUUUU=
U]
      [>....................]  resync =3D  0.0% (775616/5860147200)
finish=3D629.5min speed=3D155123K/sec

unused devices: <none>
@ion:~$ sudo mdadm -D /dev/md/md0
/dev/md/md0:
        Version : 1.2
  Creation Time : Mon Feb  4 20:40:22 2013
     Raid Level : raid10
     Array Size : 5860147200 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 1953382400 (1862.89 GiB 2000.26 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Mon Feb  4 20:40:22 2013
          State : clean, resyncing
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : far=3D2
     Chunk Size : 512K

  Resync Status : 0% complete

           Name : ion:md0  (local to host ion)
           UUID : 438e9a1a:bf840b03:05c36383:c965cb39
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg

Kind regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
