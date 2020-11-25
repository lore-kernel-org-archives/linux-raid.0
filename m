Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6D4C63798
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 02:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B5D42145D
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 02:20:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E32tcx9v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKYCUc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 21:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKYCUb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Nov 2020 21:20:31 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9245C0613D4
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 18:20:31 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id w202so875181pff.10
        for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2020 18:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GH/+e5FGH7qJanGKp3XKEvIf1tabknh/PyYUwBAk8Ag=;
        b=E32tcx9vFqW1sOX5wljJN9JlEm1iyKi6rA2Cj4X5gW4rkZkHkYnTXHwxKG3BdDBMeA
         oVWkfP/gW3zI6W2GOdKT5aw6xCrI48NqpzSgYD/sbjr44lV5+lqYn/RLEKTVK3tXDOCP
         G8TUJdhND5qcpqMuhdsuttaoJxxWYmoAt6H2gGoBNGjuqqZthIDW1XkAeX2GqGg+Id7q
         EX1RPSbDx6IH9MLm85u2H06mrKopQ6kC3lUbWsTgLfgfa8mMzSdW9dScRnfxPHogHnis
         1lpzwpT7zuHPbVV74sxlufmgzBu9PeoU1ashpwdCnoSsFkmySbuU6KOzkaqOsxweadU0
         Y2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GH/+e5FGH7qJanGKp3XKEvIf1tabknh/PyYUwBAk8Ag=;
        b=aHfWPuQTQQkdQSvComU4lVsNfwCLQMyF1470oXkCZ7Nn+6Bmm0ip1K87G2dH2j1GM2
         pQlr3NRv3oiR3HlbQ+h7n3zm690FCJUZrtsumvQfRVfwL/NbsgcPtqMfmbawsei8F5ME
         +zmgeiP1cxylzyaeFpTMX8OCcPMenpNpcSmU8ut3KOCd3eVDqR5fwKc0OWZoiOp/OGCF
         4Ey5B2IYRYw7Uz1XbDjPAXYKg882Im9jt4/KvygAgLCEyhnLj7+3HTath2A2NENYrY/h
         stKcHR+U2o6TKfyrIXJ2ugDECB9roMYNSzEl2KAZ6qLdSZ5P/+QqEQFoG947/Vn/3fLz
         ynwA==
X-Gm-Message-State: AOAM533FylxbVc3MVA2P/H3ChsJKZwcxxdafa2CL1jO81pHp1zxcVxkm
        TXVaeeVD9tYAu+IkXGVXWl0hHNGx6s/oIyUfAkW37Uk=
X-Google-Smtp-Source: ABdhPJxKklVU9T3Vbyk1k6cRFiohYnLB+5APMEnriKX0QcFsRsf73gVaVXLmza7COOUo6T11cD5zmUUaUn3KbXGmkI0=
X-Received: by 2002:a17:90a:fd0d:: with SMTP id cv13mr1427590pjb.124.1606270831342;
 Tue, 24 Nov 2020 18:20:31 -0800 (PST)
MIME-Version: 1.0
From:   Alex <mysqlstudent@gmail.com>
Date:   Tue, 24 Nov 2020 21:20:20 -0500
Message-ID: <CAB1R3sgQm2_-Bhbzned4y056XP5hM9oz1OnTZSfHH9+L5sdpFQ@mail.gmail.com>
Subject: Considering new SATA PCIe card
To:     Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, I have a fedora33 server with an E31240 @ 3.30GHz processor with
32GB that I'm using as a backup server with 4x4TB 7200 SATA disks in
RAID5 and 2x480GB SSDs in RAID1 for root. The motherboard has two
SATA-6 ports on it and the others are SATA3.

Would there really be any benefit to purchasing a new controller such
as this for it instead of the onboard for the 4x4TB disks?
https://www.amazon.com/gp/product/B07ST9CPND/

The server is relatively responsive, but I was just wondering if I
could keep it running for a few more years with a faster SATA
controller.

I'm also curious if the SATA cables have improved over time, or are
the same cables I purchased five years ago just as good today?
