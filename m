Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5628CC25B08
	for <linux-raid@archiver.kernel.org>; Sat, 20 Aug 2022 04:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbiHTE2s (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 20 Aug 2022 00:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiHTE2o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 20 Aug 2022 00:28:44 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A95927CED
        for <linux-raid@vger.kernel.org>; Fri, 19 Aug 2022 21:28:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso6528005pjh.5
        for <linux-raid@vger.kernel.org>; Fri, 19 Aug 2022 21:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc;
        bh=aa9Z2sonptPqEdxxSuvWik/RMfqhH+8ii0Wl6ycnG2I=;
        b=KVm7GsqTZ0MXWgJ11/Md3hPX31hDfd58Og+MozA8rxtwWHrLd4UpxkBum0smEMaEUP
         uQdcYURzq6a8+g79FnOQZtT3VlTLER8ReJXRCRth94hhCGYZD89Lkq8Vdgz/LClgbOwx
         nsN3jHW9uT/Pax8BgCo5H4GKh63ORELidqKkw+hYjXVebaDzxJCgGqEpRbuL865I3VIK
         dPsQagxvTMke2VNvHVw4pSPIaFgxNHBIkKBV/UW6oABr0M64Hy94KKXOAAr5cgBkl/F9
         daQGyi0CCaZzOH09JQfJHFvbr9nX+MEFvxrbl7duvn35rJpn2n7tWkjTsAgZKHQAvPzH
         eslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc;
        bh=aa9Z2sonptPqEdxxSuvWik/RMfqhH+8ii0Wl6ycnG2I=;
        b=VtLbEIGXvdgGJEtS3gr6xN3LWU5m4VMaPCduGGXyWWROmA29WHNndsvAFbGY2EcifL
         fCBsnYt7uS+hs+oseP1sRISBn/DH7sLtNsFy2UGlY/PI1OP3i9eyv/mjZdMLhlsLMkzj
         N0AKscoCh0KrBChcPOaKxdHYDQhAkW6BmTWt5v8yOQjWv1gmTqkYFrkwyQgCpGagW73F
         Jl3qUIEnPq5AAGFZ8kYpBQ2xBbPNt3xV+zBCLkiDSysA7461B7T2v/Ffq97twCNByEOa
         AFqedukHL9zAmwategfZIvu2GYwgnkITP3Eh8OQjVFHDwIBGkAwk2fe2CI3GENfXzQ3Y
         dxag==
X-Gm-Message-State: ACgBeo0fOunIXVlBDRJo8JDVUme3Dgs9up+CCKFLxGdB1cu7juetp1ZG
        N8HPf001i7U8GNNj1cIayvZdiS3ZIvsg6w==
X-Google-Smtp-Source: AA6agR5SQ3cnsWMKQPo6oyZ5JcMnYY40xJ+dh4cuMamaeoDLRmlvkdw5g3WhfLMy6EEO7d8SKAj0BQ==
X-Received: by 2002:a17:903:1cd:b0:16e:e519:c6f6 with SMTP id e13-20020a17090301cd00b0016ee519c6f6mr10241273plh.116.1660969722507;
        Fri, 19 Aug 2022 21:28:42 -0700 (PDT)
Received: from [192.168.0.32] (S0106bcd165660845.vs.shawcable.net. [96.55.138.35])
        by smtp.gmail.com with ESMTPSA id pi16-20020a17090b1e5000b001f2e50bd789sm2973425pjb.31.2022.08.19.21.28.41
        for <linux-raid@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Aug 2022 21:28:41 -0700 (PDT)
From:   Abram Wiebe <ethanpet113@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: mdadm --grow should be cancellable while array is hot, since it can
 be started while array is hot
Message-Id: <5B1B25FD-DA12-4B11-B6BD-579A2EECF323@gmail.com>
Date:   Fri, 19 Aug 2022 21:28:40 -0700
To:     linux-raid@vger.kernel.org
X-Mailer: Apple Mail (2.3445.9.7)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I poked through the source code and found that there is some effort to =
update the superblock to "revert-reshape=E2=80=9D, using the assemble =
command but:

1. Most systems assemble my arrays on my behalf
2. I was trying to back out of a reshape on a turnkey NAS, and =
couldn=E2=80=99t figure out how to mount the target filesystem
3. I tried=20
  sudo echo revert-reshape > /sys/block/md2/md/sync_action=20
  #and got echo: write error: Device or resource busy

Ideally since I can start a reshape on an array while it=E2=80=99s hot =
it would make sense to be able to back out of it by syncing up and then =
doing the transformation in reverse without needing to take it offline.
I would prefer a user friendly way to do this where all I need to do is=20=

  mdadm -G =E2=80=94cancel /md/mdX=
