Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D2DC433FE
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 19:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiCITYG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbiCITYC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 14:24:02 -0500
X-Greylist: delayed 942 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 11:22:39 PST
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A386304
        for <linux-raid@vger.kernel.org>; Wed,  9 Mar 2022 11:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:Sender
        :Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MQZGc6utTZ4kLmO015A5kHP65TZJ4ZaG51zTqLZISdY=; b=gop8ViZ1cYquIe5yh4Js03bgfI
        L7A9Rit+RbuCkSRVcKFDgJqoSgUioYtV9VSFXB0c9eru7JBkmOmlY8KOxv5mu9pwUbacmREUeMrm+
        r7mwkbfY7bBdLw76BT3XpsF8q1lA0Ah+Ir6+g6AjFSbAXmfz5SLFmIK/FMzNBw138hCo3gQeuS5ni
        AKRMAJZrAv+Z8srRjOHQ0+aA6NCQrElQ9cnf1apqmIteKIjoKkwMRQD8l1gmHAag9sOe8zmbXnAaK
        2q+epS3qqvmYobfm8vX5JIEOM3sJf/E72c+uzeLUGavRI1/SnbkElcb3c+ihySR6egR4dybPTkFz8
        PziQ6XQQ==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1nS1eC-0000CD-FC
        for linux-raid@vger.kernel.org; Wed, 09 Mar 2022 19:06:56 +0000
Date:   Wed, 9 Mar 2022 19:06:56 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Device LBA to array offset calculation
Message-ID: <20220309190656.lqd5igm6bhzmnun6@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Is there an easy way to work out what offset into /dev/md3 would
correspond to LBA 3141211755 on /dev/sdc?

$ sudo fdisk -u -l /dev/sdc
Disk /dev/sdc: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: A9D7DEE3-9894-4D43-92D0-F5CC3B6E9E2A

Device           Start        End    Sectors  Size Type
/dev/sdc1         2048    1050623    1048576  512M Linux RAID
/dev/sdc2      1050624    7342079    6291456    3G Linux RAID
/dev/sdc3      7342080    9439231    2097152    1G Linux swap
/dev/sdc4      9439232 3907022847 3897583616  1.8T Linux RAID
/dev/sdc128 3907022848 3907029134       6287  3.1M BIOS boot

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md3 : active raid10 sdc4[4] sdb4[3] sda4[0]
      2922991104 blocks super 1.2 512K chunks 2 far-copies [3/3] [UUU]
      bitmap: 0/22 pages [0KB], 65536KB chunk

An easier way than, "read the source," that is, the understanding
of which is a bit beyond me!

So it seems that is 3141211755 - 9439232 = 3131772523 sectors in to
device member sdc4, but md3 is a 3 device RAID-10 with far layout.

Cheers,
Andy
