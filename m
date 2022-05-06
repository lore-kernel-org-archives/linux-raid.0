Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325C0C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  6 May 2022 13:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392555AbiEFN3p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 May 2022 09:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392579AbiEFN24 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 May 2022 09:28:56 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FD96972A
        for <linux-raid@vger.kernel.org>; Fri,  6 May 2022 06:25:13 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e2so10029610wrh.7
        for <linux-raid@vger.kernel.org>; Fri, 06 May 2022 06:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jstephenson-me.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1nn/3QuunglSuisRHCXoRcimuNk78QfjZy4PhkR/3JI=;
        b=g09pK3bNh8U3JUwKGkWyD/7f7vljV+xKsJFA2jEB6vVn7KQUoI2FdiFYa6bn6M7DbI
         FzT8FtQgdZxn1WB5Y7E3jY3pj6GE89z687IoBaC3LHd1E8sMP677H/7XOwU88tVzgcOb
         fCGB1GcE+aoM0Q+HhbhsOcypxYeyybidO7d//Gk/X9DMDUhFlfft9+ECXGYliGIDAT2d
         eo/YWqiUXW0phVFuRfwx1QrED4LR3XtiOWItsRoPDsFcBBncm38plQxoQ4YnzWgs6D4A
         PDMgoIz+k1Ww49vhO1Tr0m4f9cjdTX8GgDbSRhKsYfnfdE8Fw/Bxw+kzDHyr1pTvQ/Ym
         F2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1nn/3QuunglSuisRHCXoRcimuNk78QfjZy4PhkR/3JI=;
        b=7zsC89k4969Kjp5H55RuGQxsVdyZ0Rub2f3sAWWDepj3wGsZmm/qsXX4MdIrs/hz6i
         0tu3qe0RIhCC9q+wsIcHggAo44Z9aVGnE+Q0vHJaJCoyqUySfqoRLOe40iWXtgcBFeCs
         PNGE1ezG6ip0+RIyzww9Ohc1i8Vg4XcK2iMss/ngv4nEskgzf4Nzl8vNGHiJKiu8lrl5
         9+Dp7O9vYdao1ogrrMe5qfkAYkTa5NxoCEYM9mpJ9H3VTgXsGgMGqmqMbLxAmE8iSaBb
         Bs2Hu1NXKHaBKQkqo8Qe5O7kSsfbAScznSYgigoPWNe2TjEmL2l2Qg5J1OOrscIA2Ff1
         Vb6w==
X-Gm-Message-State: AOAM531i4Jkt0F2BbsjqfVnJg8I1TxFA7/6VZd6eSDammgZogSMgoO+g
        PldRaVAYICuyI92sxDyUF8VsVcYbPjlsUpyyJzxKuR+dkiKHvg==
X-Google-Smtp-Source: ABdhPJzkr0pj5DClGE3Drb/9c7JyBX+HsNV9A6kepibqeIC3Up55/Q28/DniDSElZBhKa/qLs+06k/k3gBsze+rri6o=
X-Received: by 2002:adf:eb82:0:b0:20c:a2eb:5fe6 with SMTP id
 t2-20020adfeb82000000b0020ca2eb5fe6mr2719054wrn.563.1651843511618; Fri, 06
 May 2022 06:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <CA+an+MoM_Vb4Z3FSRcTo+ykmFTW5cwh1CQWCN9BMT45CdW_P0g@mail.gmail.com>
 <26c0f640-8801-240c-ce2c-99246b09f2e2@linux.dev> <CA+an+Mq8S8hNnbQP3uJCHU_yw_5Fbr+cvWjfmiL9Sa2n-cEpvA@mail.gmail.com>
 <d51fc202-337f-382d-f82c-6a97c9e09736@linux.dev>
In-Reply-To: <d51fc202-337f-382d-f82c-6a97c9e09736@linux.dev>
From:   James Stephenson <inbox@jstephenson.me>
Date:   Fri, 6 May 2022 14:25:00 +0100
Message-ID: <CA+an+Mq_=nCtLCMpoms8xdXdVsaSAmB7B9q+ZBdEhNKxnjPDyQ@mail.gmail.com>
Subject: Re: Unable to add journal device to RAID 6 array
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks for your reply. The bitmap state there was because the array
was active at the time.

I've found the issue however: it turns out that a previous 'check'
must have been interrupted by power loss or similar, and so the array
still had memory of this in some way (perhaps I could have seen this
state in the sysfs tree somewhere?). After reading the comment in
https://elixir.bootlin.com/linux/v5.10.106/source/drivers/md/md.h#L348
I thought I'd try a 'check' followed by an 'idle', and indeed after
that I was able to successfully remove the bitmap and add a journal
device :)!

Thanks,

James

On Fri, 6 May 2022 at 13:05, Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 5/6/22 7:55 PM, James Stephenson wrote:
> > Thank you for your reply. I did check the source and found the same
> > block, however I=E2=80=99m not familiar enough to understand where I wo=
uld see
> > this condition indicated?
> >
> > As of now the array seems perfectly normal:
> > https://gist.github.com/jstephenson/0b615aab33bb8157a3876471ef50424e
>
> Seems the bitmap is not clean, so resync thread might be running.
>
> bitmap: 3/88 pages [12KB], 65536KB chunk
>
> I suppose you can find relevant threads with "ps aux | grep md126", and a=
lso
> the output of "cat /proc/mdstat" could be helpful.
>
> Thanks,
> Guoqing
