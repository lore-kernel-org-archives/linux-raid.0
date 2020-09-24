Return-Path: <SRS0=HtB1=DB=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A188C4346E
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 03:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8CB02388A
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 03:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600918000;
	bh=17cSOhZAOjq0y9Mym8O2mP/ldgw8rBNS9LJzP0S/8+Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=aNXOkdR+qDfebtphw44tMLtvHYnaq+QaBEOD/PfmIey2D9o7jDz0nXAWYIncb9UHO
	 FYAIAgcZYmYFU8Hlt3fwMOEwDOWEKphloPDUZdU74NTyp6oDU2KfYOFuiuLUS3HJsc
	 rm0Ms7gdvpALggKygMAPd5wt75MDo7QZxH8+lKpc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgIXD0j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Sep 2020 23:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgIXD0j (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 23 Sep 2020 23:26:39 -0400
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4152C2388A
        for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2020 03:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600917998;
        bh=17cSOhZAOjq0y9Mym8O2mP/ldgw8rBNS9LJzP0S/8+Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DHvec2lO+4FiMLhauIqLGs9+XDm1sl+GeTWp4enjJJPJC4qrPt+oj51HZhrxkedps
         v+b4O8r18nFPvvl0I6di9evj6bthqDISUZ+U89BngM7+huAtWQPizexgtx3pqCYBHA
         WJpoH3bfHi1UTxsTbDlgPQYG27nPeBXNexbWyIFc=
Received: by mail-lj1-f180.google.com with SMTP id s205so1432877lja.7
        for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2020 20:26:38 -0700 (PDT)
X-Gm-Message-State: AOAM532A/L+Ay5B2tIQj8REMl6XX1CHrQ3cSrl5PVQFe4J585QkOxaCq
        iIfFZYVB+5e72XAPeAu11tYi/1mYCuTktGAXVwM=
X-Google-Smtp-Source: ABdhPJwonLj8KOTPKJuYnZloZ9msutvAKTdfJ2RFVG8+BHHgVRzD1THHi45mT+piW6xULyC4PjCsiOQodnZt0RmldU4=
X-Received: by 2002:a2e:b0d6:: with SMTP id g22mr815075ljl.350.1600917996604;
 Wed, 23 Sep 2020 20:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <1600754282-3982-1-git-send-email-xni@redhat.com>
In-Reply-To: <1600754282-3982-1-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 23 Sep 2020 20:26:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6x6C4P7jsUz8hAS-foTz_u1Zv7M4JLp+PS7cO0-FiDLw@mail.gmail.com>
Message-ID: <CAPhsuW6x6C4P7jsUz8hAS-foTz_u1Zv7M4JLp+PS7cO0-FiDLw@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: Change the return type of
 raid10_handle_discard to int
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        kbuild test robot <lkp@intel.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 21, 2020 at 10:58 PM Xiao Ni <xni@redhat.com> wrote:
>
> Now the return type of raid10_handle_discard is bool. This is wrong.
> Change the return type to int.
>
> Reported-by: kernel test robot <lkp@intel.com>
> fixes: 8f694215ae4c (md/raid10: improve raid10 discard request)
> Signed-off-by: Xiao Ni <xni@redhat.com>

Applied to md-next. Thanks for the fix!
