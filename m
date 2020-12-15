Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20619C2BB9A
	for <linux-raid@archiver.kernel.org>; Tue, 15 Dec 2020 20:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC43E22B43
	for <linux-raid@archiver.kernel.org>; Tue, 15 Dec 2020 20:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgLOUKB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Dec 2020 15:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbgLOUJs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Dec 2020 15:09:48 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DB3C0617A6
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 12:09:08 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id s6so10215206qvn.6
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 12:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=oz1WREk2KhDuU1rtgSKD9BA5SFMIIgH9ATkJNoMk1GA=;
        b=g8Nf0CpkUN+wmSq7kj877SfZEfpphvFcYUG6Is6GDBZI9n1NrRHbSXNKrIZBwiLG5N
         7FLU6RotSIoBVriemLMh8xALmal7Jvb0n1vrISAGG0X7SSkMdDeiI6VNKRq81MO6cavs
         pLpjpk2J1YfHBwBLiht6UocY5iXlrurVIus5mZXQTAUKXcWI1gPHEVArBAowCUm7KVVw
         X5f6R7flmHvqVm3O6PtfeNE2tY8iAlzDQnDu1Gk16mya2XLabW7A4dsZP7rBVUprZtJ0
         2xoEB2ew4KfxZkj2Ho8j318MBDlswDKA4p9Rjs45J3IlX6eieCFmzzqhQhZOGau0ncAR
         SPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oz1WREk2KhDuU1rtgSKD9BA5SFMIIgH9ATkJNoMk1GA=;
        b=K8OIvpwk3e2gp94ojYWqV7ZlTxhz5uFgF3G8QNSQmTK4KELHinVHKtp2QGCLiuS2CK
         sQKEegU0pu9IjAvghAxxVbalZ69W+z8vRaxZLhYf8D6AIGSap57WbHrJB6+UJ1is2WzE
         /OBV4a2jnydjQt7KoVp6MLX/EAKRCB5G433wmW8U765bOh+QbGSPdwOi+Bw/haqE9ALP
         OvAkU8lqv6tKy4zOgKpAhLxjX1kx1B3sln2xJxIemgCyt2X8WgnhufFyJDADtkFC1l0+
         yfsfrz7o3pLwk8WEnUviLwBHuxUB7kB5XwTTK+s31PzV1Gn4VkZ5iErUy8pcJOJiWuvl
         mivA==
X-Gm-Message-State: AOAM530scBd3vQ6YpuUBY5u+GhiIxwBVgoaG7z+W6JQgoqHZd/j1IV6P
        wJYQBWB6GdcKM6b4zkTVcfRzDVSTYHNcewn7lrOoBv3MbiJ3Rxjv
X-Google-Smtp-Source: ABdhPJw7tFarg6DzL4qUgZx2nRB37oM0semNSehiNS5KWTBu+QyjjRJqU4N76QTrQwvTcRUsXWOKPh4A4Zm5FpYa8IM=
X-Received: by 2002:a05:6214:1887:: with SMTP id cx7mr14245324qvb.39.1608062945996;
 Tue, 15 Dec 2020 12:09:05 -0800 (PST)
MIME-Version: 1.0
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Tue, 15 Dec 2020 21:08:55 +0100
Message-ID: <CAA85sZt+MV=LY7xCvKqccD_gK35hwSnczPSKenW81rQ3yK7JTA@mail.gmail.com>
Subject: RE Array size dropped from 40TB to 7TB when upgrading to 5.10
To:     =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

the same thing happened to me, but it was a raid6...

Eventually I just gave up and did a:
mdadm --grow /dev/md3 --size=max (since it reflects the size it used to be)

After a few hours of syncing, everything was ok again
(according to btrfs check which also took a few hours =))

But remember to do this with a 5.0.1 kernel ;)
