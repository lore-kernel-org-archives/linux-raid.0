From: Joe Williams <jwilliams315@gmail.com>
Subject: increasing stripe_cache_size decreases RAID-6 read throughput
Date: Sat, 24 Apr 2010 16:36:20 -0700
Message-ID: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am new to mdadm, and I just set up an mdadm v3.1.2 RAID-6 of five 2
TB Samsung Spinpoint F3EGs. I created the RAID-6 with the default
parameters, including a 512 KB chunk size. It took about 6 hours to
initialize, then I created an XFS filesystem:

# mkfs.xfs -f -d su=3D512k,sw=3D3 -l su=3D256k -l lazy-count=3D1 -L rai=
dvol /dev/md0
meta-data=3D/dev/md0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 isize=3D=
256=A0=A0=A0 agcount=3D32, agsize=3D45776384 blks
=A0=A0=A0=A0=A0=A0=A0=A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 sectsz=3D512=A0=A0 attr=3D2
data=A0=A0=A0=A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 bsize=3D4096=A0=A0 blocks=3D1464843648, imaxpct=3D5
=A0=A0=A0=A0=A0=A0=A0=A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 sunit=3D128=A0=A0=A0 swidth=3D384 blks
naming=A0=A0 =3Dversion 2=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bsize=3D=
4096=A0=A0 ascii-ci=3D0
log=A0=A0=A0=A0=A0 =3Dinternal log=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bsize=3D=
4096=A0=A0 blocks=3D521728, version=3D2
=A0=A0=A0=A0=A0=A0=A0=A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 sectsz=3D512=A0=A0 sunit=3D64 blks, lazy-count=3D=
1
realtime =3Dnone=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
extsz=3D4096=A0=A0 blocks=3D0, rtextents=3D0

Note that 256k is the maximum allowed by mkfs.xfs for the log stripe un=
it.

Then it was time to optimize the performance. First I ran a benchmark
with the default settings (from a recent Arch linux install) for the
following parameters:

# cat /sys/block/md0/md/stripe_cache_size
256

# cat /sys/block/md0/queue/read_ahead_kb
3072
# cat /sys/block/sdb/queue/read_ahead_kb
128

# cat /sys/block/md0/queue/scheduler
none
# cat /sys/block/sdb/queue/scheduler
noop deadline [cfq]

# cat /sys/block/md0/queue/nr_requests
128
# cat /sys/block/sdb/queue/nr_requests
128

# cat /sys/block/md0/device/queue_depth
cat: /sys/block/md0/device/queue_depth: No such file or directory
# cat /sys/block/sdb/device/queue_depth
31

# cat /sys/block/md0/queue/max_sectors_kb
127
# cat /sys/block/sdb/queue/max_sectors_kb
512

Note that sdb is one of the 5 drives for the RAID volume, and the
other 4 have the same settings.

=46irst question, is it normal for the md0 scheduler to be "none"? I
cannot change it by writing, eg., "deadline" into the file.

Next question, is it normal for md0 to have no queue_depth setting?

Are there any other parameters that are important to performance that
I should be looking at?

I started the kernel with mem=3D1024M so that the buffer cache wasn't
too large (this machine has 72G of RAM), and ran an iozone benchmark:

=A0=A0=A0 Iozone: Performance Test of File I/O
=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 Version $Revision: 3.338 $
=A0=A0=A0 =A0=A0=A0 Compiled for 64 bit mode.
=A0=A0=A0 =A0=A0=A0 Build: linux-AMD64

=A0=A0=A0 Auto Mode
=A0=A0=A0 Using Minimum Record Size 64 KB
=A0=A0=A0 Using Maximum Record Size 16384 KB
=A0=A0=A0 File size set to 4194304 KB
=A0=A0=A0 Include fsync in write timing
=A0=A0=A0 Command line used: iozone -a -y64K -q16M -s4G -e -f iotest -i=
0 -i1 -i2
=A0=A0=A0 Output is in Kbytes/sec
=A0=A0=A0 Time Resolution =3D 0.000001 seconds.
=A0=A0=A0 Processor cache size set to 1024 Kbytes.
=A0=A0=A0 Processor cache line size set to 32 bytes.
=A0=A0=A0 File stride size set to 17 * record size.
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 random
random
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 KB=A0 reclen=A0=A0 write rewrit=
e=A0=A0=A0 read=A0=A0=A0 reread=A0=A0=A0 read=A0=A0 write
=A0=A0=A0=A0=A0=A0=A0=A0 4194304=A0=A0=A0=A0=A0 64=A0 133608=A0 114920=A0=
=A0 191367=A0=A0 191559=A0=A0=A0 7772
14718
=A0=A0=A0=A0=A0=A0=A0=A0 4194304=A0=A0=A0=A0 128=A0 142748=A0 113722=A0=
=A0 165832=A0=A0 161023=A0=A0 14055
20728
=A0=A0=A0=A0=A0=A0=A0=A0 4194304=A0=A0=A0=A0 256=A0 127493=A0 108110=A0=
=A0 165142=A0=A0 175396=A0=A0 24156
23300
=A0=A0=A0=A0=A0=A0=A0=A0 4194304=A0=A0=A0=A0 512=A0 136022=A0 112711=A0=
=A0 171146=A0=A0 165466=A0=A0 36147
25698
=A0=A0=A0=A0=A0=A0=A0=A0 4194304=A0=A0=A0 1024=A0 140618=A0 110196=A0=A0=
 153134=A0=A0 148925=A0=A0 57498
39864
=A0=A0=A0=A0=A0=A0=A0=A0 4194304=A0=A0=A0 2048=A0 137110=A0 108872=A0=A0=
 177201=A0=A0 193416=A0=A0 98759
50106
=A0=A0=A0=A0=A0=A0=A0=A0 4194304=A0=A0=A0 4096=A0 138723=A0 113352=A0=A0=
 130858=A0=A0 129940=A0=A0 78636
64615
=A0=A0=A0=A0=A0=A0=A0=A0 4194304=A0=A0=A0 8192=A0 140100=A0 114089=A0=A0=
 175240=A0=A0 168807=A0 109858
84656
=A0=A0=A0=A0=A0=A0=A0=A0 4194304=A0=A0 16384=A0 130633=A0 116475=A0=A0 =
131867=A0=A0 142958=A0 115147
102795


I was expecting a little faster sequential reads, but 191 MB/s is not
too bad. I'm not sure why it decreases to 130-131 MB/s at larger
record sizes.

But the writes were disappointing. So the first thing I tried tuning
was stripe_cache_size

# echo 16384 > /sys/block/md0/md/stripe_cache_size

I re-ran the iozone benchmark:

                                                            random
random
              KB  reclen   write rewrite    read    reread    read   wr=
ite
         4194304      64  219206  264113   104751   108118    7240
12372
         4194304     128  232713  255337   153990   142872   13209
21979
         4194304     256  229446  242155   132753   131009   20858
32286
         4194304     512  236389  245713   144280   149283   32024
44119
         4194304    1024  234205  243135   141243   141604   53539
70459
         4194304    2048  219163  224379   134043   131765   84428
90394
         4194304    4096  226037  225588   143682   146620   60171
125360
         4194304    8192  214487  231506   135311   140918   78868
156935
         4194304   16384  210671  215078   138466   129098   96340
178073

And now the sequential writes are quite satisfactory, but the reads
are low. Next I tried 2560 for stipe_cache_size, since that is


                                                            random
random
              KB  reclen   write rewrite    read    reread    read   wr=
ite
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
