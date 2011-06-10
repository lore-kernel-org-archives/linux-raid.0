From: Phil Turmel <philip@turmel.org>
Subject: Re: SRaid with 13 Disks crashed
Date: Fri, 10 Jun 2011 10:01:46 -0400
Message-ID: <4DF223CA.7050302@turmel.org>
References: <20110610130652.298530@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110610130652.298530@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/10/2011 09:06 AM, Dragon wrote:
> You are right, the array starts at pos 0 and so pos 1 and 7 are the r=
ight pos. the 2. try was perfect. fsck shows this:

Yay!

> fsck -n /dev/md0
> fsck from util-linux-ng 2.17.2
> e2fsck 1.41.12 (17-May-2010)
> /dev/md0 wurde nicht ordnungsgem=C3=A4=C3=9F ausgeh=C3=A4ngt, Pr=C3=BC=
fung erzwungen.
> Durchgang 1: Pr=C3=BCfe Inodes, Blocks, und Gr=C3=B6=C3=9Fen
> Durchgang 2: Pr=C3=BCfe Verzeichnis Struktur
> Durchgang 3: Pr=C3=BCfe Verzeichnis Verkn=C3=BCpfungen
> Durchgang 4: =C3=9Cberpr=C3=BCfe die Referenzz=C3=A4hler
> Durchgang 5: =C3=9Cberpr=C3=BCfe Gruppe Zusammenfassung
> dd/dev/md0: 266872/1007288320 Dateien (15.4% nicht zusammenh=C3=A4nge=
nd), 3769576927/4029130864 Bl=C3=B6cke
>=20
> and:
> mdadm --detail /dev/md0
> /dev/md0:
>         Version : 0.90
>   Creation Time : Fri Jun 10 14:19:24 2011
>      Raid Level : raid5
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>    Raid Devices : 13
>   Total Devices : 13
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Fri Jun 10 14:19:24 2011
>           State : clean
>  Active Devices : 13
> Working Devices : 13
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            UUID : 8c4d8438:42aa49f9:a6d866f6:b6ea6b93 (local to host =
nassrv01)
>          Events : 0.1
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8      160        0      active sync   /dev/sdk
>        1       8      208        1      active sync   /dev/sdn
>        2       8      176        2      active sync   /dev/sdl
>        3       8      192        3      active sync   /dev/sdm
>        4       8        0        4      active sync   /dev/sda
>        5       8       16        5      active sync   /dev/sdb
>        6       8       64        6      active sync   /dev/sde
>        7       8       48        7      active sync   /dev/sdd
>        8       8       80        8      active sync   /dev/sdf
>        9       8       96        9      active sync   /dev/sdg
>       10       8      112       10      active sync   /dev/sdh
>       11       8      128       11      active sync   /dev/sdi
>       12       8      144       12      active sync   /dev/sdj
>=20
> normaly i use fsck.ext4 e.a. fsck.ext4dev. problem? what means 15,4% =
not related? the quote of lost data? after that i shrink like this:?

fsck automatically calls fsck.ext4 when it sees an ext4 filesystem.  15=
=2E4% Not contiguous =3D=3D 15.4 fragmented.  No lost data.

Now that you have a good filesystem, mounting it and taking a backup wo=
uld be a good idea.  Or at least retrieve any files that are very impor=
tant to you.

> mdadm  /dev/md0 --fail /dev/sdj
> mdadm /dev/md0 --remove /dev/sdj

NO! You must use "mdadm --grow".  Yes, "--grow" also does "shrink".  Yo=
ur fsck shows that the ext4 filesystem is still sized for the original =
12-disk setup, so you don't have to shrink the filesystem.  You do have=
 to shrink the raid:

Step 1a: Tell mdadm the final size you are aiming for.  MD will emulate=
 this while you test that the new size works:
mdadm /dev/md0 --grow --array-size=3D16116523456k

(Please show "mdadm -D /dev/md0" at this point.)

Step 1b: Verify data integrity with another fsck -n

Step 2:  Tell mdadm to really reshape to the 12-disk raid5
mdadm /dev/md0 --grow -n 12 --backup-file=3D/reshape.bak

When the reshape/shrink is done, "mdadm -D /dev/md0" will report "Raid =
Devices : 12" and "Spare Devices : 1", and one of them, almost certainl=
y /dev/sdj, will be marked "spare".

At this point, I recommend converting to raid6, consuming the spare.

mdadm /dev/md0 --grow -n 13 -l 6 --backup-file=3D/reshape.bak

It might be possible to go directly to this layout (in place of step 2 =
above).  It would save a lot of time.  Maybe someone else on the list c=
an answer that.  Or you can just try it.  I'm sure mdadm will complain =
if it's not possible ;).

> mdadm --detail --scan >> /etc/mdadm/mdadm.conf

Yes.  Make sure you edit it afterwards to remove the old array's inform=
ation.

> right way? i assume that the disk that i take off the raid is not the=
 same like i added at last? so i have to read out the serial to find it=
 under the harddrives?

Yes, use lsdrv or "/s -l /dev/disk/by-id/" to make sure you remove the =
spare.  Of course, if you convert to raid6, it won't be a spare :).

> many thx so far

You are welcome.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
