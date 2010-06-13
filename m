From: Neil Brown <neilb@suse.de>
Subject: Re: Problem re-shaping RAID6
Date: Mon, 14 Jun 2010 09:15:18 +1000
Message-ID: <20100614091518.2492a9db@notabene.brown>
References: <AANLkTikv3JPbto1F2YYmRx0HNP7cgFh3gj6dHekCt1SE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikv3JPbto1F2YYmRx0HNP7cgFh3gj6dHekCt1SE@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWU=?= Poulin <jeromepoulin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 13 Jun 2010 15:15:08 -0400
J=C3=A9r=C3=B4me Poulin <jeromepoulin@gmail.com> wrote:

> I had problems reshaping my RAID6 down 1 disk today and found a
> problem in Grow.c:
>=20
> diff -udpr mdadm-3.1.2/Grow.c mdadm-3.1.2-critical-section/Grow.c
> --- mdadm-3.1.2/Grow.c  2010-03-09 23:31:39.000000000 -0500
> +++ mdadm-3.1.2-critical-section/Grow.c 2010-06-13 14:57:44.000000000=
 -0400
> @@ -497,7 +497,7 @@ int Grow_reshape(char *devname, int fd,
>         int rv =3D 0;
>         struct supertype *st;
>=20
> -       int nchunk, ochunk;
> +       unsigned long nchunk, ochunk;
>         int nlayout, olayout;
>         int ndisks, odisks;
>         int ndata, odata;
>=20
>=20
> After changing this I was able to re-shape the array, it seems it was
> overflowing and I had a message saying:
> root@billsshack:~/mdadm-3.1.2/ > ./mdadm --grow /dev/md0
> --raid-devices=3D6 --backup-file=3D/mnt/data1/md-raid6-grow-backup.ba=
k
> mdadm: Need to backup 4503599627350016K of critical section..
> mdadm: /dev/md0: Something wrong - reshape aborted
>=20
> Now it works:
> root@billsshack:~/mdadm-3.1.2/ > ./mdadm --grow /dev/md0
> --raid-devices=3D6 --backup-file=3D/mnt/data1/md-raid6-grow-backup.ba=
k
> mdadm: Need to backup 20480K of critical section..
> root@billsshack:~/mdadm-3.1.2/ > cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> [faulty] [linear]
> md0 : active raid6 dm-6[0] dm-8[5] dm-5[4] dm-3[3] dm-4[2] dm-7[1]
>       7814041600 blocks super 0.91 level 6, 1024k chunk, algorithm 2
> [6/5] [UUUUUU]
>       [>....................]  reshape =3D  0.0% (33792/1953510400)
> finish=3D1926.0min speed=3D16896K/sec
>=20
>=20
> Here's a nice output of GDB:
>       Breakpoint 1, Grow_reshape (devname=3D0x7fffffffe390 "/dev/md0"=
,
> fd=3D5, quiet=3D0,
>           backup_file=3D0x7fffffffe3b8
> "/mnt/data1/md-raid6-grow-backup.bak", size=3D1953510400, level=3D655=
34,
>           layout_str=3D0x0, chunksize=3D0, raid_disks=3D6) at Grow.c:=
939
>       939                     blocks =3D ochunk/512 * nchunk/512 * od=
ata
> * ndata / a;
>       (gdb) p ochunk/512
>       $9 =3D 2048
>       (gdb) p ochunk/512 * nchunk/512
>       $10 =3D -4194304


Thanks.
I fixed this bug a slightly different way

-               blocks =3D ochunk/512 * nchunk/512 * odata * ndata / a;
+               blocks =3D (ochunk/512) * (nchunk/512) * odata * ndata =
/ a;


See
http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D200871adf9e15d5=
ad985f28c349fd89c386ef48a

I guess it is time to release a 3.1.3...

Thanks,
NeilBrown


>       (gdb) p nchunk
>       $11 =3D 1048576
>       (gdb) p ochunk
>       $12 =3D 1048576
>       (gdb) p ochunk/512
>       $13 =3D 2048
>       (gdb) p nchunk/512
>       $14 =3D 2048
>       (gdb) p 2048*2048
>       $15 =3D 4194304
>       (gdb) p 2048*2048*odata
>       $16 =3D 20971520
>       (gdb) p 2048*2048*odata*ndata
>       $17 =3D 83886080
>       (gdb) p 2048*2048*odata*ndata/a
>       $18 =3D 40960
>       (gdb) p ochunk/512 * nchunk/512 * odata * ndata / a
>       $19 =3D 9007199254700032
>       (gdb) p ochunk/512 * nchunk/512
>       $20 =3D -4194304
>       (gdb)
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
