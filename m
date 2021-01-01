Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BE7C433E0
	for <linux-raid@archiver.kernel.org>; Fri,  1 Jan 2021 15:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72E5C221F2
	for <linux-raid@archiver.kernel.org>; Fri,  1 Jan 2021 15:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbhAAP3H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Jan 2021 10:29:07 -0500
Received: from mout02.posteo.de ([185.67.36.66]:57697 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbhAAP3H (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 1 Jan 2021 10:29:07 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 2664A2400FE
        for <linux-raid@vger.kernel.org>; Fri,  1 Jan 2021 16:28:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.jp; s=2017;
        t=1609514891; bh=//LEGTijzfkxbTDOgryqx9oSPCNE3hNziGamRHo6auc=;
        h=Date:From:To:Subject:From;
        b=ZgMhvovCJwufmBU6hBkjxZJ219jXFe01FlEmTBp0UigGYTUjt8kwkteS5unWAQLwX
         TckEUaY0QCuHEFqDItY+EUFXZYkaXrFRcdqBfsEzyp0qtHYFUEaaEOSJX1JaYyo5le
         tdVFwYKI/HCRPlPLN1dya1hTAO/mRmqTtKQemDuxZQS0TNHhZcdbX7RYfQlrv0Apzc
         MkTzeJvYz0VFz0T304Hrp52uW2fV/Ffkm98LPHBYk09ufEsWP4Rtfh7t4mZaX/A+3P
         09fNsY3iu97rPmIY8agj5E2ckSR7U2I6X5pYXWnyn1PBkPfE9DbBZOQXjZ0xbqmVLk
         jPpRWjkscHvpA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4D6pnQ67tZz9rxQ
        for <linux-raid@vger.kernel.org>; Fri,  1 Jan 2021 16:28:10 +0100 (CET)
Date:   Fri, 1 Jan 2021 16:28:10 +0100
From:   <c.buhtz@posteo.jp>
To:     linux-raid@vger.kernel.org
Subject: naming system of raid devices
Followup-To: linux-raid@vger.kernel.org
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <4D6pnR0fqcz9rxN@submission02.posteo.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In the last weeks I played around with mdadm - on VMs, Odroid-Devices,
PCs - all with Debian 10.

I observed a (for me) curious behavior about the naming of RAID
devices.

I did "--create /dev/md0" all the time.

But sometimes it results in /dev/md127.
Sometimes it is /dev/md/0.
Sometimes it switches between upgrade of the kernel image (/dev/md127
become /dev/md0 and booting fails).

Googleing this topic brings up a lot of other users discussing about
that problem.

My current solution is to ignore the /dev/*-name and mount the
device/partition by its UUID.

Another often reported "solution" is to edit the mdadm.conf. But this
is not a good solution for me. mdadm looks in the superblock and knows
(nearly) everything. Each conf-file I need to edit keeps the
possibility for errors/mistakes/faults (because I am not a sysop/admin
but a simple home-server-wannabe-admin).

My Question is how this names come up? How does mdadm, the kernel or
what ever component is responsible here, decide about the "name" of a
raid device?
And which factors influence the re-nameing of such devices (e.g.
between boot or kernel-updates)?
