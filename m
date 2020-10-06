Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213D5C41604
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 17:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7F0A206F7
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 17:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgJFRAi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 13:00:38 -0400
Received: from mail.thelounge.net ([91.118.73.15]:27205 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJFRAi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Oct 2020 13:00:38 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4C5Ny967PMzXNf;
        Tue,  6 Oct 2020 19:00:28 +0200 (CEST)
To:     linux-raid@zq3q.org, Linux-RAID <linux-raid@vger.kernel.org>
References: <202010061607.096G7CgT4052287@epjdn.zq3q.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: pls help/review: fed 32 | LVM over raid1, on SSDs & spinning
 disks
Message-ID: <1f21b8cb-a9eb-74e8-24b5-550d016b6473@thelounge.net>
Date:   Tue, 6 Oct 2020 19:00:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <202010061607.096G7CgT4052287@epjdn.zq3q.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 06.10.20 um 18:07 schrieb linux-raid@zq3q.org:
> Is it possible to get the 2MiB "bios boot" partition into raid1?
> This seems to be the most vulnerable part of my setup.
should be no problem when you have the same partitioning on all disks, 
"BIOS boot" normally have no writes at boot time

RAID1 is handeled like a single disk at early boot

the only thing you need to do manually is install the bootloaer on all 
disks and don#t forget repeat it after replace one

the only thing i am not sure is the partition type, until now my setups 
are MBR and sda1 is a RAID1 over all 4 disks

[root@srv-rhsoft:~]$ fdisk -l /dev/sda
Disk /dev/sda: 1.84 TiB, 2000398934016 bytes, 3907029168 sectors
Disk model: Samsung SSD 860
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000d9ef2

Device     Boot    Start        End    Sectors  Size Id Type
/dev/sda1  *        2048    1026047    1024000  500M fd Linux raid 
autodetect
/dev/sda2        1026048   31746047   30720000 14.7G fd Linux raid 
autodetect
/dev/sda3       31746048 3906971647 3875225600  1.8T fd Linux raid 
autodetect

[root@srv-rhsoft:~]$ df
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/md1       ext4   29G  7.4G   22G  26% /
/dev/md2       ext4  3.6T  1.2T  2.5T  33% /mnt/data
/dev/md0       ext4  485M   49M  432M  11% /boot
