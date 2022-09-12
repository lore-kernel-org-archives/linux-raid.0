Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39926ECAAD5
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 15:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiILPEq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 11:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiILPEp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 11:04:45 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAD56352
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 08:04:43 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MR8yb0Fl5zXLZ
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 17:04:39 +0200 (CEST)
Message-ID: <2341a2a9-b86e-f0e5-784a-05dbd474dec5@thelounge.net>
Date:   Mon, 12 Sep 2022 17:04:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Language: en-US
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: change UUID of RAID devcies
Organization: the lounge interactive design
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

is is possible to change the UUID of RAID devcies?

background: we have several machines with 4 disks (/boot RAID1, / 
RAID10, /data RAID10)

the plan is buy twice as large SSDs (currently HDD), partition them from 
a Live-ISO and dd-over-ssh the contents

at that time the RAID10 would be degraded and two disks out of the machines

besides the UUID one interesting question is how to make sure the copy 
of /etc/mdadm.conf contains "RAID1" instead of "RAID10"

the reason for that game is that the machines are running for 10 years 
now and all the new desktop hardware can't hold 4x3.5" disks and so just 
put them in a new one isn't possible

-----------------

[root@srv-rhsoft:~]$ cat /etc/mdadm.conf
MAILADDR root
HOMEHOST localhost.localdomain
AUTO +imsm +1.x -all

ARRAY /dev/md0 level=raid1 num-devices=4 
UUID=1d691642:baed26df:1d197496:4fb00ff8
ARRAY /dev/md1 level=raid10 num-devices=4 
UUID=b7475879:c95d9a47:c5043c02:0c5ae720
ARRAY /dev/md2 level=raid10 num-devices=4 
UUID=ea253255:cb915401:f32794ad:ce0fe396

-----------------

GRUB_CMDLINE_LINUX="quiet hpet=disable audit=0 rd.plymouth=0 
plymouth.enable=0 rd.md.uuid=b7475879:c95d9a47:c5043c02:0c5ae720 
rd.md.uuid=1d691642:baed26df:1d197496:4fb00ff8 
rd.md.uuid=ea253255:cb915401:f32794ad:ce0fe396 rd.luks=0 rd.lvm=0 
rd.dm=0 zswap.enabled=0 selinux=0 net.ifnames=0 biosdevname=0 noresume 
hibernate=no printk.time=0 nmi_watchdog=0 acpi_osi=Linux 
vconsole.font=latarcyrheb-sun16 vconsole.keymap=de-nodeadkeys 
locale.LANG=de_DE.UTF-8"
