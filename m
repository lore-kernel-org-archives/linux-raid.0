Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899BDC77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 02:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjE3CbM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 22:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjE3CbK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 22:31:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B073FA7
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 19:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685413822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rj5+Ac4WBhFEkwYkStvFh5l9lrzqoYJldxeUvSnyd6k=;
        b=WUu4KQhnV/cGpFkoqAFQtI+L2rMkEqYq0HkRZkyxkXJMg5BUO6ZASYYV1nO2xsMO2T1ly/
        E7El1ByksjcmMsvXpUwh/SRe2VFd/2zpHRv+Wgg4wvheyNkOHu1U/Q6WwSQtIG+B5swm8+
        MkK0OQxvAiw6Qx+FbiGX8lVTzjqk/Kg=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-GHTriD89NP2LXBN7aNfbVA-1; Mon, 29 May 2023 22:30:21 -0400
X-MC-Unique: GHTriD89NP2LXBN7aNfbVA-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-53f6e19f814so1131699a12.3
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 19:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685413820; x=1688005820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rj5+Ac4WBhFEkwYkStvFh5l9lrzqoYJldxeUvSnyd6k=;
        b=ZRPQWYSF2ARFSLu3YQp13MxOdX5G/NezBTQ8ShordJli9H4aFKv8cYdYPMf1L5pA9g
         edy0EmSfiF3qmDyw7xv5MDHKUKH7iF6GOQPW6rrq6a70rOO2i4TfEuh5bz5761ja+fwp
         jZ/47gfR0sJti06GiQeCRSyEvkRkErQ+zZ4mX7jnYN3troa8jXW0FGEwcdvcFXWpqNlm
         oEsXtmdSh01LUYs8/VQ2d8UTYZ7hsnl65ehj/qYajxumQhBGxUt2tWQqR6ex7oUUP+4C
         bng9A9Sfhcr5AnbZscwIefso7oCWhRfx9DvQWyliQ4l6tQcnBU3jIaZBBJI6IC/Ofu/c
         XEEg==
X-Gm-Message-State: AC+VfDzXTDk+lGQb0xRuqA4FEaQeoiLlQlOJ8imnqrhJZa4mBRf3gB5L
        DOLmdup7b/b54GUF3A47vywavR/INMcGmuIb7daVViWY+57l858/pgmAkm4ozOkHsJUeXzyQ2hJ
        34Lj/PFcvHWVaSlInOv2ZHJYOE2VpN2/riaSJFA==
X-Received: by 2002:a17:902:a9c9:b0:1a9:6dfb:4b09 with SMTP id b9-20020a170902a9c900b001a96dfb4b09mr678178plr.67.1685413820420;
        Mon, 29 May 2023 19:30:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5b6JSoG41zCjJALzzUEMmMTm6WOlHIzLXRq0g0NCVyI5J776XPcENLXEQEG5xnTJeWLuPhpWWymuetD6MAnwY=
X-Received: by 2002:a17:902:a9c9:b0:1a9:6dfb:4b09 with SMTP id
 b9-20020a170902a9c900b001a96dfb4b09mr678170plr.67.1685413820210; Mon, 29 May
 2023 19:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev> <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev> <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev> <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
 <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev> <CALTww2_vmryrM1V+Cr8FKj3TRv0qEGjYNzv6nStj=LnM8QKSuw@mail.gmail.com>
 <73b79a2d-95fe-dac0-9afc-8937d723ffdf@linux.dev> <495541d3-3165-6d4b-f662-3690139229e9@huaweicloud.com>
 <CALTww2_wphLSHV6RAOO05gs0QO8H9di-s_yJRm0b=D7JmjjbUg@mail.gmail.com> <d3e3ccdf-3384-b302-7266-8996edee4ca8@linux.dev>
In-Reply-To: <d3e3ccdf-3384-b302-7266-8996edee4ca8@linux.dev>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 30 May 2023 10:30:09 +0800
Message-ID: <CALTww2_7PFmmCk1bGMco3a1cMJTxJtUiOs-i764qp0vnQRZJkw@mail.gmail.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 30, 2023 at 10:23=E2=80=AFAM Guoqing Jiang <guoqing.jiang@linux=
.dev> wrote:
>
>
>
> On 5/30/23 10:11, Xiao Ni wrote:
> >> May I ask if these processes write the same file with same offset? It'=
s
> >> insane if they do... If not, this cound be a problem.
> > They write to different files. One process writes to its own file.
>
> How big is the capacity of your array? I see the script write 100G file
> first, then create
> different files with 3GB size. So you probably need a array with 200G arr=
ay.
>
> ./01-test.sh:dd if=3D/dev/zero of=3D/tmp/pythontest/file1bs=3D1M count=3D=
100000
> status=3Dprogress
>
> Thanks,
> Guoqing
>
>
I used ssd disks and without --size. So the raid is almost 1TB

Regards
Xiao

