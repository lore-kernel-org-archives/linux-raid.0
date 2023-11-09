Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF53C4167B
	for <linux-raid@archiver.kernel.org>; Thu,  9 Nov 2023 13:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjKINRG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Nov 2023 08:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjKINRF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Nov 2023 08:17:05 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D3830CD
        for <linux-raid@vger.kernel.org>; Thu,  9 Nov 2023 05:17:03 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-359d559766cso1400695ab.1
        for <linux-raid@vger.kernel.org>; Thu, 09 Nov 2023 05:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699535823; x=1700140623; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6f58aWxzQb+LWLTnTNWDmKaDVh23pRcJkOY97//UkNI=;
        b=lZnn7zZ9tbs2+1N5wnQurbWexBcYdIjwbD9infqpuUonunh0ILVQu3B4TAIJID5M8L
         eNfgpnKHwJSmmC0D6RLJ380F0fadLqygzypiSs1z6+TDEr3rQwhQS6+54fw4gTYlFJQ7
         816jM+O5H+nrqBjW8RI70TjFlZLPW7xlogKgilwrRMQTfsKqX0lYBDkwqRRe1kwAQE40
         bFKYdaCndkRyqlm3/C0Ls2xzEAxFlJpRG4cvh8Pmv+5FioXZx+mP6U3ATMEaEK8eRM1W
         ACP86byQILL59VeGxLo2IAnpyXXi5NwFdV6sletKicWsakxH2wlnN4dHXBOfTwPEsb5B
         XBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699535823; x=1700140623;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6f58aWxzQb+LWLTnTNWDmKaDVh23pRcJkOY97//UkNI=;
        b=WZeOdCwcR/0JlE4PO5RYah5QZYenhdwy5hi4iYdtcYhojDOSMVmOwCFW/KlP+tOU/s
         b46E0MSEAeyOCI4nJmlkM/fToDLm0zIIoKaw9kNpF9EDfwlOoJN+u8qehUkSk7bD4Fhw
         2a4XMxisfYh8Ls6nWsWIecUuVJBoO/NmT//lcVS8tpdVN4tTzCGrhWSFgyQsu1tW+xYT
         txT88AHvuN2ZWfwLP3OfXIpURmZrblZtFIiJnhSB73vfRoPiENmDv/8IYbJUBrldkIbO
         jLiF/J7xjAjcmeVFwpOXA6gVNtdKfuovQKDLMQN7jc2EP4HKMgrrj6pWI55bmYyIQmy3
         a4sg==
X-Gm-Message-State: AOJu0YzkYYHwGyJ38YhNAO57VJdYka64TvMuKOhCQ5myVdg1NGQbMQ7l
        sIMI7lBtnrswOgln9+/EICv0aE7eEkafmwmHALyak0e1
X-Google-Smtp-Source: AGHT+IF35+JU1pu5EQjcw7Gri9wl9vkiCYHRivvzy1e/cRBqA+pN7YOel+CKGLF7DZeipsEzl8SLhanNhy4Idr6v6Q4=
X-Received: by 2002:a05:6602:b84:b0:7ac:cb6b:616a with SMTP id
 fm4-20020a0566020b8400b007accb6b616amr2263586iob.8.1699535822791; Thu, 09 Nov
 2023 05:17:02 -0800 (PST)
MIME-Version: 1.0
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au> <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
In-Reply-To: <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Thu, 9 Nov 2023 07:16:51 -0600
Message-ID: <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
Subject: Re: extremely slow writes to array [now not degraded]
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The issue he is asking about is why does the md127 device have a
w_await time of 1473.96ms when the highest response time on the
underlying device is 15.94ms.  %util of all devices is low.

Something has to be going on inside the kernel to cause there to be
that sort of a difference.

He is also doing about 3 io/second which is significantly under the
capacity of a spinning disk.

If a disk was having issues with bad sectors/failed sectors/silent
retries then the %util/awaits should show that.

So between when the write gets to the md  device and when the io gets
to the physical device there are 1000+ ms (on average).

And this is a typical sample that is being seen when the array is not
functioning fast, and this issue clears (all by itself) some minutes
or hours later and continues as if nothing happened.
