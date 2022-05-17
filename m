Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA051C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 17 May 2022 03:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiEQDiV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 May 2022 23:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbiEQDiR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 May 2022 23:38:17 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE6E46B1D
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 20:38:14 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x52so15743633pfu.11
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 20:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8rb5YAnT4q61r5OFUKyY8/kc8YnIY9p2tTz3G6h+GnI=;
        b=K+NCG2NOY2YHCZGF9tR3CDFh6GmYnmapld8oChptia7I0fznmJTqFy4IMPDhzPzrpB
         GSJnUjrCDj89eeru6nx+LJLj1uPP74dleWSLfQYcQtNKqITscv70QYhZXqFiLf4zCOwW
         ACYO6Tlu5Tz6ik2Cp8qUhoVk8JI4piml8NDRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8rb5YAnT4q61r5OFUKyY8/kc8YnIY9p2tTz3G6h+GnI=;
        b=QK+mS/wgQlFN9zTVPrW3aFvmSBnbjZ6Z+wup4z0+zqCRfhdtYYG8hqC6AvQnVBgR95
         AhQPnzGsNxV+yZX+CiORNpt+m7pDSsvVkWeW3ELnoHZs8OYzYvqWxxf6UMZq5vpB7rfp
         YP4KMaUIUzL+jvMivwiJEHCHeW4egqjtIngsVU0AxPKC+Ot0J5NNBVVXd6TijC7gZg/b
         zSUuWEbg2obpPLOsddEGwUtxg+fZT7Nslev1JEtaFEo9FUuXpHtkXzpZ6+r/QE/ruMC9
         YMnvRRaZ3qejOMWdLg/tp3+Gd54yFsRVos02EIYdEYNUfb8vHydk/Fy4vHKY1K7TCNa4
         dmkg==
X-Gm-Message-State: AOAM5331OOJFJYQ5io7pbKtGw864Ys0BHragdMaLHC97JRgGEYaOR32c
        q8iNwL2T+IOf6u7CDgIzzaMJLw==
X-Google-Smtp-Source: ABdhPJyIsPDpWnvy/XwAKF70PpFSrTdafFUxvd2g6pCcfojmxhOeRGWOV4pPfIMZkiY5fzkbYDiRnA==
X-Received: by 2002:a05:6a02:10d:b0:381:f4c8:ad26 with SMTP id bg13-20020a056a02010d00b00381f4c8ad26mr17570035pgb.135.1652758693846;
        Mon, 16 May 2022 20:38:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090332c700b0015e8d4eb27esm7802065plr.200.2022.05.16.20.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 20:38:13 -0700 (PDT)
Date:   Mon, 16 May 2022 20:38:12 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dm: Add verity helpers for LoadPin
Message-ID: <202205162035.CABA5B2C6@keescook>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <02028CEA-5704-4A51-8CAD-BEE53CEF7CCA@chromium.org>
 <YoKdSrjVf/tHGoa5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoKdSrjVf/tHGoa5@google.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 16, 2022 at 11:51:54AM -0700, Matthias Kaehlcke wrote:
> 'targets' are different types of DM mappings like 'linear' or 'verity'. A
> device mapper table contains has one or more targets that define the mapping
> of the blocks of the mapped device.
> 
> Having spelled that out I realize that the above check is wrong. It would
> consider a device like this trusted:
> 
> 0 10000000 linear 8:1
> 10000000 10001000 verity <params>
> 
> In the above case only a small part of the DM device would be backed by verity.
> 
> I think we want a table with a single entry that is a verity target.

Ah-ha! Okay, that's what I was worried about. Yes, a device made up
of only trusted verity targets should be the only trusted device. (So,
technically it could be more than 1 verity target, but each would need
to be trusted. Supporting that arrangement, though, may be overkill --
I would expect a 1:1 mapping as you suggest.

-- 
Kees Cook
