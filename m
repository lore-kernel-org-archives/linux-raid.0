From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?bWQgcmFpZDUgcGVyZm9ybWFjZSA2eCBTU0QgUkFJRDU=?=
Date: Wed, 27 Nov 2013 21:48:22 +0800
Message-ID: <3c94e3bd-c74f-44ed-a1da-443b08edc43e@aliyun.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>	<1385369796.2076.16.camel@bews002.euractiv.com>	<5293EF32.9090301@hardwarefreak.com>	<20131126025210.GL8803@dastard>	<52941C5D.1000305@hardwarefreak.com> <20131126061458.GM8803@dastard>,529455CB.6050907@hardwarefreak.com
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 529455CB.6050907@hardwarefreak.com
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi=EF=BC=9Aall;
when I create raid5 which use six SSD(sTEC s840),
when the stripe_cache_size is set 4096.=20
root@host1:/sys/block/md126/md# cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
md126 : active raid5 sdg[6] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
      3906404480 blocks super 1.2 level 5, 128k chunk, algorithm 2 [6/6=
] [UUUUUU]

the single ssd read/write performance :

root@host1:~# dd if=3D/dev/sdb of=3D/dev/zero count=3D100000 bs=3D1M
^C76120+0 records in
76119+0 records out
79816556544 bytes (80 GB) copied, 208.278 s, 383 MB/s

root@host1:~# dd of=3D/dev/sdb if=3D/dev/zero count=3D100000 bs=3D1M
100000+0 records in
100000+0 records out
104857600000 bytes (105 GB) copied, 232.943 s, 450 MB/s

the raid read and write performance is  approx 1.8GB/s read and 1.1GB/s=
 write performance
root@sc0:/sys/block/md126/md# dd if=3D/dev/zero of=3D/dev/md126 count=3D=
100000 bs=3D1M
100000+0 records in
100000+0 records out
104857600000 bytes (105 GB) copied, 94.2039 s, 1.1 GB/s


root@sc0:/sys/block/md126/md# dd of=3D/dev/zero if=3D/dev/md126 count=3D=
100000 bs=3D1M
100000+0 records in
100000+0 records out
104857600000 bytes (105 GB) copied, 59.5551 s, 1.8 GB/s

why the performance is so bad?  especially the write performace.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
