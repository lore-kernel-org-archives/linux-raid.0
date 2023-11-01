Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BBAC4167D
	for <linux-raid@archiver.kernel.org>; Wed,  1 Nov 2023 10:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbjKAK4r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Nov 2023 06:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbjKAK4o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Nov 2023 06:56:44 -0400
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81E012E
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 03:56:38 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SL3pr5HH2z9RPf
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 21:56:36 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SL3pr2c6Mz9Q2v
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 21:56:36 +1100 (AEDT)
Message-ID: <6f40b05e-d5d3-4d85-9ce1-238cde112c1e@eyal.emu.id.au>
Date:   Wed, 1 Nov 2023 21:56:31 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To:     linux-raid@vger.kernel.org
Content-Language: en-US
From:   eyal@eyal.emu.id.au
Subject: how to start a degraded array that shows all members are spare
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have a thread with a full story, but I think that asking one question at a time will work better.

My array is degraded as one disk was sent for replacement.

The system failed (reason not important) and on restart I am in an emergency shell.
mdstat shows all members are spare.

The question is: what is the correct way to start the array when it is all spares (and degraded)?

This is what I did
==================
	mdadm --run /dev/md127
responds with
	says: cannot start dirty degraded array

mdadm --stop md127
mdadm --assemble /dev/md127 /dev/sd{b,c,d,e,f,g}1
	says: not clean -- starting background reconstruction
	says: cannot start dirty degraded array
	suggests to use --force

mdadm --assemble --force /dev/md127 /dev/sd{b,c,d,e,f,g}1
	starts the array.
In the system log I see
	md: requested-resync of RAID array md127
and mdstat shows a resync (maybe a different term?) in progress.

After a while I reboot and the system comes up but it has issues.

Now I see:
$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid6 sde1[4] sdc1[9] sdf1[5] sdb1[8] sdd1[7] sdg1[6]
       58593761280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [_UUUUUU]
       bitmap: 88/88 pages [352KB], 65536KB chunk

Before this drama it said "bitmap: 0/88" if this matters.

TIA

-- 
Eyal at Home (eyal@eyal.emu.id.au)
