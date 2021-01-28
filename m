Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B522C433E6
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jan 2021 11:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E837164DDC
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jan 2021 11:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhA1LVV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jan 2021 06:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhA1LVU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jan 2021 06:21:20 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921FAC061573
        for <linux-raid@vger.kernel.org>; Thu, 28 Jan 2021 03:20:40 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id bl23so7183671ejb.5
        for <linux-raid@vger.kernel.org>; Thu, 28 Jan 2021 03:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=FW0cdTM7A2L03s0BomGwyUe4NarZowSpzPNWfsDoRHA=;
        b=AII2bId+zd4YFjJKf9OWKzMCStB/t1qDQ0kZyjhnMBkCHoA9Xb7uW3i4jj7POhRcR3
         mSb87f8o117IQE9jwH8+FlqwYTiJhB7NaTcj1ntGJZ8qVcAM35wpUsKiMcWs3VJswREw
         wZEqC9ZNRGV/eCT+CzVeRMTAs+G7Q5g9vpP0Su57RBCnWx79hzj0E7liujwtiBZ7Me8U
         WtP0gEDAS/EcdvSVdoXkMhvn9JxnFkFkFAeX5kf89hZh3rLL0tgFMkfD5FeJWVj0RP2S
         SNygDFsQbs9f3xerWI8CIe30D6A+1FNVMS7HxOHkPiMkyuFRLeGWVWHBg+ZFwwUhEjVT
         M/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=FW0cdTM7A2L03s0BomGwyUe4NarZowSpzPNWfsDoRHA=;
        b=qf6NAxmn5WuuEu+JazcRv2uE9Q/ZHjDFA5H4sMs8WC0umS/6Z2KVLW/W/ZPp8zu0QP
         UjpYPXXQ+ie/7CHSLjI2VfSASyUC2noLrBx1YjyIY4ajgHOlnmmlHpiuUZDAaWSzql7P
         GyAA+xLEYHTTAb8fNmHDXMZmXTUaRZhfzroVf1waR0CSPi3qhR3aTEF/WUfy3Af4L4hJ
         zf4BOtpcGK2KWPvRasnSHCY1YpD4gBPdbgFdSl3jAqb1Tqkkpy06HnOHumJ4D/zn7fWN
         j0EDCv7vO3xMN7HGGbkPiv6RZAUEXCNbMJFXeFkuhXmd+zqZHKq6XmCr+1V1M9cE63tz
         v2Gw==
X-Gm-Message-State: AOAM533auMi5ECWbOR+1Adh6UVBeYLzHjBjeYi/dbN3NfupZAH8IY1gy
        bRnRDYmsoXyzrCdgXdblpdhlyusl0qVB3A==
X-Google-Smtp-Source: ABdhPJxe1QgZ1qTxslp95j6DR0As3tXswhDDPCUsrrZV5HKospHIdwUUfQ/tu7+EksTXjRLPvM4BTQ==
X-Received: by 2002:a17:906:f144:: with SMTP id gw4mr10662306ejb.189.1611832839359;
        Thu, 28 Jan 2021 03:20:39 -0800 (PST)
Received: from [192.168.0.7] ([65.18.223.249])
        by smtp.googlemail.com with ESMTPSA id e6sm2349649edv.46.2021.01.28.03.20.37
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 03:20:38 -0800 (PST)
From:   George Shuklin <george.shuklin@gmail.com>
Subject: md: Speed shrinks with drives number
To:     linux-raid@vger.kernel.org
Message-ID: <d5acde4e-e3a1-debe-0b8c-866a8cb11584@gmail.com>
Date:   Thu, 28 Jan 2021 13:20:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

TL;DR; The more drives are in the array, the slower it is.

I found this when I was debugging NVME array issues, but I was able to 
reduce it to the case with with ram-disks, so no special hardware involved.

It can be reproduced on any machine with reasonable amount of memory 
(16-32Gb). I checked it on Ubuntu Focal (5.4.0-65-generic), Groovy 
(5.8.0-41-generic), Centos 8

For a very fast underlying device (NVME or brd: block ram disk) the more 
drives are added to the array, the slower it become, and it's irrelevant 
of the array type: raid1, 0, 10.

The speed lost is very high: a single ram-disk is yielding 200-250 
kIOPS, the raid0 of 4 ram disks yields less than 150kIOPS, and 100 RAM 
disks in raid0 yields mere 30 kIOPS.

The script to reproduce the issue:


export NUM=100  # or any other number between 1 and 1920.

modprobe brd rd_nr=${NUM} rd_size=10000
mdadm --create /dev/md42 -n ${NUM} -l raid0 --assume-clean /dev/ram* -e 
1.2 --force
fio --name test --ioengine=libaio   --blocksize=4k --iodepth=${NUM} 
--rw=randwrite --time_based   --runtime=5s --ramp_time=1s   --fsync=1 
--direct=1 --disk_util=0 --filename=/dev/md42
mdadm --stop /dev/md42
rmmod brd

My laptop (baseline for ram0 without raid - 197k IOPS)

disks in array - IOPS

1 - 108k
2 - 103k
4 - 99.0k
8 - 89.8k
16 - 75.5k
32 - 52.6k
64 - 34.7k
128 - 20.5k
256 - 11.3k
512 - 5.9k
1024 - 3.4k
1920 - 1.5k

(without --assume-clean it's the same, using --iodepth=1 intead of 
${NUM} gives the same).

I feel that having 1.5k IOPS on RAID0 consisting of 1920 ram-disks is a 
bit slow.

P.S. The real issue is with NVME devices in 10 drives per array, they 
shows even faster decline, but ram-disk make it more visual.

