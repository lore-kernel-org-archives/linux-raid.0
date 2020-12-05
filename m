Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E176C433FE
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 21:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD55B230F9
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 21:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgLEVCa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Dec 2020 16:02:30 -0500
Received: from mout.perfora.net ([74.208.4.197]:47773 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEVCa (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 5 Dec 2020 16:02:30 -0500
Received: from [192.168.1.23] ([72.94.51.172]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1N7RQ1-1k6Qew08K5-017oAM
 for <linux-raid@vger.kernel.org>; Sat, 05 Dec 2020 22:01:19 +0100
Subject: Re: Disk identifiers
To:     list Linux RAID <linux-raid@vger.kernel.org>
References: <5B155FE8-2761-47FF-BDBA-F5AE3A9BC396@meddatainc.com>
 <24523.11681.86857.449384@cyme.ty.sabi.co.uk>
 <3302e569-5ac4-1738-1d9f-9f1db66bfcee@meddatainc.com>
 <24523.55982.520696.570767@cyme.ty.sabi.co.uk>
From:   H <agents@meddatainc.com>
Message-ID: <362dc592-d2e4-d8a1-b167-a1e28a22c735@meddatainc.com>
Date:   Sat, 5 Dec 2020 16:01:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <24523.55982.520696.570767@cyme.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:9ENWqVWg8vMwDJsOHC4+j2x5w+BhUm22jkpULBV8uP7Hh2vgohU
 5iclqxIAsAWYMdGjKWnAQkiEFXmRJCC0qUysHnZwGE9XRGoiKmdkqrZbDBpf7kMSISWI4JX
 NiERL5U/kFHlYd734prgwNwCe80FzTkCPF3pTiAtt6ekkKubvpu38Fyc1fUXpAkuYidIVdV
 74TVkyVJ/q91yeF/uTekA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:0z8mwKe7AQA=:DVurfmwZj40CbBsmcU0aI3
 bx4njNc64+zodz6ymaMMQpAHI2MdFmZNDRBBe0PEg7GByS/NB0ctbY2bSuaIMLFeM/zrSrP0q
 mEIicmzN/QSEMYW744I1AVgli/XSrd4ioFWxGP9nNXC+gh8vqJZnu4VU3/LfyAEXNh6Fnp7YF
 3YWSKd5GXwj8FeK1xokOf4r9x/tEaF4+H28P39Vf50AUHEXPgToYwiiPThe5dwIKiJJl7XM7O
 E9jHnUu9AgXMbnbkWpgQwINo1dSLTUvu7qwxrla0CBvvmj8pPMKomES/qzCNlo9rEjJgYFpss
 YND55MEg5k47vovnJmPuNMTL/wVM9iSkuNloBBoy4Db13x1yR55m9kZeh5WaiVYi24hd1jZFt
 ZbYAMyBigGzzBOkPvcOiRKgcRUCkn67R3PBZZuIw6EkM1ekPql9h5UZobRfxOLqjwpQpuOVxL
 TwsSIpW8wQ==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/05/2020 02:08 PM, Peter Grandi wrote:
> [...]
>
>> I was referring to what fdisk -l calls "disk
>> identifier". [...]
> That's not a very fruitful approach :-). The real disk
> identifiers are the serial number or WWN.
>
> What 'fdisk' reports is the identifier of the "label" (called by
> 'fdisk' "Disklabel", which is a metadata block which usually
> contains the partition table, and of which there are several
> types).
>
> For MBR/DOS type labels that is a pretty obscure field at offset
> 0x1B8 on the disk, and it is a 32b field. I personally use it
> to store 4 characters, but it can be any 32-bit value.
>
> That value matters a lot more to MS-Windows than to GNU/Linux,
> which basically ignores it. I find that value used under
> '/dev/disk/by-partuuid/' where it is used to prefix the number
> of the partition for DOS/MBR labeled disks. BTW the entries
> under '/dev/disk/' seem to me a "legacy" mess.
>
> GPT/EFI labels instead have 128b fields which are usually filled
> with UUID-structured random values, and those are not ignored
> and usually appear under '/dev/disk/by-uuid'.
>
> For MD raid sets I like to use GPT labels and refer to RAID set
> members by partition name, where I give those partitions
> meaningful proper-name prefixes. But that's another story.

This is the output from fdisk -l where it is called "Disk identifier":

Disk /dev/sda: 256.1 GB, 256060514304 bytes, 500118192 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk label type: gpt
Disk identifier: 00000000-0000-0000-0000-000000000000

and the output from another disk:

Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes, 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: gpt
Disk identifier: EF1A3010-0A15-5A4B-A6FC-1B0EA869D0A7

Thus the disk identifier in the first case is not, as I had mentioned seeing in my first e-mail, something like 0x12345678, but rather a UUID-like number.

Should I change the disk identifier for the first disk to something else than all-zeroes? And, if so, should I use a UUID-like number since fdisk presents it as such or should I use a 8-character string?

I

