Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46C6C43334
	for <linux-raid@archiver.kernel.org>; Fri, 22 Jul 2022 11:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiGVL6p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Jul 2022 07:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiGVL6a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Jul 2022 07:58:30 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F25BE9D2
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 04:58:20 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id e16so3391494qka.5
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 04:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vAYvc28X2RtERrl3qehpSw1g2RcXdqhgfKR255M8Vqk=;
        b=ZBk0IiwTucVFrK9CIbR0rl8djNKlmWCPKIsf/BkMYYk2A2JVbFPegWFw/vInmb5HMb
         NrKBvwq/sdokvMwlPmgqmd1sjpqo7jWn26XdVrpaXWcc7muIk7eRSKiTYe3IN6SWtdOb
         b2ea1Uoc6s8JX/TY96RKji+nDo4hPpPCZcumpeGTtN7lu/yiN/EU/jZoz9PjyLH6WfiX
         t+pIPw/BGSfAMFGVk34+gtOkIthF/kfzQz+vtgxtqD0mJKxSwxtd54SHYlankygsb7cr
         DCMtn4E14F9C3BMDEDPkpTPa3D+CL8tBpjzGGoaK+cjFFzyP88I0+EoGfZu3k4qH7QRm
         J04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vAYvc28X2RtERrl3qehpSw1g2RcXdqhgfKR255M8Vqk=;
        b=Os6oy2IaWWmWXEfScK0V8RkLL/LIiQdTBvfaY/fToQ/mxN6au3jnple/PKjNn5QQ4H
         lXgJRqMpDz858Xe2hKzldUgK+dA0ZXizLjKE93Vk3bbfjAaSpuTqNC92jy3vWUq2PKbZ
         2vKrY3PkBeUj/x/NzrWF7DnyAhRqmqt9quCDaT8er6DcovxPVfEHIPgcyNcCevvA50kz
         o2BxMhSb31fEyasfVjGcQVHWtdp02d0efQyz2ZJpYdl27+GS2Fv7Gb1imQNdqd/DJmQw
         ERKeAh6zWEaoaNVVZIL0U6TkUmIjkcqc8PEENutfk9czYxFcjTWDHboHdl1oDherNnJE
         H1ag==
X-Gm-Message-State: AJIora+SwqNiRiTkNayTrVV18ZAkkvoghTu+5uNtqItxFlTzfa3/eSg5
        tZeEQKGBAOMpYciac4lcPcDJeAR+kbWju4Y5CvDBBOMM2Gg=
X-Google-Smtp-Source: AGRyM1sIsrU5t/kDzGqjhjwXf5V2XdSQGvDEXNYW3qCxMukoTnYttGC5kVEIC7oBmwozrqRo4tGMeVQEsR7meD+KFHg=
X-Received: by 2002:a05:620a:1a9b:b0:6a6:d3f6:5c97 with SMTP id
 bl27-20020a05620a1a9b00b006a6d3f65c97mr200777qkb.225.1658491099398; Fri, 22
 Jul 2022 04:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <87o7xmsjcv.fsf@esperi.org.uk> <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
 <87bktjpyna.fsf@esperi.org.uk> <2a0119a2-814f-d61b-cf82-b446c453e6dc@youngman.org.uk>
 <875yjpo56x.fsf@esperi.org.uk>
In-Reply-To: <875yjpo56x.fsf@esperi.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 22 Jul 2022 06:58:09 -0500
Message-ID: <CAAMCDect7m24tQaDZ7dqv+En2LveaLfOtTgYNJu5G1jtzVmbUg@mail.gmail.com>
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
To:     Nix <nix@esperi.org.uk>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

if you find the partitions missing if you initrd has kpartx on it that
will create the mappings.

  kpartx -av <device>

If something is not creating the partitions a workaround might be
simply to add that command in before the commands that bring up the
array.

There did seem to be a lot of changes that did change how partitions
were handled.  Probably some sort of unexpected side-effect.

I wonder if it is some sort of module loading order issue and/or
build-in vs module for one or more of the critical drives in the
chain.


On Fri, Jul 22, 2022 at 5:11 AM Nix <nix@esperi.org.uk> wrote:
>
> On 20 Jul 2022, Wols Lists outgrape:
>
> > On 20/07/2022 16:55, Nix wrote:
> >> [    9.833720] md: md126 stopped.
> >> [    9.847327] md/raid:md126: device sda4 operational as raid disk 0
> >> [    9.857837] md/raid:md126: device sdf4 operational as raid disk 4
> >> [    9.868167] md/raid:md126: device sdd4 operational as raid disk 3
> >> [    9.878245] md/raid:md126: device sdc4 operational as raid disk 2
> >> [    9.887941] md/raid:md126: device sdb4 operational as raid disk 1
> >> [    9.897551] md/raid:md126: raid level 6 active with 5 out of 5 devices, algorithm 2
> >> [    9.925899] md126: detected capacity change from 0 to 14520041472
> >
> > Hmm.
> >
> > Most of that looks perfectly normal to me. The only oddity, to my eyes, is that md126 is stopped before the disks become
> > operational. That could be perfectly okay, it could be down to a bug, whatever whatever.
>
> Yeah this is the *working* boot. I can't easily get logs of the
> non-working one because, well, no writable filesystems and most of the
> interesting stuff scrolls straight off the screen anyway. (It's mostly
> for comparison with the non-working boot once I manage to capture that.
> Somehow. A high-speed camera on video mode and hand-transcribing? Uggh.)
>
> --
> NULL && (void)
