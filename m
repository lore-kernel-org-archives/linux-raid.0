Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9C1C43334
	for <linux-raid@archiver.kernel.org>; Tue, 14 Jun 2022 15:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiFNPW4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Jun 2022 11:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiFNPWx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Jun 2022 11:22:53 -0400
X-Greylist: delayed 68 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Jun 2022 08:22:24 PDT
Received: from UPDC19PA19.eemsg.mail.mil (UPDC19PA19.eemsg.mail.mil [214.24.27.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCE9114B
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 08:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1655220144; x=1686756144;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=wr3sRPS4fhiJBUcPAiv+hbT4S2trwctKd8vRtMWE/j8=;
  b=IHvEl4Tar5cXHunSHx2wztBUGS9DoGLngRSF5A/qnQM7a2JV4ZdRonsO
   OLTe6fbrmPYoZjsrqv4zbeuB0Kdsttsf7gpKRz6Gj+eLJEFXTY/iPeayu
   Hqu4wvoLlL2htXf0qHsvT7q2AhDDCJcg7LBkyAXwrPWutKoMsOS/chr5R
   efaCLU9gUSMp5dGST4Z551Y82adc0bhQ+euwn4Wv8itneULEA5d/3Zy2K
   ta1Ns8cvZn6FFV18wGqMc+WEKKJWC5vb1P3WEHqR6ulbd+KpZXz3Xc8Ar
   LYFGXhNqhuboybmu54EgwSYA2Y7cMHe3873rLDBdVbDhPs/2zqifcEzZB
   Q==;
X-EEMSG-check-017: 359127731|UPDC19PA19_ESA_OUT01.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.91,300,1647302400"; 
   d="scan'208";a="359127731"
Received: from edge-mech01.mail.mil ([214.21.130.103])
  by UPDC19PA19.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 14 Jun 2022 15:20:57 +0000
Received: from UMECHPAOM.easf.csd.disa.mil (214.21.130.40) by
 edge-mech01.mail.mil (214.21.130.103) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 14 Jun 2022 15:20:31 +0000
Received: from UMECHPA68.easf.csd.disa.mil ([169.254.4.207]) by
 umechpaom.easf.csd.disa.mil ([214.21.130.40]) with mapi id 14.03.0513.000;
 Tue, 14 Jun 2022 15:20:30 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
CC:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Subject: Mdraid resync
Thread-Topic: Mdraid resync
Thread-Index: Adh/+uu/lGZ7jHypSPWSPJrprm7RaA==
Date:   Tue, 14 Jun 2022 15:20:30 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A2389D45F51@UMECHPA68.easf.csd.disa.mil>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.44.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

All,
I had an active resync going on and I was peeking at the average request si=
ze and the queue size........I can understand  seeing the queue size multip=
lied by  the 4K IO size getting relatively close to the 512k chunk size of =
the array.   Might it be more efficient to have the resync process do resyn=
c I/Os  in "chunk size" increments?   =20


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.02    0.00   12.00    0.00    0.00   87.97

Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm =
 %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme7n1       277262.00    0.00 1109048.00      0.00     0.00     0.00   0.=
00   0.00    0.29    0.00  80.72     4.00     0.00   0.00  99.90
nvme2n1       277279.00    0.00 1109116.00      0.00     0.00     0.00   0.=
00   0.00    0.27    0.00  75.18     4.00     0.00   0.00  99.90
nvme0n1       277232.00    0.00 1108928.00      0.00     0.00     0.00   0.=
00   0.00    0.28    0.00  76.91     4.00     0.00   0.00  99.90
nvme4n1       277219.00    0.00 1108876.00      0.00     0.00     0.00   0.=
00   0.00    0.30    0.00  81.83     4.00     0.00   0.00 100.00
nvme1n1       277203.00    0.00 1108812.00      0.00     0.00     0.00   0.=
00   0.00    0.27    0.00  75.25     4.00     0.00   0.00 100.00
nvme5n1       277164.00    0.00 1108656.00      0.00     0.00     0.00   0.=
00   0.00    0.30    0.00  82.90     4.00     0.00   0.00  99.90
nvme6n1       277168.00    0.00 1108672.00      0.00     0.00     0.00   0.=
00   0.00    0.30    0.00  84.18     4.00     0.00   0.00  99.90
nvme3n1       277193.00    0.00 1108772.00      0.00     0.00     0.00   0.=
00   0.00    0.28    0.00  78.73     4.00     0.00   0.00  99.90
nvme8n1       277161.00    0.00 1108644.00      0.00     0.00     0.00   0.=
00   0.00    0.30    0.00  83.49     4.00     0.00   0.00  99.90
nvme9n1       277126.00    0.00 1108504.00      0.00     0.00     0.00   0.=
00   0.00    0.31    0.00  84.64     4.00     0.00   0.00  99.90
nvme10n1      277143.00    0.00 1108572.00      0.00     0.00     0.00   0.=
00   0.00    0.31    0.00  85.67     4.00     0.00   0.00  99.90
nvme11n1      277131.00    0.00 1108524.00      0.00     0.00     0.00   0.=
00   0.00    0.32    0.00  87.46     4.00     0.00   0.00  99.90

^C
[root@rebel00 rules.d]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]=20
md1 : active raid6 nvme12n1p1[0] nvme23n1p1[11] nvme22n1p1[10] nvme21n1p1[9=
] nvme20n1p1[8] nvme19n1p1[7] nvme18n1p1[6] nvme17n1p1[5] nvme16n1p1[4] nvm=
e15n1p1[3] nvme14n1p1[2] nvme13n1p1[1]
      37506037760 blocks super 1.2 level 6, 512k chunk, algorithm 2 [12/12]=
 [UUUUUUUUUUUU]
      bitmap: 0/28 pages [0KB], 65536KB chunk

md0 : active raid6 nvme0n1p1[0] nvme11n1p1[11] nvme10n1p1[10] nvme9n1p1[9] =
nvme8n1p1[8] nvme7n1p1[7] nvme6n1p1[6] nvme5n1p1[5] nvme4n1p1[4] nvme3n1p1[=
3] nvme2n1p1[2] nvme1n1p1[1]
      150027868160 blocks super 1.2 level 6, 512k chunk, algorithm 2 [12/12=
] [UUUUUUUUUUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D>............]  resync =3D 43.5% (6530712732=
/15002786816) finish=3D124.6min speed=3D1132744K/sec
      bitmap: 0/112 pages [0KB], 65536KB chunk

unused devices: <none>


I see resyncs running at 1.1GB/s and initial raid creations at around the s=
ame (maybe a bit less - in the 900MB/s range IIRC), should I be able to get=
 these number ultimately to the streaming read and random write abilities o=
f an SSD?   While looking at the benchmarks below, we don't seem to be limi=
ted by the processor:
model name	: AMD EPYC 7763 64-Core Processor
cpu MHz		: 3243.827
cache size	: 512 KB

localhost.localdomain kernel: raid6: avx2x4   gen() 36354 MB/s
localhost.localdomain kernel: raid6: avx2x4   xor()  5159 MB/s
localhost.localdomain kernel: raid6: avx2x2   gen() 34979 MB/s
localhost.localdomain kernel: raid6: avx2x2   xor() 31157 MB/s
localhost.localdomain kernel: raid6: avx2x1   gen() 24533 MB/s
localhost.localdomain kernel: raid6: avx2x1   xor() 25809 MB/s
localhost.localdomain kernel: raid6: sse2x4   gen() 20491 MB/s
localhost.localdomain kernel: raid6: sse2x4   xor()  2997 MB/s
localhost.localdomain kernel: raid6: sse2x2   gen() 17399 MB/s
localhost.localdomain kernel: raid6: sse2x2   xor() 16011 MB/s
localhost.localdomain kernel: raid6: sse2x1   gen()  1340 MB/s
localhost.localdomain kernel: raid6: sse2x1   xor() 13975 MB/s
localhost.localdomain kernel: raid6: using algorithm avx2x4 gen() 36354 MB/=
s
localhost.localdomain kernel: raid6: .... xor() 5159 MB/s, rmw enabled
localhost.localdomain kernel: raid6: using avx2x2 recovery algorithm


Am I doing anything silly with some base settings?   I can obviously crank =
up sync_speed_max, but I assume there is something else that limits me prio=
r to the 2GB/s I have it set to.....
SUBSYSTEM=3D=3D"block",ACTION=3D=3D"add|change",KERNEL=3D=3D"md*",\
	ATTR{md/sync_speed_max}=3D"2000000",\
	ATTR{md/group_thread_cnt}=3D"64",\
	ATTR{md/stripe_cache_size}=3D"8192",\
	ATTR{queue/nomerges}=3D"2",\
	ATTR{queue/nr_requests}=3D"1023",\
	ATTR{queue/rotational}=3D"0",\
	ATTR{queue/rq_affinity}=3D"2",\
	ATTR{queue/scheduler}=3D"none",\
	ATTR{queue/add_random}=3D"0",\
	ATTR{queue/max_sectors_kb}=3D"4096"

[root@rebel00 md]# cat chunk_size=20
524288
[root@rebel00 md]# cat sync_speed_max
2000000 (local)
[root@rebel00 md]# cat sync_max
max
[root@rebel00 md]# cat group_thread_cnt=20
64
[root@rebel00 md]# cat stripe_cache_size
8192

Regards,
Jim Finlayson
US Department of Defense
