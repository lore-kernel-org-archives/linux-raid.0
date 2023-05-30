Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FD2C77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 23:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbjE3XAz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 19:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjE3XAy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 19:00:54 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB05E8
        for <linux-raid@vger.kernel.org>; Tue, 30 May 2023 16:00:52 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b024e29657so27772295ad.3
        for <linux-raid@vger.kernel.org>; Tue, 30 May 2023 16:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1685487651; x=1688079651;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rJiLW7AmmQnpv9DEnjN9p5/4mIGo+5HG0C4i82Hita4=;
        b=dxiJXImoRvtMCanp9c/ceTZ8qTmSPzD9b1rkVpo2uNvegmRaKNTVAVmuuWbCmnqbZk
         LO6bFjayl63AyoqRb11VMuyfiv45TChQjVsuP5zqr3dkHUYMwJRPzRkIqo4njsP3bcSV
         LjrzWPAs6kMkf5eHTc1VLqHWDu3hatO7OD3Jo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685487651; x=1688079651;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rJiLW7AmmQnpv9DEnjN9p5/4mIGo+5HG0C4i82Hita4=;
        b=OkK8dVYWw4BbrJwrz+h3OX+bn9z26pO1/pLfIC7H/4+7HdntnFw+8nlWQfZJ6uks7s
         1CZM7TndzYSZMJPvSK8oyOe+KVfJV9mxn7R+BjhZKzteypPBH7PMDAqiRT8m6Yd/SDcT
         Iv5WJ0a8eblXH4qbCK+kquPRnDnMdY7xT8Vye0AhZkQCwpo0xxsiWuY3XFXKkaBzmlWt
         GKfYCRQIPkPocc55R9HGwRUrToVn3/GpBimQmHhmiF+lAGeuEkFHJXpKPg7VtQvabSDw
         rPRBLdrLG1WmimZGooP/70gHVrv/nygWYt7Mv+B2JElP9hoDs7ZtqxTt8IdT00wNOfHv
         5yHg==
X-Gm-Message-State: AC+VfDydr3fRZw2b98ucmy2v9qhjReyZ78qQvHQPcd6bJm+opkKsFj6H
        giSqzGPzNCBGalrX/+Li/UbdIw==
X-Google-Smtp-Source: ACHHUZ67LwwGjf/CO2NXgUokK7LdElpmLqHmamM5N0opD0v/5UjtIAhbIW+nDOEd3A//mwLET8bStQ==
X-Received: by 2002:a17:902:e809:b0:1a5:22a:165c with SMTP id u9-20020a170902e80900b001a5022a165cmr3877787plg.0.1685487651583;
        Tue, 30 May 2023 16:00:51 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ik24-20020a170902ab1800b001b0142908f7sm8886130plb.291.2023.05.30.16.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 16:00:50 -0700 (PDT)
Date:   Tue, 30 May 2023 16:00:50 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] md/raid5: Convert stripe_head's "dev" to flexible
 array member
Message-ID: <202305301600.EEF0BAAD@keescook>
References: <20230522212114.gonna.589-kees@kernel.org>
 <CAPhsuW5ibONdyyJq0zVCEHuM38GUocn8A1abi4mTa9gUHH1hHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW5ibONdyyJq0zVCEHuM38GUocn8A1abi4mTa9gUHH1hHQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 23, 2023 at 10:43:52AM -0700, Song Liu wrote:
> On Mon, May 22, 2023 at 2:21 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > Replace old-style 1-element array of "dev" in struct stripe_head with
> > modern C99 flexible array. In the future, we can additionally annotate
> > it with the run-time size, found in the "disks" member.
> >
> > Cc: Christoph Hellwig <hch@infradead.org>
> > Cc: linux-raid@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > It looks like this memory calculation:
> >
> >         memory = conf->min_nr_stripes * (sizeof(struct stripe_head) +
> >                  max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
> >
> > ... was already buggy (i.e. it included the single "dev" bytes in the
> > result). However, I'm not entirely sure if that is the right analysis,
> > since "dev" is not related to struct bio nor PAGE_SIZE?
> >
> > v1: https://lore.kernel.org/all/20230517233313.never.130-kees@kernel.org/
> > v2: use new struct_size_t() helper from
> >     https://lore.kernel.org/lkml/20230522211810.never.421-kees@kernel.org/
> 
> LTGM. Thanks!

Thanks!

> I will hold this for a while until struct_size_t() merged.

Since my tree will introduce struct_size_t(), I will just carry it
there.

-- 
Kees Cook
