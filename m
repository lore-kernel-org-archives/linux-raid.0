Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45D7C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jan 2021 00:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B88A22EBF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jan 2021 00:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbhASAKN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jan 2021 19:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731557AbhASAKM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jan 2021 19:10:12 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E2FC061573
        for <linux-raid@vger.kernel.org>; Mon, 18 Jan 2021 16:09:32 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id w1so26010437ejf.11
        for <linux-raid@vger.kernel.org>; Mon, 18 Jan 2021 16:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zj6lj1EKV9y6gbJRNSl9V+sGUbC+pZyrp8aqvNYhh+U=;
        b=kzNFUkCK/5h99B56JKZQg+3bh+cHHObu4J0g+Dvq6MBaCmtxBw8zPVgdhEP8995ZyU
         iZ75ie+eMEJ0knrHmzHqk0rmHREL3gSE8TuBVK7zPKczto3IVO+E4UXI2tYwmLNuthqb
         J4eWuQ8mSGA9LGNC4jpgwhyT+fbg/XBPaEvbXC6v0qQQnPxGaS/VkiZ81p/0KFWO1IxG
         vTg7t7+Jk4Pmx0cN4H4VRTcK/XhYvkg+BHMhBbJvB5334+ZjjhGRYkLbz1PgWc183609
         2BMYAsBEx6GdNjG7A4GHs9+pNC9zY9TLmZgcOTzieqJDGmYFKq8d62Z+LH1daU/NIj+i
         6D6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zj6lj1EKV9y6gbJRNSl9V+sGUbC+pZyrp8aqvNYhh+U=;
        b=YxCLkV2s+D1XN0PqR2gL30g+8y8j334yqIPrhsHvdKXGxEozo0pkAw3pxDxhlwePLz
         nolAK4mYc3kzrRb/EoQADDKURPRS5Evv5ziYsR3Ga035vEGaKgsYpebT1/0PWYiOK7KB
         iidVh0uB5FyajaPT2pTb7PXddXIgmptrZ8JJOZtyyZAN8Rxv8wvhIiwu4uSz71+iNLt4
         bILde0xRB4xDjEXz6oO2QHAb8aD+lh2/XpWQAa69QUVrXU9QjliThY3wwxXy+OsL/o1v
         MeUoFIj/T/pzYy3L6qXgZ2hvhgT/qj1X0BxiW+kSyRpz5z3wb/8CzyUh9O9cP4OQFnZb
         IEkw==
X-Gm-Message-State: AOAM530qQJNgpKTNJsvDJSOHXAVb/NDenpfMpeIRogB6qudRnS+Tpnsl
        72YNYj9YnQRNq+HiPo5gggMp5hSPWhSRbtliTzwpMRRzUcA=
X-Google-Smtp-Source: ABdhPJw/bgcuGa7kqOxFyTDU1pld6YHSDGx1kNnU5YlOxQoR/ZhhDett2thu2XDJMyoWIErYtmJYP3E84hPwrKNDE/c=
X-Received: by 2002:a17:906:9345:: with SMTP id p5mr1314061ejw.40.1611014971002;
 Mon, 18 Jan 2021 16:09:31 -0800 (PST)
MIME-Version: 1.0
References: <CAHikZs7DaOj4QAw0VcbidmdrP11pWE-NTcxXDJS=KW9rf0TY7Q@mail.gmail.com>
 <87eeijjcgo.fsf@notabene.neil.brown.name> <CAHikZs7EKe2H5OYdxd5dwZ8WCs8fdVp-5BWku0vQ5Bb-yCstCw@mail.gmail.com>
 <8735yxkh30.fsf@notabene.neil.brown.name>
In-Reply-To: <8735yxkh30.fsf@notabene.neil.brown.name>
From:   Nathan Brown <nbrown.us@gmail.com>
Date:   Mon, 18 Jan 2021 18:09:19 -0600
Message-ID: <CAHikZs4uOs7RZs038vkw7ryEEK31e-rq7M8Xu7B0cGDa7fiK4A@mail.gmail.com>
Subject: Re: Self inflicted reshape catastrophe
To:     NeilBrown <neil@brown.name>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> That command wouldn't have the effect you describe (and is visible in
> the --examine output - thanks).
>
> Maybe you mean "--add" ???

I feel like I did `--assemble` but it is entirely possible I am not
remembering correctly and did an `--add`. It may be worth testing both
scenarios to see if `mdadm` could stop people like me from shooting
themselves in the foot. To be clear I am not placing any blame on
`mdadm` for my stupid mistakes.

> To reconstruct the correct metadata, the easiest approach is probably to
> copy the superblock from the best drive in md0 and use a binary-editor
> to change the 'Device Role' field to an appropriate number for each
> different device.  Maybe your kernel logs will have enough info to
> confirm which device was in each role.

I checked all my logs and all I can see is the start of the reshape
with no indication of what is changing.

Jan 14 00:20:46 nas2 kernel: md: reshape of RAID array md0

> One approach to copying the metadata is to use "mdadm --dump=/tmp/md0 /dev/md0"
> which should create sparse files in /tmp/md0 with the metadata from each
> device.
> Then binary-edit those files, and rename them. Then use
>    mdadm --restore=/tmp/md0 /dev/md0
> to copy the metadata back.  Maybe.
>
> Then use "mdadm --examine --super=1.2" to check that the superblock
> looks OK and to find out what the "expected" checksum is.  Then edit the
> superblock again to set the checksum.
>
> Then try assembling the array with
>    mdadm --assemble --freeze-reshape --readonly ....
>
> which should minimize the damage that can be done if something isn't
> right.
> Then try "fsck -n" the filesystem to see if it looks OK.

Since I do not know the disk order I'll work up a script to use
overlays and craft these super blocks in each permutation with `fsck`
checks to see which one gets me the most data back.

I truly appreciate the help, thank you very much. I'll let you all
know how it goes :)
