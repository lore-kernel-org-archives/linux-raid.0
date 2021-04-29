Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728E7C43461
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 15:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 206306143E
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 15:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhD2PwD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:52:03 -0400
Received: from mail.thelounge.net ([91.118.73.15]:50971 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbhD2PwC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Apr 2021 11:52:02 -0400
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Apr 2021 11:52:02 EDT
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4FWKLh1qNVzXNj;
        Thu, 29 Apr 2021 17:34:52 +0200 (CEST)
Subject: Re: add new disk with dd
To:     d tbsky <tbskyd@gmail.com>, Mateusz <mateusz-lists@ant.gliwice.pl>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHLDYhQDtfQMYozN6EBYB=nsKvB77hmyByZNr9uTpQH+KQ@mail.gmail.com>
 <7903054.T7Z3S40VBb@matkor-hp>
 <CAC6SzH+JM9EWiB9kQNPaSm8prX-hK3N7D7yzB3Po3nS43fZJ3A@mail.gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <8b4b8716-1ffd-5919-baf8-3f46de7ca479@thelounge.net>
Date:   Thu, 29 Apr 2021 17:34:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAC6SzH+JM9EWiB9kQNPaSm8prX-hK3N7D7yzB3Po3nS43fZJ3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 29.04.21 um 17:32 schrieb d tbsky:
> Mateusz <mateusz-lists@ant.gliwice.pl>
>> Should in most cases [1], but IMHO it's good idea to
>> mdadm --zero-superblock /dev/YOU_ARE_SURE_IS_ONE_YOU_WANT_TO_ADD
>> before adding disk already used somewhere else.
> 
>     "madam --zero-superblock" is great.  I will add it to my procedure.
>     thanks a lot for the hint!
> 
>> BTW,  IMHO it's better to clone partition layout, and than install bootloaders
>> instead of dding disk.
> 
>     yes. but sometimes dd is easy, especially for mbr layout.
> anyway I think your suggestion "--zero-superblock" make things safe
> with new and old disks

doing both for years on dozens of machines which have 3 RAID partitions 
(boot, os, data) on 4 disks with a script

GOOD_DISK is a full working one and BAD_DISK the blank drive

[root@srv-rhsoft:~]$ cat /scripts/raid-recovery.sh
#!/usr/bin/bash

GOOD_DISK="/dev/sda"
BAD_DISK="/dev/sdd"

# --------------------------------------------------------------------------

echo "NOT NOW"
exit

# --------------------------------------------------------------------------

# clone MBR
dd if=$GOOD_DISK of=$BAD_DISK bs=512 count=1

# force OS to read partition tables
partprobe $BAD_DISK

# start RAID recovery
mdadm /dev/md0 --add ${BAD_DISK}1
mdadm /dev/md1 --add ${BAD_DISK}2
mdadm /dev/md2 --add ${BAD_DISK}3

# print RAID status on screen
sleep 5
cat /proc/mdstat

# install bootloader on replacement disk
grub2-install "$BAD_DISK"
