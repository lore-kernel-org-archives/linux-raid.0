Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84F4C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 15:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbjKGPXD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbjKGPWw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 10:22:52 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2D2AD1F
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 07:14:14 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7a66bf80fa3so35942439f.0
        for <linux-raid@vger.kernel.org>; Tue, 07 Nov 2023 07:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brooks-nu.20230601.gappssmtp.com; s=20230601; t=1699370053; x=1699974853; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q8zEAvmY6PIYXmSFL0Zu1zKnP7X4pyukIUQT0i8e7FU=;
        b=BvVjbXMRvTLaL4kYXSbN1m4AIpsB5RaA1EdhsLfPusAQ6KgKZUho+/ukSKZc91OfXF
         2xLhgU/XJfMgJ6ywWfYERUmjOJagqmj1XFmmdn/FEySbz+0rfEsd/7P0bzx5bVyPBz7F
         aOz+chr3hN6W0IoGehhur/CRUixv8h3zKR10WuoPQJUy++xQ+Ncxt6aK/J/MqaLqSU9J
         KM9spCvr6Hgal0/NBmSCJex+J5doFA52Pjt3ofZ6nM52/AzWdr7I9Z/xH7trhTPJzBhR
         2IH140K1fgeKPZSVLwygXC+BTsQZ3CH2FDN73aY0A2Br1Z7m1vlNA2jUorcPv/XtTaMc
         kuZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699370053; x=1699974853;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q8zEAvmY6PIYXmSFL0Zu1zKnP7X4pyukIUQT0i8e7FU=;
        b=jQibgqeYywwIbX1slth07sfyaoh2m3qBDI7R/rs4V6q8Xb14Vqrt3j37m2ns8MQxtV
         Uli149nOgnHNGmfjqx89AtTFZkXe5KpdLvzjnFdagbLnLCHywVbHXCWHhBmVSDvCUCB5
         tfRxZoQ8MfpXhekZWz24mQadLhZSmCZ7mxNAAXacQ/hhvkZMDLeEArqz4OKJKLPSwScK
         +hcYd2VkABeJskjTnngFiKWwwzgOetqDCLhMJs2MTh9u9VIDzWIaaZTM4drC8QoCmZ9K
         d19yrgPRZtO47izK/18ZotNeb1uiomWdsL7RPhpSkgG1DVu53QoKqoKPVT1yfUNUzCGV
         7jcw==
X-Gm-Message-State: AOJu0Yyvy+0Jvz2sNTZUe6KYJvWEM3dHLVwJ/HlW8n1hSkkqVz+nAWMj
        w1etVWbePv/QkN8f+5HL5eBxEyhxcH05zQiIqPQUIKmldXJNCX5cIjS0lQ==
X-Google-Smtp-Source: AGHT+IGBDkillloiTaunmYMxef5q/pDEEn0xjnFWIRvXiqAXblsHggyx1NGvq8U8vqbO01YL7SB0PaZn3e6ueYu842s=
X-Received: by 2002:a5d:924a:0:b0:7a9:7aa9:c175 with SMTP id
 e10-20020a5d924a000000b007a97aa9c175mr33979241iol.1.1699370053328; Tue, 07
 Nov 2023 07:14:13 -0800 (PST)
MIME-Version: 1.0
From:   Lane Brooks <lane@brooks.nu>
Date:   Tue, 7 Nov 2023 08:14:02 -0700
Message-ID: <CAE1wYva7ArH+=okXPWBG7r7EYj-3_Ph3OM3OXHvGLEHOp+tK-A@mail.gmail.com>
Subject: Issues restoring a degraded array
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have a 14 drive RAID5 array with 1 spare. Each drive is a 2TB SSD.
One of the drives failed. I replaced it, and while it was rebuilding,
one of the original drives experienced some read errors and seems to
have been marked bad. I have since cloned that drive (first using dd
and the nddrescue), and it clones without any read errors. I think the
read errors were coming from a faulty SATA cable.

But now when I run the 'mdadm --assemble --scan' command, I get:
mdadm: failed to add /dev/sdi to /dev/md/0: Invalid argument
mdadm: /dev/md/0 assembled from 12 drives and 1 spare - not enough to
start the array while not clean - consider --force
mdadm: No arrays foudn in config file or automatically

The sdi drive is the cloned drive. My googling for the "Invalid
argument" error have come up dry. Both the original and the cloned
drive give the same error.

If I try the --force, I get the same Invalid argument error but also a
'not enough operational devices (2/14 failed).

Any suggestions on how to recover from this situation?

Lane
