Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0987BC77B7F
	for <linux-raid@archiver.kernel.org>; Fri, 12 May 2023 11:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240787AbjELLs4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 May 2023 07:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240753AbjELLsy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 May 2023 07:48:54 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B506610E53
        for <linux-raid@vger.kernel.org>; Fri, 12 May 2023 04:48:53 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-7591797c638so85083185a.1
        for <linux-raid@vger.kernel.org>; Fri, 12 May 2023 04:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683892132; x=1686484132;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w96xlmPVg/9PfST3JiMnc4zVR3yBl3XY/8ag7kWBIm8=;
        b=Jx3pr/ZRVLF2AkIMR2Tmh5WCIw5SanHLW2o8EsD+HeVaQfAl3ZDia6x7ErZpVD7jWi
         +5Vd7Tg1xLz3c4oCrclZpk9WiQxVoT3A+Lecs7+Zg5DJRyDngZEYv2toy+5SZTyJp8UK
         4JZoCUesrgBx53W5kYDAiaKPAS0eeYp1vhwOQeTVooVj5S3d5vQZJGygw13VYm8gxoUi
         AexBzDWYepTeSrcp5bFx3WXWVlbfmDhyQUrxSOTJz8dm7RNcInFSt69b3ExHM0cJnpGm
         RfmKF+L4EQ6a8HE5az6B5IUwLWL6FVYgIFyYg3258BD96jeC/GrqCGoEFXvZLsN/fTFe
         /Icw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683892132; x=1686484132;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w96xlmPVg/9PfST3JiMnc4zVR3yBl3XY/8ag7kWBIm8=;
        b=I4TFd183QabEvtrqYy3CdFw3eE+diyaLDZQLrVJgpERHhmTSJYc2X8L1iMgJziTmV6
         ksrEkT7dakhtbUxWMyB7yacRkYqEjamMO4xyfITAh6sfmK6XCA7JspnXsm3+dTdb1n1J
         EUe0Ea4FGsdW+wqNjd3zr83n2WaQqGnREaUdVsWYY8m7E3gsnxrL9GDD3QAmwyera++V
         hrKVHX0ATRQo7z7vFgeZ/nF8SzsEaH5vGrauRZnBhXRUPkJlSmC3LbGsx6MloWoUleRg
         LS8qjiobwA/Q8BQBsKUWzOz8uxdnkcMFIgpXW9ws+V3gE4GwSvyZO8FbQ5iPPk4h60hZ
         WVoA==
X-Gm-Message-State: AC+VfDxCov0HcExYNV4/YBmgmWhvM+d69Vxy+Sltugq9Lp/bPL1wA8Se
        1tuzKzgyu+ZQbsFxDk2PUuw1fOnGfAEvqDIM21i0x4IBQXk=
X-Google-Smtp-Source: ACHHUZ7r3vR22GlynOAq3MbszFWbIAkTQPU0wZfFij5hijhZ7ELYwWWCTCV87Bmv2wMMLw88atj1Y/tIbknARc+Qbhw=
X-Received: by 2002:a05:6214:f03:b0:56a:b623:9b09 with SMTP id
 gw3-20020a0562140f0300b0056ab6239b09mr46080820qvb.14.1683892132481; Fri, 12
 May 2023 04:48:52 -0700 (PDT)
MIME-Version: 1.0
From:   A Pro <alexandre.prokofiev@gmail.com>
Date:   Fri, 12 May 2023 14:48:41 +0300
Message-ID: <CAF_BDZ_mo=5Xqd0dC3boqHThF=vuO9BO_3gBFZ_r2wvL2=ESUQ@mail.gmail.com>
Subject: Weird problem with raid5/6 - very low linear speed
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi!

I'm trying to set up a new server and stumbled on a strange problem:
linear speeds on parity md arrays are very small. Minimal test case:
created raid5 on 3 HDD, checked read speed with fio (reading full
stripes) and got 40 IOPS (10 MB/s)!
But when I've created raid0 on the same drives, everything is good - 3
times of single disk.

The same raid5 works fine in another system (usual desktop computer).
Each individual drive transfers 250+ MB/s, drives are new, no SMART problems.

I'm not sure this is md-driver related, but can't understand the
difference of raid5 vs raid0 - access patterns should be quite
similar, but results are way different.

After doing some operations on array (random reads/writes) speed
sometimes recovers, giving about 2k IOPS on linear read, then again
drops.

Could someone advise what is causing this?

Kernel version 5.19.0-40-generic (Ubuntu 22.04)

Server is dual Xeon Silver 4314, 256GB RAM
Motherboard Supermicro X12DPi-NT6 (Intel C621 chipset)
Drives are WD HC550 18TB SATA (WUH721818AL), connected via LSI3808
HBA, mpt3sas driver (I also tried with chipset SATA controller - no
difference).

Command to create array:
mdadm -C /dev/md0 -l 5 -n 3 -c 128 --assume-clean --bitmap=none
/dev/sda /dev/sdb /dev/sdc

/proc/mdstat:
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdc[2] sdb[1] sda[0]
      35156391936 blocks super 1.2 level 5, 128k chunk, algorithm 2 [3/3] [UUU]

Test linear throughput:
fio -name test -filename /dev/md0 -rw read -bs 256k -ioengine libaio
-direct 1 -runtime 30

test: (groupid=0, jobs=1): err= 0: pid=4680: Thu May  4 09:40:11 2023
  read: IOPS=40, BW=10.0MiB/s (10.5MB/s)(301MiB/30040msec)
    slat (usec): min=18, max=207, avg=83.39, stdev=12.24
    clat (usec): min=263, max=424390, avg=24900.32, stdev=33926.46
     lat (usec): min=305, max=424474, avg=24984.48, stdev=33927.97
    clat percentiles (usec):
     |  1.00th=[   269],  5.00th=[   330], 10.00th=[   359], 20.00th=[   383],
     | 30.00th=[   594], 40.00th=[ 10552], 50.00th=[ 10683], 60.00th=[ 43779],
     | 70.00th=[ 43779], 80.00th=[ 45351], 90.00th=[ 45351], 95.00th=[ 45876],
     | 99.00th=[ 50594], 99.50th=[ 65274], 99.90th=[425722], 99.95th=[425722],
     | 99.99th=[425722]
   bw (  KiB/s): min= 2048, max=195072, per=100.00%, avg=10248.53,
stdev=24313.44, samples=60
   iops        : min=    8, max=  762, avg=40.03, stdev=94.97, samples=60
  lat (usec)   : 500=29.12%, 750=1.33%, 1000=0.50%
  lat (msec)   : 2=0.58%, 10=0.25%, 20=21.88%, 50=45.26%, 100=0.58%
  lat (msec)   : 500=0.50%
  cpu          : usr=0.06%, sys=0.33%, ctx=3606, majf=0, minf=76
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1202,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=10.0MiB/s (10.5MB/s), 10.0MiB/s-10.0MiB/s
(10.5MB/s-10.5MB/s), io=301MiB (315MB), run=30040-30040msec

Disk stats (read/write):
    md0: ios=2394/0, merge=0/0, ticks=30076/0, in_queue=30076,
util=99.81%, aggrios=801/0, aggrmerge=0/0, aggrticks=10160/0,
aggrin_queue=10159, aggrutil=47.28%
  sdb: ios=801/0, merge=0/0, ticks=13105/0, in_queue=13105, util=47.28%
  sdc: ios=801/0, merge=0/0, ticks=12854/0, in_queue=12853, util=46.68%
  sda: ios=802/0, merge=0/0, ticks=4521/0, in_queue=4521, util=18.39%
