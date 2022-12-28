Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F7EC4332F
	for <linux-raid@archiver.kernel.org>; Wed, 28 Dec 2022 08:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiL1INv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Dec 2022 03:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiL1INt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Dec 2022 03:13:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976A4E023
        for <linux-raid@vger.kernel.org>; Wed, 28 Dec 2022 00:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672215186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tiSlI/KQkcq0MsJq8rmpcWYA5eJbp01k9jHB2F7SCU4=;
        b=NKXaPzTd+3rEKBJAudHGEtPwMhVhB9HJOZEJw3Mp28xTqHRKM7cDI7HY/oxsW0EjCxRd0T
        cTr4YsIDuKEGSC3+JQx+KEL7QNFAaiB4WMZnud2Dhfb/R1f+2U1s0+NaiOymULV44YVZRC
        +TZwyk8VBMkGS0LiNlPl05hW6kl2ITc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-r_xWEy0tMzCHKPZ3cNZKVw-1; Wed, 28 Dec 2022 03:13:01 -0500
X-MC-Unique: r_xWEy0tMzCHKPZ3cNZKVw-1
Received: by mail-pj1-f72.google.com with SMTP id v17-20020a17090abb9100b002239a73bc6eso12206494pjr.1
        for <linux-raid@vger.kernel.org>; Wed, 28 Dec 2022 00:13:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tiSlI/KQkcq0MsJq8rmpcWYA5eJbp01k9jHB2F7SCU4=;
        b=vvaCWw2UCAsgaE0q+Z0tGuDGLBS++zlnDIgvD/LsCKQfUpyvbo19QCVhcWZ0j8Afr1
         a/2joK5NwNwBWMQiQa3MKe4OYiaF3nA7AtKp9lRUepCFSDlAEqn0USaFyx7Zk2cSDYbb
         gsh6SihZACdP3SzVj2sE+M378y3xReiSa551easyjOhC1htHmFvfb6tMrRRkRm9pGsqt
         8lu2cErfXs8j0NjT769vssPZgbCBmZxPZVGgdSehF5X8rtwDXaoTbP5JADUXHgnt0VCN
         4MfwLDH37ujo3ZATsoeMH6mHG4vT6S63Rv2DfvB5hgVrimNzdX0JcKQOhE+a/6GvJilK
         EOhA==
X-Gm-Message-State: AFqh2krS3sMVVrVxm7nggUmf3jJdDDk0VXPgzVM6aeilKxBru9ecnjoH
        kPwlNT1WoUpaU/df4ttT61VZUrmQnFZTAHDgwYgvpr+lj2F64iWN1UXQjP5TPzYangavl0ozX6M
        bOQQeDMrMZvX7udOkNIVVFYCRnWkyIsF4F96R2g==
X-Received: by 2002:a63:4c2:0:b0:478:b499:e789 with SMTP id 185-20020a6304c2000000b00478b499e789mr1530494pge.157.1672215180233;
        Wed, 28 Dec 2022 00:13:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsPFNzjZlAz6h8h23yksF4Ze0JhPAOHPe8Cw2qiDWiI4bXDnG/utVWu3KQAgf6UXcX8aNywFrwlQwIOHFALGMc=
X-Received: by 2002:a63:4c2:0:b0:478:b499:e789 with SMTP id
 185-20020a6304c2000000b00478b499e789mr1530493pge.157.1672215179920; Wed, 28
 Dec 2022 00:12:59 -0800 (PST)
MIME-Version: 1.0
References: <20221227055044.18168-1-kinga.tanska@intel.com>
In-Reply-To: <20221227055044.18168-1-kinga.tanska@intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 28 Dec 2022 16:12:48 +0800
Message-ID: <CALTww28cLYY8KbuzmOaVbDOty3TYOaBG-ggVFQriLN-Xuva9Hw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Incremental mode: remove safety verification
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org, colyli@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 27, 2022 at 8:49 PM Kinga Tanska <kinga.tanska@intel.com> wrote:
>
> Changes in incremental mode. Removing verification
> if remove is safe, when this mode is triggered. Also
> moving commit description to obey kernel coding style.
>
> Kinga Tanska (3):
>   Manage: do not check array state when drive is removed
>   incremental, manage: do not verify if remove is safe
>   manage: move comment with function description
>
>  Incremental.c |  2 +-
>  Manage.c      | 82 ++++++++++++++++++++++++++++++---------------------
>  2 files changed, 50 insertions(+), 34 deletions(-)
>
> --
> 2.26.2
>

Acked-by: Xiao Ni <xni@redhat.com>

