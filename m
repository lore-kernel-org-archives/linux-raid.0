Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52347C64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 08:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjCCIwR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 03:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCCIwQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 03:52:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905644E5FE
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 00:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677833490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ygl23er0UDQlPMwv+4NA+1c1Ld1E0uoRapwxOwJTFn4=;
        b=gtMmU0HD+R46Tq46GFkdeu6eRked5qh0cEJPLGFDhPFDTmTwMdcPSh7Z1zcdke+D20UXD8
        nJxkkolzIlAUXAA/NhAY2lTBnFSeTAFXVaRPXLRYjXBYyOiENIcTgTf9qosMgst87+5Y3R
        5jLUAupwscDLmLhOcn6f0GJv3MPUfC4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-jjHcBweoPNmYtTsMwiTZ5A-1; Fri, 03 Mar 2023 03:51:26 -0500
X-MC-Unique: jjHcBweoPNmYtTsMwiTZ5A-1
Received: by mail-pg1-f200.google.com with SMTP id s21-20020a632155000000b004fc1f5c8a4dso584991pgm.11
        for <linux-raid@vger.kernel.org>; Fri, 03 Mar 2023 00:51:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677833486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ygl23er0UDQlPMwv+4NA+1c1Ld1E0uoRapwxOwJTFn4=;
        b=HPFgovXJhDc6swHemKJlAFHGO9YIm00UhJTyEeuiBq22BgQwEQoq2qvXbi6qiraXzT
         VYgzokoPTrliQDxKacepIyhc2wEETw/JJrV33ONQKxaAzvV6VfOf7x6ppywJGH3+qgMZ
         hjFDiHiHmqLPV6Ci87onNUZKXt2MQyS4J2wAv7PaVoyTGD6Z9Zxtf8RPBZTLLZw1KxSY
         vHZiCTEKBI9LKCfdBnJ7cdR9AZ0FxjFayY6YJfBftYl/7eO5xT95ABQPOBku/D7H6lHL
         Qt/9XzJFP42CXptWs8BBQSIT5QSYr1YyD44ptUz8GbNBfrGBkuRz3fXVNykGboC7CIQo
         +Tdw==
X-Gm-Message-State: AO0yUKUD/pDKQB1KAI/R0x/e780XnmxglHjugJijKjZEzg1w372RcZNd
        CpZjHAXz9T2H5+LEQ84fjJL1Ly+5KRIZTs45WS0pWldyvOzvYdGHcoTRJdH3AiiZ9M3izZFG12b
        1SvRadZfZWrDLxBz3Di2ZzuWNDc9ESqT6ARxHlg==
X-Received: by 2002:a17:90a:bb8d:b0:234:b23:eade with SMTP id v13-20020a17090abb8d00b002340b23eademr298648pjr.9.1677833485949;
        Fri, 03 Mar 2023 00:51:25 -0800 (PST)
X-Google-Smtp-Source: AK7set/clTNL9t3RBSYlBYXclm4rQ7I44QJSdQM32XbSm8+qDeECH9GzVPO1css0VVs7MzhGy4XeljVOk3DnN1HN36k=
X-Received: by 2002:a17:90a:bb8d:b0:234:b23:eade with SMTP id
 v13-20020a17090abb8d00b002340b23eademr298641pjr.9.1677833485672; Fri, 03 Mar
 2023 00:51:25 -0800 (PST)
MIME-Version: 1.0
References: <CALTww28pEdW+f1SaXrG7Umf8uA6fAc9io-WKb_W8mVxEzW8EzA@mail.gmail.com>
 <ZAFhRj8YVpiO3b5g@T590>
In-Reply-To: <ZAFhRj8YVpiO3b5g@T590>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 3 Mar 2023 16:51:14 +0800
Message-ID: <CALTww28i3W6dsGAmgYgGKSpJMMA_ci-hZs_EERr+1BBiyE-vsw@mail.gmail.com>
Subject: Re: The gendisk of raid can't be released
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org, Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Mar 3, 2023 at 10:54=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Thu, Mar 02, 2023 at 11:51:59PM +0800, Xiao Ni wrote:
> > Hi Christoph
> >
> > There is a regression problem which is introduced by 84d7d462b16d
> > (blk-cgroup: pin the gendisk in struct blkcg_gq).
>
> The above commit has been reverted, can you test the latest linus tree?
>
>
> Thanks,
> Ming
>

Thanks for the information. I have tried with the latest linux-next version=
. The
problem doesn't appear anymore.

Best regards
Xiao

