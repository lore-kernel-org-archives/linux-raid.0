Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE81C5519F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Nov 2020 12:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D781208B8
	for <linux-raid@archiver.kernel.org>; Wed, 18 Nov 2020 12:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nqCVW652"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgKRM2c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Nov 2020 07:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgKRM2c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 Nov 2020 07:28:32 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE44C0613D4
        for <linux-raid@vger.kernel.org>; Wed, 18 Nov 2020 04:28:32 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id u18so2655404lfd.9
        for <linux-raid@vger.kernel.org>; Wed, 18 Nov 2020 04:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=A55yOkcvhaOXORHvitpEr5uSLE3xy7lbaLldp0+pTPg=;
        b=nqCVW652Ddz+B9K7ZuO63Rs5nx6mJ2ubv9veqF3nFPOQ6surqORC+svHIRd8+rGHaF
         vvV4ZW4q68Z71GxsNSPdxwXxBSYZcTm0nf4UsKKJxg2ayWkKoXwb1zIgnb5nd9hpPeex
         7iVz+/Kgx/yG6nDRhf85eJmclFFL/Lc4VckLv0SC2j71P4P+SIEX5B1v238FY6k5iRZ5
         eWZHLKffHI5sGghB+FlDB7NTIWmEA9R0DG0peWFp8yPFa4Yfv7JDoq7XSaXXIWxuQSCT
         YYCdMZAY5FKLtIVScPwx98gIIcBD77FiFMCL9IW9PEIP2fIbPJfHRKxdd940qM/kw+qZ
         I4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=A55yOkcvhaOXORHvitpEr5uSLE3xy7lbaLldp0+pTPg=;
        b=L23wqP1Zx8Txb1uVquoZaM9e+iQNIeWiGx2ZDh2Eydcgq94hc0/rMivrBAabBlacHA
         zmojGCscFTgmBHmfC+BnePhpVNUvHRmdDH0W+0K4C6mXkDyvirYexny1/PAOgvMGFeXJ
         1If3rNFAXqJHAkJt3a2fA77dKNSUfvn2KIJLl3r8QYSZ0r+9mUmNk+TIZPe+RW64TeBk
         8T2Xwwam/kClBmImUkt8FsdA/NlTnqgN4JGIjxgspWTE/+SzKYPteWUP2gZG3NTxXVty
         idN3vjPk/y9WUKsv4+fjuwivmYK8HMDd7wbYi1uSUUEDUyMpnI2lkUEpxnMDE/MKTwWE
         ZjEQ==
X-Gm-Message-State: AOAM531puZSpHBdKqvupAzm+GH4+ND1nAqoitZfxbpcIq3ZA+3sI5Chl
        jF8TO5J6lX/JWAYZHo5X6SaSQR2GY1Ylp3D15gy+L1bbPJE=
X-Google-Smtp-Source: ABdhPJxaECj4wbYaUJqChtSliVZU2CSI668dxBjZ6F/cR6xZDr38MXJWoJf6j4VZ13EyJ96v0DU71x0JJGYQGDenwgA=
X-Received: by 2002:a05:6512:3287:: with SMTP id p7mr4006915lfe.346.1605702510398;
 Wed, 18 Nov 2020 04:28:30 -0800 (PST)
MIME-Version: 1.0
From:   o1bigtenor <o1bigtenor@gmail.com>
Date:   Wed, 18 Nov 2020 06:27:54 -0600
Message-ID: <CAPpdf5-9J6S+Etg8viXoPxrur9pTDiz5DQNHBaY1HLAq388Ufw@mail.gmail.com>
Subject: procedure for unmounting and remounting an array
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Greetings

I find myself needing to unmount my raid array (Debian bullseye
(testing) using mdadm version 4.1) to complete an action. I then would
like to remount it.

AIUI I would just use the commands umount /dev/md0p1  then do my
action (hopefully with a successful outcome) and then use mount
/dev/md0p1 to remount the array (raid-10).

Is this a good way of doing things or is there a better way?

TIA
