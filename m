Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EA4C678D5
	for <linux-raid@archiver.kernel.org>; Sat,  4 Mar 2023 21:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjCDVgW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Mar 2023 16:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCDVgM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Mar 2023 16:36:12 -0500
Received: from z1.octopuce.fr (z1.octopuce.fr [91.194.60.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02A21ABCA
        for <linux-raid@vger.kernel.org>; Sat,  4 Mar 2023 13:36:09 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by z1.octopuce.fr (Postfix) with ESMTP id 592F73E747D
        for <linux-raid@vger.kernel.org>; Sat,  4 Mar 2023 22:36:07 +0100 (CET)
Received: from z1.octopuce.fr ([127.0.0.1])
        by localhost (z1.octopuce.fr [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id F2jNr02ZxttQ for <linux-raid@vger.kernel.org>;
        Sat,  4 Mar 2023 22:36:03 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by z1.octopuce.fr (Postfix) with ESMTP id 797FB3E85A1
        for <linux-raid@vger.kernel.org>; Sat,  4 Mar 2023 22:36:03 +0100 (CET)
X-Virus-Scanned: amavisd-new at z1.octopuce.fr
Received: from z1.octopuce.fr ([127.0.0.1])
        by localhost (z1.octopuce.fr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xz0zgqs180fe for <linux-raid@vger.kernel.org>;
        Sat,  4 Mar 2023 22:36:03 +0100 (CET)
Received: from z1.octopuce.fr (z1.octopuce.fr [91.194.60.127])
        by z1.octopuce.fr (Postfix) with ESMTP id 62F173E747D
        for <linux-raid@vger.kernel.org>; Sat,  4 Mar 2023 22:36:03 +0100 (CET)
Date:   Sat, 4 Mar 2023 22:36:02 +0100 (CET)
From:   Benjamin Sonntag <benjamin@octopuce.fr>
To:     linux-raid <linux-raid@vger.kernel.org>
Message-ID: <1132955858.4035.1677965762570.JavaMail.zimbra@z1.octopuce.fr>
Subject: Bug in reshape+discard?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [91.194.60.127]
X-Mailer: Zimbra 8.8.15_GA_4508 (ZimbraWebClient - GC110 (Linux)/8.8.15_GA_4508)
Thread-Index: uVOhLhXuRp5A2TLdgxkLllkRS4D85g==
Thread-Topic: Bug in reshape+discard?
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi everyone, 

I think we found a bug in the mdadm code here at Octopuce. I'm reporting it here, please tell me if that's not the right place to report it, or if you need any other information. 

This bug "hangs" processes in the Device-busy (D) state forever, until we reboot. It has been tested on both a debian 5.10 an 6.0 Linux kernel 

How to trigger the bug: 

- create a raid5 or raid6 block device using mdadm 
mdadm --create /dev/md0 -l 5 -n 3 /dev/sd{a,b,c}2 

- create a partition on it and mount it USING DISCARD/TRIM (important) (the underlying device must support trim) 
mkfs.ext4 /dev/md0 
mount /dev/md0 /mnt -o discard 

- create a few files 
for i in $( seq 1 1000 ) ; do dd if=/dev/zero of=/mnt/$i bs=10M count=1 ; done 

- expand the raid by adding a new drive
mdadm --add /dev/md0 /dev/sdd2 
mdadm --grow /dev/md0 -n 4 

- the last command will start a "reshape" operation on md0 
- DURING THE RESHAPE (it's important) erase some file (it goes fine) 
rm /mnt/* -rf 

- THEN, still during the reshape (important) try to sync or fsync 
sync 

- the sync process get stuck in the D state. no way to kill it until reboot 
(in fact, any process that does sync during the reshape after some files were deleted will get stuck, such as mariadbd or rsyslog...) 

- If you don't mount with discard your partition, the 'sync' works properly 


An easy way to circumvent this problem: 

- before reshaping, remount without discard 
mount /mnt -o remount,nodiscard 

- after the reshaping ends, remount with discard 
mount /mnt -o remount,discard 


We don't really know how to start searching for a solution, since it requires knowing the internal of MD & Discard pretty well :/ (and I'm definitely not a kernel coder ;) ) 

thanks for your help on this issue, 

cheers, 

Benjamin Sonntag 
Octopuce, Paris. 

