Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19928C64E8A
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 21:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD1012084C
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 21:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387511AbgK3V5n (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 16:57:43 -0500
Received: from mail.thelounge.net ([91.118.73.15]:18457 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387480AbgK3V5n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Nov 2020 16:57:43 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4ClJwr4vmKzXVl;
        Mon, 30 Nov 2020 22:57:00 +0100 (CET)
To:     David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
 <ef7d7b4c-d7d2-1bff-8b13-2187889162af@grumpydevil.homelinux.org>
 <ed411d06-c343-43dc-04e1-0a17658cb989@thelounge.net>
 <20201130200620.GW1415@justpickone.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: ???root account locked??? after removing one RAID1 hard disc
Message-ID: <e580e980-1842-b505-8159-e921ccd412a8@thelounge.net>
Date:   Mon, 30 Nov 2020 22:57:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130200620.GW1415@justpickone.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 30.11.20 um 21:06 schrieb David T-G:
> Reindl, et al --
> 
> ...and then Reindl Harald said...
> %
> ...
> %
> % typically fire up my "raid-repair.sh" telling the script source and
> % target disk for cloning partition table, mbr and finally add the new
> % partitions to start the rebuild
> [snip]
> 
> Oooh!  How handy :-)  Share, please!

just make sure GOOD_DISK is one of the remaining and BAD_DISK is the 
repalcement drive before uncomment the "exit"

and yeah, adjust how many raid-partitions are there

the first is my homeserver with 3 filesystems (boot, system, data), the 
second one is a RAID10 on a HP microserver with the OS on a sd-card

---------------------------------------------------------------------

DOS:

[root@srv-rhsoft:~]$ cat /scripts/raid-recovery.sh
#!/usr/bin/bash

GOOD_DISK="/dev/sda"
BAD_DISK="/dev/sdd"

echo "NOT NOW"
exit 1

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

---------------------------------------------------------------------

GPT:

[root@nfs:~]$ cat /scripts/raid-recovery.sh
#!/usr/bin/bash

GOOD_DISK="/dev/sda"
BAD_DISK="/dev/sde"

echo "NOT NOW"
exit 1

echo "sgdisk $GOOD_DISK -R $BAD_DISK"
sgdisk $GOOD_DISK -R $BAD_DISK

echo "sgdisk -G $BAD_DISK"
sgdisk -G $BAD_DISK

echo "sleep 5"
sleep 5

echo "partprobe $BAD_DISK"
partprobe $BAD_DISK

echo "sleep 5"
sleep 5

echo "mdadm /dev/md0 --add ${BAD_DISK}1"
mdadm /dev/md0 --add ${BAD_DISK}1

echo "sleep 5"
sleep 5

echo "cat /proc/mdstat"
cat /proc/mdstat

---------------------------------------------------------------------
