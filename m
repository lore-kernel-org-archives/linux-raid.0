From: Neil Brown <neilb@suse.de>
Subject: Re: Problem re-shaping RAID6
Date: Tue, 29 Jun 2010 11:11:35 +1000
Message-ID: <20100629111135.1b7cc50b@notabene.brown>
References: <AANLkTikv3JPbto1F2YYmRx0HNP7cgFh3gj6dHekCt1SE@mail.gmail.com>
	<20100614091518.2492a9db@notabene.brown>
	<4C1BBE6E.5090802@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C1BBE6E.5090802@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: =?UTF-8?B?SsOpcsO0bWU=?= Poulin <jeromepoulin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 18 Jun 2010 14:43:58 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> Neil Brown wrote:
> > On Sun, 13 Jun 2010 15:15:08 -0400
> > J=C3=A9r=C3=B4me Poulin <jeromepoulin@gmail.com> wrote:
> >
> >  =20
> >> I had problems reshaping my RAID6 down 1 disk today and found a
> >> problem in Grow.c:
> >>
> >> diff -udpr mdadm-3.1.2/Grow.c mdadm-3.1.2-critical-section/Grow.c
> >> --- mdadm-3.1.2/Grow.c  2010-03-09 23:31:39.000000000 -0500
> >> +++ mdadm-3.1.2-critical-section/Grow.c 2010-06-13 14:57:44.000000=
000 -0400
> >> @@ -497,7 +497,7 @@ int Grow_reshape(char *devname, int fd,
> >>         int rv =3D 0;
> >>         struct supertype *st;
> >>
> >> -       int nchunk, ochunk;
> >> +       unsigned long nchunk, ochunk;
> >>         int nlayout, olayout;
> >>         int ndisks, odisks;
> >>         int ndata, odata;
> >>
> >>
> >> After changing this I was able to re-shape the array, it seems it =
was
> >> overflowing and I had a message saying:
> >> root@billsshack:~/mdadm-3.1.2/ > ./mdadm --grow /dev/md0
> >> --raid-devices=3D6 --backup-file=3D/mnt/data1/md-raid6-grow-backup=
=2Ebak
> >> mdadm: Need to backup 4503599627350016K of critical section..
> >> mdadm: /dev/md0: Something wrong - reshape aborted
> >>
> >> Now it works:
> >> root@billsshack:~/mdadm-3.1.2/ > ./mdadm --grow /dev/md0
> >> --raid-devices=3D6 --backup-file=3D/mnt/data1/md-raid6-grow-backup=
=2Ebak
> >> mdadm: Need to backup 20480K of critical section..
> >> root@billsshack:~/mdadm-3.1.2/ > cat /proc/mdstat
> >> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> >> [faulty] [linear]
> >> md0 : active raid6 dm-6[0] dm-8[5] dm-5[4] dm-3[3] dm-4[2] dm-7[1]
> >>       7814041600 blocks super 0.91 level 6, 1024k chunk, algorithm=
 2
> >> [6/5] [UUUUUU]
> >>       [>....................]  reshape =3D  0.0% (33792/1953510400=
)
> >> finish=3D1926.0min speed=3D16896K/sec
> >>
> >>
> >> Here's a nice output of GDB:
> >>       Breakpoint 1, Grow_reshape (devname=3D0x7fffffffe390 "/dev/m=
d0",
> >> fd=3D5, quiet=3D0,
> >>           backup_file=3D0x7fffffffe3b8
> >> "/mnt/data1/md-raid6-grow-backup.bak", size=3D1953510400, level=3D=
65534,
> >>           layout_str=3D0x0, chunksize=3D0, raid_disks=3D6) at Grow=
=2Ec:939
> >>       939                     blocks =3D ochunk/512 * nchunk/512 *=
 odata
> >> * ndata / a;
> >>       (gdb) p ochunk/512
> >>       $9 =3D 2048
> >>       (gdb) p ochunk/512 * nchunk/512
> >>       $10 =3D -4194304
> >>    =20
> >
> >
> > Thanks.
> > I fixed this bug a slightly different way
> >
> > -               blocks =3D ochunk/512 * nchunk/512 * odata * ndata =
/ a;
> > +               blocks =3D (ochunk/512) * (nchunk/512) * odata * nd=
ata / a;
> >
> >
> >  =20
> I don't have a current C standard handy, but I was on the original X3=
J11=20
> committee, and I'm fairly sure that even with that grouping, which ma=
y=20
> work fine for gcc, the standard allows the compiler to ignore what yo=
u=20
> did and do the optimization as long as the result "is the same as" do=
ing=20
> what you said, in math terms rather than real world. And since other=20
> compilers (such as Intel C) are used to compile the kernel and may be=
 in=20
> the future, and since disks are getting larger and faster, I do prefe=
r=20
> the future proofing of the original solution.

Seriously?  It sounds pretty broken to allow any transformation on fixe=
d-size
integers that would valid on real numbers... (You did say "real world".=
=2E.)
Even anything valid on integers is quite possibly not valid on fixed-si=
zed
numbers.

But if I were to change it I don't think I would make the variables big=
ger.
I would do something like

  ochunk_sectors =3D ochunk / 512;
  nchunk_sectors =3D nchunk / 512;

  blocks =3D ochunk_sectors * nchunk_sectors * odata * ndata / a;

but that just makes it clearer to me that if the guarantees there are
different to the guarantees for what I originally proposed, then there =
is
something seriously wrong with the language.

Do you have any reference to any standard that I could look at and try =
to
understand?

Thanks.
NeilBrown


>=20
> > See
> > http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D200871adf9e=
15d5ad985f28c349fd89c386ef48a
> >
> > I guess it is time to release a 3.1.3...
> >
> > Thanks,
> > NeilBrown
> >  =20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
