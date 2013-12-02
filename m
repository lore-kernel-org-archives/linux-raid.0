From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?bWQgcmFpZDUgcGVyZm9ybWFjZSA2eCBTU0QgUkFJRDU=?=
Date: Mon, 02 Dec 2013 11:48:13 +0800
Message-ID: <2cd32253-a361-4c98-a7b4-f373a9959c39@aliyun.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com> <20131126061458.GM8803@dastard>,529455CB.6050907@hardwarefreak.com,3c94e3bd-c74f-44ed-a1da-443b08edc43e@aliyun.com <36ffd6f7-bfb0-4298-a18c-f45b07cab326@aliyun.com>,5296C98D.8000302@hardwarefreak.com,e93182b7-34a4-4a7c-8f78-e5dae83a3cae@aliyun.com
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: e93182b7-34a4-4a7c-8f78-e5dae83a3cae@aliyun.com
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>, stan <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

#1 will eventually be addressed with a multi-thread patch to the variou=
s RAID drivers including RAID5

what is the differences between the multi-thread patch and the CONFIG_M=
ULTICORE_RAID456?
=20
my understanding is CONFIG_MULTICORE_RAID456
 enum {
	STRIPE_OP_BIOFILL,
	STRIPE_OP_COMPUTE_BLK,
	STRIPE_OP_PREXOR,
	STRIPE_OP_BIODRAIN,
	STRIPE_OP_RECONSTRUCT,
	STRIPE_OP_CHECK,
};  this operations  in a stripe can be schedule to other CPU to run,

while  multi-thread patch  mainly modify lock contention of thread, thi=
s understanding is correct?=20

------------------------------------------------------------------
=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B411=E6=9C=8828=
=E6=97=A5(=E6=98=9F=E6=9C=9F=E5=9B=9B) 19:54
=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Astan <stan@hardwarefreak.com>; Linu=
x RAID <linux-raid@vger.kernel.org>
=E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9A=E7=AD=94=E5=A4=8D=EF=BC=9A=E7=AD=94=
=E5=A4=8D=EF=BC=9Amd raid5 performace 6x SSD RAID5

I have change stripe cache size from   4096 stripe cache to  8192, the =
test result show the performance improve <5%, maybe The effect is not v=
ery obvious=E3=80=82


------------------------------------------------------------------
=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9AStan Hoeppner <stan@hardwarefreak.c=
om>
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B411=E6=9C=8828=
=E6=97=A5(=E6=98=9F=E6=9C=9F=E5=9B=9B) 12:41
=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>; Lin=
ux RAID <linux-raid@vger.kernel.org>
=E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9ARe: =E7=AD=94=E5=A4=8D=EF=BC=9Amd r=
aid5 performace 6x SSD RAID5

On 11/27/2013 7:51 AM, lilofile wrote:
> additional: CPU: Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
>                 memory:32GB
=2E..
> when I create raid5 which use six SSD(sTEC s840),
> when the stripe_cache_size is set 4096.=20
> root@host1:/sys/block/md126/md# cat /proc/mdstat=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]=20
> md126 : active raid5 sdg[6] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
>       3906404480 blocks super 1.2 level 5, 128k chunk, algorithm 2 [6=
/6] [UUUUUU]
>=20
> the single ssd read/write performance :
>=20
> root@host1:~# dd if=3D/dev/sdb of=3D/dev/zero count=3D100000 bs=3D1M
> ^C76120+0 records in
> 76119+0 records out
> 79816556544 bytes (80 GB) copied, 208.278 s, 383 MB/s
>=20
> root@host1:~# dd of=3D/dev/sdb if=3D/dev/zero count=3D100000 bs=3D1M
> 100000+0 records in
> 100000+0 records out
> 104857600000 bytes (105 GB) copied, 232.943 s, 450 MB/s
>=20
> the raid read and write performance is  approx 1.8GB/s read and 1.1GB=
/s write performance
> root@sc0:/sys/block/md126/md# dd if=3D/dev/zero of=3D/dev/md126 count=
=3D100000 bs=3D1M
> 100000+0 records in
> 100000+0 records out
> 104857600000 bytes (105 GB) copied, 94.2039 s, 1.1 GB/s
>=20
>=20
> root@sc0:/sys/block/md126/md# dd of=3D/dev/zero if=3D/dev/md126 count=
=3D100000 bs=3D1M
> 100000+0 records in
> 100000+0 records out
> 104857600000 bytes (105 GB) copied, 59.5551 s, 1.8 GB/s
>=20
> why the performance is so bad?  especially the write performace.

There are 3 things that could be, or are, limiting performance here.

1.  The RAID5 write thread peaks one CPU core as it is single threaded
2.  A 4KB stripe cache is too small for 6 SSDs, try 8KB
3.  dd issues IOs serially and will thus never saturate the hardware

#1 will eventually be addressed with a multi-thread patch to the variou=
s
RAID drivers including RAID5.  There is no workaround at this time.

To address #3 use FIO or a similar testing tool that can issue IOs in
parallel.  With SSD based storage you will never reach maximum
throughput with a serial data stream.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
