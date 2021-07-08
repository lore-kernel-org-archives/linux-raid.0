Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E3BC07E96
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 10:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 871EC61451
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 10:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhGHKKX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Jul 2021 06:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhGHKKW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Jul 2021 06:10:22 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AEFC061574
        for <linux-raid@vger.kernel.org>; Thu,  8 Jul 2021 03:07:40 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f17so6788029wrt.6
        for <linux-raid@vger.kernel.org>; Thu, 08 Jul 2021 03:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=DVg8K1iRJCLV+D5fUhkvcg2lUwk78mkF2mDgH9am0Pk=;
        b=j1hVNOZMRJZ2WOYnszYhbhIHBRNj5QiyItLQC6Id4JcaYpXP/ssEjaxwbmGWuGzneX
         TYhZ1lnRo+tk6F9IN+uZJG6YxeivtSQy6NBV5PIvn7qloLSok/GNCLshE3teQswdviUM
         h+2mSGXaLJ67kKe6fKn3LkwQ8VAypHQqujtFuD8UOM7AcAaJkbT+N8eAgaKVrh35WwyQ
         /rkM9Wd9XxkeJvxBn+QdLH2O68ReK5fNl6nwgfR1/6dPZXmTIb94PGaLKS0zK1BgEWDe
         JC69o1XwYxc3/eVibL+8T2I0zepDLGZ+u+0xZb1y9gRat/hKUqjKc2JLjeQqTbrA5s65
         7s5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=DVg8K1iRJCLV+D5fUhkvcg2lUwk78mkF2mDgH9am0Pk=;
        b=jFnuZGH5im84n1Ibv+0H0iVFTPwzVk57vDy6r6fey7LyHVa1i2ScO0J+YYipLWpKbl
         T9r1nVYA5QVX6dticoMGLx6yopm1kk9ZgvDbie6DxmbLd3ymb3VR5R0+QF0Jri19GXXB
         DxoTR8XestL3QqXDA+mYJv8r7yX8EiWDkWqaXMe2z1JNlNKX2YXWOcVOm1xwbCT2jOyd
         Vxj9Bcz3LAufbh66M6E30/HM2+Z7m5YpfjI0Egp/mbkxbb2b3Ym71Q0/ZoB5wdp6Qj7t
         3p00rEg/AMmEAJrKnonsOaGmi+pjMBrKg2ISQiwXIDuDOwvSimy44SEueDe8npGxfzuV
         1EpQ==
X-Gm-Message-State: AOAM531nL2tgjU1Nc/kVSPpG5PAUiGcDtkSu4q3W6ZMVqeiXaWQR+W4q
        ccK/Vtd5gcZiZeswQLn88+hNx8Bw6UXK0w==
X-Google-Smtp-Source: ABdhPJw4wYDBc5RbCNZCtqFEfN2eZJLnAXIfJmAgaFSlBy36b0zn4yNETHsFprQ5gj25wCr75veZfQ==
X-Received: by 2002:adf:ed07:: with SMTP id a7mr650702wro.70.1625738859301;
        Thu, 08 Jul 2021 03:07:39 -0700 (PDT)
Received: from [192.168.1.243] (91-160-11-177.subs.proxad.net. [91.160.11.177])
        by smtp.gmail.com with ESMTPSA id u9sm1738456wmq.41.2021.07.08.03.07.38
        for <linux-raid@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jul 2021 03:07:38 -0700 (PDT)
From:   Nicolas Martin <nicolas.martin.3d@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: RAID5 now recognized as RAID1
Message-Id: <C3C9F935-DD1C-409C-8C9D-56F97B13B676@gmail.com>
Date:   Thu, 8 Jul 2021 12:07:37 +0200
To:     linux-raid@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

For a bit of context :I had a RAID5 with 4 disks running on a QNAP NAS.
One disk started failing, so I ordered a replacement disk, but in the =
mean time the NAS became irresponsive and I had to reboot it.
Now the NAS does not (really) come back alive, and I can only log onto =
it with ssh.

When I run cat /proc/mdstatus, this is what I get :
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] =
[raid4] [multipath]
md322 : active raid1 sdd5[3](S) sdc5[2](S) sdb5[1] sda5[0]
      7235136 blocks super 1.0 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md256 : active raid1 sdd2[3](S) sdc2[2](S) sdb2[1] sda2[0]
      530112 blocks super 1.0 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md13 : active raid1 sdc4[24] sda4[1] sdb4[0] sdd4[25]
      458880 blocks super 1.0 [24/4] [UUUU____________________]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md9 : active raid1 sdb1[0] sdd1[25] sdc1[24] sda1[26]
      530048 blocks super 1.0 [24/4] [UUUU____________________]
      bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>

So, I don=E2=80=99t know how this could happen ? I looked up on the FAQ, =
but I can=E2=80=99t seem to see what could explain this, nor how I can =
recover from this ?

Any help appreciated.

Thanks=
