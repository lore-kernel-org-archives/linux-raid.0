Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863ABC38142
	for <linux-raid@archiver.kernel.org>; Tue, 31 Jan 2023 12:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjAaMS3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Jan 2023 07:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjAaMS1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Jan 2023 07:18:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F05941B65
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 04:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675167464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0xKlxpkUZRo2mPicdjcp1VlQPa8+dcAbG4ZeEJrymiQ=;
        b=UWb42KNSY48B46V1kyvhV27kMAc4nZ595D9LQe5taP+PgDaO7D2er9ZyFJg8lJyWo7wZ4X
        5mOj/2dJgpltXjVIKsJnQ3FXKTm1H5HvxEnHLEOHfYFqMC0T1iI91q7O57dK159erG2GTw
        FlMg/urmObm75CH3hgxbWUFAnOLelYQ=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556-rrp8X7d5ORC4GW10175lcA-1; Tue, 31 Jan 2023 07:17:43 -0500
X-MC-Unique: rrp8X7d5ORC4GW10175lcA-1
Received: by mail-ua1-f71.google.com with SMTP id p25-20020ab05859000000b006001ac8d2efso5602490uac.11
        for <linux-raid@vger.kernel.org>; Tue, 31 Jan 2023 04:17:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0xKlxpkUZRo2mPicdjcp1VlQPa8+dcAbG4ZeEJrymiQ=;
        b=UfFYrj9fykwXPowPZZKbNltVrXApMmatQLGJHmndYwpYkFO/LJZ4S5WNmyWms0S9tO
         4s1/KWMxUQXt0RefJ80308bEF2e7PF0uEzotRJCURoylzxx7DZqbpxYwvJ36+wxinHvA
         Oa2Sc0HFskoENDSS7jdJTRO5gzEonYjvcFZV/7m74MDC8+njpE7DrdMr6dPxxanWuKaA
         sbMxm7zoiFGqmz5ub9dWxqT1bZHaUI1My+EM1PFGtyN9V5lDcxvJGhH01PPTzL0J3Hjz
         +/M5M5pcm1kCodjsDfcrpjL4fLZCXkhmluZXHV/m1DaOJ6BzgPt+MbP1g6Z2bNzhejQ6
         oqOw==
X-Gm-Message-State: AO0yUKWOb009eFl7QBxGp04YAYMPMF54xM8/fGmp6bzFKtSSCGaqKYIl
        UB6jZY8Ld68k7EZSFzGD214owXRIbw9uZyTaTFwI7wU4WonbI+ZCRR5CotmXJ0I6GE19cxd/79G
        G86wTuoJ8Zp+CE2ZbqXXXnQ==
X-Received: by 2002:a67:c119:0:b0:3ea:99cb:c3e with SMTP id d25-20020a67c119000000b003ea99cb0c3emr2996503vsj.2.1675167462888;
        Tue, 31 Jan 2023 04:17:42 -0800 (PST)
X-Google-Smtp-Source: AK7set/3cWf1zFQSzSaXyTvYZFmhtrofj2WcZS5Lru0KQCl9i0U0TOY96Lm9fQ3ijteXPFUn2WOINw==
X-Received: by 2002:a67:c119:0:b0:3ea:99cb:c3e with SMTP id d25-20020a67c119000000b003ea99cb0c3emr2996457vsj.2.1675167462612;
        Tue, 31 Jan 2023 04:17:42 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id 10-20020a370b0a000000b007203bbbbb31sm3325683qkl.47.2023.01.31.04.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 04:17:42 -0800 (PST)
Message-ID: <865b04949b69c3470ecb3fa5f93005e4c5a9e86e.camel@redhat.com>
Subject: Re: [PATCH 0/9] Documentation: correct lots of spelling errors
 (series 2)
From:   Paolo Abeni <pabeni@redhat.com>
To:     patchwork-bot+netdevbpf@kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, tj@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, cgroups@vger.kernel.org, agk@redhat.com,
        snitzer@kernel.org, dm-devel@redhat.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, nvdimm@lists.linux.dev, vkoul@kernel.org,
        dmaengine@vger.kernel.org, song@kernel.org,
        linux-raid@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, jdelvare@suse.com, linux@roeck-us.net,
        linux-hwmon@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        paulmck@kernel.org, frederic@kernel.org, quic_neeraju@quicinc.com,
        josh@joshtriplett.org, rcu@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        sparclinux@vger.kernel.org
Date:   Tue, 31 Jan 2023 13:17:35 +0100
In-Reply-To: <167516701747.19012.10728935395396675001.git-patchwork-notify@kernel.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
         <167516701747.19012.10728935395396675001.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 2023-01-31 at 12:10 +0000, patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
>=20
> This patch was applied to netdev/net-next.git (master)
> by Paolo Abeni <pabeni@redhat.com>:
>=20
> On Sun, 29 Jan 2023 15:10:44 -0800 you wrote:
> > Maintainers of specific kernel subsystems are only Cc-ed on their
> > respective patches, not the entire series. [if all goes well]
> >=20
> > These patches are based on linux-next-20230127.
> >=20
> >=20
> >  [PATCH 1/9] Documentation: admin-guide: correct spelling
> >  [PATCH 2/9] Documentation: driver-api: correct spelling
> >  [PATCH 3/9] Documentation: hwmon: correct spelling
> >  [PATCH 4/9] Documentation: networking: correct spelling
> >  [PATCH 5/9] Documentation: RCU: correct spelling
> >  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
> >  [PATCH 7/9] Documentation: scsi: correct spelling
> >  [PATCH 8/9] Documentation: sparc: correct spelling
> >  [PATCH 9/9] Documentation: userspace-api: correct spelling
> >=20
> > [...]
>=20
> Here is the summary with links:
>   - [4/9] Documentation: networking: correct spelling
>     https://git.kernel.org/netdev/net-next/c/a266ef69b890
>=20
> You are awesome, thank you!

That is just a bot glitch. I actually applied only patch 4/9 to the
net-next tree. I hope this is not too much scarying/confusing.

Thanks,

Paolo

