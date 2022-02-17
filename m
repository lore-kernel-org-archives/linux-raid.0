Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEBFC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 17 Feb 2022 13:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbiBQNVG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:21:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240720AbiBQNVF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Feb 2022 08:21:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 003ED2AE734
        for <linux-raid@vger.kernel.org>; Thu, 17 Feb 2022 05:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645104049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k3CtLIYPfTzwt5ZNE3qDndhQiDTLTVFRSOAzXK0i2vw=;
        b=XZNfUbOyC7jfMABAD316swNCI2kNoX8msEao7YApU/rUHElKAs9CQcKxwmIU/0KkYgKbJE
        MBsKBX8TZqWtFZIvzaXkehgQHsi5Y4ZbPy2Csw1waZCZWZxVRWLRHIKWkPqbzpDD0CbwQ0
        wfEQDHohvOrAAU6jE+l7s8iibFYfZAY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-XOs6QVwiOzKQ_TdFTFx4Fg-1; Thu, 17 Feb 2022 08:20:47 -0500
X-MC-Unique: XOs6QVwiOzKQ_TdFTFx4Fg-1
Received: by mail-ed1-f72.google.com with SMTP id y10-20020a056402358a00b00410deddea4cso3483620edc.16
        for <linux-raid@vger.kernel.org>; Thu, 17 Feb 2022 05:20:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k3CtLIYPfTzwt5ZNE3qDndhQiDTLTVFRSOAzXK0i2vw=;
        b=lJ8dzVUwj+h34teKEvirXCJoQC1o6GA5+0ALMY74Ln887YXpfFPBAD+WV22dPL3izn
         1Cl9yPVzSOUEintahjFy+28Wfqw5n0Cc4dn/Sm/iU3Oq6dmB6XiUsQF5ao1QbBeq4FZR
         GQESGZwTv1qSd5S6DWI74tXIePxfWNfcGEOzKdEFAQDbUSz9GHo8m9nbefSws5iMF9Mn
         iefAWHtncE2tJC5VelHjkXM+pswVpUODfCM+FtijfwKBgMZqVlMHmlGb2b2m1nfbX7hC
         8G8nQvugdQ84izh2UZjB2NMNKnq+AuvMY/Y1iTKunLgE5c6cqaBsRwcvjKdj1M7prhNN
         WTbA==
X-Gm-Message-State: AOAM533rzxzoImUxfYDyyPMVxGIAMWRd6OZXqC2cpoUOkS7HVsEZNsrp
        21bQbUU9X/Zq0JyPQazTZfO5CUaBmurP4bITd6VW61eHkQJm/KiyNpm6pmdmKtIXCN7lF4+qXnV
        XtN018Pm6EHlB0IQhAIqmlA==
X-Received: by 2002:a05:6402:35c8:b0:410:b9fd:67bb with SMTP id z8-20020a05640235c800b00410b9fd67bbmr2485151edc.69.1645104046576;
        Thu, 17 Feb 2022 05:20:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzG+5YCeI2QCHM8NsHJGOwaygRT178a8hfMJag9L17lixwktIJKGCIddnV26daajuC/ekHVg==
X-Received: by 2002:a05:6402:35c8:b0:410:b9fd:67bb with SMTP id z8-20020a05640235c800b00410b9fd67bbmr2485135edc.69.1645104046424;
        Thu, 17 Feb 2022 05:20:46 -0800 (PST)
Received: from alatyr-rpi.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 18sm1132582ejj.1.2022.02.17.05.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 05:20:46 -0800 (PST)
Date:   Thu, 17 Feb 2022 14:20:42 +0100
From:   Peter Rajnoha <prajnoha@redhat.com>
To:     Martin Wilck <mwilck@suse.com>
Cc:     NeilBrown <neilb@suse.de>, Jes Sorensen <jsorensen@fb.com>,
        linux-raid@vger.kernel.org, lvm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Heming Zhao <heming.zhao@suse.com>, Coly Li <colyli@suse.com>,
        dm-devel@redhat.com
Subject: Re: [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
Message-ID: <20220217132042.dmmkhecvvylnyc3b@alatyr-rpi.brq.redhat.com>
References: <20220216205914.7575-1-mwilck@suse.com>
 <164504936873.10228.7361167610237544463@noble.neil.brown.name>
 <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu 17 Feb 2022 11:58, Martin Wilck wrote:
> The main reason is that SYSTEMD_READY=0 is set too late, in 99-systemd-
> rules, and only on "add" events:
> https://github.com/systemd/systemd/blob/bfae960e53f6986f1c4d234ea82681d0acad57df/rules.d/99-systemd.rules.in#L18
> 
> I guess the device-mapper rules themselves could be setting
> SYSTEMD_READY="0". @Peter Rajnoha, do you want to comment on that? My
> concern wrt such a change would be possible side effects. Setting
> SYSTEMD_READY=0 on "change" events could actually be wrong, see below.

We need to be very careful with SYSTEMD_READY as switching that from 1
to 0 would cause the systemd device unit to stop. And services can be
bound to device existence (that is, systemd device unit). If we just
temporarily suspend a DM device and not completely removing it, then
we might get out-of-sync easily when it comes to notion of device
presence in various parts of the system.

One thing is device presence, the other are various sub-states that
a single SYSTEMD_READY is not covering, like the suspended state...

-- 
Peter

