Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E7DE728DA
	for <linux-raid@archiver.kernel.org>; Fri, 29 Sep 2023 19:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbjI2TVX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjI2TVW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Sep 2023 15:21:22 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7AC1BD
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 12:21:20 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c5db4925f9so7955585ad.1
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 12:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696015280; x=1696620080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1aEgZXilDM7YqBibwIo+3j857Ar2xHuwGZYUU0Ocu+c=;
        b=KBQFpB+xfDNFWIHHlTi8QcXz/jZ0iwk5l+DciKBf/dTkq9SlUE9risbenp90ibST3n
         Kbysj2xIXUkG1rlhFosXoOrkBv0hAuuhlKUdOt1d9oFxQjTPH2ZMuMOL29UA9Elip+KY
         xIWO8JdS8tlWRm6DNdbK1WttiRtIdY6AEV3Rc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696015280; x=1696620080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1aEgZXilDM7YqBibwIo+3j857Ar2xHuwGZYUU0Ocu+c=;
        b=NotkSIpkIupkToZk3HBwlrnsRYz5TNqPVV7EYrtBmQcw4ViwncPWGrJdBxUuPlsaaw
         R+JzbZG8eo2K+OG8ABuJRiB5MOm4lQC2hYQA3Yc0YPE8LxDtUDOexEkLJXhxKdnmRI8G
         ZYNXph/TFpqKMu2lcTG83F2BKER2GyLyu25Lp/d0F52LM4h2TU4Cg2bD4knHil4uHXt1
         1tZAM7RwfQdy8Lar8wzMfPScHBdj3KC1F822VXCYjPl9oLE27+CDYWCrUrMDJuk+o19K
         Nl/81MCVpVod+ei9Hizs/8yrvbD8c6QSe39tBK8a0B2GiJW4R/VGdrBEbAYYTXuD1Ixf
         l1nw==
X-Gm-Message-State: AOJu0YwZe9+p1239sudCX2ajRYLqGUXvEYcN82CvGBn96kN5FBbDigrz
        kyyQ+jNCm3jbYxFmFab5UuRjzNv0B/2wUUnI7JU=
X-Google-Smtp-Source: AGHT+IG2g06b1pAU8D9HLnGJFm+KvBiJ8WwyJ5eZb/HgchXrkfd9LQ+8XwPTFdERaFnnLTfsp/xOhg==
X-Received: by 2002:a17:902:a416:b0:1c6:362:3553 with SMTP id p22-20020a170902a41600b001c603623553mr6067189plq.31.1696015279776;
        Fri, 29 Sep 2023 12:21:19 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902cec200b001c5fc11c085sm13354610plg.264.2023.09.29.12.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Sep 2023 12:21:16 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Song Liu <song@kernel.org>, Kees Cook <keescook@chromium.org>
Cc:     linux-raid@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] md/md-linear: Annotate struct linear_conf with __counted_by
Date:   Fri, 29 Sep 2023 12:21:09 -0700
Message-Id: <169601526973.3013632.16756928162777602693.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230915200328.never.064-kees@kernel.org>
References: <20230915200328.never.064-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 15 Sep 2023 13:03:28 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct linear_conf.
> Additionally, since the element count member must be set before accessing
> the annotated flexible array member, move its initialization earlier.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] md/md-linear: Annotate struct linear_conf with __counted_by
      https://git.kernel.org/kees/c/9add7681e09b

Take care,

-- 
Kees Cook

