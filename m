Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252B1C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jan 2022 16:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349847AbiAKQLQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jan 2022 11:11:16 -0500
Received: from UPDC19PA20.eemsg.mail.mil ([214.24.27.195]:45102 "EHLO
        UPDC19PA20.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349848AbiAKQLP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jan 2022 11:11:15 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 11:11:15 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1641917475; x=1673453475;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=CA6MgLpqweTpTNiKEoOq0v6ViHOcS4opg/AZfo7qa6w=;
  b=NzDyvLVlDH8uu87P0yNzmmgSe8e9QJukBJh0lD6lxe7nlYvPf0ETUoiQ
   AD2rhWNkXMFhZh66EQwv3h/pYaeBB3Tn2qLnFeIfpuBTymn4UJy4pcddl
   WRzrpIaSa5hfey2BlcNADabcOsARv1Q8BHk2phopg4iK6LLAQOcQsvrOF
   Q8a4x0CieOd5huL5hVMKgxcECq1K4elcbmlztwoGr4M/Z0S/KtSaOa369
   ZbHobb0UNzCLHNra68uq/V8Q0rJc2803Bua1+uAN8iOgcvki5fhGv7R9S
   LznWXqMgcW9zOBjfWNbrJr8KJTqY7o86yhr2fe/P3anZM3j8wSZjfJcgg
   A==;
X-EEMSG-check-017: 306541830|UPDC19PA20_ESA_OUT02.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.88,279,1635206400"; 
   d="scan'208";a="306541830"
Received: from edge-mech02.mail.mil ([214.21.130.229])
  by UPDC19PA20.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 11 Jan 2022 16:03:53 +0000
Received: from UMECHPAOZ.easf.csd.disa.mil (214.21.130.169) by
 edge-mech02.mail.mil (214.21.130.229) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 11 Jan 2022 16:03:05 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.86]) by
 umechpaoz.easf.csd.disa.mil ([214.21.130.169]) with mapi id 14.03.0513.000;
 Tue, 11 Jan 2022 16:03:05 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: MDRAID NVMe performance question, but I don't know what I don't
 know 
Thread-Topic: MDRAID NVMe performance question, but I don't know what I
 don't know 
Thread-Index: AdgHBLe7oDH1OEXSR92W1elMlXHuIw==
Date:   Tue, 11 Jan 2022 16:03:05 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A238926397D@UMECHPA7B.easf.csd.disa.mil>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.44.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
Sorry this is a long read.   If you want to get to the gist of it, look for=
 "<KEY>" for key points.   I'm having some issues with where to find inform=
ation to troubleshoot mdraid performance issues.   The latest "rathole" I'm=
 going down is that I have two identically configured mdraids, 1 per NUMA n=
ode on a dual socket AMD Rome with "numas per socket" set to 1 in the BIOS.=
   Things are cranking with a 64K blocksize but I have a substantial dispar=
ity between NUMA0's mdraid and NUMA1's.    =20

[root@hornet04 block]# uname -r
<KEY> 5.15.13-1.el8.elrepo.x86_64

<KEY>  [root@hornet04 block]# cat /proc/mdstat  (md127 is NUMA 0, md126 is =
NUMA 1).
Personalities : [raid6] [raid5] [raid4]=20
md126 : active raid5 nvme22n1p1[10] nvme20n1p1[7] nvme21n1p1[8] nvme18n1p1[=
5] nvme19n1p1[6] nvme17n1p1[4] nvme15n1p1[3] nvme14n1p1[2] nvme12n1p1[0] nv=
me13n1p1[1]
      135007147008 blocks super 1.2 level 5, 128k chunk, algorithm 2 [10/10=
] [UUUUUUUUUU]
      bitmap: 0/112 pages [0KB], 65536KB chunk

md127 : active raid5 nvme9n1p1[10] nvme8n1p1[8] nvme7n1p1[7] nvme6n1p1[6] n=
vme5n1p1[5] nvme3n1p1[3] nvme4n1p1[4] nvme2n1p1[2] nvme1n1p1[1] nvme0n1p1[0=
]
      135007147008 blocks super 1.2 level 5, 128k chunk, algorithm 2 [10/10=
] [UUUUUUUUUU]
      bitmap: 0/112 pages [0KB], 65536KB chunk

unused devices: <none>


I'm running numa aware identical FIOs, but getting the following in iostat =
(numa 0 mdraid, outperforms numa 1 mdraid by 12GB/s)

[root@hornet04 ~]#  iostat -xkz 1=20
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.20    0.00    3.35    0.00    0.00   96.45

Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm =
 %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme2c2n1     72856.00    0.00 4662784.00      0.00     0.00     0.00   0.0=
0   0.00    0.68    0.00  49.50    64.00     0.00   0.01 100.00
nvme3c3n1     73077.00    0.00 4676928.00      0.00     0.00     0.00   0.0=
0   0.00    0.68    0.00  49.94    64.00     0.00   0.01 100.00
nvme4c4n1     73013.00    0.00 4672896.00      0.00     0.00     0.00   0.0=
0   0.00    0.69    0.00  50.35    64.00     0.00   0.01 100.00
<KEY> nvme18c18n1   54384.00    0.00 3480576.00      0.00     0.00     0.00=
   0.00   0.00  144.80    0.00 7874.85    64.00     0.00   0.02 100.00
nvme5c5n1     72841.00    0.00 4661824.00      0.00     0.00     0.00   0.0=
0   0.00    0.70    0.00  51.01    64.00     0.00   0.01 100.00
nvme7c7n1     72220.00    0.00 4622080.00      0.00     0.00     0.00   0.0=
0   0.00    0.67    0.00  48.61    64.00     0.00   0.01 100.00
nvme22c22n1   54652.00    0.00 3497728.00      0.00     0.00     0.00   0.0=
0   0.00    0.64    0.00  34.73    64.00     0.00   0.02 100.00
nvme12c12n1   54756.00    0.00 3504384.00      0.00     0.00     0.00   0.0=
0   0.00    0.66    0.00  36.34    64.00     0.00   0.02 100.00
nvme14c14n1   54517.00    0.00 3489088.00      0.00     0.00     0.00   0.0=
0   0.00    0.65    0.00  35.66    64.00     0.00   0.02 100.00
nvme6c6n1     72721.00    0.00 4654144.00      0.00     0.00     0.00   0.0=
0   0.00    0.68    0.00  49.77    64.00     0.00   0.01 100.00
nvme21c21n1   54731.00    0.00 3502784.00      0.00     0.00     0.00   0.0=
0   0.00    0.67    0.00  36.46    64.00     0.00   0.02 100.00
nvme9c9n1     72661.00    0.00 4650304.00      0.00     0.00     0.00   0.0=
0   0.00    0.71    0.00  51.35    64.00     0.00   0.01 100.00
nvme17c17n1   54462.00    0.00 3485568.00      0.00     0.00     0.00   0.0=
0   0.00    0.66    0.00  36.09    64.00     0.00   0.02 100.00
nvme20c20n1   54463.00    0.00 3485632.00      0.00     0.00     0.00   0.0=
0   0.00    0.66    0.00  36.10    64.00     0.00   0.02 100.10
nvme13c13n1   54910.00    0.00 3514240.00      0.00     0.00     0.00   0.0=
0   0.00    0.61    0.00  33.45    64.00     0.00   0.02 100.00
nvme8c8n1     72622.00    0.00 4647808.00      0.00     0.00     0.00   0.0=
0   0.00    0.67    0.00  48.52    64.00     0.00   0.01 100.00
nvme15c15n1   54543.00    0.00 3490752.00      0.00     0.00     0.00   0.0=
0   0.00    0.61    0.00  33.28    64.00     0.00   0.02 100.00
nvme0c0n1     73215.00    0.00 4685760.00      0.00     0.00     0.00   0.0=
0   0.00    0.67    0.00  49.41    64.00     0.00   0.01 100.00
nvme19c19n1   55034.00    0.00 3522176.00      0.00     0.00     0.00   0.0=
0   0.00    0.67    0.00  36.93    64.00     0.00   0.02 100.10
<KEY> nvme1c1n1     72672.00    0.00 4650944.00      0.00     0.00     0.00=
   0.00   0.00  106.98    0.00 7774.54    64.00     0.00   0.01 100.00
<KEY> md127         727871.00    0.00 46583744.00      0.00     0.00     0.=
00   0.00   0.00   11.30    0.00 8221.92    64.00     0.00   0.00 100.00
<KEY> md126         546553.00    0.00 34979392.00      0.00     0.00     0.=
00   0.00   0.00   14.99    0.00 8194.91    64.00     0.00   0.00 100.10


<KEY> I started chasing the aqu_sz and r_await to see if I have a device is=
sue or if these are known mdraid "features" when I started to try to find t=
he kernel workers and start chasing kernel workers when it became apparent =
to me that I DON'T KNOW WHAT I'M DOING OR WHAT TO DO NEXT. Any guidance is =
appreciated.  Given 1 drive per NUMA is showing the bad behavior, I'm reluc=
tant to point the finger at hardware.


[root@hornet04 ~]# lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              256
On-line CPU(s) list: 0-255
Thread(s) per core:  2
Core(s) per socket:  64
Socket(s):           2
NUMA node(s):        2
Vendor ID:           AuthenticAMD
BIOS Vendor ID:      Advanced Micro Devices, Inc.
CPU family:          23
Model:               49
Model name:          AMD EPYC 7742 64-Core Processor
BIOS Model name:     AMD EPYC 7742 64-Core Processor               =20
Stepping:            0
CPU MHz:             3243.803
BogoMIPS:            4491.53
Virtualization:      AMD-V
L1d cache:           32K
L1i cache:           32K
L2 cache:            512K
L3 cache:            16384K
<KEY> NUMA node0 CPU(s):   0-63,128-191
<KEY>  NUMA node1 CPU(s):   64-127,192-255
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge m=
ca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt p=
dpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid a=
perfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 x2apic mo=
vbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_leg=
acy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext per=
fctr_core perfctr_nb bpext perfctr_llc mwaitx cpb cat_l3 cdp_l3 hw_pstate s=
sbd mba ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 cqm rdt_a rdse=
ed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves cqm_llc c=
qm_occup_llc cqm_mbm_total cqm_mbm_local clzero irperf xsaveerptr rdpru wbn=
oinvd amd_ppin arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushb=
yasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif v_spe=
c_ctrl umip rdpid overflow_recov succor smca


<KEY> When I start doing some basic debugging - not a Linux ninja by far, I=
 see the following, but what is throwing me is seeing (at least these worke=
rs that I suspect have to do with md, all running on NUMA node 1.   This is=
 catching me by surprise.   Are there other workers that I'm missing?????

ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan:14,comm | head =
-1; ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan:14,comm  | =
egrep 'md|raid' | grep -v systemd | grep -v mlx
    PID     TID CLS RTPRIO  NI PRI NUMA PSR %CPU STAT WCHAN          COMMAN=
D
   1522    1522 TS       -   5  14    1 208  0.0 SN   -              ksmd
   1590    1590 TS       - -20  39    1 220  0.0 I<   -              md
   3688    3688 TS       - -20  39    1 198  0.0 I<   -              raid5w=
q
   3693    3693 TS       -   0  19    1 234  0.0 S    -              md126_=
raid5
   3694    3694 TS       -   0  19    1  95  0.0 S    -              md127_=
raid5
   3788    3788 TS       -   0  19    1 240  0.0 Ss   -              lsmdca=
t /



Jim Finlayson
U.S. Department of Defense

