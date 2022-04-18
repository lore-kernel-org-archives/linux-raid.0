Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95545C4321E
	for <linux-raid@archiver.kernel.org>; Mon, 18 Apr 2022 12:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbiDRM3u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Apr 2022 08:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240110AbiDRM3U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Apr 2022 08:29:20 -0400
X-Greylist: delayed 118 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Apr 2022 05:23:16 PDT
Received: from srv8.trombetti.net (srv8.trombetti.net [81.4.105.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E6B5237C8
        for <linux-raid@vger.kernel.org>; Mon, 18 Apr 2022 05:23:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sasluser)
        by srv8.trombetti.net (Postfix) with ESMTPSA id E1426C01935
        for <linux-raid@vger.kernel.org>; Mon, 18 Apr 2022 08:21:17 -0400 (EDT)
Message-ID: <156a484a-aa6a-438a-9ef1-db193e2babc3@shiftmail.org>
Date:   Mon, 18 Apr 2022 14:21:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     linux-raid <linux-raid@vger.kernel.org>
From:   "Nik.Brt." <nik.brt@shiftmail.org>
Subject: Read error in superblock not handled well by MD
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello all,

recently in a server we had what seemed to be a sporadic corruption 
during write, and that happened during the write of the superblock and 
the bitmap on one disk of an array.

This corruption resulted in two consecutive 4k sectors (superblock, 
bitmap) being unreadable on a disk which was otherwise good.
The array was a raid1 with 2 disks. The disks are of model WDC 
WD60EFRX-68MYMN1.
We realized about that error due to SMART long tests, because MD/mdadm 
would not tell us anything.
Trying to read with dd, we could confirm the on-disk problem (read error).
Also mdadm --examine and --examine-bitmap could obviously not read any 
valid data from there

After this episode, MD didn't behave well IMHO.

During array checks the error was not reported and the superblock and 
the bitmap on that disk would never be rewritten; during event count 
changes the superblock on that disk was never rewritten (it was written 
on the other disk of the array), and during writes to the array, the 
bitmap of that disk was never rewritten (it was written on the other 
disk of the array).
The array stayed up otherwise, but had we restarted the server, it would 
have restarted with 1 disk only.

We waited days to see if the problem would resolve on its own but it 
wouldn't.
Then we went in and used dd to overwrite those two 4k sectors with zeroes.
The disk was good so this solved the read error problem instantly and at 
the first attempt.

After a very short time, less than 2 minutes, MD restarted rewriting 
those sectors so we again had a good superblock and good bitmap on the 
previously-bad disk.

So I suppose what MD does is: before updating the superblock and/or the 
bitmap, MD tries to read such sectors. If it encounters a read error it 
refrains from rewriting such sectors, however reading zeroes (a clearly 
invalid value) is apparently fine.

I'm not sure of why the algorithm is like this, but it prevents to fix a 
disk surface problem / read error on disks in the superblock and/or 
bitmap areas, and those are not fixed even during check/repair actions 
for the array.

I propose that MD should write those sectors without attempting to read 
them first.

Thank you
N.Br. (prefer not to be acknowledged for this bug report or fix)

