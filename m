Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A8EC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jan 2022 19:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiACTxi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jan 2022 14:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbiACTxi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 3 Jan 2022 14:53:38 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26697C061761
        for <linux-raid@vger.kernel.org>; Mon,  3 Jan 2022 11:53:38 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id m21so141010630edc.0
        for <linux-raid@vger.kernel.org>; Mon, 03 Jan 2022 11:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jb1cHx7NUtCc6wHz+H//KWrS5XMdnXN9boixbWetpl0=;
        b=h0EwKNAb+U4bBwBEPKIkk8XVcD8jMiaBkWAXL7UVpFZMTORnFzqTm3rVdnUsHhumPO
         SCgKOm+88n8KuPRd4NzwSVxLYY3SO2T331HWgyZRymDn8qMU9NThYYRc6HOS76ZBOaqm
         urEz86v4gzL6HI7VZ7GDz0XEzMDoJ6V8C5JLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jb1cHx7NUtCc6wHz+H//KWrS5XMdnXN9boixbWetpl0=;
        b=7aUP7LFSuBEzq23WnestFwlFBd+eMH81WBRqWstQMY5yLRCa3Klboxq8sLhMiQyJxR
         PAPo9WQdWkXC9A5TPFximi2ahKXtuAeVvfi17cC5nDhhyZEmHK8VpQST6IdpdyyFn9ri
         cQYCSXHmpJeWySS8m9MBer13srfcuvc4SKzilz5G/rccJnUbt4uI+jt17iKbA5Zz70M0
         F2r4Ewi4uQKp+gfqts9GP//Koh8otScU5supuQPOKmCw9UDZudcjZfl8/iPaH9Nzh/ZB
         d1L1gyrOV7x8FRleV5wz0atqyq5xmBtYH/6rT/LrSwM/cW1Vmqek37clEph+JvAhukUJ
         sROg==
X-Gm-Message-State: AOAM533h689o3SpaQ/Na8ERMXpqozK5qe7vxpoc8oYAtnZw4eFxICyXu
        xdZJWbWJZK3BhDaPPLVZU9c9KI9zHnYvIQtJ
X-Google-Smtp-Source: ABdhPJywL+oMU13nDIEnmhpJJN88Hoh0uzLm5D+FOIyZApoKqQP9ruj2mqKuSlxm8/YyJd/yztSXSw==
X-Received: by 2002:a17:907:72c6:: with SMTP id du6mr33074924ejc.552.1641239616539;
        Mon, 03 Jan 2022 11:53:36 -0800 (PST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id gt20sm7040976ejc.11.2022.01.03.11.53.35
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 11:53:35 -0800 (PST)
Received: by mail-wm1-f51.google.com with SMTP id a83-20020a1c9856000000b00344731e044bso385581wme.1
        for <linux-raid@vger.kernel.org>; Mon, 03 Jan 2022 11:53:35 -0800 (PST)
X-Received: by 2002:a05:600c:4f13:: with SMTP id l19mr40031036wmq.152.1641239614943;
 Mon, 03 Jan 2022 11:53:34 -0800 (PST)
MIME-Version: 1.0
References: <m3tuekbos5.fsf@nogrod.ivcecceob.t-online.de>
In-Reply-To: <m3tuekbos5.fsf@nogrod.ivcecceob.t-online.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Jan 2022 11:53:18 -0800
X-Gmail-Original-Message-ID: <CAHk-=whzdxBuoeTP1uJrxRQYtwOxPDYuP92c8e=_K5T1xHy7Ug@mail.gmail.com>
Message-ID: <CAHk-=whzdxBuoeTP1uJrxRQYtwOxPDYuP92c8e=_K5T1xHy7Ug@mail.gmail.com>
Subject: Re: [Regression] md/raid1: write-intent logging/bitmap issue since
 fd3b6975e9c1 - v5.16-rc1
To:     Norbert Warmuth <nwarmuth@t-online.de>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000003d9ee005d4b2e0b0"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--0000000000003d9ee005d4b2e0b0
Content-Type: text/plain; charset="UTF-8"

[ Jens wasn't cc'd for some reason but was the signer-off-on the patch
you bisected to. Added him to the cc. I'll bounce the original
separately, as I also don't see this on lore.kernel.org - it might not
have gotten there yet ]

On Mon, Jan 3, 2022 at 11:30 AM Norbert Warmuth <nwarmuth@t-online.de> wrote:
>
> Please verify and either revert or fixup fd3b6975e9c1 if my analysis is
> correct.

Can you check if moving the WriteMostly bit to the "do behind I/O?"
section fixes things for you?

IOW, something like the attached patch..

Warning: This is very much a "Money see, monkey do" patch. I'm not
really familiar with the raid1 code ]

But yeah, if you see corruption and there isn't an absolutely trivial
fix for this, we should revert.

           Linus

--0000000000003d9ee005d4b2e0b0
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kxz3mh010>
X-Attachment-Id: f_kxz3mh010

IGRyaXZlcnMvbWQvcmFpZDEuYyB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9yYWlkMS5jIGIvZHJp
dmVycy9tZC9yYWlkMS5jCmluZGV4IDdkYzgwMjZjZjZlZS4uODU1MDU0MjRmN2E0IDEwMDY0NAot
LS0gYS9kcml2ZXJzL21kL3JhaWQxLmMKKysrIGIvZHJpdmVycy9tZC9yYWlkMS5jCkBAIC0xNDk2
LDEyICsxNDk2LDEzIEBAIHN0YXRpYyB2b2lkIHJhaWQxX3dyaXRlX3JlcXVlc3Qoc3RydWN0IG1k
ZGV2ICptZGRldiwgc3RydWN0IGJpbyAqYmlvLAogCQlpZiAoIXIxX2Jpby0+Ymlvc1tpXSkKIAkJ
CWNvbnRpbnVlOwogCi0JCWlmIChmaXJzdF9jbG9uZSAmJiB0ZXN0X2JpdChXcml0ZU1vc3RseSwg
JnJkZXYtPmZsYWdzKSkgeworCQlpZiAoZmlyc3RfY2xvbmUpIHsKIAkJCS8qIGRvIGJlaGluZCBJ
L08gPwogCQkJICogTm90IGlmIHRoZXJlIGFyZSB0b28gbWFueSwgb3IgY2Fubm90CiAJCQkgKiBh
bGxvY2F0ZSBtZW1vcnksIG9yIGEgcmVhZGVyIG9uIFdyaXRlTW9zdGx5CiAJCQkgKiBpcyB3YWl0
aW5nIGZvciBiZWhpbmQgd3JpdGVzIHRvIGZsdXNoICovCiAJCQlpZiAoYml0bWFwICYmCisJCQkg
ICAgdGVzdF9iaXQoV3JpdGVNb3N0bHksICZyZGV2LT5mbGFncykgJiYKIAkJCSAgICAoYXRvbWlj
X3JlYWQoJmJpdG1hcC0+YmVoaW5kX3dyaXRlcykKIAkJCSAgICAgPCBtZGRldi0+Yml0bWFwX2lu
Zm8ubWF4X3dyaXRlX2JlaGluZCkgJiYKIAkJCSAgICAhd2FpdHF1ZXVlX2FjdGl2ZSgmYml0bWFw
LT5iZWhpbmRfd2FpdCkpIHsK
--0000000000003d9ee005d4b2e0b0--
