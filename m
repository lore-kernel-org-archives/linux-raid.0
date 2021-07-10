Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F96C07E95
	for <linux-raid@archiver.kernel.org>; Sat, 10 Jul 2021 12:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D87A60FF4
	for <linux-raid@archiver.kernel.org>; Sat, 10 Jul 2021 12:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhGJMSO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Jul 2021 08:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhGJMSO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Jul 2021 08:18:14 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF3FC0613DD
        for <linux-raid@vger.kernel.org>; Sat, 10 Jul 2021 05:15:28 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l17-20020a05600c1d11b029021f84fcaf75so948005wms.1
        for <linux-raid@vger.kernel.org>; Sat, 10 Jul 2021 05:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=PfC1detABTXdUKRkQpNKHP4yGJHs9ITks6NhfZsn/c8=;
        b=IeqmI5KmpGb6FWpkbDjxJLw3xaO0sOExb4hjSlFnRO8sj+eqHdq3mJcBBhZ0PYYmv5
         QTuNXn3W9cm+VlXkQdi+pHDSgtA4hMsEOjTdE1SlO1s0cFUjLqXPSYb/OUn8kQIcCBM6
         eUL5+ssg1euV8iPfg8YS7ujtcMyFShhO8Rv65eKqTQqwEmi8up+BthxyUUmyNmwLfPzW
         L65eOewNNGUUCyfguS3EzbrGmS++jw67mQeWSByqh85b5RHM6fqDNqgqpsK+G6WVJ0c7
         d0hAj+xHWOGV5cZ1OhyQ5+mmMlOBNi6SEtd5Ionw4VMCoy1EOUYrbHT+iR4FZcx/NqPt
         WiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PfC1detABTXdUKRkQpNKHP4yGJHs9ITks6NhfZsn/c8=;
        b=sIIqU+nMFAXda7sWjL9jyeJsHxLZ0RW0wIilSM3sBuVFz9A6qcsE/72NXXFazaXLKO
         6N68yMuKy1sXGD4pkCVQEsTe2QP0do6/gT7qyRl3TfwsiN2Lv+3YINovPgvODAhnddP3
         Gb55UwOQKUGT1ZW+Bq0InE5thVIhqSkfk3CqbahNdOxjNROqEEf1wo3Xp7mxMR98tgr4
         qE8qTcfRUmfsdEpUeh9rZMS1mFwi5hrNe5IkMQBWRZ9xwhEbEKLDcpyof2KaMmxlhQ6i
         d1snRIMozGUpl0RY1PnC0/UkcX9kpgvaSUhUguSxPmXXcUJclq4AJqm+R/HnDS1KM+2m
         SNzA==
X-Gm-Message-State: AOAM531bgQ9WMaurwCtx8++k3vucwpLTTQzwmpnAn4zmtIOKz/phh8U8
        FkGRjgn9PW9urKWVzngbNFGdwy3dIMtS+mcuapGefbWiVBQ=
X-Google-Smtp-Source: ABdhPJyygS1DQKFfGtNomYRmUWkQkJoMTBk90abxIVQLJcVqGuR2mlYNEgEL+u2+e679dC+KIZa74UYrpakKLXky2x4=
X-Received: by 2002:a05:600c:2ca4:: with SMTP id h4mr27093637wmc.37.1625919326730;
 Sat, 10 Jul 2021 05:15:26 -0700 (PDT)
MIME-Version: 1.0
From:   BW <m40636067@gmail.com>
Date:   Sat, 10 Jul 2021 14:15:13 +0200
Message-ID: <CADcL3SDHb-0U2cjoNOMXbFmbiwpVfytzczyg9VkaK=vWyKiFtA@mail.gmail.com>
Subject: What about the kernel patch "failfast" and SCTERC/kernel-driver timeouts
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I don't know if the "failfast" patch was ever pushed into the kernel
back in 2017, but if it was, does it change anything in regards to the
SCTERC/Kernel-driver. timeout issue(s)?

Link to a thread about the patch: https://lkml.org/lkml/2016/11/18/1

And what is the reason why mdadm just doesn't mark a drive fail if no
response has been received from a array-member-device within e.g. 29
seconds (just less than kernel-driver default timeout of 30 sec) e.g.
because of write/read issue. Then all those SCTERC/kernel-driver
timeout-issues would be solved, right?
