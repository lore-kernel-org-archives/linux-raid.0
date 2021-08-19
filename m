Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8FCC4338F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 09:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC7261100
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 09:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhHSJ3h (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhHSJ3g (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Aug 2021 05:29:36 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE0FC061575
        for <linux-raid@vger.kernel.org>; Thu, 19 Aug 2021 02:29:00 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id a9so7672846ybr.5
        for <linux-raid@vger.kernel.org>; Thu, 19 Aug 2021 02:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qAC+lK2n0HaaA6EHd6TdbGcthwOzHrHd6l69qWVmwn8=;
        b=jE2uv7xYeyZonHGVMoZQRJwysDWF49LGmijV4+Zz1Y9UsidGRS9eiJf/+skErBO06i
         +jIdxd6JLqUOYBYmyHVgKZ184uuDbzN+tTSM3ade6ZIRXyaax/utJLLXNDxCs/E8fOQZ
         q/0+vsGfiSM2f5PccLn1cgSQ2SFnoQPTv2ARaAX30IkZMV+Vnn0x6XedsytWkUQv89Ra
         6/Tt1SsRxlhoPc/C2mwzy4puiw7150TPKWqDeeftB0b0kuESVeb8WB9xBkNXdMX5ra/m
         o3BQYeJEW4NXiHNT/GIHoFb4v86XQbc/SzGpmbVnJgA7ACEkmrw4MMjSxcCGKTCaMI8H
         U+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qAC+lK2n0HaaA6EHd6TdbGcthwOzHrHd6l69qWVmwn8=;
        b=ndz3WV1jrfTxt4vKdl3Q/5BjIhjU9k6dMyiv5/NIGZDMRNsmp5Dnh/lhtvapIvwnoC
         2NnnXXDYWEUulZ8BESLeRbljwy+j1zguDw0rJjgfMHg3vdBaB3XLFyVZe2qsuGU2fkyl
         wBQW0kNJm/2T3spnE/o9Op4FybTYz28qtpw2l58UKXl43prtfihS6BzCBaLsJzJwG5K+
         3MB1bnIPMWyHKMDf40bnYZveTuDxb8GHi65sJ3ZFoj3By6XHdEKQGvBJ/Kjn6s3vtzKD
         /k+up1nDaYJctLezxBLCsh4mJMMh6/17FlGdUPkBqtfodbdPSv1OhDfLykGbPxe4pB3X
         eXSQ==
X-Gm-Message-State: AOAM532iw+K9/VsfQH6xEipFXV6rwfAszwhaD3dqS0bl8OrEn316UaUE
        GEut3bGxDNZ+7pyz/jbMfnA1ezal8tQDzrCI0DnexH4quq0=
X-Google-Smtp-Source: ABdhPJxuf0jm0wNxkvOeZrW5aJs6/QCAn+dPLka5+IxjreNuXYJmowAE6rh3s9L8okjq3Nd4Un7yvkkAiJOMpiGpNZ8=
X-Received: by 2002:a25:8810:: with SMTP id c16mr16452966ybl.383.1629365339444;
 Thu, 19 Aug 2021 02:28:59 -0700 (PDT)
MIME-Version: 1.0
From:   Marcin Wanat <marcin.wanat@gmail.com>
Date:   Thu, 19 Aug 2021 11:28:48 +0200
Message-ID: <CAFDAVznKiKC7YrCTJ4oj6NimXrhnY-=PUnJhFopw6Ur5LvOCjg@mail.gmail.com>
Subject: Slow initial resync in RAID6 with 36 SAS drives
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sorry, this will be a long email with everything I find to be relevant.
I have a mdraid6 array with 36 hdd SAS drives each able to do
>200MB/s, but I am unable to get more than 38MB/s resync speed on a
fast system (48cores/96GB ram) with no other load.

Here are all details:

kernel 5.13.11-1.el8.elrepo.x86_64

# mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Tue Aug 17 09:37:39 2021
        Raid Level : raid6
        Array Size : 464838634496 (432.91 TiB 475.99 TB)
     Used Dev Size : 13671724544 (12.73 TiB 14.00 TB)
      Raid Devices : 36
     Total Devices : 36
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Thu Aug 19 09:26:33 2021
             State : clean, resyncing
    Active Devices : 36
   Working Devices : 36
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

     Resync Status : 49% complete

              Name : large1:0  (local to host large1)
              UUID : b7cace22:832e570f:eba39768:bb1a1ed6
            Events : 40702

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       3       8       81        3      active sync   /dev/sdf1
       4       8       97        4      active sync   /dev/sdg1
       5       8      113        5      active sync   /dev/sdh1
       6       8      129        6      active sync   /dev/sdi1
       7       8      145        7      active sync   /dev/sdj1
       8       8      161        8      active sync   /dev/sdk1
       9       8      209        9      active sync   /dev/sdn1
      10       8      177       10      active sync   /dev/sdl1
      11       8      225       11      active sync   /dev/sdo1
      12       8      241       12      active sync   /dev/sdp1
      13      65        1       13      active sync   /dev/sdq1
      14      65       17       14      active sync   /dev/sdr1
      15       8      193       15      active sync   /dev/sdm1
      16      65      145       16      active sync   /dev/sdz1
      17      65      161       17      active sync   /dev/sdaa1
      18      65       33       18      active sync   /dev/sds1
      19      65       49       19      active sync   /dev/sdt1
      20      65       65       20      active sync   /dev/sdu1
      21      65       81       21      active sync   /dev/sdv1
      22      65       97       22      active sync   /dev/sdw1
      23      65      113       23      active sync   /dev/sdx1
      24      65      129       24      active sync   /dev/sdy1
      25      65      177       25      active sync   /dev/sdab1
      26      65      193       26      active sync   /dev/sdac1
      27      65      209       27      active sync   /dev/sdad1
      28      65      225       28      active sync   /dev/sdae1
      29      65      241       29      active sync   /dev/sdaf1
      30      66        1       30      active sync   /dev/sdag1
      31      66       17       31      active sync   /dev/sdah1
      32      66       33       32      active sync   /dev/sdai1
      33      66       49       33      active sync   /dev/sdaj1
      34      66       65       34      active sync   /dev/sdak1
      35      66       81       35      active sync   /dev/sdal1


# cat /proc/mdstat

md0 : active raid6 sdal1[35] sdak1[34] sdaj1[33] sdah1[31] sdai1[32]
sdag1[30] sdaf1[29] sdac1[26] sdae1[28] sdab1[25] sdad1[27] sds1[18]
sdq1[13] sdz1[16] sdo1[11] sdp1[12] sdx1[23] sdr1[14] sdw1[22] sdn1[9]
sdaa1[17] sdv1[21] sdu1[20] sdy1[24] sdt1[19] sdk1[8] sdm1[15]
sdl1[10] sdh1[5] sdj1[7] sdf1[3] sdi1[6] sdc1[0] sdg1[4] sde1[2]
sdd1[1]
      464838634496 blocks super 1.2 level 6, 512k chunk, algorithm 2
[36/36] [UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
      [=========>...........]  resync = 49.5% (6773640400/13671724544)
finish=3026.3min speed=37987K/sec
      bitmap: 53/102 pages [212KB], 65536KB chunk

# iostat -dx 5

Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s
%rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
sdc           9738.60    1.40  38956.00      5.80     0.40     0.40
0.00  22.22    0.20    9.29   1.93     4.00     4.14   0.07  71.82
sdd           9738.20    1.00  38952.80      2.60     0.00     0.00
0.00   0.00    0.89    5.80   8.68     4.00     2.60   0.07  71.60
sde           9738.60    1.40  38956.00      5.80     0.40     0.40
0.00  22.22    0.31    3.71   3.02     4.00     4.14   0.07  70.60
sdf           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.17    3.20   1.69     4.00     2.60   0.07  70.56
sdg           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.85    4.20   8.31     4.00     2.60   0.07  70.72
sdh           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.20    4.00   1.93     4.00     2.60   0.07  70.64
sdi           9738.60    1.00  38954.40      2.60     0.00     0.00
0.00   0.00    0.17    8.20   1.70     4.00     2.60   0.07  70.98
sdj           9714.60    1.00  38954.40      2.60    24.00     0.00
0.25   0.00    0.58    4.00   5.61     4.01     2.60   0.07  70.66
sdk           9677.00    1.00  38953.60      2.60    61.40     0.00
0.63   0.00    1.23    4.40  11.94     4.03     2.60   0.07  70.76
sdl           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.15    5.80   1.44     4.00     2.60   0.07  70.76
sdm           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.38    2.80   3.73     4.00     2.60   0.07  70.96
sdo           9705.60    1.00  38953.60      2.60    32.80     0.00
0.34   0.00    0.83    5.80   8.07     4.01     2.60   0.07  70.80
sdp           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.30    4.20   2.91     4.00     2.60   0.07  70.60
sdn           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.34    5.60   3.30     4.00     2.60   0.07  70.76
sdt           9659.80    1.00  38954.40      2.60    78.80     0.00
0.81   0.00    1.00    4.00   9.71     4.03     2.60   0.07  70.44
sds           9640.40    1.00  38954.40      2.60    98.20     0.00
1.01   0.00    1.29    5.60  12.42     4.04     2.60   0.07  70.60
sdq           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.30    4.40   2.92     4.00     2.60   0.07  70.68
sdu           9738.60    1.00  38954.40      2.60     0.00     0.00
0.00   0.00    0.13    4.40   1.31     4.00     2.60   0.07  70.66
sdv           9696.20    1.00  38954.40      2.60    42.40     0.00
0.44   0.00    1.30    4.20  12.57     4.02     2.60   0.07  70.76
sdw           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.94    4.20   9.13     4.00     2.60   0.07  70.70
sdy           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.11    4.40   1.05     4.00     2.60   0.07  70.62
sdr           9730.80    1.00  38953.60      2.60     7.60     0.00
0.08   0.00    1.22    4.20  11.87     4.00     2.60   0.07  70.68
sdx           9718.00    1.00  38954.40      2.60    20.60     0.00
0.21   0.00    0.88    4.20   8.57     4.01     2.60   0.07  70.70
sdaa          9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.24    4.20   2.38     4.00     2.60   0.07  70.60
sdz           9738.40    1.00  38953.60      2.60     0.00     0.00
0.00   0.00    0.20    4.20   1.91     4.00     2.60   0.07  70.60
sdab          9633.60    1.00  38953.60      2.60   104.80     0.00
1.08   0.00    1.38    4.20  13.33     4.04     2.60   0.07  70.52
sdac          9639.20    1.00  38954.40      2.60    99.40     0.00
1.02   0.00    1.08    5.60  10.45     4.04     2.60   0.07  70.56
sdad          9536.20    1.00  38954.40      2.60   202.40     0.00
2.08   0.00    2.73    4.00  26.04     4.08     2.60   0.07  70.36
sdaf          9738.60    1.00  38954.40      2.60     0.00     0.00
0.00   0.00    0.37    4.00   3.63     4.00     2.60   0.07  70.64
sdae          9738.60    1.00  38954.40      2.60     0.00     0.00
0.00   0.00    0.16    5.40   1.61     4.00     2.60   0.07  70.72
sdag          9735.20    1.00  38940.80      2.60     0.00     0.00
0.00   0.00    0.46    5.80   4.48     4.00     2.60   0.07  70.76
sdai          9738.60    1.00  38954.40      2.60     0.00     0.00
0.00   0.00    0.31    4.00   3.01     4.00     2.60   0.07  70.60
sdah          9661.60    1.00  38955.20      2.60    77.00     0.00
0.79   0.00    1.51    4.20  14.57     4.03     2.60   0.07  70.70
sdal          9739.20    1.40  38958.40      5.80     0.40     0.40
0.00  22.22    0.27    4.86   2.65     4.00     4.14   0.07  70.80
sdaj          9738.60    1.00  38954.40      2.60     0.00     0.00
0.00   0.00    0.17    4.40   1.68     4.00     2.60   0.07  70.64
sdak          9738.80    1.00  38955.20      2.60     0.00     0.00
0.00   0.00    0.53    5.40   5.21     4.00     2.60   0.07  70.80

# blockdev --report
RO    RA   SSZ   BSZ   StartSec            Size   Device
rw  8192   512  4096          0    480103981056   /dev/sda
rw  8192   512  4096       2048       535822336   /dev/sda1
rw  8192   512  4096    1048576       536870912   /dev/sda2
rw  8192   512  4096    2097152    447569985536   /dev/sda3
rw  8192   512  4096  876257280     31457280000   /dev/sda4
rw  8192   512  4096          0    480103981056   /dev/sdb
rw  8192   512   512       2048       535822336   /dev/sdb1
rw  8192   512  4096    1048576       536870912   /dev/sdb2
rw  8192   512  4096    2097152    447569985536   /dev/sdb3
rw  8192   512  4096  876257280     31457280000   /dev/sdb4
rw  8192   512   512  937698992         2080256   /dev/sdb5
rw  8192   512  4096          0  14000519643136   /dev/sdc
rw  8192   512   512       2048  13999981706752   /dev/sdc1
rw  8192   512  4096          0  14000519643136   /dev/sdd
rw  8192   512   512       2048  13999981706752   /dev/sdd1
rw  8192   512  4096          0  14000519643136   /dev/sde
rw  8192   512   512       2048  13999981706752   /dev/sde1
rw  8192   512  4096          0  14000519643136   /dev/sdf
rw  8192   512   512       2048  13999981706752   /dev/sdf1
rw  8192   512  4096          0  14000519643136   /dev/sdg
rw  8192   512   512       2048  13999981706752   /dev/sdg1
rw  8192   512  4096          0  14000519643136   /dev/sdh
rw  8192   512   512       2048  13999981706752   /dev/sdh1
rw  8192   512  4096          0  14000519643136   /dev/sdi
rw  8192   512   512       2048  13999981706752   /dev/sdi1
rw  8192   512  4096          0  14000519643136   /dev/sdj
rw  8192   512   512       2048  13999981706752   /dev/sdj1
rw  8192   512  4096          0       536281088   /dev/md2
rw  8192   512  4096          0  14000519643136   /dev/sdk
rw  8192   512   512       2048  13999981706752   /dev/sdk1
rw  8192   512  4096          0  14000519643136   /dev/sdl
rw  8192   512   512       2048  13999981706752   /dev/sdl1
rw  8192   512  4096          0    447435767808   /dev/md3
rw  8192   512  4096          0  14000519643136   /dev/sdm
rw  8192   512   512       2048  13999981706752   /dev/sdm1
rw 69632   512  4096          0 475994761723904   /dev/md0
rw  8192   512  4096          0  14000519643136   /dev/sdo
rw  8192   512   512       2048  13999981706752   /dev/sdo1
rw  8192   512  4096          0  14000519643136   /dev/sdp
rw  8192   512   512       2048  13999981706752   /dev/sdp1
rw  8192   512  4096          0  14000519643136   /dev/sdn
rw  8192   512   512       2048  13999981706752   /dev/sdn1
rw  8192   512  4096          0  14000519643136   /dev/sdt
rw  8192   512   512       2048  13999981706752   /dev/sdt1
rw  8192   512  4096          0  14000519643136   /dev/sds
rw  8192   512   512       2048  13999981706752   /dev/sds1
rw  8192   512  4096          0  14000519643136   /dev/sdq
rw  8192   512   512       2048  13999981706752   /dev/sdq1
rw  8192   512  4096          0  14000519643136   /dev/sdu
rw  8192   512   512       2048  13999981706752   /dev/sdu1
rw  8192   512  4096          0  14000519643136   /dev/sdv
rw  8192   512   512       2048  13999981706752   /dev/sdv1
rw  8192   512  4096          0  14000519643136   /dev/sdw
rw  8192   512   512       2048  13999981706752   /dev/sdw1
rw  8192   512  4096          0  14000519643136   /dev/sdy
rw  8192   512   512       2048  13999981706752   /dev/sdy1
rw  8192   512  4096          0  14000519643136   /dev/sdr
rw  8192   512   512       2048  13999981706752   /dev/sdr1
rw  8192   512  4096          0  14000519643136   /dev/sdx
rw  8192   512   512       2048  13999981706752   /dev/sdx1
rw  8192   512  4096          0  14000519643136   /dev/sdaa
rw  8192   512   512       2048  13999981706752   /dev/sdaa1
rw  8192   512  4096          0  14000519643136   /dev/sdz
rw  8192   512   512       2048  13999981706752   /dev/sdz1
rw  8192   512  4096          0  14000519643136   /dev/sdab
rw  8192   512   512       2048  13999981706752   /dev/sdab1
rw  8192   512  4096          0  14000519643136   /dev/sdac
rw  8192   512   512       2048  13999981706752   /dev/sdac1
rw  8192   512  4096          0  14000519643136   /dev/sdad
rw  8192   512   512       2048  13999981706752   /dev/sdad1
rw  8192   512  4096          0  14000519643136   /dev/sdaf
rw  8192   512   512       2048  13999981706752   /dev/sdaf1
rw  8192   512  4096          0  14000519643136   /dev/sdae
rw  8192   512   512       2048  13999981706752   /dev/sdae1
rw  8192   512  4096          0  14000519643136   /dev/sdag
rw  8192   512   512       2048  13999981706752   /dev/sdag1
rw  8192   512  4096          0  14000519643136   /dev/sdai
rw  8192   512   512       2048  13999981706752   /dev/sdai1
rw  8192   512  4096          0  14000519643136   /dev/sdah
rw  8192   512   512       2048  13999981706752   /dev/sdah1
rw  8192   512  4096          0  14000519643136   /dev/sdal
rw  8192   512   512       2048  13999981706752   /dev/sdal1
rw  8192   512  4096          0  14000519643136   /dev/sdaj
rw  8192   512   512       2048  13999981706752   /dev/sdaj1
rw  8192   512  4096          0  14000519643136   /dev/sdak
rw  8192   512   512       2048  13999981706752   /dev/sdak1

# find /sys/block/md0/queue/ -type f -printf "%h/%f : " -exec cat '{}' ';'
/sys/block/md0/queue/io_poll_delay : 0
/sys/block/md0/queue/max_integrity_segments : 0
/sys/block/md0/queue/zoned : none
/sys/block/md0/queue/scheduler : none
/sys/block/md0/queue/io_poll : 0
/sys/block/md0/queue/discard_zeroes_data : 0
/sys/block/md0/queue/minimum_io_size : 524288
/sys/block/md0/queue/nr_zones : 0
/sys/block/md0/queue/write_same_max_bytes : 0
/sys/block/md0/queue/max_segments : 128
/sys/block/md0/queue/dax : 0
/sys/block/md0/queue/physical_block_size : 4096
/sys/block/md0/queue/logical_block_size : 512
/sys/block/md0/queue/virt_boundary_mask : 0
/sys/block/md0/queue/zone_append_max_bytes : 0
/sys/block/md0/queue/nr_requests : 128
/sys/block/md0/queue/write_cache : write back
/sys/block/md0/queue/stable_writes : 0
/sys/block/md0/queue/max_segment_size : 4294967295
/sys/block/md0/queue/rotational : 1
/sys/block/md0/queue/discard_max_bytes : 0
/sys/block/md0/queue/add_random : 0
/sys/block/md0/queue/discard_max_hw_bytes : 0
/sys/block/md0/queue/optimal_io_size : 17825792
/sys/block/md0/queue/chunk_sectors : 0
/sys/block/md0/queue/read_ahead_kb : 34816
/sys/block/md0/queue/max_discard_segments : 1
/sys/block/md0/queue/write_zeroes_max_bytes : 0
/sys/block/md0/queue/nomerges : 0
/sys/block/md0/queue/zone_write_granularity : 0
/sys/block/md0/queue/wbt_lat_usec : cat:
/sys/block/md0/queue/wbt_lat_usec: Invalid argument
/sys/block/md0/queue/fua : 1
/sys/block/md0/queue/discard_granularity : 33554432
/sys/block/md0/queue/rq_affinity : 0
/sys/block/md0/queue/max_sectors_kb : 1280
/sys/block/md0/queue/hw_sector_size : 512
/sys/block/md0/queue/max_hw_sectors_kb : 2147483647
/sys/block/md0/queue/iostats : 0

# find /sys/block/md0/md/ -type f -not -path "*/dev-*" -printf "%h/%f
: " -exec cat '{}' ';'
/sys/block/md0/md/sync_min : 0
/sys/block/md0/md/new_dev : cat: /sys/block/md0/md/new_dev: Permission denied
/sys/block/md0/md/consistency_policy : bitmap
/sys/block/md0/md/sync_max : max
/sys/block/md0/md/sync_speed_min : 1000 (local)
/sys/block/md0/md/stripe_cache_active : 37522
/sys/block/md0/md/stripe_cache_size : 32768
/sys/block/md0/md/array_size : default
/sys/block/md0/md/suspend_hi : 0
/sys/block/md0/md/chunk_size : 524288
/sys/block/md0/md/max_read_errors : 20
/sys/block/md0/md/component_size : 13671724544
/sys/block/md0/md/rmw_level : 1
/sys/block/md0/md/sync_speed_max : 200000 (system)
/sys/block/md0/md/sync_force_parallel : 0
/sys/block/md0/md/layout : 2
/sys/block/md0/md/safe_mode_delay : 0.201
/sys/block/md0/md/reshape_position : none
/sys/block/md0/md/sync_action : resync
/sys/block/md0/md/resync_start : 13501066048
/sys/block/md0/md/serialize_policy : n/a
/sys/block/md0/md/bitmap_set_bits : cat:
/sys/block/md0/md/bitmap_set_bits: Permission denied
/sys/block/md0/md/degraded : 0
/sys/block/md0/md/bitmap/location : +8
/sys/block/md0/md/bitmap/space : 0
/sys/block/md0/md/bitmap/can_clear : false
/sys/block/md0/md/bitmap/metadata : internal
/sys/block/md0/md/bitmap/max_backlog_used : 0
/sys/block/md0/md/bitmap/time_base : 5
/sys/block/md0/md/bitmap/chunksize : 67108864
/sys/block/md0/md/bitmap/backlog : 0
/sys/block/md0/md/uuid : b7cace22-832e-570f-eba3-9768bb1a1ed6
/sys/block/md0/md/skip_copy : 0
/sys/block/md0/md/mismatch_cnt : 0
/sys/block/md0/md/last_sync_action : resync
/sys/block/md0/md/sync_speed : 38966
/sys/block/md0/md/raid_disks : 36
/sys/block/md0/md/sync_completed : 13518742200 / 27343449088
/sys/block/md0/md/array_state : active-idle
/sys/block/md0/md/reshape_direction : forwards
/sys/block/md0/md/journal_mode : /sys/block/md0/md/level : raid6
/sys/block/md0/md/suspend_lo : 0
/sys/block/md0/md/fail_last_dev : 0
/sys/block/md0/md/preread_bypass_threshold : 1
/sys/block/md0/md/stripe_size : 4096
/sys/block/md0/md/group_thread_cnt : 0
/sys/block/md0/md/metadata_version : 1.2
/sys/block/md0/md/ppl_write_hint : 0


# find /sys/block/sdc/queue/ -type f -printf "%h/%f : " -exec cat '{}' ';'
/sys/block/sdc/queue/io_poll_delay : -1
/sys/block/sdc/queue/max_integrity_segments : 0
/sys/block/sdc/queue/zoned : none
/sys/block/sdc/queue/scheduler : [mq-deadline] kyber bfq none
/sys/block/sdc/queue/io_poll : 0
/sys/block/sdc/queue/discard_zeroes_data : 0
/sys/block/sdc/queue/minimum_io_size : 4096
/sys/block/sdc/queue/nr_zones : 0
/sys/block/sdc/queue/write_same_max_bytes : 33550336
/sys/block/sdc/queue/max_segments : 128
/sys/block/sdc/queue/dax : 0
/sys/block/sdc/queue/physical_block_size : 4096
/sys/block/sdc/queue/logical_block_size : 512
/sys/block/sdc/queue/virt_boundary_mask : 0
/sys/block/sdc/queue/zone_append_max_bytes : 0
/sys/block/sdc/queue/io_timeout : 30000
/sys/block/sdc/queue/nr_requests : 256
/sys/block/sdc/queue/write_cache : write back
/sys/block/sdc/queue/stable_writes : 0
/sys/block/sdc/queue/max_segment_size : 4294967295
/sys/block/sdc/queue/rotational : 1
/sys/block/sdc/queue/discard_max_bytes : 0
/sys/block/sdc/queue/add_random : 1
/sys/block/sdc/queue/discard_max_hw_bytes : 0
/sys/block/sdc/queue/optimal_io_size : 0
/sys/block/sdc/queue/chunk_sectors : 0
/sys/block/sdc/queue/iosched/front_merges : 1
/sys/block/sdc/queue/iosched/read_expire : 500
/sys/block/sdc/queue/iosched/fifo_batch : 16
/sys/block/sdc/queue/iosched/write_expire : 5000
/sys/block/sdc/queue/iosched/writes_starved : 2
/sys/block/sdc/queue/read_ahead_kb : 4096
/sys/block/sdc/queue/max_discard_segments : 1
/sys/block/sdc/queue/write_zeroes_max_bytes : 33550336
/sys/block/sdc/queue/nomerges : 0
/sys/block/sdc/queue/zone_write_granularity : 0
/sys/block/sdc/queue/wbt_lat_usec : 75000
/sys/block/sdc/queue/fua : 1
/sys/block/sdc/queue/discard_granularity : 0
/sys/block/sdc/queue/rq_affinity : 1
/sys/block/sdc/queue/max_sectors_kb : 1280
/sys/block/sdc/queue/hw_sector_size : 512
/sys/block/sdc/queue/max_hw_sectors_kb : 16383
/sys/block/sdc/queue/iostats : 1


Array is running on systems with 48 cores, 96GB RAM with no other load.

stripe_cache_size = 32768

md0_raid6 process is using 50-75% cpu.

14TB hdds in 36 drives array are: WDC WUH721414AL5201

Each drive in has >200MB/s sequential read/write when tested by fio.

sync_speed_min/sync_speed_max is set to 200000.

36 drives are connected as JBOD via two controllers LSI SAS3008
PCI-Express Fusion-MPT SAS-3

Both controllers are in PCI-E 3.0 x8 slots: LnkSta: Speed 8GT/s (ok),
Width x8 (ok)

Iostat for this array shows:
9738.60 r/s
38956.00 rKB/s
0 rrqm/s
4.00 rareq-sz

Why there are so many 4KB IOPS issued to drives ? With other raid6
arrays during resync i always have rareq-sz at least 200KB and IOPS at
least 10x lower.

I was trying setting group_thread_cnt = 4. This was helpful on other
arrays but on this array it only resulted in increase in CPU iowait
and resync speed decrease to 33MB/s.

Regards,
Marcin Wanat
