Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91339C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 09:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjKMJgZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Nov 2023 04:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjKMJgY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Nov 2023 04:36:24 -0500
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CBC10E9
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 01:36:20 -0800 (PST)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4STPSf2V6Nz9R67
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 20:36:18 +1100 (AEDT)
Received: from [192.168.2.7] (unknown [101.115.9.238])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4STPSf17zCz9QXC
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 20:36:18 +1100 (AEDT)
Message-ID: <60e4892e-f6b3-4f0a-956d-09555d8ee147@eyal.emu.id.au>
Date:   Mon, 13 Nov 2023 20:36:15 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: extremely slow writes to array [now not degraded]
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
 <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
 <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
 <1d0fb40a-1908-4b5e-9856-a5b79eafdc9c@eyal.emu.id.au>
 <ZVHIPNwC2RKTVmok@vault.lan>
 <182d07c8-a76e-430d-90e8-6df8c1f1c54d@eyal.emu.id.au>
 <ZVHqbnFRU4bXBDNQ@vault.lan>
From:   eyal@eyal.emu.id.au
In-Reply-To: <ZVHqbnFRU4bXBDNQ@vault.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13/11/2023 20.20, Johannes Truschnigg wrote:
> Interesting data; thanks for providing it. Unfortunately, I am not familiar
> with that part of kernel code at all, but there's two observations that I can
> contribute:
> 
> According to kernel source, `ext4_mb_scan_aligned` is a "special case for
> storages like raid5", where "we try to find stripe-aligned chunks for
> stripe-size-multiple requests" - and it seems that on your system, it might be
> trying a tad too hard. I don't have a kernel source tree handy right now to
> take a look at what might have changed in the function and any of its
> calle[er]s during recent times, but it's the first place I'd go take a closer
> look at.

Maybe someone else is able to look into this part? One hopes.

> Also, there's a recent Kernel bugzilla entry[0] that observes a similarly
> pathological behavior from ext4 on a single disk of spinning rust where that
> particular function appears in the call stack, and which revolves around an
> mkfs-time-enabled feature which will, afaik, happen to also be set if
> mke2fs(8) detects md RAID in the storage stack beneath the device it is
> supposed to format (and which SHOULD get set, esp. for parity-based RAID).
> 
> Chances are you may be able to disable this particular optimization by running
> `tune2fs -E stride=0` against the filesystem's backing array (be warned that I
> did NOT verify if that might screw your data, which it very well could!!) and
> remounting it afterwards, to check if that is indeed (part of) the underlying
> cause to the poor performance you see. If you choose to try that, make sure to
> record the current stride-size, so you may re-apply it at a later time
> (`tune2fs -l` should do).

No, I am not ready to take this chance, but here is the relevant data anyway (see below).
However, maybe I could boot into an older kernel, but the oldest I have is 6.5.7, not that far behind.

The fact that recently the machine crashed and the array was reassembled may have offered an opportunity
for some setting to go out of wack. This is above my pay grade...

tune2fs 1.46.5 (30-Dec-2021)
Filesystem volume name:   7x12TB
Last mounted on:          /data1
Filesystem UUID:          378e74a6-e379-4bd5-ade5-f3cd85952099
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr dir_index filetype needs_recovery extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              57220480
Block count:              14648440320
Reserved block count:     0
Overhead clusters:        4921116
Free blocks:              2615571465
Free inodes:              55168125
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         128
Inode blocks per group:   8
RAID stride:              128
RAID stripe width:        640
Flex block group size:    16
Filesystem created:       Fri Oct 26 17:58:35 2018
Last mount time:          Mon Nov 13 16:28:16 2023
Last write time:          Mon Nov 13 16:28:16 2023
Mount count:              7
Maximum mount count:      -1
Last checked:             Tue Oct 31 18:15:25 2023
Check interval:           0 (<none>)
Lifetime writes:          495 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     32
Desired extra isize:      32
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      7eb08e20-5ee6-46af-9ef9-2d1280dfae98
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0x3590ae50

> [0]: https://bugzilla.kernel.org/show_bug.cgi?id=217965
> 

-- 
Eyal at Home (eyal@eyal.emu.id.au)

