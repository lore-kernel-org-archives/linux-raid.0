Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E575C433ED
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 08:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EED7661431
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 08:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbhD2IxV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Apr 2021 04:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbhD2IxU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Apr 2021 04:53:20 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9101C06138B
        for <linux-raid@vger.kernel.org>; Thu, 29 Apr 2021 01:52:34 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id c22so13957052edn.7
        for <linux-raid@vger.kernel.org>; Thu, 29 Apr 2021 01:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gUtxw7JOzDgTiY9hppjD3Eh2DifpCEEPRD8Cm2n8b7w=;
        b=raZPWWB0X9y/ZXzsDENC8fkolsRCuD1ljTESYLhawdiLAVUlPVNf0iw9lYCd5UD07g
         Z435P4nHAX7D/h2nRUyZGQD1WcPPBwXjuL0wRIVePl5cviWKdkX5kIlG+tDwKUGFjyXf
         dTePP95azPBPJJdpKmk3bPP259g5Dst7JpDqD8YDjngnc/lIBW7/Hgouc4dhWyZYyZWR
         qts2yhPn8s+NSs6mSm1w33gR4NCYjaSiVgqXFg7Eqr5ZXd7E66eeEpqUKMyzGVYdRRhx
         kmRCpPQ7Meq5sajfZGjyqjng9+ey12K79Vrs+boDKHzoYdUEshNv0TxaEpElPUrvktx3
         Dg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gUtxw7JOzDgTiY9hppjD3Eh2DifpCEEPRD8Cm2n8b7w=;
        b=bdK0OoiEtniwhkW8SZJm5bxTLIp1SMqnH2Jnv3Uu6GDkbx0UcKT4oM/s6luXVWwA52
         Lw96mK3wIdygdObNpBPQuU41dovNHoEhHbmg3hoY63LvWAO86n9AKUrgmY8AEvIuLyR9
         yO9CZpKZ5litw7+l1J3h6z+wvLSx/LbK4Lk8mbLVQ5vWw4KXuWVNzAeK/+Zxjq2uaR3k
         FjJPUGaptfrsmbAESQJTw8cbgHzcuJqJgesjm9bMk43Fthf+iv17YIpOhAomwKVyFWBP
         3sDhWKQGWwDW0BuhMG9acCP/F2ZTy+2u+8yLydF0+HntYvOjr0ZL7qr39/59F9T3UhZ2
         8Dmg==
X-Gm-Message-State: AOAM531XB77NnsblzPXu6tBE2Q3HZQ1zZngmG0o8gEoIe39bvys1Clt8
        jWjTZuVv0xceEJtWYyLVpSwEJzDEnOafjKRKOeUdu1YGnv5gvw==
X-Google-Smtp-Source: ABdhPJwdFbBEcmT5UPfLXwatAjuqma+yfhYrQkfe4o3SJ96iA5X+rSm1cD7DmxBLlZe2LZ+irkmYYyDQ6f5Q/i8kNmA=
X-Received: by 2002:a05:6402:12c6:: with SMTP id k6mr16613106edx.372.1619686353114;
 Thu, 29 Apr 2021 01:52:33 -0700 (PDT)
MIME-Version: 1.0
From:   d tbsky <tbskyd@gmail.com>
Date:   Thu, 29 Apr 2021 16:52:21 +0800
Message-ID: <CAC6SzHLDYhQDtfQMYozN6EBYB=nsKvB77hmyByZNr9uTpQH+KQ@mail.gmail.com>
Subject: add new disk with dd
To:     list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi:
   I want to replace a fault disk for software raid5. there is
something like grub/biosgrub at the beginning of the disk, so if I can
use command below to copy them:

"dd if=/dev/sda of=/dev/sdb bs=1M count=10"

if it is a gpt disk I can use sgdisk to copy the partition table then
radmonize guid.

however dd may also copy the mdadm superblock which include internal
bitmap(since I don't caculate correct size). I don't know if there is
risk that mdadm will be confused with the bitmap in new disk. although
I have tried and it seems work fine.

should I disable internal bitmap before add new disk? or mdadm will
understand the superblock/bitmap at new disk is invalid and just
overwrite everything?
