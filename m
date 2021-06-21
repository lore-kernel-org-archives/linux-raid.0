Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D347C49361
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 05:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFBC76100B
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 05:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhFUFCk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Jun 2021 01:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhFUFCj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Jun 2021 01:02:39 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6754BC061574
        for <linux-raid@vger.kernel.org>; Sun, 20 Jun 2021 22:00:25 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v13so7848727ple.9
        for <linux-raid@vger.kernel.org>; Sun, 20 Jun 2021 22:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=kopspj/Kxx0EjxMveVw7K+iFKgLMQVpAfdQc2jPNCMY=;
        b=kMc0jLs7mK4iVgWGVxVaxG42S5i0MGyDyQ2wuPjhUEQXkFkppIUWXiGcQNmtMEoCWT
         Pn9A+tJv4TV2VgV9lMQQlfcuIk905pXXcUydY6MItjSHWQe65TiY4Rlk60OS60sJFd7F
         RNWPVOhGwwJxBSk5Zw0SwN3nt+I56vO+fuklv/xA6K/C8IE9tR9jResZqzeqiW3/ILjd
         mg1Je1G8OFLGOzIO0SGXMexAeJvOSdE/eo9G9mYT3FYJQpLj9q0kqJfZP5OA3enJM5Li
         ThmxU6YgsI6IcwDBVvn7zTIMmOJ8r7Ho6S0JPzwGAcCikqWIZHOud2BZXPJT4Zyr4gTz
         eAVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kopspj/Kxx0EjxMveVw7K+iFKgLMQVpAfdQc2jPNCMY=;
        b=qEZ2kl50QS+j0WkhXxWJy+82okra/XL1rUlimk/R1x2ktesw5vYJJMoZkgIJYh2p38
         nxvjj6iSLkkYreAYoZUk38q2244LCTavnDokOi5xJaVqmobBJQRjLgNBm7WZCmn5959d
         QojA/BPo6Liv4kKf+Dnp7zeYo04tiHp3bFZKm/EPKjP17CdcNJd1yMzbfG2EH1ydQ3YQ
         0tWTfpMNq3R6H1xaElflTHsBr+oel+yT2UNt82oBsqFAANl7QYYnorQjISXP5IONuvhN
         MZfkhKuRvotRiol7NJtCzq6ti6nK/uQ3fcefiFxSNwnAhvAVxn4ub0mqFiXClml8qDW9
         6yhw==
X-Gm-Message-State: AOAM533v6YjQNbagQ5PqB4iOk1MFTZ2VS2AMN+YjPRbRoIGcKf+cOlDO
        lqenRVs8ZeSTs9tYKBwWgSZs7Z88JhWIIIlwTAVrIck51dI=
X-Google-Smtp-Source: ABdhPJzpY1m8BidHmjLF6fG10KnvaNC03K3KKU2+BoXGq6FBhaC4uVzC5m6KfL8h29P/9xvEs+WKKleLr6n353uSzoo=
X-Received: by 2002:a17:90b:f84:: with SMTP id ft4mr37304010pjb.104.1624251624506;
 Sun, 20 Jun 2021 22:00:24 -0700 (PDT)
MIME-Version: 1.0
From:   Edward Kuns <eddie.kuns@gmail.com>
Date:   Mon, 21 Jun 2021 00:00:13 -0500
Message-ID: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
Subject: How does one enable SCTERC on an NVMe drive (and other install questions)
To:     Linux-RAID <linux-raid@vger.kernel.org>
Cc:     Edward Kuns <eddie.kuns@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

1) Topic one - SCTERC on NVMe

I'm in the middle of installing Linux on a new PC.  I have a pair of
1TB NVMe drives.  All of my non-NVMe drives support "smartctl -l
scterc,70,70" but the NVMe drives do not seem to.  How can one ensure
that SCTERC is configured properly in an NVMe drive that is part of a
software RAID constructed using mdadm?  Is this an issue that has been
solved or asked or addressed before?  The searching I did didn't bring
anything up.

2) Topic two - RAID on /boot and /boot/efi

It looks like RHEL 8 and clones don't support the installer building
LVM on top of RAID as they used to.  I kind of suspect that the
installer would prefer that if I want LVM, that I use the RAID built
into LVM at this point.  But it looks to me like the mdadm tools are
still much more mature than the RAID built into LVM.  (Even though it
appears that this is built on top of the same code base?)

This means I have to do that work before running the installer, by
running the installer in rescue mode, then run the installer and
"reformat' the partitions I have created by hand.  I haven't gone all
the way through this process but it looks like it works.  It also
looks like maybe I cannot use the installer to set up RAID mirroring
for /boot or /boot/efi.  I may have to set that up after the fact.  It
looks like I have to use metadata format 1.0 for that?  I'm going to
go through a couple experimental installs to see how it all goes
(using wipefs, and so on, between attempts).  I've made a script to do
all the work for me so I can experiment.

The good thing about this is it gets me more familiar with the
command-line tools before I have an issue, and it forces me to
document what I'm doing in order to set it up.  One of my goals for
this install is that any single disk can fail, including a disk
containing / or /boot or /boot/efi, with a simple recovery process of
replacing the failed disk and rebuilding an array and no unscheduled
downtime.  I'm not sure it's possible (with /boot and /boot/efi in
particular)  but I'm going to find out.  All I can tell from research
so far is that metadata 1.1 or 1.2 won't work for such partitions.

3) Topic three - WD Red vs Red Plus vs Red Pro

In the Wiki, it might be worth mentioning that while WD Red are
currently shingled, the Red Plus and Red Pro are not.  I can search
again and provide links to that information if it would help.  I
thought I had bought bad drives (Red Pro) but then discovered that the
Red Pro is CMR now SMR.  Whew.

While this page is clear about the difference between Red, Red Pro,
and Red Plus:

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

this page is not:

https://raid.wiki.kernel.org/index.php/Drive_Data_Sheets

I would be happy to propose some text changes if that would help.

4) Topic four -- Wiki

Would it be worth it if I documented some of the work I've gone
through to get this set up?  I'm just an enthusiast who works with
RHEL at my employer and has been running Red Hat in some form or
another at home since 1996, but I'm not a sysadmin.  I'm certain I'm
going overkill in trying to ensure that every single filesystem is
ultimately on some form of mdadm RAID, but I just don't want to deal
with unscheduled downtime any longer.

        Thanks

                 Eddie
