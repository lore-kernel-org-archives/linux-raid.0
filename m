Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB9ACA0FF3
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 20:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350716AbjIAUYC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 16:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244443AbjIAUYC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 16:24:02 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B42E7E
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 13:23:58 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-500760b296aso469616e87.0
        for <linux-raid@vger.kernel.org>; Fri, 01 Sep 2023 13:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693599836; x=1694204636; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4zU8YFCJfrESduucsXqptkeesw4nMd1tzfSfc8JxrL0=;
        b=QKqgVChp7IX5gXH/TUxBhCgv+WSuoC8FrObKVpq4CQ46jvAmzxai2+q31/Mkp10Wim
         gv6tefBnzQEoJfL3/YODIyfkWY2YUsL7YwQSBwANHA6uDBXS9RLV2SPDv3nVLUkfHE5i
         oJUZtJA3ToBe0Yh0KNBBPtNQzuTaknoTlI8mX1cA/YIEO2Yww3Q5jQWnFFQfuvhILYDu
         63OIioqSpPi9ObHIk0Kb8f6EvbF3aPw9H8PUNiFadehRKlrkWzErgrEvkKpgqN8vvk3v
         WIWSG4AdbcjJ/l7KM0+I7NYW/N1Hix5Ayb19W/A/q5XyFkA6WHar8+H/Z1BnIdwWXHmj
         1Y3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693599836; x=1694204636;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4zU8YFCJfrESduucsXqptkeesw4nMd1tzfSfc8JxrL0=;
        b=YMPUzegkj8n4+Wt0ZC+Bt8gKqH6ZmneHxDmqbHENkqjNwtHQwlTX+n+e2An9pVKWXo
         pGwpcWsD/EqAwbrkC+cSas+Oj7Uhl846zI0Wpk7K8QT8YY7Un2DVuygUJL12lBn7YANY
         aqps8tiOERyJDDkU0jpr3N9gNJolqpCrAv7/Lbc0G/+RyGAeICzaQTjqvL0ERUXMT1m3
         93ojybBRzO3u0F62pp2TUNm2ZedR2k9139QtckJalIG8a8XrUV3iwdMq7JOcVBdkMYSy
         ZxfNdxxoeMidcVhaNkWepCnqdkDP9Rgbq7saiHwCnMb+j57EkmJYKdPoa5GbHHfofEfh
         xmkw==
X-Gm-Message-State: AOJu0Ywe87fseRWJi52bT6YA1v0ICK8bhTzmUFogYf5HHaeAvVbI38Xe
        5MN5/qAsfaCTlhGYhmBDIpXoLMrrjyYEY20JuGUmep3GYFPQ5A==
X-Google-Smtp-Source: AGHT+IHPjkcU2aDHjRfin4mi9wnfPF9CiaMjWlGyITHhZuXHlMAaPAc25lewW1fDNTbPvVl47cLR7ZOYvMgdvwSgJ98=
X-Received: by 2002:a05:6512:39c5:b0:500:7bf0:2b91 with SMTP id
 k5-20020a05651239c500b005007bf02b91mr2571325lfu.13.1693599836350; Fri, 01 Sep
 2023 13:23:56 -0700 (PDT)
MIME-Version: 1.0
From:   CoolCold <coolthecold@gmail.com>
Date:   Sat, 2 Sep 2023 03:23:00 +0700
Message-ID: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
Subject: raid10, far layout initial sync slow + XFS question
To:     Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good day!

I have 4 NVMe new drives which are planned to replace 2 current NVMe
drives, serving primarily as MYSQL storage, Hetzner dedicated server
AX161 if it matters. Drives are SAMSUNG MZQL23T8HCLS-00A07, 3.8TB .
System - Ubuntu 20.04 / 5.4.0-153-generic #170-Ubuntu

So the strange thing I do observe, is its initial raid sync speed.
Created with:
mdadm --create /dev/md3 --run -b none --level=10 --layout=f2
--chunk=16 --raid-devices=4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n1
/dev/nvme5n1

sync speed:

md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
      7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UUUU]
      [=>...................]  resync =  6.2% (466905632/7501212288)
finish=207.7min speed=564418K/sec

If I try to create RAID1 with just two drives - sync speed is around
3.2GByte per second, sysclt is tuned of course:
dev.raid.speed_limit_max = 8000000

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md70 : active raid1 nvme4n1[1] nvme5n1[0]
      3750606144 blocks super 1.2 [2/2] [UU]
      [>....................]  resync =  1.5% (58270272/3750606144)
finish=19.0min speed=3237244K/sec

From iostat, drives are basically doing just READs, no writes.
Quick tests with fio, mounting single drive shows it can do around 30k
IOPS with 16kb ( fio --rw=write --ioengine=sync --fdatasync=1
--directory=test-data --size=8200m --bs=16k --name=mytest ) so likely
issue are not drives themselves.

Not sure where to look further, please advise.

-- 
Best regards,
[COOLCOLD-RIPN]
