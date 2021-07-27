Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B812DC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 20:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9473660F9D
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 20:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhG0Uj4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:39:56 -0400
Received: from UPDC19PA23.eemsg.mail.mil ([214.24.27.198]:22298 "EHLO
        UPDC19PA23.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhG0Ujz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Jul 2021 16:39:55 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jul 2021 16:39:53 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1627418394; x=1658954394;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=hKacpADz5uzhO/PhoLaZeDV35tmAZnfB2Q93KlI4oI8=;
  b=PNmTc8xXghSAoDZIJ7FBEmGHJyypkWR3p9Dluu3TBKsC+wg5ccDlh6hA
   zg+i75tnWWJxthZg37MxCmySdkHDhOfq8XvyOs0eJE9YpKkngCkDxnBy6
   XOm3B04n1LpTufeBjoDb7QtdmuIHrLU1Noz3Rf84minAoXIwqmwiE70qE
   jCqa9dyQvyJiN20l3Gi0DrpgFF0m5wfPQvruRC4CZSjNhcrjMCEHQR8Zz
   puvZHtQoYlGDe1KDbR1z6IYaCz6P3RtoLAh7B4xH9fXVYnjUv+9IrkXJp
   CJ4HgfwURG0gdjDk782byFY6yoShmvTJRiRuTpn1ghL2aIljV7krK2Qss
   Q==;
X-EEMSG-check-017: 248072536|UPDC19PA23_ESA_OUT05.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.84,274,1620691200"; 
   d="scan'208";a="248072536"
Received: from edge-mech02.mail.mil ([214.21.130.228])
  by UPDC19PA23.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 27 Jul 2021 20:32:41 +0000
Received: from UMECHPAOW.easf.csd.disa.mil (214.21.130.166) by
 edge-mech02.mail.mil (214.21.130.228) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 27 Jul 2021 20:32:02 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.97]) by
 umechpaow.easf.csd.disa.mil ([214.21.130.166]) with mapi id 14.03.0513.000;
 Tue, 27 Jul 2021 20:32:02 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
CC:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Subject: Can't get RAID5/RAID6  NVMe randomread  IOPS - AMD ROME what am I
 missing?????
Thread-Topic: Can't get RAID5/RAID6  NVMe randomread  IOPS - AMD ROME what
 am I missing?????
Thread-Index: AdeDJj2b8zw2PAVtRTa42ky+28JFyg==
Date:   Tue, 27 Jul 2021 20:32:00 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.44.12]
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sorry, this will be a long email with everything I find to be relevant, but=
 I can get over 110GB/s of 4kB random reads from individual NVMe SSDs, but =
I'm at a loss why mdraid can only do a very small  fraction of it.   I'm at=
 my "organizational world record" for sustained IOPS, but I need protected =
IOPS to do something useful.     This is everything I do to a server to mak=
e the I/O crank.....My role is that of a lab researcher/resident expert/con=
sultant.   I'm just stumped why I can't do better.   If there is a fine man=
ual that somebody can point me to, I'm happy to read it.......

I have tried both RAID5 and RAID6 trying to be highly cognizant of NUMAness=
.    The ROME is set to numas per socket to 1 and the BIOS is set to maximi=
ze infinity fabric performance and pcie performance via AMD's white papers.=
   NVMe drives are all Gen4 (I believe HPE rebadged SAMSUNG 1733a? - I can =
get the drives doing 1.45M 4KB random reads  each if I try hard.

Everything I can think to share:

[root@<server> <server>]# cat /etc/redhat-release=20
Red Hat Enterprise Linux release 8.4 (Ootpa)
[root@<server> <server>]# uname -r
4.18.0-305.el8.x86_64

root@<server> ~]# modinfo raid6
filename:       /lib/modules/4.18.0-305.el8.x86_64/kernel/drivers/md/raid45=
6.ko.xz
alias:          raid6
alias:          raid5
alias:          md-level-6
alias:          md-raid6
alias:          md-personality-8
alias:          md-level-4
alias:          md-level-5
alias:          md-raid4
alias:          md-raid5
alias:          md-personality-4
description:    RAID4/5/6 (striping with parity) personality for MD
license:        GPL
rhelversion:    8.4
srcversion:     FE86A53E1C1CDAE8F972CBA
depends:        async_raid6_recov,async_pq,libcrc32c,raid6_pq,async_tx,asyn=
c_memcpy,async_xor
intree:         Y
name:           raid456
vermagic:       4.18.0-305.el8.x86_64 SMP mod_unload modversions=20
sig_id:         PKCS#7
signer:         Red Hat Enterprise Linux kernel signing key

[root@<server> ~]# lsblk
NAME         MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
nvme16n1     259:0    0   1.8T  0 disk =20
=86=80nvme16n1p1 259:1    0   512M  0 part  /boot/efi
=86=80nvme16n1p2 259:2    0   512M  0 part  /boot
=86=80nvme16n1p3 259:3    0  49.4G  0 part  [SWAP]
=84=80nvme16n1p4 259:4    0   1.7T  0 part  /
nvme0n1      259:5    0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme1n1      259:6    0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme2n1      259:7    0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme3n1      259:8    0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme7n1      259:9    0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme11n1     259:10   0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme10n1     259:11   0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme14n1     259:12   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme5n1      259:13   0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme8n1      259:14   0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme6n1      259:15   0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme9n1      259:16   0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme15n1     259:17   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme20n1     259:18   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme13n1     259:19   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme18n1     259:20   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme4n1      259:21   0    14T  0 disk =20
=84=80md0          9:0    0 139.7T  0 raid5=20
nvme21n1     259:22   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme22n1     259:23   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme24n1     259:24   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme12n1     259:25   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme17n1     259:26   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5
nvme19n1     259:27   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5=20
nvme23n1     259:28   0    14T  0 disk =20
=84=80md1          9:1    0 139.7T  0 raid5

[root@<server> ~]# lsblk -o KNAME,MODEL,VENDOR
KNAME      MODEL                                    VENDOR
nvme0n1    MZXL515THALA-000H3                      =20
nvme1n1    MZXL515THALA-000H3                      =20
nvme2n1    MZXL515THALA-000H3                      =20
nvme3n1    MZXL515THALA-000H3                      =20
nvme7n1    MZXL515THALA-000H3                      =20
nvme11n1   MZXL515THALA-000H3                      =20
nvme10n1   MZXL515THALA-000H3                      =20
nvme14n1   MZXL515THALA-000H3                      =20
nvme5n1    MZXL515THALA-000H3                      =20
nvme8n1    MZXL515THALA-000H3                      =20
nvme6n1    MZXL515THALA-000H3                      =20
nvme9n1    MZXL515THALA-000H3                      =20
nvme15n1   MZXL515THALA-000H3                      =20
nvme20n1   MZXL515THALA-000H3                      =20
nvme13n1   MZXL515THALA-000H3                      =20
nvme18n1   MZXL515THALA-000H3                      =20
nvme4n1    MZXL515THALA-000H3                      =20
nvme21n1   MZXL515THALA-000H3                      =20
nvme22n1   MZXL515THALA-000H3                      =20
nvme24n1   MZXL515THALA-000H3                      =20
nvme12n1   MZXL515THALA-000H3                      =20
nvme17n1   MZXL515THALA-000H3                      =20
nvme19n1   MZXL515THALA-000H3                      =20
nvme23n1   MZXL515THALA-000H3   =20

[root@<server> jim]# ./map_numa.sh       (16 is the boot drive 0-11 on numa=
 0, 12-16,17-24 on numa 1)
device: nvme8 numanode: 0
device: nvme9 numanode: 0
device: nvme10 numanode: 0
device: nvme11 numanode: 0
device: nvme4 numanode: 0
device: nvme5 numanode: 0
device: nvme6 numanode: 0
device: nvme7 numanode: 0
device: nvme2 numanode: 0
device: nvme3 numanode: 0
device: nvme0 numanode: 0
device: nvme1 numanode: 0
device: nvme21 numanode: 1
device: nvme22 numanode: 1
device: nvme23 numanode: 1
device: nvme24 numanode: 1
device: nvme16 numanode: 1
device: nvme17 numanode: 1
device: nvme18 numanode: 1
device: nvme19 numanode: 1
device: nvme20 numanode: 1
device: nvme14 numanode: 1
device: nvme15 numanode: 1
device: nvme12 numanode: 1
device: nvme13 numanode: 1

[root@<server> jim]# cat /etc/udev/rules.d/99-abj.nr_32.rules=20
KERNEL=3D=3D"nvme*[0-9]n*[0-9]",ATTRS{model}=3D=3D"MZXL515THALA-000H3",ATTR=
{queue/io_poll}=3D"1",ATTR{queue/io_poll_delay}=3D"100000",ATTR{queue/nomer=
ges}=3D"2",ATTR{queue/nr_requests}=3D"1023",ATTR{queue/rotational}=3D"0",AT=
TR{queue/rq_affinity}=3D"2",ATTR{queue/scheduler}=3D"none",ATTR{queue/add_r=
andom}=3D"0",ATTR{queue/max_sectors_kb}=3D"4096",PROGRAM=3D"/usr/sbin/nvme =
set-feature /dev/%k --feature-id 8 --value 522 "    {coalesce up to 10 inte=
rrupts per device}



SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add|change", KERNEL=3D=3D"md*", ATTR{m=
d/sync_speed_max}=3D"2000000",ATTR{md/group_thread_cnt}=3D"64", ATTR{md/str=
ipe_cache_size}=3D"8192",ATTR{queue/io_poll}=3D"1",ATTR{queue/io_poll_delay=
}=3D"100000",ATTR{queue/nomerges}=3D"2",ATTR{queue/nr_requests}=3D"1023",AT=
TR{queue/rotational}=3D"0",ATTR{queue/rq_affinity}=3D"2",ATTR{queue/schedul=
er}=3D"none",ATTR{queue/add_random}=3D"0",ATTR{queue/max_sectors_kb}=3D"409=
6"

(I know the 1023 doesn't work in the md, but there for reference) - we tune=
 for max iops, not for latency, thus the going hard at rq_affinity, nomerge=
s, etc.....

[root@<server> <server>]# cat /proc/mdstat  (128K chunk is just something F=
usion IO told me way back when and never needed to change)
Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid5 nvme11n1[11](S) nvme10n1[10] nvme9n1[9] nvme8n1[8] nvme7=
n1[7] nvme6n1[6] nvme5n1[5] nvme4n1[4] nvme3n1[3] nvme2n1[2] nvme1n1[1] nvm=
e0n1[0]
      150007961600 blocks super 1.2 level 5, 128k chunk, algorithm 2 [11/11=
] [UUUUUUUUUUU]
      bitmap: 0/112 pages [0KB], 65536KB chunk

md1 : active raid5 nvme24n1[11](S) nvme23n1[10] nvme22n1[9] nvme21n1[8] nvm=
e20n1[7] nvme19n1[6] nvme18n1[5] nvme17n1[4] nvme15n1[3] nvme14n1[2] nvme13=
n1[1] nvme12n1[0]
      150007961600 blocks super 1.2 level 5, 128k chunk, algorithm 2 [11/11=
] [UUUUUUUUUUU]
      bitmap: 0/112 pages [0KB], 65536KB chunk

unused devices: <none>

[root@<server> /]# grep raid /var/log/messages......What troubles me is if =
mdraid checked parity on read, I could somewhat understand, but I would thi=
nk the reads are nearly a pass through....
Jul 27 00:00:02 <server> rpmlist_verification[12745]: libblockdev-mdraid 2.=
24 Thu 22 Jul 2021 02:58:37 PM GMT
Jul 27 18:00:28 <server> kernel: raid6: sse2x1   gen()  9792 MB/s
Jul 27 18:00:28 <server> kernel: raid6: sse2x1   xor()  6436 MB/s
Jul 27 18:00:28 <server> kernel: raid6: sse2x2   gen() 11198 MB/s
Jul 27 18:00:28 <server> kernel: raid6: sse2x2   xor()  9546 MB/s
Jul 27 18:00:28 <server> kernel: raid6: sse2x4   gen() 14271 MB/s
Jul 27 18:00:29 <server> kernel: raid6: sse2x4   xor()  6354 MB/s
Jul 27 18:00:29 <server> kernel: raid6: avx2x1   gen() 22838 MB/s
Jul 27 18:00:29 <server> kernel: raid6: avx2x1   xor() 14069 MB/s
Jul 27 18:00:29 <server> kernel: raid6: avx2x2   gen() 26973 MB/s
Jul 27 18:00:29 <server> kernel: raid6: avx2x2   xor() 18380 MB/s
Jul 27 18:00:29 <server> kernel: raid6: avx2x4   gen() 26601 MB/s
Jul 27 18:00:29 <server> kernel: raid6: avx2x4   xor()  7025 MB/s
Jul 27 18:00:29 <server> kernel: raid6: using algorithm avx2x2 gen() 26973 =
MB/s
Jul 27 18:00:29 <server> kernel: raid6: .... xor() 18380 MB/s, rmw enabled
Jul 27 18:00:29 <server> kernel: raid6: using avx2x2 recovery algorithm

[root@<server> <server>]# cat fiojim.hpdl385.nps1
 [global]
name=3Drandom
iodepth=3D128
ioengine=3Dlibaio
direct=3D1
norandommap
group_reporting
randrepeat=3D1
random_generator=3Dtausworthe64
bs=3D4k
rw=3Drandread
numjobs=3D64
runtime=3D60

[socket0]
new_group
numa_mem_policy=3Dbind:0
numa_cpu_nodes=3D0
filename=3D/dev/nvme0n1
filename=3D/dev/nvme1n1
filename=3D/dev/nvme2n1
filename=3D/dev/nvme3n1
filename=3D/dev/nvme4n1
filename=3D/dev/nvme5n1
filename=3D/dev/nvme6n1
filename=3D/dev/nvme7n1
filename=3D/dev/nvme8n1
filename=3D/dev/nvme9n1
filename=3D/dev/nvme10n1
filename=3D/dev/nvme11n1
[socket1]
new_group
numa_mem_policy=3Dbind:1
numa_cpu_nodes=3D1
filename=3D/dev/nvme12n1
filename=3D/dev/nvme13n1
filename=3D/dev/nvme14n1
filename=3D/dev/nvme15n1
filename=3D/dev/nvme17n1
filename=3D/dev/nvme18n1
filename=3D/dev/nvme19n1
filename=3D/dev/nvme20n1
filename=3D/dev/nvme21n1
filename=3D/dev/nvme22n1
filename=3D/dev/nvme23n1
filename=3D/dev/nvme24n1
[socket0-md]
stonewall
numa_mem_policy=3Dbind:0
numa_cpu_nodes=3D0
filename=3D/dev/md0
[socket1-md]
new_group
numa_mem_policy=3Dbind:1
numa_cpu_nodes=3D1
filename=3D/dev/md1

iostat -xkz 1 with the drives raw:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           8.32    0.00   38.30    0.00    0.00   53.39

Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm =
 %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1       1317510.00    0.00 5270044.00      0.00     0.00     0.00   0=
.00   0.00    0.31    0.00 411.95     4.00     0.00   0.00 100.40
nvme1n1       1317548.00    0.00 5270192.00      0.00     0.00     0.00   0=
.00   0.00    0.32    0.00 417.38     4.00     0.00   0.00 100.00
nvme2n1       1317578.00    0.00 5270316.00      0.00     0.00     0.00   0=
.00   0.00    0.31    0.00 414.77     4.00     0.00   0.00 100.20
nvme3n1       1317554.00    0.00 5270216.00      0.00     0.00     0.00   0=
.00   0.00    0.31    0.00 413.25     4.00     0.00   0.00 100.40
nvme7n1       1317559.00    0.00 5270236.00      0.00     0.00     0.00   0=
.00   0.00    0.33    0.00 430.03     4.00     0.00   0.00 100.40
nvme11n1      1317502.00    0.00 5269996.00      0.00     0.00     0.00   0=
.00   0.00    0.73    0.00 964.85     4.00     0.00   0.00 100.40
nvme10n1      1317656.00    0.00 5270624.00      0.00     0.00     0.00   0=
.00   0.00    0.80    0.00 1050.05     4.00     0.00   0.00 100.40
nvme14n1      1107632.00    0.00 4430528.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 307.52     4.00     0.00   0.00 100.40
nvme5n1       1317583.00    0.00 5270332.00      0.00     0.00     0.00   0=
.00   0.00    0.33    0.00 430.47     4.00     0.00   0.00 100.00
nvme8n1       1317617.00    0.00 5270468.00      0.00     0.00     0.00   0=
.00   0.00    0.74    0.00 972.52     4.00     0.00   0.00 101.00
nvme6n1       1317535.00    0.00 5270144.00      0.00     0.00     0.00   0=
.00   0.00    0.33    0.00 432.48     4.00     0.00   0.00 100.60
nvme9n1       1317582.00    0.00 5270328.00      0.00     0.00     0.00   0=
.00   0.00    0.75    0.00 992.82     4.00     0.00   0.00 100.40
nvme15n1      1107703.00    0.00 4430816.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 305.93     4.00     0.00   0.00 100.60
nvme20n1      1107712.00    0.00 4430848.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 306.72     4.00     0.00   0.00 100.20
nvme13n1      1107714.00    0.00 4430852.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 307.10     4.00     0.00   0.00 101.40
nvme18n1      1107674.00    0.00 4430696.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 306.04     4.00     0.00   0.00 100.20
nvme4n1       1317521.00    0.00 5270076.00      0.00     0.00     0.00   0=
.00   0.00    0.33    0.00 431.63     4.00     0.00   0.00 100.20
nvme21n1      1107714.00    0.00 4430856.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 309.11     4.00     0.00   0.00 100.40
nvme22n1      1107711.00    0.00 4430840.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 308.52     4.00     0.00   0.00 100.60
nvme24n1      1107441.00    0.00 4429768.00      0.00     0.00     0.00   0=
.00   0.00    3.86    0.00 4271.29     4.00     0.00   0.00 100.20
nvme12n1      1107733.00    0.00 4430932.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 307.70     4.00     0.00   0.00 100.40
nvme17n1      1107858.00    0.00 4431436.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 307.95     4.00     0.00   0.00 100.60
nvme19n1      1107766.00    0.00 4431064.00      0.00     0.00     0.00   0=
.00   0.00    0.28    0.00 307.17     4.00     0.00   0.00 100.40
nvme23n1      1108033.00    0.00 4432132.00      0.00     0.00     0.00   0=
.00   0.00    0.31    0.00 340.62     4.00     0.00   0.00 100.00



iostat -xkz 1 with the md's
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.56    0.00   49.94    0.00    0.00   49.51

Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm =
 %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme0n1       114589.00    0.00 458356.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.54     4.00     0.00   0.01 100.00
nvme1n1       115284.00    0.00 461136.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.77     4.00     0.00   0.01 100.00
nvme2n1       114911.00    0.00 459644.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.61     4.00     0.00   0.01 100.00
nvme3n1       114538.00    0.00 458152.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.55     4.00     0.00   0.01 100.00
nvme7n1       114524.00    0.00 458096.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.53     4.00     0.00   0.01 100.00
nvme10n1      114934.00    0.00 459736.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.61     4.00     0.00   0.01 100.00
nvme14n1      97399.00    0.00 389596.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.41     4.00     0.00   0.01 100.00
nvme5n1       114929.00    0.00 459716.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.61     4.00     0.00   0.01 100.00
nvme8n1       114393.00    0.00 457572.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.40     4.00     0.00   0.01  99.90
nvme6n1       114731.00    0.00 458924.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.56     4.00     0.00   0.01  99.90
nvme9n1       114146.00    0.00 456584.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.37     4.00     0.00   0.01  99.90
nvme15n1      96960.00    0.00 387840.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.30     4.00     0.00   0.01 100.00
nvme20n1      97171.00    0.00 388684.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.36     4.00     0.00   0.01 100.00
nvme13n1      96874.00    0.00 387496.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.31     4.00     0.00   0.01 100.00
nvme18n1      96696.00    0.00 386784.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.16     4.00     0.00   0.01 100.00
nvme4n1       115220.00    0.00 460876.00      0.00     0.00     0.00   0.0=
0   0.00    0.29    0.00  33.75     4.00     0.00   0.01 100.00
nvme21n1      96756.00    0.00 387024.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.24     4.00     0.00   0.01 100.00
nvme22n1      97352.00    0.00 389408.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.36     4.00     0.00   0.01 100.00
nvme12n1      96899.00    0.00 387596.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.22     4.00     0.00   0.01 100.20
nvme17n1      96748.00    0.00 386992.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.24     4.00     0.00   0.01 100.00
nvme19n1      97191.00    0.00 388764.00      0.00     0.00     0.00   0.00=
   0.00    0.30    0.00  29.30     4.00     0.00   0.01 100.00
nvme23n1      96787.00    0.00 387148.00      0.00     0.00     0.00   0.00=
   0.00    0.29    0.00  28.41     4.00     0.00   0.01  99.90
md1           1066812.00    0.00 4267248.00      0.00     0.00     0.00   0=
.00   0.00    0.00    0.00   0.00     4.00     0.00   0.00   0.00
md0           1262173.00    0.00 5048692.00      0.00     0.00     0.00   0=
.00   0.00    0.00    0.00   0.00     4.00     0.00   0.00   0.00

fio output:
socket0: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)=
 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128
...
socket1: (g=3D1): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)=
 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128
...
socket0-md: (g=3D2): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128
...
socket1-md: (g=3D3): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128
...
fio-3.26
Starting 256 processes
Jobs: 128 (f=3D128): [_(128),r(128)][1.6%][r=3D9103MiB/s][r=3D2330k IOPS][e=
ta 02h:08m:00s]       =20
socket0: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D18344: Tue Jul 27 20:00:=
10 2021
  read: IOPS=3D16.0M, BW=3D60.8GiB/s (65.3GB/s)(3651GiB/60003msec)
    slat (nsec): min=3D1222, max=3D18033k, avg=3D2429.23, stdev=3D2975.48
    clat (usec): min=3D24, max=3D20221, avg=3D510.51, stdev=3D336.57
     lat (usec): min=3D30, max=3D20240, avg=3D513.01, stdev=3D336.58
    clat percentiles (usec):
     |  1.00th=3D[  147],  5.00th=3D[  194], 10.00th=3D[  229], 20.00th=3D[=
  281],
     | 30.00th=3D[  326], 40.00th=3D[  367], 50.00th=3D[  412], 60.00th=3D[=
  469],
     | 70.00th=3D[  553], 80.00th=3D[  676], 90.00th=3D[  914], 95.00th=3D[=
 1156],
     | 99.00th=3D[ 1778], 99.50th=3D[ 2073], 99.90th=3D[ 2868], 99.95th=3D[=
 3294],
     | 99.99th=3D[ 4424]
   bw (  MiB/s): min=3D52367, max=3D65429, per=3D32.81%, avg=3D62388.68, st=
dev=3D33.73, samples=3D7424
   iops        : min=3D13406054, max=3D16749890, avg=3D15971477.42, stdev=
=3D8635.86, samples=3D7424
  lat (usec)   : 50=3D0.01%, 100=3D0.02%, 250=3D13.89%, 500=3D50.33%, 750=
=3D19.72%
  lat (usec)   : 1000=3D8.24%
  lat (msec)   : 2=3D7.22%, 4=3D0.57%, 10=3D0.02%, 20=3D0.01%, 50=3D0.01%
  cpu          : usr=3D17.93%, sys=3D49.30%, ctx=3D21719222, majf=3D0, minf=
=3D9915
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued rwts: total=3D957111950,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D128
socket1: (groupid=3D1, jobs=3D64): err=3D 0: pid=3D18408: Tue Jul 27 20:00:=
10 2021
  read: IOPS=3D13.5M, BW=3D51.4GiB/s (55.2GB/s)(3085GiB/60008msec)
    slat (nsec): min=3D1232, max=3D1696.9k, avg=3D2580.28, stdev=3D2841.95
    clat (usec): min=3D21, max=3D26808, avg=3D604.58, stdev=3D1211.79
     lat (usec): min=3D26, max=3D26810, avg=3D607.23, stdev=3D1211.80
    clat percentiles (usec):
     |  1.00th=3D[  124],  5.00th=3D[  157], 10.00th=3D[  184], 20.00th=3D[=
  225],
     | 30.00th=3D[  258], 40.00th=3D[  289], 50.00th=3D[  318], 60.00th=3D[=
  351],
     | 70.00th=3D[  388], 80.00th=3D[  437], 90.00th=3D[  586], 95.00th=3D[=
 2769],
     | 99.00th=3D[ 6587], 99.50th=3D[ 9372], 99.90th=3D[12649], 99.95th=3D[=
13829],
     | 99.99th=3D[16712]
   bw (  MiB/s): min=3D32950, max=3D67704, per=3D20.46%, avg=3D52713.11, st=
dev=3D106.96, samples=3D7424
   iops        : min=3D8435402, max=3D17332350, avg=3D13494532.64, stdev=3D=
27383.02, samples=3D7424
  lat (usec)   : 50=3D0.01%, 100=3D0.16%, 250=3D27.38%, 500=3D59.09%, 750=
=3D4.93%
  lat (usec)   : 1000=3D0.30%
  lat (msec)   : 2=3D0.60%, 4=3D5.67%, 10=3D1.47%, 20=3D0.39%, 50=3D0.01%
  cpu          : usr=3D14.86%, sys=3D45.29%, ctx=3D36050249, majf=3D0, minf=
=3D10046
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued rwts: total=3D808781317,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D128
socket0-md: (groupid=3D2, jobs=3D64): err=3D 0: pid=3D18479: Tue Jul 27 20:=
00:10 2021
  read: IOPS=3D1263k, BW=3D4934MiB/s (5174MB/s)(289GiB/60001msec)
    slat (nsec): min=3D1512, max=3D48037k, avg=3D49957.85, stdev=3D33615.19
    clat (usec): min=3D176, max=3D51614, avg=3D6432.56, stdev=3D410.54
     lat (usec): min=3D178, max=3D51639, avg=3D6482.58, stdev=3D412.23
    clat percentiles (usec):
     |  1.00th=3D[ 6128],  5.00th=3D[ 6259], 10.00th=3D[ 6325], 20.00th=3D[=
 6325],
     | 30.00th=3D[ 6390], 40.00th=3D[ 6390], 50.00th=3D[ 6456], 60.00th=3D[=
 6456],
     | 70.00th=3D[ 6521], 80.00th=3D[ 6521], 90.00th=3D[ 6587], 95.00th=3D[=
 6587],
     | 99.00th=3D[ 6652], 99.50th=3D[ 6718], 99.90th=3D[ 7635], 99.95th=3D[=
16909],
     | 99.99th=3D[18220]
   bw (  MiB/s): min=3D 4582, max=3D 5934, per=3D100.00%, avg=3D4938.25, st=
dev=3D 2.07, samples=3D7616
   iops        : min=3D1173219, max=3D1519297, avg=3D1264175.97, stdev=3D52=
8.77, samples=3D7616
  lat (usec)   : 250=3D0.01%, 500=3D0.01%, 750=3D0.01%, 1000=3D0.01%
  lat (msec)   : 2=3D0.01%, 4=3D0.34%, 10=3D99.57%, 20=3D0.08%, 50=3D0.01%
  lat (msec)   : 100=3D0.01%
  cpu          : usr=3D1.23%, sys=3D95.69%, ctx=3D2557, majf=3D0, minf=3D90=
64
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued rwts: total=3D75789817,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D128
socket1-md: (groupid=3D3, jobs=3D64): err=3D 0: pid=3D18543: Tue Jul 27 20:=
00:10 2021
  read: IOPS=3D1071k, BW=3D4183MiB/s (4386MB/s)(245GiB/60002msec)
    slat (nsec): min=3D1563, max=3D14080k, avg=3D59051.10, stdev=3D22401.39
    clat (usec): min=3D179, max=3D20799, avg=3D7588.23, stdev=3D303.92
     lat (usec): min=3D211, max=3D20853, avg=3D7647.34, stdev=3D305.26
    clat percentiles (usec):
     |  1.00th=3D[ 7111],  5.00th=3D[ 7373], 10.00th=3D[ 7439], 20.00th=3D[=
 7504],
     | 30.00th=3D[ 7504], 40.00th=3D[ 7570], 50.00th=3D[ 7570], 60.00th=3D[=
 7635],
     | 70.00th=3D[ 7635], 80.00th=3D[ 7701], 90.00th=3D[ 7767], 95.00th=3D[=
 7767],
     | 99.00th=3D[ 7898], 99.50th=3D[ 7898], 99.90th=3D[ 8586], 99.95th=3D[=
13304],
     | 99.99th=3D[19006]
   bw (  MiB/s): min=3D 3955, max=3D 4642, per=3D100.00%, avg=3D4186.20, st=
dev=3D 0.98, samples=3D7616
   iops        : min=3D1012714, max=3D1188416, avg=3D1071653.68, stdev=3D25=
1.68, samples=3D7616
  lat (usec)   : 250=3D0.01%, 500=3D0.01%, 750=3D0.01%, 1000=3D0.01%
  lat (msec)   : 2=3D0.01%, 4=3D0.01%, 10=3D99.94%, 20=3D0.05%, 50=3D0.01%
  cpu          : usr=3D1.06%, sys=3D95.70%, ctx=3D1980, majf=3D0, minf=3D90=
30
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued rwts: total=3D64246431,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D128

Run status group 0 (all jobs):
   READ: bw=3D60.8GiB/s (65.3GB/s), 60.8GiB/s-60.8GiB/s (65.3GB/s-65.3GB/s)=
, io=3D3651GiB (3920GB), run=3D60003-60003msec

Run status group 1 (all jobs):
   READ: bw=3D51.4GiB/s (55.2GB/s), 51.4GiB/s-51.4GiB/s (55.2GB/s-55.2GB/s)=
, io=3D3085GiB (3313GB), run=3D60008-60008msec

Run status group 2 (all jobs):
   READ: bw=3D4934MiB/s (5174MB/s), 4934MiB/s-4934MiB/s (5174MB/s-5174MB/s)=
, io=3D289GiB (310GB), run=3D60001-60001msec

Run status group 3 (all jobs):
   READ: bw=3D4183MiB/s (4386MB/s), 4183MiB/s-4183MiB/s (4386MB/s-4386MB/s)=
, io=3D245GiB (263GB), run=3D60002-60002msec

Disk stats (read/write):
  nvme0n1: ios=3D79463384/0, merge=3D0/0, ticks=3D25148472/0, in_queue=3D25=
148472, util=3D98.78%
  nvme1n1: ios=3D79463574/0, merge=3D0/0, ticks=3D25224784/0, in_queue=3D25=
224784, util=3D98.87%
  nvme2n1: ios=3D79463699/0, merge=3D0/0, ticks=3D25305193/0, in_queue=3D25=
305193, util=3D98.96%
  nvme3n1: ios=3D79463925/0, merge=3D0/0, ticks=3D25234093/0, in_queue=3D25=
234093, util=3D99.00%
  nvme4n1: ios=3D79464135/0, merge=3D0/0, ticks=3D25396547/0, in_queue=3D25=
396547, util=3D99.06%
  nvme5n1: ios=3D79464346/0, merge=3D0/0, ticks=3D25393624/0, in_queue=3D25=
393624, util=3D99.10%
  nvme6n1: ios=3D79464535/0, merge=3D0/0, ticks=3D25330700/0, in_queue=3D25=
330700, util=3D99.19%
  nvme7n1: ios=3D79464721/0, merge=3D0/0, ticks=3D25349171/0, in_queue=3D25=
349171, util=3D99.24%
  nvme8n1: ios=3D79464029/0, merge=3D0/0, ticks=3D59063115/0, in_queue=3D59=
063115, util=3D99.32%
  nvme9n1: ios=3D79464120/0, merge=3D0/0, ticks=3D59023913/0, in_queue=3D59=
023913, util=3D99.33%
  nvme10n1: ios=3D79464799/0, merge=3D0/0, ticks=3D59136926/0, in_queue=3D5=
9136927, util=3D99.39%
  nvme11n1: ios=3D79465392/0, merge=3D0/0, ticks=3D59091104/0, in_queue=3D5=
9091104, util=3D99.51%
  nvme12n1: ios=3D67137057/0, merge=3D0/0, ticks=3D18685135/0, in_queue=3D1=
8685136, util=3D99.60%
  nvme13n1: ios=3D67137217/0, merge=3D0/0, ticks=3D18638940/0, in_queue=3D1=
8638940, util=3D99.76%
  nvme14n1: ios=3D67137341/0, merge=3D0/0, ticks=3D18663275/0, in_queue=3D1=
8663275, util=3D99.70%
  nvme15n1: ios=3D67137620/0, merge=3D0/0, ticks=3D18629947/0, in_queue=3D1=
8629948, util=3D99.77%
  nvme17n1: ios=3D67137778/0, merge=3D0/0, ticks=3D18709586/0, in_queue=3D1=
8709585, util=3D99.80%
  nvme18n1: ios=3D67137952/0, merge=3D0/0, ticks=3D18591798/0, in_queue=3D1=
8591797, util=3D99.72%
  nvme19n1: ios=3D67138199/0, merge=3D0/0, ticks=3D18669545/0, in_queue=3D1=
8669545, util=3D99.86%
  nvme20n1: ios=3D67138378/0, merge=3D0/0, ticks=3D18600128/0, in_queue=3D1=
8600128, util=3D99.89%
  nvme21n1: ios=3D67138562/0, merge=3D0/0, ticks=3D18720763/0, in_queue=3D1=
8720763, util=3D100.00%
  nvme22n1: ios=3D67138772/0, merge=3D0/0, ticks=3D18659716/0, in_queue=3D1=
8659716, util=3D100.00%
  nvme23n1: ios=3D67138982/0, merge=3D0/0, ticks=3D27862395/0, in_queue=3D2=
7862395, util=3D100.00%
  nvme24n1: ios=3D67134934/0, merge=3D0/0, ticks=3D241977879/0, in_queue=3D=
241977879, util=3D100.00%
  md0: ios=3D75701982/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
  md1: ios=3D64175011/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%


I'm used to tuning interrupts, so here are the interrupts during the hero p=
ortion of the fio and the mdraid portion.....Without polling they are just =
well balanced irq's across the different nvme MQs
[root@<server> jim]# ./top-irq.pl -k 1
reporting top 10 every 6 secs subject to thresh=3D10 kernel=3D1

CAL             532284   CPU146   Function call interrupts
CAL             529615   CPU154   Function call interrupts
CAL             526198   CPU162   Function call interrupts
CAL             524012   CPU142   Function call interrupts
CAL             521467   CPU174   Function call interrupts
CAL             520821   CPU178   Function call interrupts
CAL             518798   CPU176   Function call interrupts
CAL             518244   CPU166   Function call interrupts
CAL             517524   CPU180   Function call interrupts
CAL             514563   CPU136   Function call interrupts

  reported top 10 (of 1885)
  reported interrupts =3D 5223526  870587.7 per sec    6.8% of all interrup=
ts
^C
[root@<server> jim]# !!
./top-irq.pl -k 1
reporting top 10 every 6 secs subject to thresh=3D10 kernel=3D1

CAL              63759   CPU15    Function call interrupts
CAL              63664   CPU178   Function call interrupts
CAL              63428   CPU142   Function call interrupts
CAL              63382   CPU51    Function call interrupts
CAL              63285   CPU140   Function call interrupts
CAL              63068   CPU150   Function call interrupts
CAL              63017   CPU148   Function call interrupts
CAL              62984   CPU144   Function call interrupts
CAL              62842   CPU25    Function call interrupts
CAL              62835   CPU37    Function call interrupts

  reported top 10 (of 1885)
  reported interrupts =3D 632264  105377.3 per sec    4.0% of all interrupt=
s


Lastly, I can't make md0 and md1 each get ~2M IOPS at the same time.   Some=
times the NUMA0 md is the fastest, sometimes the NUMA1 md is the fastest - =
I think there might some sort of bottleneck/race somewhere.   It stays that=
 way until I stop them and reassemble.....and then it may switch.    I have=
n't troubleshooted enough to notice the pattern.

I have to work out with HPE why the socket0/socket1 difference in hero numb=
ers 16.0M/13.5M is something I'll have to take up with HPE or maybe there i=
s a card slowing down the drives in socket1.


Any help is greatly appreciated.  Criticism will be accepted and worst case=
, IF I HAVEN'T MISSED SOMETHING SO UTTERLY SILLY,  this becomes a defacto "=
where to start" for the base users like me before the kernel level experts =
get involved.

As an FYI - I have booted a 5.13 kernel and started using io_uring - no not=
iceable difference in md performance on a different server with GEN3 drives=
.....I can raise my "hero numbers" when I have time to play, but right now,=
 my job is to get protected IOPS.


Jim Finlayson
U.S. Department of Defense


