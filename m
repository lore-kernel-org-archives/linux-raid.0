Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E8EC2B9F4
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 03:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5D9F60232
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 03:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhF1ECE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Jun 2021 00:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhF1ECE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Jun 2021 00:02:04 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2EFC061574
        for <linux-raid@vger.kernel.org>; Sun, 27 Jun 2021 20:59:38 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id g7so14727627wri.7
        for <linux-raid@vger.kernel.org>; Sun, 27 Jun 2021 20:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PuR5jMKgM9KJKAjU88x3gBIU75sdY4l5p7FPV14Wx70=;
        b=0DhRCrspYfuSFJO3hCzCmXPwJUhgzL79Ngb6dNlanJXLUVF36Yq2w0wXTzfANzcYcn
         EzcSgeNO+FaxlxSAH8p7HXh9a9zbcDvTqq02ND5R70Xa3Bq2Rej5YGQgxEstenOZ4+Zq
         HMTTeBojmsqHEORUodLTtQ6G7lpiOHr1OASHsDHOXYe0ZUUPWxMyU9SNqydtpf7B0MMF
         U7XYE7r8ksmuEMpkcv3BWAi8alNEvEq4CMkkfyBN6EtmCNvYXALjDge8yY6al/5c9H1W
         kpcmiD0R6kccjKI4cpIHTeng4oNYLAGxc6Ad1vwnWDMpoNzU3cOs62IL4AQwO0x1m+ra
         migw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PuR5jMKgM9KJKAjU88x3gBIU75sdY4l5p7FPV14Wx70=;
        b=O2niJRLZQ+rmoARQzVEQXZcgl3jN6zUAGwpPaduCE94p3OKPH0gl+8sMTU7KcP/a4l
         uREoVIRanGLHGdZ+dIBto3glOvi0ADy3KIox+8IHh3l/av5BTEzs/6WrmzXz30l6Duvh
         fesfDUObdJUaxvpVCFezNRQXEnJLrhFrx3l+ECJgzNBTuP9WJOAMqKys+7pWs1aHT76Y
         sPrs+1kGSsVc0GFQiwOEP7V+I+2Ke9/FPb3u19IKDY2w1Jn06BtHH+eRC37363sXZbBV
         2LlJs/6suxQJ4/ABPFf/AqytA+DtgbKUpT4RuGpB8+owvht1EMPHR/20IjUJrSkRjR5D
         PtFg==
X-Gm-Message-State: AOAM531HQxtnsKsgUK4XzjEt7znDLPTtOsR0mlE1Lm2Eoe/116IRWHyF
        4DnoST1EupUe/amtk5zabVFSGSHZCjZxnAQNqS1xtQ==
X-Google-Smtp-Source: ABdhPJw63JSZhuE2D9i9oxANhNGhRsyzgJdl7vbLzfhtkoaM7Gk19Z3PNVbznZ4wilIx5JolOJVOMecj28r9sPmvTDU=
X-Received: by 2002:a05:6000:18af:: with SMTP id b15mr24523715wri.252.1624852776658;
 Sun, 27 Jun 2021 20:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <CACsGCyRLJ7Lr5rpxUDaNRzZr=s0LjK8wwOENC2RXmNsHvz4HaA@mail.gmail.com>
 <20210625220845.57wcwz4sppavywf6@bitfolk.com> <afbb6970-72ac-6900-8bf9-ba84bc6f3ffb@turmel.org>
 <CAJCQCtQ0i2cOUnWZ-SAZMcf3m4jsmJz7wUpUzU+Ge3xL=dT+9A@mail.gmail.com> <CACsGCyQUyOpyfzB2xs6SXZe1UrvO=az7ngRAbJT29B+Hz1_8_g@mail.gmail.com>
In-Reply-To: <CACsGCyQUyOpyfzB2xs6SXZe1UrvO=az7ngRAbJT29B+Hz1_8_g@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 27 Jun 2021 21:59:20 -0600
Message-ID: <CAJCQCtSmMPdK5AmJu-i-amhQBKV8Fqcix7HOTM+_Pn-Uj6Ggig@mail.gmail.com>
Subject: Re: Redundant EFI Systemp Partitions (Was Re: How does one enable
 SCTERC on an NVMe drive (and other install questions))
To:     Edward Kuns <eddie.kuns@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Phil Turmel <philip@turmel.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Jun 27, 2021 at 8:21 PM Edward Kuns <eddie.kuns@gmail.com> wrote:
>
> On Sat, Jun 26, 2021 at 10:14 PM Chris Murphy <lists@colorremedies.com> wrote:
> > I think it's unreliable. GRUB can write to the ESP when grubenv is on
> > it. And sd-boot likewise can write to the ESP as part of
> > https://systemd.io/AUTOMATIC_BOOT_ASSESSMENT/
> >
> > And the firmware itself can write to the ESP for any reason but most
> > commonly when cleaning up after firmware updates. Any of these events
> > would write to just one of the members, and involve file system
> > writes. So now what happens when they're assembled by mdadm as a raid,
> > and the two member devices have the same event count, and yet now
> > completely different file system states? I think it's a train wreck.
>
> It sounds like the least risky option is just manually creating more
> than one ESP and manually syncing them periodically as Andy Smith
> mentioned.  (Or automatically syncing them upon every boot.)
>
>                 Eddie

I'd like to say we are definitely better off with stale ESPs
occasionally being used, than corrupt file systems. That's probably
almost always true.  But since fallback to another ESP can be silent,
without the benefit of any information from the pre-boot environment
ending up in the system journal to know which ESP booted the system,
it might be false comfort.




-- 
Chris Murphy
