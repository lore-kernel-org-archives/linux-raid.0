Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A76C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 25 Oct 2021 12:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED67A60527
	for <linux-raid@archiver.kernel.org>; Mon, 25 Oct 2021 12:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhJYMEV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Oct 2021 08:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhJYMEU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Oct 2021 08:04:20 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0801C061745
        for <linux-raid@vger.kernel.org>; Mon, 25 Oct 2021 05:01:58 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id q129so15249485oib.0
        for <linux-raid@vger.kernel.org>; Mon, 25 Oct 2021 05:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=o5d+vCFvuo5OgndPJF7UIiuw1T9m3XWYeNbw60vdlUE=;
        b=nNij9MbYCm2AovA+KWNso7CC6uiiSByya3LM5TKmGvJvmBVrMoWWp1rHT3/ljd7Dhp
         fkHqGwTYm+MTix+PfLPYzprbmkwhT0Zmcar0yNThtcTOv3Sxbmvp+ghCZ72fHjkQKHMe
         xDCCKFxlUuj1ifDrzHUCKN4ULFRn3O10AReAx3TpLzgYioOuTXCg7HNfq0wQIlEvIIpa
         422yJfnIOqg0yx0TrujhWy8NNvRS+UctxEfOXoqv7+HhbB+lB2CEVAFT+tg1JBBDmep1
         lZpPVn4GEyyCKcqI41x/sOHvsexH7QlM9JTjHXiBdXAWgaQAfZUudoQSjPzmrRd8SseF
         4ElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=o5d+vCFvuo5OgndPJF7UIiuw1T9m3XWYeNbw60vdlUE=;
        b=22tHKjFrA9TknS8w3sA49YCxSxiu+c8bH6gCKErlnbWu2kPNTGWmUGtmDoUrgj6081
         g5nkSna9Id5hTUX2ix5HOSvah43zDAhnQHJGkyFYxNlCZox0SHFxwd5Vz0kAtjoTckW7
         NGc6Bpr/Yq6QhUtJQPzdLuCqiMQVaSm9sDAWsQ6JF16YrqNvoLKXYK0G0KOKHMS0D2jH
         WjqiPh8giqnTCSnkqWWsokrnB9RcwMT3Tr7fldqfdNMeGF2YDbNdnRWgRW6TNWu61Syi
         2voYcDRCWSj1QN/25ke6D3iADP0dnd135r9QYYtZlO2pVf++7KI1tyrYvIpos2YqUyx8
         ATdw==
X-Gm-Message-State: AOAM532ujtzbN7XcTkuzX+iFlZiX5Dxn1PR9ZHshr1y8jXMkE1y30pco
        eQ7LmjRgXupG1cv6FtTi+xFrsK24I4ICN+nnOtr/qIxzu/bP+A==
X-Google-Smtp-Source: ABdhPJyI1IhG9mMgNOWSw7RfqzFWL3zXx1B5E6+Pasfj9lmkz8ctMU6PiDGL5C8ARki4Z7O8C/7PRvmDIcmhQEruXuk=
X-Received: by 2002:a05:6808:21a1:: with SMTP id be33mr11856095oib.161.1635163316912;
 Mon, 25 Oct 2021 05:01:56 -0700 (PDT)
MIME-Version: 1.0
From:   Marek <mlf.conv@gmail.com>
Date:   Mon, 25 Oct 2021 14:01:46 +0200
Message-ID: <CA+sqOsZB7s76CVmOQw6jbG3L9q7FLJ_Lw85QEnYVn7RTr4RNxw@mail.gmail.com>
Subject: (looking for) more info on parity creation
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,

I'm looking for the piece of code inside mdadm source code that
calculates parity can someone please point me to the part of source
code which implements parity creation?
Also is it just a simple XOR as described everywhere:
eg double word disk1 XOR  double word disk2 XOR double word disk3 =
double word disk 4
or is something more complex going on.
thanks

Marek
