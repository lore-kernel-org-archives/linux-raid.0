Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167FAC5DF62
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 20:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiAZURn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 15:17:43 -0500
Received: from UCOL19PA37.eemsg.mail.mil ([214.24.24.197]:50636 "EHLO
        UCOL19PA37.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiAZURn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Jan 2022 15:17:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1643228263; x=1674764263;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=vMkUVogk1RRNRu1kVi45GCcxkW3QsSjVeMG15tqDAKw=;
  b=T5GN7UZ5LNz5AJBuvg7pNOD5fxUS4xEWUzCVltojyhuIC0JdVg3P5ySr
   0gHV3B4ttzkXYFqKXbp//eQLfUNmXtoQWaniyzOUX21e3mSzywKbeSUz2
   dn/RrTm3iGs2ApAt99F2BFRjIsiheq7abq+tJYAEB2b5h4yJQ5gbXZHMk
   M5RUY7CPSA003aKJhCuMcZRfVaXTYdq+V0XrvCONhKqCXkwAWNCDuv5sf
   HjyauduRYnUPNlSMMzpAno8rukAQY1tD8aZAj51Gho3ZJzzvmL8rXC6Cu
   2pByTFPjhW7Q5XQE47Dk9rCJ6Z+x6pdlvlZ256MCAasxUYL20T4nqOEvk
   w==;
X-EEMSG-check-017: 324433814|UCOL19PA37_ESA_OUT04.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.88,319,1635206400"; 
   d="scan'208";a="324433814"
IronPort-Data: A9a23:VVHQgqqz3mhcvYC9S1u4DxSk96heBmLWZxIvgKrLsJaIsI4StFCzt
 garIBmAbvmKNjOmLth+boXl9xhS78WHyocyHABlpS9jEXsQ+ZacVYWSI3mrMnLJJKUvbq7GA
 +byyDXkBJppJpPkjk72dOCn8RGQ7InQLlbGILas1htZGEk0GE/NtTo5w7Rj2tcy34Dia++wk
 YuaT/P3aQfNNwFcbzp8B5Kr8HuDjdyq0N8qlgVWicNj5Tcyo0Io4Kc3fsldGZdYrr58RYZWT
 86bpF2wE/iwEx0FUrtJmZ6jGqEGryK7AOSAtpZWc/DKbhlqqyA93+M+OfEcMR0RjjyIm5Z0y
 dElWZ6YE151ePeV3r1GC18CSHkW0a5uodcrJVC9uMme1AvDNXXtxfFnHVoxO9Fe8edpKWRH9
 PheLTEJBvyGr7nsnO7gEbk12qzPK+GuZuvzoEpIyTDfEOZjW5nCT43U6tJCmjQ9nMZDGbDZf
 cVxVNbFRHwseDVCNlgaTZczl+fw3D/6ejxc7leUocIKD6Ho5FQZ+NDQ3BD9ILRmme09cp6km
 1/7
IronPort-HdrOrdr: A9a23:urkI2q9c/p0XPhoGg5Juk+D2I+orL9Y04lQ7vn2ZESYlF/Bxl6
 iV88jzpiWE7Ar5P0tQ4uxoWZPwOU80mqQFgrX5UY3OYOCEghrTEGgB1/qB/9SIIUSXnYRgPM
 9bAtVD4bbLY2SS+Pyb3ODOKbcdKbe8nJxAzt2uqEuFBTsaDZ2IwT0JczqmLg==
Received: from edge-mech02.mail.mil ([214.21.130.230])
  by UCOL19PA37.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 26 Jan 2022 20:17:41 +0000
Received: from UMECHPAOX.easf.csd.disa.mil (214.21.130.167) by
 edge-mech02.mail.mil (214.21.130.230) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Wed, 26 Jan 2022 20:17:37 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.67]) by
 umechpaox.easf.csd.disa.mil ([214.21.130.167]) with mapi id 14.03.0513.000;
 Wed, 26 Jan 2022 20:17:34 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Subject: Showing my ignorance - kernel workers
Thread-Topic: Showing my ignorance - kernel workers
Thread-Index: AdgS5P61xTa9Pr/xShuP8xB3beZ1eg==
Date:   Wed, 26 Jan 2022 20:17:33 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A23892829E5@UMECHPA7B.easf.csd.disa.mil>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.44.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

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


