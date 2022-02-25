Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB1CC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 25 Feb 2022 08:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbiBYIRc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Feb 2022 03:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbiBYIRb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Feb 2022 03:17:31 -0500
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Feb 2022 00:16:58 PST
Received: from pasta.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EFE488A8
        for <linux-raid@vger.kernel.org>; Fri, 25 Feb 2022 00:16:57 -0800 (PST)
Received: from pasta.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4K4jBD4f1Gz9PxM
        for <linux-raid@vger.kernel.org>; Fri, 25 Feb 2022 19:10:12 +1100 (AEDT)
Received: from [192.168.122.14] (unknown [121.45.47.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by pasta.tip.net.au (Postfix) with ESMTPSA id 4K4jBD3yRFz8tBG
        for <linux-raid@vger.kernel.org>; Fri, 25 Feb 2022 19:10:12 +1100 (AEDT)
Message-ID: <932f281a-3c42-a5cc-2705-ea32cf6af738@eyal.emu.id.au>
Date:   Fri, 25 Feb 2022 19:10:11 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: What leads to "bitmap file is out of date, doing full recovery"
To:     linux-raid@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

A few days ago my machine locked up hard, requiring pressing the reset button.
This morning I noticed that a resync is going on. Here are the relevant messages in the system log (after boot):
-----
Feb 23 21:16:09 e7 kernel: md/raid:md127: not clean -- starting background reconstruction
Feb 23 21:16:09 e7 kernel: md/raid:md127: device sdg1 operational as raid disk 5
Feb 23 21:16:09 e7 kernel: md/raid:md127: device sdf1 operational as raid disk 4
Feb 23 21:16:09 e7 kernel: md/raid:md127: device sdd1 operational as raid disk 2
Feb 23 21:16:09 e7 kernel: md/raid:md127: device sdh1 operational as raid disk 6
Feb 23 21:16:09 e7 kernel: md/raid:md127: device sde1 operational as raid disk 3
Feb 23 21:16:09 e7 kernel: md/raid:md127: device sdc1 operational as raid disk 1
Feb 23 21:16:09 e7 kernel: md/raid:md127: device sdb1 operational as raid disk 0
Feb 23 21:16:09 e7 kernel: md/raid:md127: raid level 6 active with 7 out of 7 devices, algorithm 2
Feb 23 21:16:09 e7 kernel: md127: bitmap file is out of date, doing full recovery
Feb 23 21:16:09 e7 kernel: md127: detected capacity change from 0 to 117187522560
Feb 23 21:16:09 e7 kernel: md: resync of RAID array md127
	Then finally
Feb 24 17:40:27 e7 kernel: md: md127: resync done.
Feb 24 17:40:28 e7 mdadm[1194]: RebuildFinished event detected on md device /dev/md127

fsck of the fs on md127 was clean.

I thought that the whole point of the logfile/bitmap is to avoid this and allow a quick recovery,
and as such these files are written very carefully and safely.

In the past, following a similar lockup/reset recovered quickly. bitmap was probably valid:
Oct  3 21:25:21 e7 kernel: md/raid:md127: not clean -- starting background reconstruction
Oct  3 21:25:21 e7 kernel: md/raid:md127: device sdf1 operational as raid disk 2
Oct  3 21:25:21 e7 kernel: md/raid:md127: device sdd1 operational as raid disk 4
Oct  3 21:25:21 e7 kernel: md/raid:md127: device sdi1 operational as raid disk 6
Oct  3 21:25:21 e7 kernel: md/raid:md127: device sdh1 operational as raid disk 0
Oct  3 21:25:21 e7 kernel: md/raid:md127: device sde1 operational as raid disk 3
Oct  3 21:25:21 e7 kernel: md/raid:md127: device sdg1 operational as raid disk 1
Oct  3 21:25:21 e7 kernel: md/raid:md127: device sdc1 operational as raid disk 5
Oct  3 21:25:21 e7 kernel: md/raid:md127: raid level 6 active with 7 out of 7 devices, algorithm 2
Oct  3 21:25:21 e7 kernel: md127: detected capacity change from 0 to 20003251814400
Oct  3 21:25:21 e7 kernel: md: resync of RAID array md127
Oct  3 21:25:23 e7 kernel: md: md127: resync done.

kernel is 5.16.9-100.fc34.x86_6
The array uses an internal bitmap.

What can lead to 'bitmap file is out of date'?

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
