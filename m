Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3A1C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jan 2022 18:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiAES7t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jan 2022 13:59:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41200 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243264AbiAES7l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jan 2022 13:59:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1E17B81D46
        for <linux-raid@vger.kernel.org>; Wed,  5 Jan 2022 18:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC30C36AE9
        for <linux-raid@vger.kernel.org>; Wed,  5 Jan 2022 18:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641409179;
        bh=yUxAJZKQjIJaov4VQGfZDmDLqP52zCRxquOKUb648hM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AY1miSERySPt8WVYLWD/m/A77zqY7jqtmn0GqXqyOy+GJG+weDHZjJ7gs+T8AJGDG
         zGOnMlK2uZ1fR5JKhY8MfpNoq87vmRZF7zcISeQ9pDx2E2HBDkBfEywYxMBsTFuISz
         x+Ua6/5zg6/wBrnf3uKzi8sQfOVvmdXFe1g+as5ffg2Lklevb87kA6eml9HXnMUkUi
         nbxC0awdfVfsJVysMAdYC7nNyeEtmLO22Dv0m6OlzXhUTvo5FM4bT78H0fmJgCJW0/
         Ew1OMz+nLUMa8VzabEr8FIZOpmmRUPA0CBJXcrHGrmZkMysI0dHPtJdSLUzmlmLOug
         QBuLnH88rUz8A==
Received: by mail-yb1-f169.google.com with SMTP id p15so559059ybk.10
        for <linux-raid@vger.kernel.org>; Wed, 05 Jan 2022 10:59:39 -0800 (PST)
X-Gm-Message-State: AOAM530uBzVjwajWCFY5s7n8+lH1IfiIEA6y/YgZN9BT3agt75lZYGO5
        CiWHFqsE1ptg0bAhEhWLOM9oplP6ioShRAoe0ZI=
X-Google-Smtp-Source: ABdhPJyz3789szJMMAGhBLl7s4mbRCBWeoq1R69nq2AfdYqxvkR48tkvtYWekre9yPkgTTwH1WQBerlsaAr/AGSQNsE=
X-Received: by 2002:a25:8690:: with SMTP id z16mr19253757ybk.282.1641409178636;
 Wed, 05 Jan 2022 10:59:38 -0800 (PST)
MIME-Version: 1.0
References: <20211210093116.7847-1-xni@redhat.com> <6bb93ce0-30e0-ff3b-9457-470496f7b1bc@redhat.com>
In-Reply-To: <6bb93ce0-30e0-ff3b-9457-470496f7b1bc@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 5 Jan 2022 10:59:27 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4wmHMyG-DjR+SO5rweU70iqm903z9X3Pkxhpb8GzHFzg@mail.gmail.com>
Message-ID: <CAPhsuW4wmHMyG-DjR+SO5rweU70iqm903z9X3Pkxhpb8GzHFzg@mail.gmail.com>
Subject: Re: [PATCH 0/2] md: it panice after reshape from raid1 to raid5
To:     Xiao Ni <xni@redhat.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jan 4, 2022 at 3:30 PM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Song
>
> Ping. Do I still change something else?

I merged the two patches into one, rewrote the commit log, added
Guoqing's Acked-by, and applied it to md-next.

For future patches, please write the commit log according to the
guidance in Documentation/process/submitting-patches.rst.

Thanks,
Song
