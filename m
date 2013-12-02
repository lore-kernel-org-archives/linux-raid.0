From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: md raid5 performace 6x SSD RAID5
Date: Sun, 01 Dec 2013 23:51:36 -0600
Message-ID: <529C1FE8.90806@hardwarefreak.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com> <20131126061458.GM8803@dastard>,529455CB.6050907@hardwarefreak.com,3c94e3bd-c74f-44ed-a1da-443b08edc43e@aliyun.com <36ffd6f7-bfb0-4298-a18c-f45b07cab326@aliyun.com>,5296C98D.8000302@hardwarefreak.com,e93182b7-34a4-4a7c-8f78-e5dae83a3cae@aliyun.com <2cd32253-a361-4c98-a7b4-f373a9959c39@aliyun.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2cd32253-a361-4c98-a7b4-f373a9959c39@aliyun.com>
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>, Linux RAID <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On 12/1/2013 9:48 PM, lilofile wrote:
> #1 will eventually be addressed with a multi-thread patch to the vari=
ous RAID drivers including RAID5
>=20
> what is the differences between the multi-thread patch and the CONFIG=
_MULTICORE_RAID456?

I can't find the original description for that option, but I can tell
you that:

1.  It was experimental
2.  Neil Brown requested its complete removal from git in March 2013:

http://permalink.gmane.org/gmane.linux.kernel.commits.head/372527

> my understanding is CONFIG_MULTICORE_RAID456
>  enum {
> 	STRIPE_OP_BIOFILL,
> 	STRIPE_OP_COMPUTE_BLK,
> 	STRIPE_OP_PREXOR,
> 	STRIPE_OP_BIODRAIN,
> 	STRIPE_OP_RECONSTRUCT,
> 	STRIPE_OP_CHECK,
> };  this operations  in a stripe can be schedule to other CPU to run,
>=20
> while  multi-thread patch  mainly modify lock contention of thread, t=
his understanding is correct?=20

Shaohua Li has been working on multi-threaded md drivers to fix the CPU
bottleneck with SSD storage for some time now.  He's currently focusing
on raid5.c.  See:
http://lwn.net/Articles/500200/
http://www.spinics.net/lists/raid/msg44699.html

AFAIK this work is not yet fully completed nor thoroughly tested, nor
included in a stable release.  Shaohua, could you give us a quick updat=
e
on the status of your RAID5 multi-thread work?  Demand for it seems to
be steeply increasing recently, this current thread, and another last
week with slow RAID10 on the new hybrid SSD/rust drives.

> ------------------------------------------------------------------
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B411=E6=9C=88=
28=E6=97=A5(=E6=98=9F=E6=9C=9F=E5=9B=9B) 19:54
> =E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Astan <stan@hardwarefreak.com>; Li=
nux RAID <linux-raid@vger.kernel.org>
> =E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9A=E7=AD=94=E5=A4=8D=EF=BC=9A=E7=AD=
=94=E5=A4=8D=EF=BC=9Amd raid5 performace 6x SSD RAID5
>=20
> I have change stripe cache size from   4096 stripe cache to  8192, th=
e test result show the performance improve <5%, maybe The effect is not=
 very obvious=E3=80=82

IIRC, this was before you started testing with FIO.  I'd really like to
see your streaming read/write results of FIO with the command line I
gave you, for each of these 3 stripe_cache_size values.  BTW, you don't
need to set a timer.  The size=3D30G limits the test to 30GB.  I chose
this value because the test runs should only take 15s at this size.  Go
any smaller and it makes capturing accurate data more difficult.

The reason for running the streaming tests is that it eliminates the RM=
W
code path and any associated latencies you get with the random write
test.  The command line I gave you should give us an idea of the peak
streaming read/write throughput of your SSD RAID5 array with the only
limitation being single core performance.

To discover how much CPU is being burned, concurrently with each FIO
test, execute the following as well once FIO initialization is complete
and the actual read/write tests begin.  This will show us what your CPU
consumption looks like and if you're hitting the single core ceiling
with the md write thread.  This will give you 20 seconds of CPU stats
polled every .5s:

~# top -b -n 40 -d 0.5 |grep Cpu|mawk '{print ($1,$3,$4) }'

This will generate a lot of output.  Piping through mawk will clean thi=
s
up making it easier to see which CPU is running the md write thread
during your write tests.  The FIO threads will execute in user space,
the md write thread in system space.  You won't see one core peaking
during read tests as any/all CPUs may be used.

Which kernel version are you using?  I don't recall you saying.  With
later kernels IIRC the parity calculations are offloaded to another
thread, so you may see high load on two cores.

> ------------------------------------------------------------------
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9AStan Hoeppner <stan@hardwarefreak=
=2Ecom>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B411=E6=9C=88=
28=E6=97=A5(=E6=98=9F=E6=9C=9F=E5=9B=9B) 12:41
> =E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>; L=
inux RAID <linux-raid@vger.kernel.org>
> =E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9ARe: =E7=AD=94=E5=A4=8D=EF=BC=9Amd=
 raid5 performace 6x SSD RAID5
>=20
> On 11/27/2013 7:51 AM, lilofile wrote:
>> additional: CPU: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
>>                 memory:32GB
> ...
>> when I create raid5 which use six SSD(sTEC s840),
>> when the stripe_cache_size is set 4096.=20
>> root@host1:/sys/block/md126/md# cat /proc/mdstat=20
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=
 [raid4] [raid10]=20
>> md126 : active raid5 sdg[6] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
>>       3906404480 blocks super 1.2 level 5, 128k chunk, algorithm 2 [=
6/6] [UUUUUU]
>>
>> the single ssd read/write performance :
>>
>> root@host1:~# dd if=3D/dev/sdb of=3D/dev/zero count=3D100000 bs=3D1M
>> ^C76120+0 records in
>> 76119+0 records out
>> 79816556544 bytes (80 GB) copied, 208.278 s, 383 MB/s
>>
>> root@host1:~# dd of=3D/dev/sdb if=3D/dev/zero count=3D100000 bs=3D1M
>> 100000+0 records in
>> 100000+0 records out
>> 104857600000 bytes (105 GB) copied, 232.943 s, 450 MB/s
>>
>> the raid read and write performance is  approx 1.8GB/s read and 1.1G=
B/s write performance
>> root@sc0:/sys/block/md126/md# dd if=3D/dev/zero of=3D/dev/md126 coun=
t=3D100000 bs=3D1M
>> 100000+0 records in
>> 100000+0 records out
>> 104857600000 bytes (105 GB) copied, 94.2039 s, 1.1 GB/s
>>
>>
>> root@sc0:/sys/block/md126/md# dd of=3D/dev/zero if=3D/dev/md126 coun=
t=3D100000 bs=3D1M
>> 100000+0 records in
>> 100000+0 records out
>> 104857600000 bytes (105 GB) copied, 59.5551 s, 1.8 GB/s
>>
>> why the performance is so bad?  especially the write performace.
>=20
> There are 3 things that could be, or are, limiting performance here.
>=20
> 1.  The RAID5 write thread peaks one CPU core as it is single threade=
d
> 2.  A 4KB stripe cache is too small for 6 SSDs, try 8KB
> 3.  dd issues IOs serially and will thus never saturate the hardware
>=20
> #1 will eventually be addressed with a multi-thread patch to the vari=
ous
> RAID drivers including RAID5.  There is no workaround at this time.
>=20
> To address #3 use FIO or a similar testing tool that can issue IOs in
> parallel.  With SSD based storage you will never reach maximum
> throughput with a serial data stream.
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
