Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3621C433C1
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 11:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1A061A08
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 11:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhCXLEt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Mar 2021 07:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbhCXLEV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Mar 2021 07:04:21 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB6DC061763
        for <linux-raid@vger.kernel.org>; Wed, 24 Mar 2021 04:04:20 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id m12so31286903lfq.10
        for <linux-raid@vger.kernel.org>; Wed, 24 Mar 2021 04:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qs3I2F+7gtkatTtKES34XX6tp2NZqfHAlS6bT+/rSrs=;
        b=HEkx93j4iEdLQzwPpgi//3eLO71PQ5/r6/px2kQ0squA8wYjvTjRk6J8RaIp4EcMi9
         c8gVNyaNrEy4GJt3R2ydrDT9aXTgWKae/EM6NcSb+Kmd4c2676CKxtrjAIu0HEZJiS9M
         Ejm1zeCvsS4/OWawrbzHSrZ6wsvnsnL5b5OXhTRSDaXZTqb3jszc+f7xGYW6XNR0LuVO
         ph1CjvV8+ySQOvS08bSjXmchTcovZ9bg3ubTHhEtL8bNeZykME4UYZv5y0Rklhe/IxK0
         wsnag0zKpIIBNfm59qZ1Exh5YrwZPCl7N07hdN1ou3+ZFXJlBldsnsWJQ+I5iqq2944b
         kVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qs3I2F+7gtkatTtKES34XX6tp2NZqfHAlS6bT+/rSrs=;
        b=CytXMR5rYWKB0q6Jm/PYkRZzjajqx5iA1HfQnCYh5O/fZrGTNnHAW7o+XXccmsUebF
         lnSN9BrCPx5U6HlBuCJ8WdB6ztdyCq2rPUHl/vB780sGr8e+2gAJeqyRSE+0B34m27JY
         EAtdNcma4BV1yzszp0NqQYn29nQekKkTYX5cA2DaoPTmR3v9b9rKlXkBTK6U3enAP3lP
         HIg0w7DP4pc0D0Ry5NnCDHY1q3xhhnkv7ZOX7GWOEYYjRiBYxnnGczG+Kj+OzL2qbmRZ
         5GgonhHkwQ7UPv/jX4QmQ9hWen6wFxsGCKcS6qu3uhmH0Ddeyxh+a9XOqkzE/aclH/rm
         ZlPQ==
X-Gm-Message-State: AOAM531hLchmGkOD7fQqXPP95DLHNrCdBiY2aOj3Ku6payKTvx+Z7ksa
        8WKY2TfnzcfnP4yZnuFGxUuWeObTsdxpAyjC7OkR0WeEC4A=
X-Google-Smtp-Source: ABdhPJxKza4CyHipFQpXB9pgnwf5PVPzJF6mV1B+1w7xVmG0fqz16lteDFoGtPMbgRxZ2hy/ey6QPip8i9S4RPqZjuQ=
X-Received: by 2002:a19:4157:: with SMTP id o84mr1614469lfa.321.1616583858926;
 Wed, 24 Mar 2021 04:04:18 -0700 (PDT)
MIME-Version: 1.0
From:   Shaun Glass <shaunglass@gmail.com>
Date:   Wed, 24 Mar 2021 13:04:07 +0200
Message-ID: <CA+OzjxLW2Vw-ecs7jNELecpYxoBbK767pXEV8rFVaQp_HXfjOg@mail.gmail.com>
Subject: MDRaid Rollback
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good Day,

Would just like to know if it is possible at all to break a mirror and
convert a md device back to its original state without losing data ?

Regards

Shaun
