Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB752C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 17 May 2022 01:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiEQBs3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 May 2022 21:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiEQBs2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 May 2022 21:48:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C84427CFB
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 18:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652752107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sHZr21NeuXoOlSzwNV5pmOc6utnRPjCxB6EXo3CueCE=;
        b=P0LXSy3Z801y/8UowgbeV4LfjlivcbPZv8gPbLeqOWYyxfKOc8/DJ+KH/cigHGoDpjKZ7l
        9shKrtVnDLz2jRvwTck3Z2J0YuM9LzoTMJl12t1S4NMjreLWi/KtoznureEX3swC4YYa63
        TgXav+xTj6dhfJoee8jug6/VgWJ10W4=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-wk06ZTBMMLWAooP6fG2tIQ-1; Mon, 16 May 2022 21:48:25 -0400
X-MC-Unique: wk06ZTBMMLWAooP6fG2tIQ-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-f11c3a4d85so9315179fac.23
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 18:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHZr21NeuXoOlSzwNV5pmOc6utnRPjCxB6EXo3CueCE=;
        b=OK0xyuIbFtrOuiEEXSwpbOzCPHVMivp8LUrDMhjK2n3FA6IrYWsR9DOQvRMimrXCgq
         5KAjnNoa+Ia8N0jQa0M+9ltjCUsCqcOS6iAsran+6LDdJpobKtE2XdZeFRshkJ/XTwtl
         HKZQHQHVnEtgT/zk5KHubyPWdoEITOujvru8NagxmhexIEA5Uvi0CrroQZExQlpqt4yq
         QdZihAPl3OKhlSqhfIjMqe7sjRCzufTEFQnOqi7ZD9LFk8dJEq3CiOZMFGWuyDH3ISP4
         pBT1YkDDiUbenekEAGrgeePIcL4u/hy+ohSxSrdUxJSMKPSOmdYN2DSQNHSOSDdY9jgS
         65vQ==
X-Gm-Message-State: AOAM530d5j5y9m4EKBtO3Dk6dA4hKklSjr7DD5ECFSl4/a7UiulXQ+Yb
        bH/KMoFLMIEaGu/xKX1Vc/2CU+RneVmZUizzgkx72k5UQc61YBeSBChZOqyE1GyYhPDFukFHY9B
        o2CUWt4EWgE0b00QXLgMRTSgtg+ITy9/Z/JWsHA==
X-Received: by 2002:a05:6870:2425:b0:de:2fb0:1caa with SMTP id n37-20020a056870242500b000de2fb01caamr11243367oap.115.1652752105232;
        Mon, 16 May 2022 18:48:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3lcT+3BOwHLaUylzKDqlyGAJ+Yy2eykLRQgORIw5M4KDObAs3vcquXWn5LC6PLAl1RuqtvRUtf+OnXzzc3I0=
X-Received: by 2002:a05:6870:2425:b0:de:2fb0:1caa with SMTP id
 n37-20020a056870242500b000de2fb01caamr11243358oap.115.1652752105081; Mon, 16
 May 2022 18:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220516160941.00004e83@linux.intel.com>
In-Reply-To: <20220516160941.00004e83@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 17 May 2022 09:48:13 +0800
Message-ID: <CALTww2-mbfZRcHu_95Q+WANXZ9ayRwjXvyvqP5Gseeb86dEy=w@mail.gmail.com>
Subject: Re: mdadm test suite improvements
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>, Coly Li <colyli@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz

Thanks for the effort. Have you init the git project to start this? If
so, you can send it, so we can
work together about this.

Best Regards
Xiao

On Mon, May 16, 2022 at 10:09 PM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hello All,
> I'm working on names handling in mdadm and I need to add some new test to
> the mdadm scope - to verify that it is working as desired.
> Bash is not best choice for testing and in current form, our tests are not
> friendly for developers. I would like to introduce another python based test
> scope and add it to repository. I will integrate it with current framework.
>
> I can see that currently test are not well used and they aren't often updated.
> I want to bring new life to them. Adopting more modern approach seems to be good
> start point.
> Any thoughts?
>
> Thanks in advance,
> Mariusz
>

