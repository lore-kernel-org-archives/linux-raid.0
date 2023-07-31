Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAECC001DC
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jul 2023 14:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjGaONG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbjGaOM5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Jul 2023 10:12:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DB7AF
        for <linux-raid@vger.kernel.org>; Mon, 31 Jul 2023 07:12:55 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68730bafa6bso773541b3a.1
        for <linux-raid@vger.kernel.org>; Mon, 31 Jul 2023 07:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1690812775; x=1691417575;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wUiBnR5pWDrH+RHNvXQMMYnMmO6T9AFz3AkOQS+0wRc=;
        b=V0wAXlPc/9no/Pf/xaGA1hmBPfi65NTrusXWP2n1f9/t/06sdvkc733kGxSbB290WN
         Wp7zCMps4hg+2Guo73OkjbrkUu83DcE/NOMKsa8sund7oihNn0y8MA5b+UP0WD7Ftz/J
         mOVcvCUK3e18Sr842baFFLM2J5oCHcwHWC2kU1DaJbrq7q6flss19cnsJ4KU/lUKrxxf
         hvSJALr0Dzsv689f/2HiBaXhxGuMqHhw/LadjITIpEZjICAxHsk1oi/e4jQE1OzdFftL
         n2XHZiaMftO66Ao1Uz7fp+V6l9UKVzBXmwLvsrHv97WPaZ3PMoQqd7+QzVELqBwUIy2Y
         2nTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690812775; x=1691417575;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wUiBnR5pWDrH+RHNvXQMMYnMmO6T9AFz3AkOQS+0wRc=;
        b=T8NLCCCUtoQugf5uYDvLSy+exoPrhmy6VZdxT9QSKJ4uMjmCNxF0jBxd0iwqmlvTfT
         zBinBTCGo8AFHs+5u2qrH3kuFo4OWGjCzmX/iISslj4YQ6iwUoeAoEuz+W/SubzuNb76
         Clhi/L+qcjl3s2nwQz938SM6rNWx6Tzw4ULxNrL5jpiqH3HO/peM1t8g+PKbn/vzdjcQ
         Gu5WJR4HXxLDaqWpfWFXVi+0sFp4n9XF11IAiy4TbOhAgU3vZrVVM5QFaI8y2RnIlu1a
         Hf92/uDpPLCPL7hr3ChdpZrPmsehNpNE/EuRjDXnh2NOGKVn0B9BtiMOUJCELHGFL176
         LifA==
X-Gm-Message-State: ABy/qLZO03PyeVp3DtXiqpha4OgiZuNKRn02UESUpmLF+GZ2bYTogDOe
        wBCtoGULIEiCElZr+gycuvu6w77WJ8JuMWauv5/2rEjN458=
X-Google-Smtp-Source: APBJJlElaDT7DFr8MHlqfRKg8pOviqcXZRgU8OmVZd+cqZZ16uXeW92GWsBnLVh9mMthYwhjkSTWqg==
X-Received: by 2002:a17:903:41d1:b0:1b0:3ab6:5140 with SMTP id u17-20020a17090341d100b001b03ab65140mr11483136ple.4.1690812775340;
        Mon, 31 Jul 2023 07:12:55 -0700 (PDT)
Received: from nixos ([47.75.78.161])
        by smtp.gmail.com with ESMTPSA id jn13-20020a170903050d00b001b80ed7b66fsm8636754plb.94.2023.07.31.07.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 07:12:55 -0700 (PDT)
Date:   Mon, 31 Jul 2023 22:12:39 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
Message-ID: <o75cstdf4qq3mnmq3iucxrfxwrshhzmvoz32ao4ksf2i42hzwx@vjcppf3ig454>
References: <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
 <byhedo2kmchy6e676tfmpqvydlul5ad7kchqds2s34hmdlbu7g@5daabr77ntwb>
 <e4dd94a5-0f03-9b7b-72cf-f0ce17441815@huaweicloud.com>
 <443169b3-4e38-d4fe-0450-5d2698c65988@huaweicloud.com>
 <honxxkye2lhuzkpty2hv3jlrhd72od3mc6rcb27koeo4hq66bs@qsczyfxupqd3>
 <0d683096-5084-df23-8c6d-a1725f834b3d@huaweicloud.com>
 <bkou447mvbzpka2xyzojdyywogm3ljdstnfuhf4c3zyribrw55@joxaoryhdiji>
 <8085922e-403b-890e-8710-6ac3d09aa3d4@huaweicloud.com>
 <jm5cxwosgfolegtnkdt7madecheukl73gpgpabgogie5irt74e@v7knmmj537py>
 <b0a03f40-3e64-b906-c689-9c67b7618d53@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0a03f40-3e64-b906-c689-9c67b7618d53@huaweicloud.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jul 31, 2023 at 02:22:31PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/31 11:48, Xueshi Hu 写道:
> > > Well... I just said reshape can continue is not possible for raid1, and
> > > this patch will cause that recovery can't continue is some cases.
> 
> > I see. I will reread the relevant code to gain a better understanding of
> > "some cases".
> 
> It's not that complex at all, the key point is whether your changes
> introduce functional changes, if so, does the effect fully evaluated.
> 
> In this case, raid1_reshape(all the callers) will set
> MD_RECOVERY_RECOVER and MD_RECOVERY_NEEDED to indicate that daemon
> thread must check if recovery is needed, if so it will start recovery.
> 
> I agree that recovery is probably not needed in this case that
> raid_disks is the same, however, note that recovery can be interrupted
> by user, and raid1_reshape() can be triggered by user as well, this
> means following procedures will end up different:
> 
> 1. trigger a recovery;
> 2. interupt the recovery;
> 3. trigger a raid1_reshape();
Sincere gratitude for your detailed response. I have been consistently
misunderstanding the concept of "interrupted recovery." I now understand
your concerns.

Thanks,
Hu
> 
> Before this patch, the interupted recovery will continue;
> 
> This is minor, but I can't say that no user will be affected, and I
> really prefer to keep this behaviour, which means this patch can just do
> some cleanup without introducing functional changes.
> 
> Thanks,
> Kuai
> 
