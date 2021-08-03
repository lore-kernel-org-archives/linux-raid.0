Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307EDC4338F
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 14:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C3B261040
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 14:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbhHCORW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Aug 2021 10:17:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57036 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236549AbhHCORV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Aug 2021 10:17:21 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628000229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clbqKT1fPD2WJMpM6uc7v0qE6R46vwL2Klxs/fx6jpw=;
        b=SHp+acffAFQJTevPnSm+5yKV+s+2pXMIke8PmGtImP6eDVosdG/thA5sw1SpFHZ5WV0RrG
        uiLcFbBCc06KBblqI8fxVcN7DFDmdAT5ARYm6ACu7urd3hYGeWVHibV4ZobqcaBOYrkZa8
        9vFWJh/IxFgYhcsfrWgrrogb79VpctI/nQIeUjDn4xCxE5gnA5+t4cCLrZ7wBQBCVYZYqY
        E3mobc+LOJ1SgCVRq5I6K+4VxrUKTW0sKL0DkO6MX6jy9KOsfWihXj4MFd8Yjzht37fzS+
        AT0yqPqeB7FLChIR4nwV5CKbAA5WsmdF+/qcm+R3KkH1rx+BcsJDJjVQljjgwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628000229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clbqKT1fPD2WJMpM6uc7v0qE6R46vwL2Klxs/fx6jpw=;
        b=KasqPCA2Yv2pD4a/l519/xfeCJKQq/BCmwrsxivp1w2ab5SofeYkr2EkFl5wuJbdv6exjq
        lxEBXSmWJNXBssAg==
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH 15/38] md/raid5: Replace deprecated CPU-hotplug functions.
Date:   Tue,  3 Aug 2021 16:15:58 +0200
Message-Id: <20210803141621.780504-16-bigeasy@linutronix.de>
In-Reply-To: <20210803141621.780504-1-bigeasy@linutronix.de>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b8436e4930ed8..02ed53b20654c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2437,7 +2437,7 @@ static int resize_chunks(struct r5conf *conf, int new=
_disks, int new_sectors)
 	    conf->scribble_sectors >=3D new_sectors)
 		return 0;
 	mddev_suspend(conf->mddev);
-	get_online_cpus();
+	cpus_read_lock();
=20
 	for_each_present_cpu(cpu) {
 		struct raid5_percpu *percpu;
@@ -2449,7 +2449,7 @@ static int resize_chunks(struct r5conf *conf, int new=
_disks, int new_sectors)
 			break;
 	}
=20
-	put_online_cpus();
+	cpus_read_unlock();
 	mddev_resume(conf->mddev);
 	if (!err) {
 		conf->scribble_disks =3D new_disks;
--=20
2.32.0

