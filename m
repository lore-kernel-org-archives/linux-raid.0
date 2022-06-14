Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D85C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 14 Jun 2022 13:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbiFNNtq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Jun 2022 09:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiFNNtp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Jun 2022 09:49:45 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Jun 2022 06:49:39 PDT
Received: from UCOL19PA38.eemsg.mail.mil (UCOL19PA38.eemsg.mail.mil [214.24.24.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECC4366BF
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 06:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1655214579; x=1686750579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fYjXBkP1GRwEmee11qH9ZUAT5uJSqqHmy5EKxaEFhec=;
  b=a7cnOrDctigVCt8ys6iOQKMGS4J50TLmbTpOJUeweZv7a8vEbBOO8WHy
   6fVrj7NIiy7R3nnzrUDyLMc1knL9AbDbCIdpPBUbEpopvzjK2IBLvFAFz
   nw4BzL3NBUaOCaVWEiRB6KKhob/41t/oSWuyo6AIHzdb2ywLErCUE7srr
   dCEsKWNDry8Vg/Ex9Ptb/CxMe+Ql3Yy7hLegL8u1N5j6DpsF1TOeoxBBx
   jUAzSzq0Om32iPWCBJOnngvCqORTtTaavKGgfVDKDtwl8gDNmPSVol65B
   uXxrx/yIv21Ch5Qi74g9kRIHkhhAm+fT0SNx7A49VIfkdKdD9MoPMIom3
   Q==;
X-EEMSG-check-017: 375730999|UCOL19PA38_ESA_OUT05.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.91,300,1647302400"; 
   d="scan'208";a="375730999"
IronPort-Data: A9a23:/J8YeK15VXbdl6B2OvbD5Uxzkn2cJEfYwER7XKvMYLTBsI5bp2EEz
 GsbWj/Ua/eKMDb2e9p1a4Xnp00H75bdztFgSQU5qSg9HnlHl5HIVI+TRqvS04J+DSFhoGZPt
 Zh2hgzodZhsJpPkjk7xdOCn9xGQ7InQLlbGILas1htZGEk1EU/NtTo5w7Rj2tAx3YDja++wk
 YuaT/P3aQfNNwFcbzp8B5Kr8HuDa9yv0N+wlgVWicFj5DcypVFMZH4sDfjZw0/Df2VhNrXSq
 9AvbF2O1jixEx8FUrtJm1tgG6EAaua60QOm0hK6V0U+6/RPjnRa70o1CBYTQWxH1TKinN5o8
 /Nqp6yLdwInMK7HwPtIBnG0EwkmVUFH0LLLLnX6tMGYzxWfNX7lwvEoCUAyVWEa0rwuXScUr
 LpBc2hLN0jZ7w616OvTpu1EhM0mIdKtOcURu3dkxCDCCvB6B5vCXY3P7N5cmjIxgqiiGN6FO
 JdGMmI+PUWojxtnHAwxWb4FwcyTwWikQgZGrUufr7Qp2j2GpOB2+P23WDbPQfSORMNIjgOCr
 2PK13r2DwtcN9GFzzeBtHW2iYfycTjTVY4dGfi9+/Vq2ATVw2USDFsTVF/TTeSFt3NSkul3c
 yQ8khfCZ4BrryRHkvGVs8WEnUO5
IronPort-HdrOrdr: A9a23:RnyGF6sBgfgdTBfAt9ufYDgS7skDb9V00zEX/kB9WHVpm5qj9/
 xG/c576faasl0ssR0b8+xoW5PvfZq/z/JICNIqTNSftWDd0QOVxepZgrcKrQeMJxHD
Received: from edge-mech01.mail.mil ([214.21.130.102])
  by UCOL19PA38.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 14 Jun 2022 13:48:23 +0000
Received: from UMECHPAOG.easf.csd.disa.mil (214.21.130.34) by
 edge-mech01.mail.mil (214.21.130.102) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 14 Jun 2022 13:48:20 +0000
Received: from UMECHPA68.easf.csd.disa.mil ([169.254.4.207]) by
 umechpaog.easf.csd.disa.mil ([214.21.130.34]) with mapi id 14.03.0513.000;
 Tue, 14 Jun 2022 13:48:19 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Subject: RE: Showing my ignorance - kernel workers
Thread-Topic: Showing my ignorance - kernel workers
Thread-Index: AdgS5P61xTa9Pr/xShuP8xB3beZ1ehtC44Bw
Date:   Tue, 14 Jun 2022 13:48:19 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A2389D45E6C@UMECHPA68.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A23892829E5@UMECHPA7B.easf.csd.disa.mil>
In-Reply-To: <5EAED86C53DED2479E3E145969315A23892829E5@UMECHPA7B.easf.csd.disa.mil>
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

Hi,
I apologize for resurrecting an old thread......I'm trying to gain control =
of the system processes md<arraynumber>_raid6, as I have two RAID6 software=
 raid volumes on an 8 NUMA node system  (AMD Milan dual socket, NUMAs per s=
ocket set to 4) and I'm trying to not pay the relative latency penalty cros=
sing NUMA nodes:
Relative latency matrix (name NUMALatency kind 5) between 8 NUMANodes (dept=
h -3) by logical indexes:
  index     0     1     2     3     4     5     6     7
      0    10    12    12    12    32    32    32    32
      1    12    10    12    12    32    32    32    32
      2    12    12    10    12    32    32    32    32
      3    12    12    12    10    32    32    32    32
      4    32    32    32    32    10    12    12    12
      5    32    32    32    32    12    10    12    12
      6    32    32    32    32    12    12    10    12
      7    32    32    32    32    12    12    12    10

In all of my walking of an strace of  mdadm, walking udev, walking systemd,=
 reading everything I can find on mdraid and controlling it, the best I can=
 figure out is that=20
ioctl(FD,RUN_ARRAY) must start the parity engine process =20

I would like NUMA control of this parity engine process if possible.....

[root@rebel00 md]# cat /proc/mdstat   (ignore the resync below - I'm mid ex=
periment to see if I can recover an array I got evil with using blkdiscard)
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
      [=3D=3D>..................]  resync =3D 13.4% (2017478592/15002786816=
) finish=3D193.0min speed=3D1120965K/sec
      bitmap: 0/112 pages [0KB], 65536KB chunk

unused devices: <none>

These are the NUMA mappings for my nvme drives (I can't change the configur=
ation, they are what they are based upon the Milan dual socket architecture=
 on a Dell R7525)
[root@rebel00 md]# map_numa.sh
device: nvme0 numanode: 3
device: nvme1 numanode: 3
device: nvme2 numanode: 3
device: nvme3 numanode: 3
device: nvme4 numanode: 2
device: nvme5 numanode: 2
device: nvme6 numanode: 2
device: nvme7 numanode: 2
device: nvme8 numanode: 2
device: nvme9 numanode: 2
device: nvme10 numanode: 2
device: nvme11 numanode: 2
device: nvme12 numanode: 5
device: nvme13 numanode: 5
device: nvme14 numanode: 5
device: nvme15 numanode: 5
device: nvme16 numanode: 5
device: nvme17 numanode: 5
device: nvme18 numanode: 5
device: nvme19 numanode: 5
device: nvme20 numanode: 4
device: nvme21 numanode: 4
device: nvme22 numanode: 4
device: nvme23 numanode: 4

[root@rebel00 md]# !! | grep -v kworker
ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan,comm | head -1;=
 ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan,comm  | egrep =
'md|raid' | grep -v systemd | grep -v mlx | grep -v kworker
    PID     TID CLS RTPRIO  NI PRI NUMA PSR %CPU STAT WCHAN  COMMAND
    806     806 TS       -   5  14    1  24  0.0 SN   0xffff ksmd
    867     867 TS       - -20  39    1  30  0.0 I<   -      md
   2439    2439 TS       - -20  39    3  48  0.0 I<   -      raid5wq
   3444    3444 TS       -   0  19    3  53  3.0 R    -      md0_raid6
   3805    3805 TS       -   0  19    7 113  0.0 Ss   -      lsmd
1400292 1400292 TS       -   0  19    2  32 99.2 R    -      md0_resync
1403811 1403811 TS       -   0  19    7 126  0.0 S    -      md1_raid6
1405670 1405670 TS       -   0  19    4  66  0.0 Ss   -      amd.py


I would like to pin the md0_raid6 process to NUMA2 and the md1_raid6 proces=
s to NUMA5.....I know I can do it post start of the process with taskset, b=
ut I can't be sure of how to get the memory from that process (pre task set=
) moved to the appropriate NUMA node.....If you see, I got lucky and md0_ra=
id6 is on NUMA3 (almost the 2 I wanted), but md1_raid6 is on NUMA7, where I=
'd prefer it to be NUMA5 (or 4 worst case).....

I'm open to suggestions , but with all of the NUMAness of these advanced no=
des getting more and more complicated (there ends up being a PCIe x16 per N=
UMA domain, with NUMA 2 on socket0 stealing an xgmi2 link to get 16 more la=
nes on NUMA2 (32 lanes total, thus the 8 drives on my 12 in the RAID6)  and=
 similarly on socket1 with NUMA5 ending up with 32 lanes (8 drives of my 12=
 in the RAID6)

Any help is appreciated and longer term, I'd be thrilled if there were an m=
dadm.conf parameter to  take control of this or a /sys/module/md_mod/parame=
ters

Without understanding how ioctl(FD,RUN_ARRAY) really works, I haven't pursu=
ed whether I could possibly "hack something together"   in /usr/lib/udev/ru=
les.d/64-md-raid-assembly.rules  by wrappering the mdadm calls with numactl=
s of my choosing .....

Regards,
Jim Finlayson
US Department of Defense

-----Original Message-----
From: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>=20
Sent: Wednesday, January 26, 2022 3:18 PM
To: linux-raid@vger.kernel.org
Cc: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
Subject: Showing my ignorance - kernel workers

All,
I apologize in advance if you can point me to something I can read about md=
raid besides the source code.  I'm beyond the bounds of my understanding of=
 Linux.   Background, I do a bunch of NUMA aware computing.   I have two sy=
stems configured identically with a NUMA node 0 focused RAID5 LUN containin=
g NUMA node 0 nvme drives  and a NUMA node 1 focused RAID5 LUN identically =
configured.  9+1 nvme, 128KB stripe, xfs sitting on top, 64KB O_DIRECT read=
s from the application.

On one system, the kernel worker for each of the two MD's matches the NUMA =
node where the drives are located, yet on a second system, they both sit on=
 NUMA node 0.   I'm speculating that I could get more consistent performanc=
e of the identical LUNs if I could tie the kernel worker to the proper NUMA=
 domain.   Is my speculation accurate, if so, how might I go about this or =
is this a feature request???

Both systems are running the same kernel on top of RHEL8.
uname -r
5.15.13-1.el8.elrepo.x86_64

System 1:

# ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan,comm | head -=
1; ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan,comm  | egre=
p 'md|raid' | grep -v systemd | grep -v mlx
    PID     TID CLS RTPRIO  NI PRI NUMA PSR %CPU STAT WCHAN  COMMAND
   1559    1559 TS       -   5  14    1 244  0.0 SN   -      ksmd
   1627    1627 TS       - -20  39    1 196  0.0 I<   -      md
   3734    3734 TS       - -20  39    1 110  0.0 I<   -      raid5wq
   3752    3752 TS       -   0  19    0  22 10.5 S    -      md0_raid5
   3753    3753 TS       -   0  19    1 208 11.4 S    -      md1_raid5
   3838    3838 TS       -   0  19    0  57  0.0 Ss   -      lsmd

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.65    0.00    5.43    0.28    0.00   93.63

Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm =
 %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
md0           1263604.00    0.00 62411724.00      0.00     0.00     0.00   =
0.00   0.00    1.94    0.00 2451.89    49.39     0.00   0.00 100.00
md1           1116529.00    0.00 55157228.00      0.00     0.00     0.00   =
0.00   0.00    2.45    0.00 2733.76    49.40     0.00   0.00 100.

System 2:

ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan,comm | head -1;=
 ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan,comm  | egrep =
'md|raid' | grep -v systemd | grep -v mlx
    PID     TID CLS RTPRIO  NI PRI NUMA PSR %CPU STAT WCHAN  COMMAND
   1492    1492 TS       -   5  14    1 200  0.0 SN   -      ksmd
   1560    1560 TS       - -20  39    1 200  0.0 I<   -      md
   3810    3810 TS       - -20  39    0 137  0.0 I<   -      raid5wq
   3811    3811 TS       -   0  19    0 148  0.0 S    -      md0_raid5
   3824    3824 TS       -   0  19    0 167  0.0 S    -      md1_raid5
   3929    3929 TS       -   0  19    1 115  0.0 Ss   -      lsmd

vg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.58    0.00    5.61    0.29    0.00   93.51

Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm =
 %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
md0           1118252.00    0.00 55171048.00      0.00     0.00     0.00   =
0.00   0.00    1.79    0.00 2002.27    49.34     0.00   0.00 100.00
md1           1262715.00    0.00 62342424.00      0.00     0.00     0.00   =
0.00   0.00    0.61    0.00 769.19    49.37     0.00   0.00 100.00


Jim Finlayson
U.S. Department of Defense


