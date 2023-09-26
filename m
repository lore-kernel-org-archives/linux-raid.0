Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC85CEE14D8
	for <linux-raid@archiver.kernel.org>; Tue, 26 Sep 2023 06:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjIZGpG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Sep 2023 02:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjIZGpF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Sep 2023 02:45:05 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9173810E
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 23:44:57 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-405d70d19bcso3860585e9.0
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 23:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695710696; x=1696315496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vy+8WASYGTBS1mWxTg8Np7QtelHMw3rWndRVIOTdjBE=;
        b=Z0pcZJhu6E5SCTrt1iatL9NocivU+4cdMrsH2fIcGXo9rcRaNkcnHIJYzLupgWKKiq
         c3qg6aLY7dqimnDT0SHP+oQVO/PsHCs1ZgcgpVWUF/D9iIc7OuVowjF5Ypf49CMQlS57
         3Ual701q+RGhGn/AjzoiwtrZxjUlTpiMXm26aOfJb6SBDImBNg8J9VhsGYQJM2MI54qD
         gYC39n/NcoaXwb0V1vQimZdAMzPupHI5zIOi6f8xyhB429aHTemX1UEpZWuWLt2qooSJ
         4M62LbBwA4HN1t8MP8j2vMA1WYyYcoNBERH5m2dd8ryCgC3PtpLBLzhX3htsY+QW5907
         dy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695710696; x=1696315496;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vy+8WASYGTBS1mWxTg8Np7QtelHMw3rWndRVIOTdjBE=;
        b=lGDoiCM5A9kAqr+cl+RcZ1XOfi4oxIwrZe4QO7gJconh5HP01ecUMd/OwxYyq5cfrV
         EyfCCpmrhOjUH9oCRAORYHMYw44rtCqr+RMLCZndjwirrPPu1xKhxL3NP2lwL6iQZ6B2
         cN17ZAYuCfMUTBaVIxftucvFUEZ3LMUZfrmsTbRlgfYnNuEvRb+0CFpgVZFVAYOPImLr
         kJl+2qZX6QwEpJuhrxoonM12S5Ls7fvCkBd/cCqcicRoZ3/FsdRnt7eqal2/lZAnnqkC
         L7VdGKekoWkS+RE6y6UMEHt9Iakgfj0KWhUHe9BfjC8UFsg4EgIu7yr702OTiqmRNf//
         WU7A==
X-Gm-Message-State: AOJu0YygxONT9Xhy4MNB1TjLEsJBheOlL5MZc02VdC240eE64fQl8Lgj
        4mOzlrn2D3hiE3v76LS1gyIKxg==
X-Google-Smtp-Source: AGHT+IH9l76dfcSqxOnW7BCusuZLco1ls+8gcRWVia87WNg/ADhYwhN0gbWksHNTHTDBt6adAkwcMA==
X-Received: by 2002:a05:600c:4f50:b0:405:39bb:38a8 with SMTP id m16-20020a05600c4f5000b0040539bb38a8mr7418100wmq.2.1695710695345;
        Mon, 25 Sep 2023 23:44:55 -0700 (PDT)
Received: from [127.0.0.1] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c230800b004042dbb8925sm1127571wmo.38.2023.09.25.23.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 23:44:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Hannes Reinecke <hare@suse.de>, NeilBrown <neilb@suse.de>,
        Richard Fan <richard.fan@suse.com>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Wols Lists <antlists@youngman.org.uk>, Xiao Ni <xni@redhat.com>
In-Reply-To: <20230811170513.2300-1-colyli@suse.de>
References: <20230811170513.2300-1-colyli@suse.de>
Subject: Re: [PATCH v7 0/6] badblocks improvement for multiple bad block
 ranges
Message-Id: <169571069404.578063.8660956212739660767.b4-ty@kernel.dk>
Date:   Tue, 26 Sep 2023 00:44:54 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On Sat, 12 Aug 2023 01:05:06 +0800, Coly Li wrote:
> This is the v7 version of the badblocks improvement series, which makes
> badblocks APIs to handle multiple ranges in bad block table.
> 
> The change comparing to previous v6 version is the modifications
> enlightened by the code review comments from Xiao Ni,
> - Typo fixes in code comments and commit logs.
> - Tiny but useful optimzation in prev_badblocks(), front_overwrite(),
>   _badblocks_clear().
> 
> [...]

Applied, thanks!

[1/6] badblocks: add more helper structure and routines in badblocks.h
      commit: e850d9a52f4cd31521c80a7ea9718b69129af4d5
[2/6] badblocks: add helper routines for badblock ranges handling
      commit: c3c6a86e9efc5da5964260c322fe07feca6df782
[3/6] badblocks: improve badblocks_set() for multiple ranges handling
      commit: 1726c774678331b4af5e78db87e10ff5da448456
[4/6] badblocks: improve badblocks_clear() for multiple ranges handling
      commit: db448eb6862979aad2468ecf957a20ef98b82f29
[5/6] badblocks: improve badblocks_check() for multiple ranges handling
      commit: 3ea3354cb9f03e34ee3fab98f127ab8da4131eee
[6/6] badblocks: switch to the improved badblock handling code
      commit: aa511ff8218b3fb328181fbaac48aa5e9c5c6d93

Best regards,
-- 
Jens Axboe



