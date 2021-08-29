Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24546C432BE
	for <linux-raid@archiver.kernel.org>; Sun, 29 Aug 2021 13:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB38160232
	for <linux-raid@archiver.kernel.org>; Sun, 29 Aug 2021 13:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhH2N5K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 29 Aug 2021 09:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhH2N5I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 29 Aug 2021 09:57:08 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41D1C061575
        for <linux-raid@vger.kernel.org>; Sun, 29 Aug 2021 06:56:16 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4GyFNZ5HlSzQkBq
        for <linux-raid@vger.kernel.org>; Sun, 29 Aug 2021 15:56:14 +0200 (CEST)
Received: from gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173])
        by smtp102.mailbox.org (Postfix) with ESMTP id 11A4F26B
        for <linux-raid@vger.kernel.org>; Sun, 29 Aug 2021 15:56:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chianterastutte.eu;
        s=MBO0001; t=1630245373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CkuQ3yfpCoFmziDw8TQA47g7eP+Krri5YsE55rSNAs4=;
        b=V6bxH1RI06BRQWWYhA/akp6UVw2myXxJLSlK0DI4f7fJHsmc1PDsmEpwiWCcXS584ZdZZ2
        1trabRfBahzvc0ocfu57RHIHatZAY0QC06q2Xt5+kD4ljdso/ALfhK+qJSFpVgWCl2j7P6
        qA3FXGVRc5fWJsYtVHnXwDgXBYBA6eb72bWpNf2scUf7s5aXpuOQQrZFEKOumiJY02OeWR
        S9tQy7Tvcb/GdYbNJd2f6E/pcwlv8czWKv61DHD/+Oray4KU8xRWJ0Qv1rdtVrmqbBS5+i
        dGTcLQ8mCrKl63ZsdxRMjE0KtLED9C3c5/avvHy0VLNU+zznnXw9xtyixPSMcg==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp102.mailbox.org ([80.241.60.233])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id ZARTf1wgLpp0 for <linux-raid@vger.kernel.org>;
        Sun, 29 Aug 2021 15:56:11 +0200 (CEST)
Received: from [192.168.20.27] (ip5b41be68.dynamic.kabel-deutschland.de [91.65.190.104])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp102.mailbox.org (Postfix) with ESMTPSA id D97C8268
        for <linux-raid@vger.kernel.org>; Sun, 29 Aug 2021 15:56:11 +0200 (CEST)
To:     linux-raid@vger.kernel.org
From:   Jens Stutte <jens@chianterastutte.eu>
Subject: Disable --write-behind for existing array
Message-ID: <0bdc56ab-b043-72df-9a99-31e57714ca85@chianterastutte.eu>
Date:   Sun, 29 Aug 2021 15:56:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Rspamd-Queue-Id: 11A4F26B
X-Rspamd-UID: 15efe2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello!

I have a RAID1 array made of two identical SSD. The array historically 
contained spinning disks, and I find the following configuration on both 
devices now:

mdadm -X /dev/sdb1
         Filename : /dev/sdb1
            Magic : xxx
          Version : 4
             UUID : xxx
           Events : 32761
   Events Cleared : 32761
            State : OK
        Chunksize : 64 MB
           Daemon : 5s flush period
       Write Mode : Allow write behind, max 4096
        Sync Size : 1953381440 (1862.89 GiB 2000.26 GB)
           Bitmap : 29807 bits (chunks), 1 dirty (0.0%)
mdadm -X /dev/sdc1
         Filename : /dev/sdc1
            Magic : xxx
          Version : 4
             UUID : xxx
           Events : 32761
   Events Cleared : 32761
            State : OK
        Chunksize : 64 MB
           Daemon : 5s flush period
       Write Mode : Allow write behind, max 4096
        Sync Size : 1953381440 (1862.89 GiB 2000.26 GB)
           Bitmap : 29807 bits (chunks), 1 dirty (0.0%)

I assume, it is not very meaningful to have --write-behind active on 
both devices. Actually I would want to remove this configuration for 
both, assuming there is no reason to keep it with two SSD. But a:

mdadm /dev/md0 --fail /dev/sdb1
mdadm /dev/md0 --remove /dev/sdb1
mdadm /dev/md0 --re-add --readwrite /dev/sdb1

did not do the trick and I cannot find any instructions on how to 
disable it on an existing array.

Thanks for any help!

Jens

