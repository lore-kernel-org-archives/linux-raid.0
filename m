Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C8BC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 06:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbiFIGne (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 02:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239306AbiFIGnZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 02:43:25 -0400
Received: from forward501p.mail.yandex.net (forward501p.mail.yandex.net [77.88.28.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E856441
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 23:43:21 -0700 (PDT)
Received: from sas1-c2880b0fc97b.qloud-c.yandex.net (sas1-c2880b0fc97b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:f6a9:0:640:c288:b0f])
        by forward501p.mail.yandex.net (Yandex) with ESMTP id 1E6F962133F5
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 09:43:06 +0300 (MSK)
Received: from sas2-e7f6fb703652.qloud-c.yandex.net (sas2-e7f6fb703652.qloud-c.yandex.net [2a02:6b8:c14:4fa6:0:640:e7f6:fb70])
        by sas1-c2880b0fc97b.qloud-c.yandex.net (mxback/Yandex) with ESMTP id j8OV4lzF6j-h5gSYZmN;
        Thu, 09 Jun 2022 09:43:06 +0300
X-Yandex-Fwd: 2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ngs.ru; s=mail; t=1654756986;
        bh=535G566NJCZAiTF22wWNozWu1YwJqLlWeoF5ZTg3xvc=;
        h=In-Reply-To:From:Subject:References:Date:Message-ID:To;
        b=NieinFNZtuyiSCzJebkJynBi0o5PiiBwU+Z+DLSYUC4moEadb/kPQkhmXuK9vN+FA
         udcbfAn3cX2qIwoBoikcnrSZlpTAFUw6V8kQhg7cprrCwXv2aKSdKgtFtsKnfjofZd
         qpRk8mLK4gsnGA2uqYl7JbQVXFCkDSkzPMufg5Bk=
Authentication-Results: sas1-c2880b0fc97b.qloud-c.yandex.net; dkim=pass header.i=@ngs.ru
Received: by sas2-e7f6fb703652.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id GQK97XnMxA-h5M8JEOe;
        Thu, 09 Jun 2022 09:43:05 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Message-ID: <97a39335-8bad-d7f1-9069-f77f21ed64c1@ngs.ru>
Date:   Thu, 9 Jun 2022 13:43:04 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Misbehavior of md-raid RAID on failed NVMe.
Content-Language: ru
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <984f2ca5-2565-025d-62a2-2425b518a01f@ngs.ru>
 <b14b62c9-1494-935f-f9f0-43f8083e8547@youngman.org.uk>
 <CAAMCDef5jamJa+um=DSM08CPdzoTvEQuFOdrGo7jiNivrNVbpg@mail.gmail.com>
From:   Pavel <pavel2000@ngs.ru>
In-Reply-To: <CAAMCDef5jamJa+um=DSM08CPdzoTvEQuFOdrGo7jiNivrNVbpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

09.06.2022 1:48, Roger Heflin пишет:
> You might want to see if specific disk devices are getting 
> reset/rebooted, the more often they are getting reset/rebooted the 
> higher chance of data loss. The vendor's solution in the case I know 
> about was to treat unrequested device resets/reboots as a failing 
> device, and disable and replace it.
How to detect these resets/reboots?  Is there is a "counter" in kernel 
or in NVMe itself?

> I don't know if this is what is causing your issue or not, but it is a 
> possible issue, and an issue that is hard to write code to handle.

We see log messages explicitly reporting an I/O error and data not being 
written:

[Tue Jun  7 09:58:45 2022] I/O error, dev nvme0n1, sector 538918912 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:45 2022] I/O error, dev nvme0n1, sector 538988816 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:48 2022] I/O error, dev nvme0n1, sector 126839568 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:48 2022] I/O error, dev nvme0n1, sector 126888224 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
[Tue Jun  7 09:58:48 2022] I/O error, dev nvme0n1, sector 126894288 op 
0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0

I think that is enough reason to mark array member as failed as it has 
inconsistend data now.

