From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Dumb questions about mdadm #1 - replacing broken disks - "slot"
 reuse?
Date: Fri, 18 Sep 2009 21:12:31 +0200
Message-ID: <slrnhb7mt1.dbe.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <4AB37978.5030403@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Hughes <john@Calva.COM> wrote:
> This works, but when I look at the results it looks rather ugly, the =
new=20
> disk goes in a new "slot" in the raid superblock.  Is it the case tha=
t=20

This is not a dumb question. This is just unexpected behaviour :)
I have the same here on a 1.1 superblock RAID1

> Before:
> md0 : active raid10 sdw[11] sdg[10] sdv[9] sdf[8] sdu[7] sde[6] sdt[5=
] sdd[4] sds[3] sdc[2] sdr[1] sdb[0]
>       426970368 blocks super 1.2 64K chunks 2 near-copies [12/12] [UU=
UUUUUUUUUU]
>       bitmap: 1/204 pages [4KB], 1024KB chunk
> After:
> md0 : active raid10 sdh[12] sdw[11] sdg[10] sdv[9] sdf[8] sdu[7] sde[=
6] sdt[5] sdd[4] sds[3] sdr[1] sdb[0]
>       426970368 blocks super 1.2 64K chunks 2 near-copies [12/12] [UU=
UUUUUUUUUU]
>       bitmap: 0/204 pages [0KB], 1024KB chunk

In my case I created the array as:

# uname -a
Linux darkside 2.6.30-1-686 #1 SMP Sat Aug 15 19:11:58 UTC 2009 i686 GN=
U/Linux
# mdadm --create -e 1.1 -l raid1 -n 2 -b internal -a md /dev/md9 /dev/h=
dh missing

and subsequently added /dev/sdd.

/proc/mdstat:
md9 : active raid1 sdd[2] hdh[0]
      312571092 blocks super 1.1 [2/2] [UU]
      bitmap: 1/299 pages [4KB], 512KB chunk

# mdadm -E /dev/hdh /dev/sdd
/dev/hdh:=20
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
=2E..
     Raid Level : raid1
   Raid Devices : 2
=2E..
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
=2E..
Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 18 20:14:24 2009
       Checksum : 754e56a3 - correct
         Events : 12564
=2E..
   Device Role : Active device 0
   Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd:=20
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
=2E..
     Raid Level : raid1
   Raid Devices : 2
=2E..
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
=2E..
Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 18 20:14:24 2009
       Checksum : 8747d7b3 - correct
         Events : 12564
=2E..
   Device Role : spare
   Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)

`mdadm -A --update=3Dsummaries' doesn't help (I didn't expect it to, th=
o)
`mdadm -A --update=3Dresync' doesn't help
`--fail --remove --add' doesn't help
`--fail --remove --grow -n 1 --grow -n 2 --add' doesn't help
`--fail --remove --grow -n 1 --add --grow -n 2' doesn't help

The array resyncs the few bitmap-chunks and the component remains in
slot 2, the array has no device missing, the bitmap stays at 1 page
(1620 bits set). Writing to the array increases the bits set for a shor=
t
time and then they go back to 1 page (1620 bits) and remain there.
The components are in sync and remain in sync, I cmp'ed them.


regards
   Mario
--=20
Damit das M=F6gliche entsteht, mu=DF immer wieder das Unm=F6gliche vers=
ucht werden.
                                                  -- Hermann Hesse

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
