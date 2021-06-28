Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F0EC48BC2
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 02:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34FB561C2A
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 02:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhF1CX1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Jun 2021 22:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhF1CX0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Jun 2021 22:23:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A8CC061574
        for <linux-raid@vger.kernel.org>; Sun, 27 Jun 2021 19:21:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id q192so12835415pfc.7
        for <linux-raid@vger.kernel.org>; Sun, 27 Jun 2021 19:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cOPmFkiA2pRFugdqw+OGNs7CsGhq8sYEpbkSPBVQTNY=;
        b=KX/HJqlu9I1zSPK9jlGjNK4/jCxidj1AfWbD0s460HOfl+lyTnVZ3XQMODg/Da4YCb
         LnLUlbPRvhDjpQKsjvFxiDsmFqURbiqTDkOkJ8/cMV4LbNyNO/J/0RGvBesJD7b8ZbZ4
         RU9rGArvt1fnMS32L3lDbIr1c2SVnZsFUQ9F2yHIAJ+gRgcA984wZ/z2XEr0uGc/yzEF
         aLvUXlnQ5wb9+wgHeETlxEhyuZBHa091t6uvT8sHlyH9IpJHMSqLNF5NV7y7ilNo9vTM
         9q9O5WwXBiMqG3jSxeHNU6V8K/bKIGKG+xCc/T1PZiH3JCoajJK/HTrNay8vG3oUtahY
         8VpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cOPmFkiA2pRFugdqw+OGNs7CsGhq8sYEpbkSPBVQTNY=;
        b=sCi8yym7e+UascT0e3QffBYdMbtcvu/JTou3FlCHjRABzjMK+V6aje2N0sEmeFWODR
         gIm+7YXg787uiao6W5YIitmZ8ZkUvUl4ASn+SMvHfRVYslnEFt7qy3oWXq3X17nD20eG
         sjrDCyBgZU93osfJXPB4/h0IlFq/ywHb3N2MV3sYTZ2v/0DgPjqD9zzEb+5dNIdL3Y3s
         ULXayPoDpFxNb5Zoy9VZp2i42c30Fx5OI752poyvgZpEoWCEATCMiNuIYn3KOmAaKskz
         xR+Y2jfb1MrxiXTKA2Is0enDhKjeRaEBZ7SVV21MeEnpUnl21aVbnh7RNaIZw/WpSnnG
         2OOw==
X-Gm-Message-State: AOAM531qylzdmNuU0BhndOREMNhbvmgQVvyz/aqWJHZdYYc682gHJW7h
        wUs7TlJpFSDWiaTO2YQmH5FMzF8HISScfgLjGKs3LyKF
X-Google-Smtp-Source: ABdhPJwsmKNP86jZKPBCwsGuRnA5BAkffDwKmpX9R7PeAXVycRr69yFUOkWEqQqMNM2uFaWsLFSHzrg4k9Lu3v6FiCA=
X-Received: by 2002:a05:6a00:2ad:b029:303:41fb:41d7 with SMTP id
 q13-20020a056a0002adb029030341fb41d7mr22279094pfs.7.1624846861408; Sun, 27
 Jun 2021 19:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
 <20210625220845.57wcwz4sppavywf6@bitfolk.com> <afbb6970-72ac-6900-8bf9-ba84bc6f3ffb@turmel.org>
 <CAJCQCtQ0i2cOUnWZ-SAZMcf3m4jsmJz7wUpUzU+Ge3xL=dT+9A@mail.gmail.com>
In-Reply-To: <CAJCQCtQ0i2cOUnWZ-SAZMcf3m4jsmJz7wUpUzU+Ge3xL=dT+9A@mail.gmail.com>
From:   Edward Kuns <eddie.kuns@gmail.com>
Date:   Sun, 27 Jun 2021 21:20:50 -0500
Message-ID: <CACsGCyQUyOpyfzB2xs6SXZe1UrvO=az7ngRAbJT29B+Hz1_8_g@mail.gmail.com>
Subject: Re: Redundant EFI Systemp Partitions (Was Re: How does one enable
 SCTERC on an NVMe drive (and other install questions))
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Phil Turmel <philip@turmel.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Jun 26, 2021 at 10:14 PM Chris Murphy <lists@colorremedies.com> wrote:
> I think it's unreliable. GRUB can write to the ESP when grubenv is on
> it. And sd-boot likewise can write to the ESP as part of
> https://systemd.io/AUTOMATIC_BOOT_ASSESSMENT/
>
> And the firmware itself can write to the ESP for any reason but most
> commonly when cleaning up after firmware updates. Any of these events
> would write to just one of the members, and involve file system
> writes. So now what happens when they're assembled by mdadm as a raid,
> and the two member devices have the same event count, and yet now
> completely different file system states? I think it's a train wreck.

It sounds like the least risky option is just manually creating more
than one ESP and manually syncing them periodically as Andy Smith
mentioned.  (Or automatically syncing them upon every boot.)

                Eddie
