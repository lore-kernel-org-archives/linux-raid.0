Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44549E75459
	for <linux-raid@archiver.kernel.org>; Tue,  3 Oct 2023 18:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjJCSvd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Oct 2023 14:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbjJCSvc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Oct 2023 14:51:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98840AF
        for <linux-raid@vger.kernel.org>; Tue,  3 Oct 2023 11:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696359050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G8XUu6aRdldwM3niWRJ9adLaHhEHcAYSLoT3+whcI0g=;
        b=SRuav9M7jioBZ8zb9L98zQPfT1XBlHt6BXwWbcM1DnqlwWR0o4OR8+GpYOfZaIlBFqbGns
        i07g0ZHlrIhVPPSjTyqFwg+n3Oa2kqXIToUpt6Mh31zP45Q68s653+P5jysOglATDWgyF5
        0gNs1hc2++dqRtc6hFM2lzAYmW3yQR0=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-WSWqb86_PQ2pYF-Z88XpKw-1; Tue, 03 Oct 2023 14:50:49 -0400
X-MC-Unique: WSWqb86_PQ2pYF-Z88XpKw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-503343a850aso1135443e87.3
        for <linux-raid@vger.kernel.org>; Tue, 03 Oct 2023 11:50:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696359048; x=1696963848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G8XUu6aRdldwM3niWRJ9adLaHhEHcAYSLoT3+whcI0g=;
        b=QcPNpSjuP2oqKJKjfeARsS5KybIs2USKU5VFrzoAjXe7+3D89/SFdJIqLatQDOB/NQ
         f499KjC0VJ53F/k4/xD9hKaF76zh8kjPtqDjk0Hl83yiHruDJJODjZ7lJBx9+HxPT2dQ
         /Pb42RGFAVA0SNB5Z7rC9GIplBR1HMRZ1XBY5jFLsf8mS1fImqjJJsgktHEoDPlbDhJF
         j3VM2yGo/rzfP5MEtPqktDiFljbBaT3HH2iYV2D26RNI1F5g8R7AZw5lBw7aacMr2vwJ
         JgOo8brG1r37ExT9XT6l6FQO3p6cN2VOgFeJyLDtoc96m9Gh7U8N3ulUsa1DlleCfsbS
         qvdQ==
X-Gm-Message-State: AOJu0Yz5GSB9zO9AuwpMREq4TCqRHpWIUb+rFf59x5EGcYNbZswzSz1y
        MrQXMMGe5+29pvlC8SIvPJ168HR7wo/mEGZTkTdgLyOq2emyS60bewgUz/3G9HHmCZCiaKl0EM5
        1K9k4DcqC+ry39beBfOh2OIJxPoFy6miV5+wsiQ==
X-Received: by 2002:ac2:5f49:0:b0:4f9:5426:6622 with SMTP id 9-20020ac25f49000000b004f954266622mr40544lfz.69.1696359048202;
        Tue, 03 Oct 2023 11:50:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDB9HeKbYmgVFG8Oj+lFP0iFcUH4Whr52vZlJQgKZsdqSMadCFdn1mdUkLK2iuLT9rsqNyEkBvR0vIqtC6Ny4=
X-Received: by 2002:ac2:5f49:0:b0:4f9:5426:6622 with SMTP id
 9-20020ac25f49000000b004f954266622mr40538lfz.69.1696359047853; Tue, 03 Oct
 2023 11:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20231002183422.13047-1-djeffery@redhat.com> <CA+RJvhxrkSXRPc9wELyfYYCy_dpRaa+9=fTY7NQR0tP=MO8xUQ@mail.gmail.com>
 <CAPhsuW6iSTRGFDfbP_nQR5eeKWEY=begDZ_H8QgK+tqhKaqELw@mail.gmail.com>
In-Reply-To: <CAPhsuW6iSTRGFDfbP_nQR5eeKWEY=begDZ_H8QgK+tqhKaqELw@mail.gmail.com>
From:   David Jeffery <djeffery@redhat.com>
Date:   Tue, 3 Oct 2023 14:50:36 -0400
Message-ID: <CA+-xHTH+59y5iqkVSTA=0fRK4RgPYp=Bm10rcbH0_fk6NZQ+TQ@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: release batch_last before waiting for another stripe_head
To:     Song Liu <song@kernel.org>
Cc:     John Pittman <jpittman@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid@vger.kernel.org, Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Oct 3, 2023 at 2:48=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> Thanks for the fix! I applied it to md-fixes.
>
> Question: How easy/difficult is it to reproduce this issue?
>

Hello,

One customer system could trigger it reliably and confirmed the fix,
but I haven't had any success recreating it with synthetic workloads
on a test system.

David Jeffery

