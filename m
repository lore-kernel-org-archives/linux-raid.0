Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F142C43461
	for <linux-raid@archiver.kernel.org>; Wed,  7 Apr 2021 18:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BACC601FE
	for <linux-raid@archiver.kernel.org>; Wed,  7 Apr 2021 18:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhDGSVs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Apr 2021 14:21:48 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:39309 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229606AbhDGSVp (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 7 Apr 2021 14:21:45 -0400
Received: from [192.168.0.2] (ip5f5ae880.dynamic.kabel-deutschland.de [95.90.232.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 03491206473D0;
        Wed,  7 Apr 2021 20:21:34 +0200 (CEST)
To:     Hugh Dickins <hughd@google.com>
Cc:     linux-mm@kvack.org, linux-raid@vger.kernel.org
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: SHM: blk_update_request: I/O error, dev loop5, sector 1001648 op
 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
Message-ID: <2fb258a5-30d6-472c-364f-e190346e40d3@molgen.mpg.de>
Date:   Wed, 7 Apr 2021 20:21:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Linux folks,


Probably, I am overlooking something, but testing a RAID6 setup with 
loop-mounted fails on 16 GB RAM system (AMD and Intel), results in the 
errors below. This happens with Linux 4.19.57 and 5.10.24 for example.

$ cd /dev/shm
$ for i in $(seq 1 16); do truncate -s 512M vdisk$i.img; done
[…]
$ sudo mdadm --create /dev/md1 --level=6 --raid-devices=16 
/dev/loop{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
$ dmesg
[…]
[879198.509123] md/raid:md1: not clean -- starting background reconstruction
[879198.515895] md/raid:md1: device loop15 operational as raid disk 15
[879198.522115] md/raid:md1: device loop14 operational as raid disk 14
[879198.528323] md/raid:md1: device loop13 operational as raid disk 13
[879198.534525] md/raid:md1: device loop12 operational as raid disk 12
[879198.540724] md/raid:md1: device loop11 operational as raid disk 11
[879198.546924] md/raid:md1: device loop10 operational as raid disk 10
[879198.553126] md/raid:md1: device loop9 operational as raid disk 9
[879198.559155] md/raid:md1: device loop8 operational as raid disk 8
[879198.565185] md/raid:md1: device loop7 operational as raid disk 7
[879198.571212] md/raid:md1: device loop6 operational as raid disk 6
[879198.577238] md/raid:md1: device loop5 operational as raid disk 5
[879198.583269] md/raid:md1: device loop4 operational as raid disk 4
[879198.589296] md/raid:md1: device loop3 operational as raid disk 3
[879198.595324] md/raid:md1: device loop2 operational as raid disk 2
[879198.601353] md/raid:md1: device loop1 operational as raid disk 1
[879198.607381] md/raid:md1: device loop0 operational as raid disk 0
[879198.613971] md/raid:md1: raid level 6 active with 16 out of 16 
devices, algorithm 2
[879198.621667] md1: detected capacity change from 0 to 7486832640
[879198.627643] md: resync of RAID array md1
[879203.512870] blk_update_request: I/O error, dev loop5, sector 1001648 
op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.512872] blk_update_request: I/O error, dev loop6, sector 1001648 
op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.512874] blk_update_request: I/O error, dev loop7, sector 1001648 
op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.512878] blk_update_request: I/O error, dev loop8, sector 1001656 
op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.512880] blk_update_request: I/O error, dev loop9, sector 1001656 
op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.512882] blk_update_request: I/O error, dev loop10, sector 
1001656 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.512884] blk_update_request: I/O error, dev loop11, sector 
1001656 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.512885] blk_update_request: I/O error, dev loop12, sector 
1001656 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.512886] blk_update_request: I/O error, dev loop13, sector 
1001656 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.512887] blk_update_request: I/O error, dev loop15, sector 
1001656 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[879203.526116] md/raid:md1: 558 read_errors > 557 stripes
[879203.526117] md/raid:md1: 558 read_errors > 557 stripes
[879203.526118] md/raid:md1: 558 read_errors > 557 stripes
[879203.526118] md/raid:md1: Too many read errors, failing device loop6.
[879203.526118] md/raid:md1: Too many read errors, failing device loop7.
[879203.526119] md/raid:md1: Disk failure on loop6, disabling device.
                 md/raid:md1: Operation continuing on 15 devices.
[879203.526120] md/raid:md1: Disk failure on loop7, disabling device.
                 md/raid:md1: Operation continuing on 14 devices.
[879203.526127] md/raid:md1: read error not correctable (sector 1002288 
on loop9).
[879203.526128] md/raid:md1: read error not correctable (sector 1002288 
on loop10).
[879203.526129] md/raid:md1: read error not correctable (sector 1002288 
on loop8).
[879203.526130] md/raid:md1: read error not correctable (sector 1002288 
on loop11).
[879203.526131] md/raid:md1: read error not correctable (sector 1002288 
on loop12).
[879203.526134] md/raid:md1: read error not correctable (sector 1002288 
on loop15).
[879203.526136] md/raid:md1: read error not correctable (sector 1002280 
on loop2).
[879203.526137] md/raid:md1: read error not correctable (sector 1002280 
on loop0).
[879203.526138] md/raid:md1: read error not correctable (sector 1002288 
on loop2).
[879203.526139] md/raid:md1: read error not correctable (sector 1002288 
on loop4).
[879203.528980] md: md1: resync interrupted.
[879203.746692] md/raid:md1: Too many read errors, failing device loop5.
[879203.765274] md: resync of RAID array md1
[879203.769254] md: md1: resync done.
[879220.534393] md1: detected capacity change from 7486832640 to 0
[879220.540270] md: md1 stopped.
$ sudo mdadm -S /dev/md1 && sudo losetup -D && rm vdisk*
```


Kind regards,

Paul
