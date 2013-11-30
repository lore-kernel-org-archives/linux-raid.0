From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?562U5aSN77ya562U5aSN77ya562U5aSN77yabWQgcmFpZDUgcmFuZG9tIHBlcmZvcm1hY2Ug?=
  =?UTF-8?B?NnggU1NEIFJBSUQ1?=
Date: Sat, 30 Nov 2013 22:12:35 +0800
Message-ID: <b76f02a4-b751-4533-81ba-1c73aa65e4b4@aliyun.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com> <20131126061458.GM8803@dastard>,529455CB.6050907@hardwarefreak.com,3c94e3bd-c74f-44ed-a1da-443b08edc43e@aliyun.com <36ffd6f7-bfb0-4298-a18c-f45b07cab326@aliyun.com>,5296C98D.8000302@hardwarefreak.com <fa7f0ec0-e7ba-46ca-a129-24bb45b52460@aliyun.com>,5297FE1C.6080504@hardwarefreak.com
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 5297FE1C.6080504@hardwarefreak.com
Sender: linux-raid-owner@vger.kernel.org
To: stan <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

thanks.  now i use fio to test random write performance
why the random write performance is so low, 6X SSD , 4k IOPS write rand=
om only 55097?  when I use FIO,the single SSD random 4k write reach to =
3.5W.

root@host0:/# fio -filename=3D/dev/md0     -iodepth=3D16 -thread -rw=3D=
randwrite -ioengine=3Dlibaio -bs=3D4k -size=3D30G  -numjobs=3D10 -runti=
me=3D1000 -group_reporting -name=3Dmytest=20
mytest: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, i=
odepth=3D16
=2E..
mytest: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, i=
odepth=3D16
fio 1.59
Starting 10 threadsJobs: 1 (f=3D1): [____w_____] [68.3% done] [0K/0K /s=
] [0 /0  iops] [eta 07m:53s]       s]
mytest: (groupid=3D0, jobs=3D10): err=3D 0: pid=3D6099
  write: io=3D215230MB, bw=3D220392KB/s, iops=3D55097 , runt=3D1000019m=
sec
    slat (usec): min=3D1 , max=3D337733 , avg=3D176.46, stdev=3D2623.23
    clat (usec): min=3D4 , max=3D540048 , avg=3D2667.83, stdev=3D10078.=
16
     lat (usec): min=3D40 , max=3D576049 , avg=3D2844.42, stdev=3D10399=
=2E30
    bw (KB/s) : min=3D    0, max=3D1100192, per=3D10.22%, avg=3D22514.4=
8, stdev=3D17262.85
  cpu          : usr=3D6.70%, sys=3D16.48%, ctx=3D11656865, majf=3D46, =
minf=3D1626216
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D100.0%, 3=
2=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.1%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D0/55098999/0, short=3D0/0/0
     lat (usec): 10=3D0.01%, 50=3D41.01%, 100=3D50.01%, 250=3D1.23%, 50=
0=3D0.42%
     lat (usec): 750=3D0.02%, 1000=3D0.01%
     lat (msec): 2=3D0.01%, 4=3D0.01%, 10=3D0.05%, 20=3D0.16%, 50=3D6.5=
8%
     lat (msec): 100=3D0.44%, 250=3D0.05%, 500=3D0.01%, 750=3D0.01%

Run status group 0 (all jobs):
  WRITE: io=3D215230MB, aggrb=3D220391KB/s, minb=3D225681KB/s, maxb=3D2=
25681KB/s, mint=3D1000019msec, maxt=3D1000019msec

Disk stats (read/write):
  md0: ios=3D167/49755890, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=
=3D0.00%, aggrios=3D12530125/13199536, aggrmerge=3D1151802/1283069, agg=
rticks=3D14762174/11503916, aggrin_queue=3D26230996, aggrutil=3D95.56%
    sdh: ios=3D12519812/13192529, merge=3D1157990/1291154, ticks=3D1185=
4444/8141456, in_queue=3D19960416, util=3D90.19%
    sdi: ios=3D12524619/13201735, merge=3D1158477/1280984, ticks=3D1216=
1064/8308572, in_queue=3D20436280, util=3D90.56%
    sdj: ios=3D12526628/13210796, merge=3D1155512/1274875, ticks=3D1207=
4040/8250524, in_queue=3D20289960, util=3D90.63%
    sdk: ios=3D12534367/13213646, merge=3D1148527/1268088, ticks=3D1237=
2792/8455368, in_queue=3D20791752, util=3D90.81%
    sdl: ios=3D12534777/13205894, merge=3D1147263/1275381, ticks=3D1263=
2824/8728444, in_queue=3D21325724, util=3D90.86%
    sdm: ios=3D12540551/13172620, merge=3D1143048/1307937, ticks=3D2747=
7880/27139136, in_queue=3D54581844, util=3D95.56%





------------------------------------------------------------------
=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9AStan Hoeppner <stan@hardwarefreak.c=
om>
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B411=E6=9C=8829=
=E6=97=A5(=E6=98=9F=E6=9C=9F=E4=BA=94) 10:38
=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>; Lin=
ux RAID <linux-raid@vger.kernel.org>
=E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9ARe: =E7=AD=94=E5=A4=8D=EF=BC=9A=E7=AD=
=94=E5=A4=8D=EF=BC=9Amd raid5 performace 6x SSD RAID5

On 11/28/2013 4:02 AM, lilofile wrote:
> thank you  for your advise. now I have test multi-thread patch, the s=
ingle raid5 performance improve 30%.
>=20
> but I have another problem,when write on single raid,write performanc=
e is  approx 1.1GB/s=20
=2E..
> [1]-  Done                    dd if=3D/dev/zero of=3D/dev/md126 count=
=3D100000 bs=3D1M
> [2]+  Done                    dd if=3D/dev/zero of=3D/dev/md127 count=
=3D100000 bs=3D1M

No.  This is not a parallel IO test.

=2E..
> To address #3 use FIO or a similar testing tool that can issue IOs in
> parallel.  With SSD based storage you will never reach maximum
> throughput with a serial data stream.

This is a parallel IO test, one command line:

~# fio --directory=3D/dev/md126 --zero_buffers --numjobs=3D16
--group_reporting --blocksize=3D64k --ioengine=3Dlibaio --iodepth=3D16
--direct=3D1 --size=3D64g --name=3Dread --rw=3Dread --stonewall --name=3D=
write
--rw=3Dwrite --stonewall

Normally this targets a filesystem, not a raw block device.  This
command line should work for a raw md device.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
