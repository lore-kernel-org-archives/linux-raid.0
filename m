From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID 5 write performance advice
Date: Fri, 26 Aug 2005 13:05:23 -0400
Message-ID: <1125075923.5549.61.camel@localhost.localdomain>
References: <430C2EA6.2050103@web.de>
	 <1124887589.5550.27.camel@localhost.localdomain>	<430C798B.1030107@web.de>
	 <17164.59261.540591.841830@cse.unsw.edu.au>  <430DF416.1070101@web.de>
	 <1124988876.5552.59.camel@localhost.localdomain>  <430ECA18.10405@web.de>
	 <1125066621.5549.27.camel@localhost.localdomain>  <430F3565.2070302@web.de>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <430F3565.2070302@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i think this is out of my mind now. i think 4+1 DISK with 64KB chunk
size is 256KB which fit the 1M size well. So there should not have any
read happen...=20

ming


On Fri, 2005-08-26 at 17:29 +0200, Mirko Benz wrote:
> Hello,
>=20
> Here are the results using 5 disks for RAID 5 =E2=80=93 basically the=
 same=20
> results but with lower values.
> Again, much slower than it could be.
>=20
> *** dd TEST ***
>=20
> time dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M
> 2819620864 bytes transferred in 23,410720 seconds (120441442 bytes/se=
c)
>=20
> iostat 5 output:
> avg-cpu: %user %nice %sys %iowait %idle
> 0,10 0,00 55,40 36,20 8,30
>=20
> Device: tps Blk_read/s Blk_wrtn/s Blk_read Blk_wrtn
> hda 0,00 0,00 0,00 0 0
> sda 0,00 0,00 0,00 0 0
> sdb 345,09 1999,20 71501,40 9976 356792
> sdc 348,10 2412,83 71434,07 12040 356456
> sdd 356,31 2460,92 71748,30 12280 358024
> sde 351,50 2456,11 71058,92 12256 354584
> sdf 348,10 2008,82 70935,47 10024 353968
> sdg 0,00 0,00 0,00 0 0
> sdh 0,00 0,00 0,00 0 0
> sdi 0,00 0,00 0,00 0 0
> sdj 0,00 0,00 0,00 0 0
> sdk 0,00 0,00 0,00 0 0
> sdl 0,00 0,00 0,00 0 0
> sdm 0,00 0,00 0,00 0 0
> sdn 0,00 0,00 0,00 0 0
> md0 35226,65 0,00 281813,23 0 1406248
>=20
> disktest gives 99 MB/s but shows the same behaviour (unbalanced usage=
 of=20
> disks).
>=20
> Regards,
> Mirko
>=20
> Ming Zhang schrieb:
>=20
> >i would like to suggest u to do a 4+1 raid5 configuration and see wh=
at
> >happen.
> >
> >Ming
> >
> >On Fri, 2005-08-26 at 09:51 +0200, Mirko Benz wrote:
> > =20
> >
> >>Hello,
> >>
> >>We have created a RAID 0 for the same environment:
> >>Personalities : [raid0] [raid5]
> >>md0 : active raid0 sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1]=
 sdb[0]
> >>      1250326528 blocks 64k chunks
> >>
> >>*** dd TEST ***
> >>
> >>time dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M
> >>14967373824 bytes transferred in 32,060497 seconds (466847843 bytes=
/sec)
> >>
> >>iostat 5 output:
> >>avg-cpu:  %user   %nice    %sys %iowait   %idle
> >>           0,00    0,00   89,60    9,50    0,90
> >>
> >>Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_w=
rtn
> >>hda               0,00         0,00         0,00          0        =
  0
> >>sda               0,00         0,00         0,00          0        =
  0
> >>sdb             455,31         0,00    116559,52          0     581=
632
> >>sdc             455,51         0,00    116540,28          0     581=
536
> >>sdd             450,10         0,00    116545,09          0     581=
560
> >>sde             454,11         0,00    116559,52          0     581=
632
> >>sdf             452,30         0,00    116559,52          0     581=
632
> >>sdg             454,71         0,00    116553,11          0     581=
600
> >>sdh             453,31         0,00    116533,87          0     581=
504
> >>sdi             453,91         0,00    116556,31          0     581=
616
> >>sdj               0,00         0,00         0,00          0        =
  0
> >>sdk               0,00         0,00         0,00          0        =
  0
> >>sdl               0,00         0,00         0,00          0        =
  0
> >>sdm               0,00         0,00         0,00          0        =
  0
> >>sdn               0,00         0,00         0,00          0        =
  0
> >>md0           116556,11         0,00    932448,90          0    465=
2920
> >>
> >>Comments: 466 MB / 8 =3D 58,25 MB/s which is about the same as a dd=
 to a=20
> >>single disk (58,5 MB/s). So the controller + I/O subsystem is not t=
he=20
> >>bottleneck.
> >>
> >>Regards,
> >>Mirko
> >>
> >>   =20
> >>
> >
> >
> > =20
> >
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
