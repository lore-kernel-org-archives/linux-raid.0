Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45802EB64DA
	for <linux-raid@archiver.kernel.org>; Wed, 28 Jun 2023 08:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjF1ILA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Jun 2023 04:11:00 -0400
Received: from relay-b03.edpnet.be ([212.71.1.220]:52190 "EHLO
        relay-b03.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbjF1IF4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Jun 2023 04:05:56 -0400
X-ASG-Debug-ID: 1687935176-24639c1bb149a40001-LoH05x
Received: from [192.168.177.53] (212.233.33.219.adsl.dyn.edpnet.net [212.233.33.219]) by relay-b03.edpnet.be with ESMTP id dTAS1st7BaJMibzT for <linux-raid@vger.kernel.org>; Wed, 28 Jun 2023 08:52:56 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 212.233.33.219.adsl.dyn.edpnet.net[212.233.33.219]
X-Barracuda-Apparent-Source-IP: 212.233.33.219
Message-ID: <ef8a467a-ebf6-96e9-c8fb-b7d83506b22f@kabelmail.de>
Date:   Wed, 28 Jun 2023 08:52:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US, nl-BE
To:     linux-raid@vger.kernel.org
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: md: timeout for kicking out devices when resuming from S3?
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ASG-Orig-Subj: md: timeout for kicking out devices when resuming from S3?
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: 212.233.33.219.adsl.dyn.edpnet.net[212.233.33.219]
X-Barracuda-Start-Time: 1687935176
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 862
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.110631
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello everyone,

Due to high electricity prices, I'm starting to experiment with pushing my linux NAS into ACPI 
S3 at night.
the embedded system has no other option than using "echo mem > /sys/power/state", or rtcwake.
Unfortunately, when waking up (ether-wake or rtcwake), the MD driver starts kicking out SCSI 
disks from a RAID6 array.
SAS HBA initialization is slow due to a large nr of disks, so some are not yet available at that 
time.
when you see in dmesg, a few seconds later, they appear.
Is there a way to tell the md raid subsystem "wait xx seconds after resuming from S3 before you 
decide to kick out disks"?
another option would be: the journal on the RAID volumes is a 60GB SSD partition,
is there an option to kick out preventively and re-add when it appears, simply by replaying the 
journal?

Thank you,

Janpieter Sollie
