Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD417C77B73
	for <linux-raid@archiver.kernel.org>; Sat,  6 May 2023 16:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjEFQ20 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 May 2023 12:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEFQ2Z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 May 2023 12:28:25 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E914E16091
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 09:28:22 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-766692684e1so79769439f.3
        for <linux-raid@vger.kernel.org>; Sat, 06 May 2023 09:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1683390501; x=1685982501;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mtNhxi7lADUNX5J41YhK2a1NMcj5Vf4XMV1hRztvYM=;
        b=DfiqVVml+FauyY6VSomiS26cfc2o+rBOD45LmH+JqyEEHVUR/6iojW+wjlUky5Kypo
         CVAu8VwwOZCxh2qEn/BHjAoQN2viN1TCAui6bp4L/kn8R39rY+J7jOnwq2PCX6Z/Br1N
         RfuDhOFR2cxrtxQX1362vh66EYzhZd1+Fk/Nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683390501; x=1685982501;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7mtNhxi7lADUNX5J41YhK2a1NMcj5Vf4XMV1hRztvYM=;
        b=JaRZcKL+WqUdp+XqZHZYkbs0PHc0t+xaWU2WRpZly7ytkSARtK6QWGk+cv8gY0ZCQ1
         w+L21orZ9uSFSXY5E0hoVLaTWwJlzfN7KW0n5Fywk58BRakQ+jBFFffr2H0qa4YvlXwf
         SuQ232kINfbtJdjmJJ7Binvt+Ah+iTCXtS62AdPGg6zD939o2qK3jAAe6vbMGgVERedZ
         Sg/HkCDOLOAAwZS2GUFFq8saGXZS+95nvxHD4P7a5AXQ1dNlEw9cPommNmI0sh8yQNtx
         Uqv79xrrnzLjSA5X1myNMwugq/eQkrRv3lcZGRqvn383Xn8LafP7+lTDJNsoLuXGsyNL
         HOiw==
X-Gm-Message-State: AC+VfDzmSvb87OJmSvZBJ2RmhdBktPsMyQkNjbs7KMtLFC3jLTMujGcc
        WAquACC23EsCgGmwmNzfHpqwia92XprlsA9bB9L8UgEaS3mhZ7A8xlfI2mPAqklbsv5Z8I+pHj1
        aLSGyl3eAYN9Xo5rerxpxAbhtODaN2uN63y+NTJE9bpuJq5/LzSatXVB66KvpEvLpigNW94Tc
X-Google-Smtp-Source: ACHHUZ4LGhcK5kxxET7COj5DzLPybZ1fypNsqCKmgePreK12N4R1CgKDsX029hoMDd0H8PprfPW7mg==
X-Received: by 2002:a6b:dc17:0:b0:769:a243:6255 with SMTP id s23-20020a6bdc17000000b00769a2436255mr3236631ioc.1.1683390501499;
        Sat, 06 May 2023 09:28:21 -0700 (PDT)
Received: from [172.22.22.28] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id a11-20020a5d980b000000b007697fe48ca8sm813809iol.47.2023.05.06.09.28.19
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 May 2023 09:28:20 -0700 (PDT)
Message-ID: <d11acbac-a31b-b38c-8e10-b664ec52a47b@ieee.org>
Date:   Sat, 6 May 2023 11:28:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     linux-raid@vger.kernel.org
From:   Alex Elder <elder@ieee.org>
Subject: Second of 3 drives in RAID5 missing
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have a 3-drive RAID5 that I set up more than 5 years ago.
At some point, the "middle" drive failed (hardware failure).
I bought a replacement and issued some commands to attempt
to recover, and did *something* wrong.  I was too busy to
spend time to fix this then, and one thing led to another,
and now it's 2023 and I'd like to fire the array up again.

The current state is that /dev/md127 gets created automatically
and it contains the two good disks (partitions).  I'm pretty
sure this should be easy enough to recover if I issue the
right commands to rebuild things.

The disks are 8TB Seagate Ironwolf drives. (ST8000VN0022-2EL)
They are partitioned identically, with a GPT label.  The first
partition starts at offset 2048 sectors and continues to the end.
The RAID device was originally created with this command:
   mdadm --create /dev/md/z --level=5 --raid-devices=3 /dev/sd{b,c,d}1

I'm going to provide the output of a few commands below, and
will gladly provide whatever other information is required
to get this fixed.

Thank you.

					-Alex

root@meat:/# mdadm --version
mdadm - v4.2 - 2021-12-30 - Ubuntu 4.2-3ubuntu1
root@meat:/#

root@meat:/# mdadm --detail --scan
INACTIVE-ARRAY /dev/md127 metadata=1.2 name=meat:z 
UUID=8a021a34:f19bbc01:7bcf6f8e:3bea43a9
root@meat:/#

root@meat:/# mdadm --detail /dev/md127
/dev/md127:
            Version : 1.2
         Raid Level : raid5
      Total Devices : 2
        Persistence : Superblock is persistent

              State : inactive
    Working Devices : 2

               Name : meat:z  (local to host meat)
               UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
             Events : 9534

     Number   Major   Minor   RaidDevice

        -       8       49        -        /dev/sdd1
        -       8       17        -        /dev/sdb1
root@meat:/#

root@meat:/# ls -l /dev/sd[bcd]1
brw-rw---- 1 root disk 8, 17 May  6 11:20 /dev/sdb1
brw-rw---- 1 root disk 8, 33 May  6 11:20 /dev/sdc1
brw-rw---- 1 root disk 8, 49 May  6 11:20 /dev/sdd1
root@meat:/#

=========== Here's the disk that got replaced
root@meat:/# mdadm --examine /dev/sdc1
mdadm: No md superblock detected on /dev/sdc1.
root@meat:/#

=========== Here are the other two  disks
root@meat:/# mdadm --examine /dev/sd[bd]1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
            Name : meat:z  (local to host meat)
   Creation Time : Sun Oct 22 21:19:23 2017
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 15627786240 sectors (7.28 TiB 8.00 TB)
      Array Size : 15627786240 KiB (14.55 TiB 16.00 TB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=0 sectors
           State : clean
     Device UUID : 4cd855b7:ecba9064:b74a2182:bbc8a994

Internal Bitmap : 8 sectors from superblock
     Update Time : Sun Dec 13 16:51:21 2020
   Bad Block Log : 512 entries available at offset 40 sectors
        Checksum : be977447 - correct
          Events : 9534

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
            Name : meat:z  (local to host meat)
   Creation Time : Sun Oct 22 21:19:23 2017
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 15627786240 sectors (7.28 TiB 8.00 TB)
      Array Size : 15627786240 KiB (14.55 TiB 16.00 TB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=0 sectors
           State : clean
     Device UUID : 1d2ce616:943d0c86:fa9ef8ad:87e31be0

Internal Bitmap : 8 sectors from superblock
     Update Time : Sun Dec 13 16:51:21 2020
   Bad Block Log : 512 entries available at offset 40 sectors
        Checksum : b6ece242 - correct
          Events : 9534

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
root@meat:/#



