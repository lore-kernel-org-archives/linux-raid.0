Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F61AC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 29 Mar 2022 01:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiC2B5h (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiC2B5f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Mar 2022 21:57:35 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1210922474A
        for <linux-raid@vger.kernel.org>; Mon, 28 Mar 2022 18:55:53 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h1so19048204edj.1
        for <linux-raid@vger.kernel.org>; Mon, 28 Mar 2022 18:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0FV4eBwx+QHI39AOuL2mfG7ZijKdOkKfoJ+Pao0UNvM=;
        b=l9PeLfj4bGKv7NOa5HE+pLlRRacebtMVhI+nPDdl2XFQQKBp+6WBTVbwWLBDRr0w77
         FXoTZkrbVvBGx0jg7nJueehcKWMajHSFdPxqf2KRIWpEX+CstjEnkjXv12UjwGXZYsvx
         Pjv3eHB1j0GqpZa/81u+JNcV9R4qo/lCq2M/nQsJQInx/2CIEkCIIE4/kpgr4OfetMqH
         cJI4CaohEX/qCk8M4xKi+mLg2mHiPbFJisTQ4/BP4Sf2dEpz95imjlKy+6REdcL7lJVn
         vWm60DaJxQmWVkiYCzH9R1dNgllf0LH+EhggffcfsPXk9TRJWLGpDW0M0kTOp9uurScO
         s+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FV4eBwx+QHI39AOuL2mfG7ZijKdOkKfoJ+Pao0UNvM=;
        b=zpBBIGjlUkg97WgyWyYCzezc4koW22thoUPTeMQRQ14Z3pXTjPnMtXBzVehhADLAsa
         8TtDUTGoJ7Aecl2s7YEdcfTey1GxQ0uWDXYYt6s/AHaghuMfZC/K2BhKfzivHd8sYOSS
         cGOt3uhYFgHgBHiYAobGGg7ZAzkIJztNT9rbrSjiNiNTZNonUoF3kj2BIgGGHEgFVWXN
         ijYMpHfIjrYIZawgoF6rTmRf8eVlu5mWF9G5JKjWTfuLTVvoeBj+ykZPdZig7vo4LCIH
         XbVK4G8dyJNBeT7eOR6UA/cnhAkBbVfRZ/zpvjoC7o9FL3y+1B13iZomb1zFjIwWDwoW
         qysw==
X-Gm-Message-State: AOAM531qOeJIJPsn7McTQOu1aHbsfApYVw9s5hHtBMkg2/XIB34iH3BQ
        egAQtAXOG6tqzo2RdJnhl9ikO3F+TaDo/coU8pN46lsU
X-Google-Smtp-Source: ABdhPJy9m+/TwPFIR3ltNSwRxj5aO+yG08ZYvUCWSVOZBaZrty97d2dpmqYVS/qkqKTHd7jMbi/UNH4y32nXhROwRko=
X-Received: by 2002:aa7:ca5a:0:b0:419:a7fb:23d with SMTP id
 j26-20020aa7ca5a000000b00419a7fb023dmr1239127edt.244.1648518951549; Mon, 28
 Mar 2022 18:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220318030855.GV3131742@merlins.org> <CAC6SzHKFga59KpzhRhE-sz3K5z+=LUXfyxSB14KaOj7DCxCj-Q@mail.gmail.com>
 <20220328020512.GP4113@merlins.org> <CAJCQCtQyqG_zWhRVXjnc3Prc+J-7hK1hyp28mwyuKWWPJ8Uo5A@mail.gmail.com>
In-Reply-To: <CAJCQCtQyqG_zWhRVXjnc3Prc+J-7hK1hyp28mwyuKWWPJ8Uo5A@mail.gmail.com>
From:   d tbsky <tbskyd@gmail.com>
Date:   Tue, 29 Mar 2022 09:55:40 +0800
Message-ID: <CAC6SzHL9Vy2Tz_rVFRphTuAjwPNXg59WAuY8JCXXQ94W09y4sw@mail.gmail.com>
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Marc MERLIN <marc@merlins.org>,
        list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Chris Murphy <lists@colorremedies.com>
> None of my SATA-USB enclosures behave this way. But what it does do is
> mask (lie) the true physical sector size, claiming it's 512 bytes
> instead of 4096 bytes.

normal sata-usb should be ok. seagate/toshiba sata-usb will eat
sectors. some gigabyte dual-bios motherboards will eat sectors (with
disk HPA function).
In the early days different vendors made different capacity harddisks.
But at some moment, maybe 250GB or 500GB, suddenly every vendor made
the same capacity harddisks. It's a mystery to me. who decides the
disk sector numbers? why 2TB disk capacity is not double 1TB, 8TB not
double 4TB? capacity is different for sd-card and ssd, but harddisk
capacity seems normalized at some time.
