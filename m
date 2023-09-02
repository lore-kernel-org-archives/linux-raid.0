Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABCDCA0FFC
	for <linux-raid@archiver.kernel.org>; Sat,  2 Sep 2023 06:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjIBG5v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Sep 2023 02:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjIBG5u (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Sep 2023 02:57:50 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BF91702
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 23:57:47 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-500aed06ffcso4448846e87.0
        for <linux-raid@vger.kernel.org>; Fri, 01 Sep 2023 23:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693637865; x=1694242665; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RO9tS0oLwdtBhxkW0++MWwypRvC+1ltcOeL1kWH8u0g=;
        b=S4nxuAjgHXrkKDy4kYpuSRythvYTeiFuFm2rULulV0IUIRbMNcDbITHd+N7SLz0kBD
         XOlHK2jgROOStkev7TvNd6FbxztGYvtCg87xxCN1L1WkFDw+ceVeI3NZr6S99PZDv226
         tFXKNwceYKI2uHS5GNf4v03Dx0ajeHUDD2XdOOYSpQ86XmdUtrWlRM4FBCvGXs5fdXDc
         TQVOCfsAB+e8C9lqrLXO+9Zk2CjUaFhadMBSvukfz4GdyVRvS+hXWgjrClhj4UNNxwHr
         ST45/xWXHAZzpiKx+7ixogsWd/6MvPEA9JKxt3wbfuvD8lqhcLc+Z2V5rWFbcRxNMQr1
         lg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693637865; x=1694242665;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RO9tS0oLwdtBhxkW0++MWwypRvC+1ltcOeL1kWH8u0g=;
        b=fg9t9s5hCNcrCfEptQoYbuSUHPHS0jgTAK/p38x1CxoNn+7Ndkkwj+LHF1FAbfwXPg
         ZyNBuXMBEYF5NpD33g/DKnbzwRgqk9ZGxQPXhj4AnKLAXfn3jF1aaIJmfbl2qCyOp7XK
         PX6ibY2rdnWISGBS2u3wL38c4lHveqNR2qQ1anrjSRS96ilN8bEPmJWF7Mmwd+WmP/3o
         hJ9SPOTfLRc79jCShcfZB1icy/LmDuZeG5Ho8rkSEoC2/1a+Y+xrw2q/Ci2DreRE5BEJ
         s+cUxUAq1VLkiZpD79vIdrkhSTIVHmZeQ4QfK+vWwnuzzagCYGGm3hiaRhz345znvMv8
         3V9g==
X-Gm-Message-State: AOJu0YyR+jR9Th8IANsglrfECfhbUsWzh4XLvJZ3pZQLRp2cg6inZxd8
        1c5LONa3ED9ocljQVBKrM5Map0cKmz2GWt/444aLYs4mvdCeaQ==
X-Google-Smtp-Source: AGHT+IFb/G1vSyXZt+/f6bicMwRfjv39VefdPDI43i0uMHNH1BGyflQRoAV2+rgAsVJIRwjJpEyP8ay6AEsytnq19iE=
X-Received: by 2002:a05:6512:3e14:b0:4fc:3755:37d9 with SMTP id
 i20-20020a0565123e1400b004fc375537d9mr3352037lfv.68.1693637865298; Fri, 01
 Sep 2023 23:57:45 -0700 (PDT)
MIME-Version: 1.0
From:   CoolCold <coolthecold@gmail.com>
Date:   Sat, 2 Sep 2023 13:56:49 +0700
Message-ID: <CAGqmV7ojxmsMVStS2LWzfeN+A565z4U=d9kUBUnAfCGq5TGtsw@mail.gmail.com>
Subject: RADI10 slower than SINGLE drive - tests with fio for block device (no
 filesystem in use) - 18.5k vs 26k iops
To:     Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good day!
2nd part of the question, in relation of hardware/system from previous
thread -  "raid10, far layout initial sync slow + XFS question"
https://www.spinics.net/lists/raid/msg74907.html - Ubuntu 20.04 with
kernel "5.4.0-153-generic #170-Ubuntu" on Hetzner AX161 / AMD EPYC
7502P 32-Core Processor

Gist: issuing the same load on RAID10 4 drives N2 16kb chunk is slower
than running the same load on a single member of that RAID
Question: is such kind of behavior normal and expected? Am I doing
something terribly wrong?

RAID10: 18.5k iops
SINGLE DRIVE: 26k iops

raw data:

RAID config
root@node2:/data# cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
      7501212320 blocks super 1.2 16K chunks 2 near-copies [4/4] [UUUU]

Single drive with:
root@node2:/data# mdadm /dev/md3 --fail /dev/nvme5n1 --remove /dev/nvme5n1
mdadm: set /dev/nvme5n1 faulty in /dev/md3
mdadm: hot removed /dev/nvme5n1 from /dev/md3

mdadm --zero-superblock /dev/nvme5n1

TEST COMMANDS
RADI10:              fio --rw=write --ioengine=sync --fdatasync=1
--filename=/dev/md3 --size=8200m --bs=16k --name=mytest
SINGLE DRIVE: fio --rw=write --ioengine=sync --fdatasync=1
--filename=/dev/nvme5n1 --size=8200m --bs=16k --name=mytest

FIO output:

RAID10:
root@node2:/mnt# fio --rw=write --ioengine=sync --fdatasync=1
--filename=/dev/md3 --size=8200m --bs=16k --name=mytest
mytest: (g=0): rw=write, bs=(R) 16.0KiB-16.0KiB, (W) 16.0KiB-16.0KiB,
(T) 16.0KiB-16.0KiB, ioengine=sync, iodepth=1
fio-3.16
Starting 1 process
Jobs: 1 (f=1): [W(1)][100.0%][w=298MiB/s][w=19.0k IOPS][eta 00m:00s]
mytest: (groupid=0, jobs=1): err= 0: pid=2130392: Sat Sep  2 08:21:39 2023
  write: IOPS=18.5k, BW=290MiB/s (304MB/s)(8200MiB/28321msec); 0 zone resets
    clat (usec): min=5, max=745, avg=12.12, stdev= 7.30
     lat (usec): min=6, max=746, avg=12.47, stdev= 7.34
    clat percentiles (usec):
     |  1.00th=[    8],  5.00th=[    9], 10.00th=[   10], 20.00th=[   10],
     | 30.00th=[   10], 40.00th=[   11], 50.00th=[   11], 60.00th=[   11],
     | 70.00th=[   12], 80.00th=[   13], 90.00th=[   16], 95.00th=[   20],
     | 99.00th=[   39], 99.50th=[   55], 99.90th=[  100], 99.95th=[  116],
     | 99.99th=[  147]
   bw (  KiB/s): min=276160, max=308672, per=99.96%, avg=296354.86,
stdev=6624.06, samples=56
   iops        : min=17260, max=19292, avg=18522.18, stdev=414.00, samples=56

Run status group 0 (all jobs):
  WRITE: bw=290MiB/s (304MB/s), 290MiB/s-290MiB/s (304MB/s-304MB/s),
io=8200MiB (8598MB), run=28321-28321msec


                                              Disk stats (read/write):

                                     md3: ios=0/2604727, merge=0/0,
ticks=0/0, in_queue=0, util=0.00%, aggrios=25/262403,
aggrmerge=0/787199, aggrticks=1/5563, aggrin_queue=0, aggrutil=98.10%
  nvme0n1: ios=40/262402, merge=1/787200, ticks=3/5092, in_queue=0, util=98.09%
  nvme3n1: ios=33/262404, merge=1/787198, ticks=2/5050, in_queue=0, util=98.08%
  nvme5n1: ios=15/262404, merge=0/787198, ticks=1/6061, in_queue=0, util=98.08%
  nvme4n1: ios=12/262402, merge=0/787200, ticks=1/6052, in_queue=0, util=98.10%


SINGLE DRIVE:
root@node2:/mnt# fio --rw=write --ioengine=sync --fdatasync=1
--filename=/dev/nvme5n1 --size=8200m --bs=16k --name=mytest
mytest: (g=0): rw=write, bs=(R) 16.0KiB-16.0KiB, (W) 16.0KiB-16.0KiB,
(T) 16.0KiB-16.0KiB, ioengine=sync, iodepth=1
fio-3.16
Starting 1 process
Jobs: 1 (f=1): [W(1)][100.0%][w=414MiB/s][w=26.5k IOPS][eta 00m:00s]
mytest: (groupid=0, jobs=1): err= 0: pid=2155313: Sat Sep  2 08:26:23 2023
  write: IOPS=26.2k, BW=410MiB/s (430MB/s)(8200MiB/20000msec); 0 zone resets
    clat (usec): min=4, max=848, avg=11.25, stdev= 7.15
     lat (usec): min=5, max=848, avg=11.50, stdev= 7.17
    clat percentiles (usec):
     |  1.00th=[    7],  5.00th=[    9], 10.00th=[    9], 20.00th=[    9],
     | 30.00th=[   10], 40.00th=[   10], 50.00th=[   10], 60.00th=[   11],
     | 70.00th=[   11], 80.00th=[   12], 90.00th=[   15], 95.00th=[   18],
     | 99.00th=[   43], 99.50th=[   62], 99.90th=[   95], 99.95th=[  108],
     | 99.99th=[  133]
   bw (  KiB/s): min=395040, max=464480, per=99.90%, avg=419438.95,
stdev=17496.05, samples=39
   iops        : min=24690, max=29030, avg=26214.92, stdev=1093.56, samples=39

Run status group 0 (all jobs):
  WRITE: bw=423MiB/s (444MB/s), 423MiB/s-423MiB/s (444MB/s-444MB/s),
io=8200MiB (8598MB), run=19379-19379msec

Disk stats (read/write):
  nvme5n1: ios=49/518250, merge=0/1554753, ticks=2/10629, in_queue=0,
util=99.61%

-- 
Best regards,
[COOLCOLD-RIPN]
