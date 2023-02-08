Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1C8C636CD
	for <linux-raid@archiver.kernel.org>; Wed,  8 Feb 2023 00:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBHAjy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Feb 2023 19:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBHAjx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Feb 2023 19:39:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58273D936
        for <linux-raid@vger.kernel.org>; Tue,  7 Feb 2023 16:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675816729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i4OyXYh4xQ21/RXDpuAG0brRQZwf50HBdti6AZVIAWw=;
        b=UDQrm+ZYMOeDTbXn03PTzW0KrMNZM8mGkSbBw4E6ExgyzvEjuzVrFYWrg7t03KDrywc4jt
        Hh54P1i/nXBGqXiZ8ZyqXS6DupCe0TcUwXqCAMWzm+cH8uBXFmaXgMSNQEPNfU1WRiyy5h
        z15XIgmgnW7edg5QRrRddnEYbJJmh6M=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-251-dxYZTjaGN3Ww-5oyaceTaQ-1; Tue, 07 Feb 2023 19:38:43 -0500
X-MC-Unique: dxYZTjaGN3Ww-5oyaceTaQ-1
Received: by mail-pl1-f199.google.com with SMTP id k14-20020a170902ce0e00b001992e19d3beso1910562plg.5
        for <linux-raid@vger.kernel.org>; Tue, 07 Feb 2023 16:38:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i4OyXYh4xQ21/RXDpuAG0brRQZwf50HBdti6AZVIAWw=;
        b=SWkIKtl4eK0u9Upr6uboi8LSGUMABg5fFeENpAnDC0isxf9tjSIV9aV24w3HYEDSbg
         4M6/L6G+L6UVa3DsEKkkn5IoWHaQI+MtpWlRu9mXGSuMVpxwA4LVTbNflAViuCUsLWmr
         j4UHOzglSwKO0g1w8hZ1W9kWPOt9SR38xNJmWydj4VqeKJUfIM18KAaVnq2SmCVRwVvg
         Xks2SzGeNnNdj022f/xKG8XFjtNHzvsiJW4UhPkf42+WVXo+AUenZ4SNTjRmFU/rIg4o
         /cc2MOAGGStWksCMftjyHUTyHafyTN07SaJidfpQ5sYeblRDi+QgxExyfTySEz+NA89e
         k3wg==
X-Gm-Message-State: AO0yUKWw4gwK6BRTSWxr/b0viALsRfhOHI2jZoWf93Qef6XzWL65+ggU
        uaCKnwBY4NW1oFrYCLedC7b4SS3WKt4co7hNeIqaKfByhsy3CWdil0o/TlB47fFgaF20VNcWXiQ
        4hXCDov/cI6DID5kTrO+KCP/hhHrn+NMywphyaA==
X-Received: by 2002:aa7:9a09:0:b0:593:8deb:820a with SMTP id w9-20020aa79a09000000b005938deb820amr1218407pfj.53.1675816722887;
        Tue, 07 Feb 2023 16:38:42 -0800 (PST)
X-Google-Smtp-Source: AK7set+aI9SaKBQCx3FPClttWlI/Nr2/FHm6B50TJLDiAoHCiDFP0tlKUToVgwGoQioSICtFHCirjeX5h6FfkWsefo8=
X-Received: by 2002:aa7:9a09:0:b0:593:8deb:820a with SMTP id
 w9-20020aa79a09000000b005938deb820amr1218404pfj.53.1675816722671; Tue, 07 Feb
 2023 16:38:42 -0800 (PST)
MIME-Version: 1.0
References: <20230203051344.19328-1-xni@redhat.com> <CALTww28SZ+3uP_6+Y058fvQqLC1fc9GjTDAUC440kd++ZnUTcg@mail.gmail.com>
 <CAPhsuW5is9zyYCq09y=fHcPLWfVEADMey+FLV70E224G1M2n-g@mail.gmail.com>
In-Reply-To: <CAPhsuW5is9zyYCq09y=fHcPLWfVEADMey+FLV70E224G1M2n-g@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 8 Feb 2023 08:38:31 +0800
Message-ID: <CALTww2--mt1tRxts0ekjgQtiB6TZ_Taaz17YccvVYyjj=bLx-Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: Increase active_io to count acct_io
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 8, 2023 at 2:12 AM Song Liu <song@kernel.org> wrote:
>
> On Tue, Feb 7, 2023 at 5:49 AM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi Song
> >
> > Is the patch ok? If so, are there chances to merge this into md-next this week?
> >
>
> I rewrote the commit log and applied it to md-next. Please double check
> the new commit log is accurate.
>
> Thanks,
> Song
>

Thanks, the commit log is good.
Xiao

