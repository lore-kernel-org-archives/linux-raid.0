From: Neil Brown <neilb@suse.de>
Subject: Re: increasing stripe_cache_size decreases RAID-6 read throughput
Date: Tue, 27 Apr 2010 16:41:26 +1000
Message-ID: <20100427164126.2765f9e0@notabene.brown>
References: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Williams <jwilliams315@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 24 Apr 2010 16:36:20 -0700
Joe Williams <jwilliams315@gmail.com> wrote:

> I am new to mdadm, and I just set up an mdadm v3.1.2 RAID-6 of five 2
> TB Samsung Spinpoint F3EGs. I created the RAID-6 with the default
> parameters, including a 512 KB chunk size. It took about 6 hours to
> initialize, then I created an XFS filesystem:
>=20
> # mkfs.xfs -f -d su=3D512k,sw=3D3 -l su=3D256k -l lazy-count=3D1 -L r=
aidvol /dev/md0
> meta-data=3D/dev/md0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 isize=3D256=C2=A0=C2=A0=C2=A0 agcount=
=3D32, agsize=3D45776384 blks
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectsz=3D512=C2=A0=C2=A0 att=
r=3D2
> data=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 bsize=3D4096=C2=A0=C2=A0 blocks=3D1464843648, ima=
xpct=3D5
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sunit=3D128=C2=A0=C2=A0=C2=A0=
 swidth=3D384 blks
> naming=C2=A0=C2=A0 =3Dversion 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bsize=3D4096=C2=A0=C2=A0 ascii-=
ci=3D0
> log=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3Dinternal log=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bsize=3D4096=C2=A0=C2=A0 blocks=
=3D521728, version=3D2
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectsz=3D512=C2=A0=C2=A0 sun=
it=3D64 blks, lazy-count=3D1
> realtime =3Dnone=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extsz=3D4096=C2=A0=
=C2=A0 blocks=3D0, rtextents=3D0
>=20
> Note that 256k is the maximum allowed by mkfs.xfs for the log stripe =
unit.
>=20
> Then it was time to optimize the performance. First I ran a benchmark
> with the default settings (from a recent Arch linux install) for the
> following parameters:
>=20
> # cat /sys/block/md0/md/stripe_cache_size
> 256
>=20
> # cat /sys/block/md0/queue/read_ahead_kb
> 3072

2 full stripes - that is right.

> # cat /sys/block/sdb/queue/read_ahead_kb
> 128

This number is completely irrelevant.  Only the read_ahead_kb of the de=
vice
that the filesystem sees is used.

>=20
> # cat /sys/block/md0/queue/scheduler
> none
> # cat /sys/block/sdb/queue/scheduler
> noop deadline [cfq]
>=20
> # cat /sys/block/md0/queue/nr_requests
> 128
> # cat /sys/block/sdb/queue/nr_requests
> 128
>=20
> # cat /sys/block/md0/device/queue_depth
> cat: /sys/block/md0/device/queue_depth: No such file or directory
> # cat /sys/block/sdb/device/queue_depth
> 31
>=20
> # cat /sys/block/md0/queue/max_sectors_kb
> 127
> # cat /sys/block/sdb/queue/max_sectors_kb
> 512
>=20
> Note that sdb is one of the 5 drives for the RAID volume, and the
> other 4 have the same settings.
>=20
> First question, is it normal for the md0 scheduler to be "none"? I
> cannot change it by writing, eg., "deadline" into the file.
>=20

Because software-RAID is not disk drive, does not use and elevator and =
so
does not use a scheduler.
The whole 'queue' directory really shouldn't appear for md devices but =
for
some very boring reasons it does.


> Next question, is it normal for md0 to have no queue_depth setting?

Yes.  The stripe_cache_size is conceptually a similar think, but only
at a very abstract level.

>=20
> Are there any other parameters that are important to performance that
> I should be looking at?

No.

>=20
> I started the kernel with mem=3D1024M so that the buffer cache wasn't
> too large (this machine has 72G of RAM), and ran an iozone benchmark:
>=20
> =C2=A0=C2=A0=C2=A0 Iozone: Performance Test of File I/O
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version=
 $Revision: 3.338 $
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Compiled for 64 bit mode.
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Build: linux-AMD64
>=20
> =C2=A0=C2=A0=C2=A0 Auto Mode
> =C2=A0=C2=A0=C2=A0 Using Minimum Record Size 64 KB
> =C2=A0=C2=A0=C2=A0 Using Maximum Record Size 16384 KB
> =C2=A0=C2=A0=C2=A0 File size set to 4194304 KB
> =C2=A0=C2=A0=C2=A0 Include fsync in write timing
> =C2=A0=C2=A0=C2=A0 Command line used: iozone -a -y64K -q16M -s4G -e -=
f iotest -i0 -i1 -i2
> =C2=A0=C2=A0=C2=A0 Output is in Kbytes/sec
> =C2=A0=C2=A0=C2=A0 Time Resolution =3D 0.000001 seconds.
> =C2=A0=C2=A0=C2=A0 Processor cache size set to 1024 Kbytes.
> =C2=A0=C2=A0=C2=A0 Processor cache line size set to 32 bytes.
> =C2=A0=C2=A0=C2=A0 File stride size set to 17 * record size.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
andom
> random
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 KB=C2=A0 reclen=C2=A0=C2=A0 write rewrite=C2=A0=C2=A0=C2=A0 r=
ead=C2=A0=C2=A0=C2=A0 reread=C2=A0=C2=A0=C2=A0 read=C2=A0=C2=A0 write
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4194304=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 64=C2=A0 133608=C2=A0 114920=C2=A0=C2=A0 191367=C2=A0=C2=
=A0 191559=C2=A0=C2=A0=C2=A0 7772
> 14718
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4194304=C2=A0=C2=A0=C2=
=A0=C2=A0 128=C2=A0 142748=C2=A0 113722=C2=A0=C2=A0 165832=C2=A0=C2=A0 =
161023=C2=A0=C2=A0 14055
> 20728
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4194304=C2=A0=C2=A0=C2=
=A0=C2=A0 256=C2=A0 127493=C2=A0 108110=C2=A0=C2=A0 165142=C2=A0=C2=A0 =
175396=C2=A0=C2=A0 24156
> 23300
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4194304=C2=A0=C2=A0=C2=
=A0=C2=A0 512=C2=A0 136022=C2=A0 112711=C2=A0=C2=A0 171146=C2=A0=C2=A0 =
165466=C2=A0=C2=A0 36147
> 25698
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4194304=C2=A0=C2=A0=C2=
=A0 1024=C2=A0 140618=C2=A0 110196=C2=A0=C2=A0 153134=C2=A0=C2=A0 14892=
5=C2=A0=C2=A0 57498
> 39864
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4194304=C2=A0=C2=A0=C2=
=A0 2048=C2=A0 137110=C2=A0 108872=C2=A0=C2=A0 177201=C2=A0=C2=A0 19341=
6=C2=A0=C2=A0 98759
> 50106
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4194304=C2=A0=C2=A0=C2=
=A0 4096=C2=A0 138723=C2=A0 113352=C2=A0=C2=A0 130858=C2=A0=C2=A0 12994=
0=C2=A0=C2=A0 78636
> 64615
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4194304=C2=A0=C2=A0=C2=
=A0 8192=C2=A0 140100=C2=A0 114089=C2=A0=C2=A0 175240=C2=A0=C2=A0 16880=
7=C2=A0 109858
> 84656
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4194304=C2=A0=C2=A0 =
16384=C2=A0 130633=C2=A0 116475=C2=A0=C2=A0 131867=C2=A0=C2=A0 142958=C2=
=A0 115147
> 102795
>=20
>=20
> I was expecting a little faster sequential reads, but 191 MB/s is not
> too bad. I'm not sure why it decreases to 130-131 MB/s at larger
> record sizes.

I don't know why it would decrease either.  For sequential reads, read-=
ahead
should be scheduling all the read requests and that actual reads should=
 just
be waiting for the read-ahead to complete.  So there shouldn't be any
variability - clearly there is.  I wonder if it is an XFS thing....
care to try a different filesystem for comparison?  ext3?


>=20
> But the writes were disappointing. So the first thing I tried tuning
> was stripe_cache_size
>=20
> # echo 16384 > /sys/block/md0/md/stripe_cache_size
>=20
> I re-ran the iozone benchmark:
>=20
>                                                             random
> random
>               KB  reclen   write rewrite    read    reread    read   =
write
>          4194304      64  219206  264113   104751   108118    7240
> 12372
>          4194304     128  232713  255337   153990   142872   13209
> 21979
>          4194304     256  229446  242155   132753   131009   20858
> 32286
>          4194304     512  236389  245713   144280   149283   32024
> 44119
>          4194304    1024  234205  243135   141243   141604   53539
> 70459
>          4194304    2048  219163  224379   134043   131765   84428
> 90394
>          4194304    4096  226037  225588   143682   146620   60171
> 125360
>          4194304    8192  214487  231506   135311   140918   78868
> 156935
>          4194304   16384  210671  215078   138466   129098   96340
> 178073
>=20
> And now the sequential writes are quite satisfactory, but the reads
> are low. Next I tried 2560 for stipe_cache_size, since that is the 51=
2KB x 5
> stripe width.


That is very weird, as reads don't use the stripe cache at all - when
the array is not degraded and no overlapping writes are happening.

And the stripe_cache is measured in pages-per-device.  So 2560 means
2560*4k for each device. There are 3 data devices, so 30720K or 60 stri=
pes.

When you set stripe_cache_size to 16384, it would have consumed
 16384*5*4K =3D=3D 320Meg
or 1/3 of your available RAM.  This might have affected throughput,
I'm not sure.


> So the sequential reads at 200+ MB/s look okay (although I do not
> understand the huge throughput variability with record size), but the
> writes are not as high as with 16MB stripe cache. This may be the
> setting that I decide to stick with, but I would like to understand
> what is going on.

> Why did increasing the stripe cache from 256 KB to 16 MB decrease the
> sequential read speeds?

The only reason I can guess at is that you actually changed it from
from 5M to 320M, and maybe that affect available buffer memory?

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
