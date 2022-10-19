Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E94C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 19 Oct 2022 19:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiJSTa5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Oct 2022 15:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiJSTaw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Oct 2022 15:30:52 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F232FE09EE
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 12:30:50 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bu30so30778196wrb.8
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iHU2hd9JUYyJGL+SDJdGfd4IvUbM1z/k3GZ/lZnf4ak=;
        b=aZI8WaRNp45l5AO2o7Fybs3u93enx7qdHkUTxYzaNuWCxYecc3MeDbi4AtEFsEftS8
         LcqOduP/mHuQvUJbJmLK65lYyujlAWN9OqtcdeJ7p9skDcB6EUx0yMw81A2QQiORvaUK
         ldGA9GSaM7CV5gLAko3KO4EPJ9hZuwt9A/xB/S9n91fU34CKuPvmxpww2EjaB3D3dMpN
         /gQuktGid51MZSRWWbonQXdxTzvD4BbzD25TGPl8Ht4qadow2DjvLxx/bKlu8UcCpORd
         ORXWbA1DG7G5f1CcxbTCeqvl+EZz0n+sO+yymRJxYBGFm7ks74WCwDxEUvUJKsL5d91a
         ZZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iHU2hd9JUYyJGL+SDJdGfd4IvUbM1z/k3GZ/lZnf4ak=;
        b=W89Dy64qzKs+10fDpAyijYeh+X99QwWtzhKGp4wfjT3Vq22Qp8sB46nXnUQ9lLUoPx
         QQHLYN2CFkUk2pN3Vyr59nKGD1YoS71MeWsDXClz63gO5WndZ6/2HX+hhr/b8tL/NIkG
         59vJoGhfSkE3KPxYyQlY0mm6iMfbGBKkIVlLNRJzP0CryJ/yVYAcOGIBMRJu3euPqTL+
         aFMbub+By4roZgGniyDNvoF4+kJ4Sx/NxFpwrcKs9lSPpDk0GsQ9tCLasHCqJP69D/qT
         l7YAdGcK2URaQZWVIzDJc9jgF/fz97udZM2YhGlH1cmnSlua07XsiyXn5p6BtMbFVyXm
         s8Ag==
X-Gm-Message-State: ACrzQf3NvlnhKI9hy8DPG9aZYwPF44pRnjskfTh7zjIb2zmS5xKZDaAL
        s/vN+3DwtDU09zJ3LYYm4AWD94AsmYeRvBDcfcR14NbqMhI=
X-Google-Smtp-Source: AMsMyM4XRUJjwxhu8ugB7GUi0ZVXOvz69zi9ERhkOrAKdhG9YKiGJe3eYUaQL1tG3c2P7klU5oSmu8HdlUCQlB9VjJA=
X-Received: by 2002:a05:6000:18a5:b0:230:a3a:d93e with SMTP id
 b5-20020a05600018a500b002300a3ad93emr6202916wri.626.1666207848975; Wed, 19
 Oct 2022 12:30:48 -0700 (PDT)
MIME-Version: 1.0
From:   Umang Agarwalla <umangagarwalla111@gmail.com>
Date:   Thu, 20 Oct 2022 01:00:15 +0530
Message-ID: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
Subject: Performance Testing MD-RAID10 with 1 failed drive
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello all,

We run Linux RAID 10 in our production with 8 SAS HDDs 7200RPM.
We recently got to know from the application owners that the writes on
these machines get affected when there is one failed drive in this
RAID10 setup, but unfortunately we do not have much data around to
prove this and exactly replicate this in production.

Wanted to know from the people of this mailing list if they have ever
come across any such issues.
Theoretically as per my understanding a RAID10 with even a failed
drive should be able to handle all the production traffic without any
issues. Please let me know if my understanding of this is correct or
not.

Also if anyone can help with some links/guides/how-tos about this
would be great.

Thanks,
Umang Agarwalla
