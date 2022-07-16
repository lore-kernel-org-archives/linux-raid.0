Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B71C43334
	for <linux-raid@archiver.kernel.org>; Sat, 16 Jul 2022 21:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiGPVXZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 16 Jul 2022 17:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGPVXY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 16 Jul 2022 17:23:24 -0400
X-Greylist: delayed 357 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 16 Jul 2022 14:23:23 PDT
Received: from sneak2.sneakemail.com (sneak2.sneakemail.com [64.46.159.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7191BEB6
        for <linux-raid@vger.kernel.org>; Sat, 16 Jul 2022 14:23:23 -0700 (PDT)
Received: (sneakemail censored 4470-1658006245-486940 #2); 16 Jul 2022
 21:17:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=liamekaens.com;
        s=mail; t=1658006245;
        bh=Q+rTJRqhqT29bCgEz+EwD5HZA33MFvI0tkdPoAogJJA=;
        h=Date:From:To:Subject:From;
        b=hlQSILaRKkBFca4gulETD0puAjtLF4IOszjfNIBuSKGADe28aw72kQykvtYd01Vmi
         /y9Rba2U4rPypzZwli7rkgitRjTdSbuZZbZ+Z/8OXqy7ZI9tudKmnw+WoO78be0X0f
         XB9YmbdbqZrxyluIwClNgq4TIDIhthNakoPhdn3pWCi9iN6l5ONY81RHpOGrcxhCei
         1daCyzpZ1c36fAE7PFOZB4Kz/EgUPN9s5HbBc0SPNOYhdA7lKTFYDnVBDHvQQwnBYc
         kAqwVICqzfwUwpqavGSAJe3r146hjuPx8JsGu6eREJf7KNthm8qTHqho/SiMk3Qtnm
         Moez6T09q66Kw==
Received: (sneakemail censored 4470-1658006245-486940 #1); 16 Jul 2022
 21:17:25 -0000
Date:   Sat, 16 Jul 2022 21:17:25 +0000
From:   esqychd2f5@liamekaens.com
To:     linux-raid@vger.kernel.org
Message-ID: <4470-1658006245-486940@sneakemail.com>
Subject: Determining cause of md RAID 'recovery interrupted'
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Perl5 Mail::Internet v
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I'm a long-time md raid user, and a big fan of the project.  I have run into an issue that I haven't been able to track down a solution to online.

I have an md raid array using 12TB Seagate Iron Wolf NAS drives in a RAID6 configuration.  This array grew from 4 drives to 10 drives over several years, and after the restripe to 10 drives it started occasionally dropping drives without obvious errors (no read or write issues).

The server is running Ubuntu 20.04.4 LTS (fully updated) and the drives are connected using LSI SAS 9207-8i adapters.

The dropping of drives has led to the array now being in a degraded state, and I can't get it to rebuild.  It fails with a 'recovery interrupted' message. It did rebuild successfully a few times, but now fails consistently at the same point around 12% done.

I have confirmed that I can read all data from all of my drives using the 'badblocks' tool to read all data from all drives.  No read errors are reported.

The rebuild start up to failure looks like this in the system log:
[  715.210403] md: md3 stopped.
[  715.447441] md/raid:md3: device sdd operational as raid disk 1
[  715.447443] md/raid:md3: device sdp operational as raid disk 9
[  715.447444] md/raid:md3: device sdc operational as raid disk 7
[  715.447445] md/raid:md3: device sdb operational as raid disk 6
[  715.447446] md/raid:md3: device sdm operational as raid disk 5
[  715.447447] md/raid:md3: device sdn operational as raid disk 4
[  715.447448] md/raid:md3: device sdq operational as raid disk 3
[  715.447449] md/raid:md3: device sdo operational as raid disk 2
[  715.451780] md/raid:md3: raid level 6 active with 8 out of 10 devices, algorithm 2
[  715.451839] md3: detected capacity change from 0 to 96000035258368
[  715.452035] md: recovery of RAID array md3
[  715.674492]  md3: p1
[ 9803.487218] md: md3: recovery interrupted.

I have the technical data about the drive, but it is very large (181K) so I'll post it as a response to this post to minimize clutter.
There are a few md RAID arrays shown in the logs, the one with the problem is 'md3'.

Initially, I'd like to figure out why the rebuild gets interrupted (later I will look into why drives are being dropped).  I would expect an error message explaining the interruption, but I haven't been able to find it.  Maybe it is in an unexpected system log file?

One thing I notice is that one of my drives (/dev/sdc) has 'Bad Blocks Present':
  Bad Block Log : 512 entries available at offset 264 sectors - bad blocks present.

So, a few questions:

- Would the 'Bad Blocks Present' for sdc lead to 'recovery interrupted'?
- More generally, how do I find out what has interrupted the rebuild?

Thanks in advance for your help!

Joe
