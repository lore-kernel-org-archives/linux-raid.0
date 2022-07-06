Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB6E2C43334
	for <linux-raid@archiver.kernel.org>; Wed,  6 Jul 2022 15:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbiGFPHI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiGFPHH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Jul 2022 11:07:07 -0400
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64541AF2A
        for <linux-raid@vger.kernel.org>; Wed,  6 Jul 2022 08:07:01 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id c13so18572838qtq.10
        for <linux-raid@vger.kernel.org>; Wed, 06 Jul 2022 08:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I0RXuzZs3s0id/kcom5gH7O0HmNMUUNPAv91LFO4+a4=;
        b=7AN/kI7Ry3IgOoHlORIijPtzTzhUz2Kn7M435S2Az7WGDgjR40+48VTtZjFeuPYWVA
         u6z3S5wL5Z+76z+jhuRIdRYcqbXs/79lb7OPnISPciDeatQHmlAF7w7uU1lytzAsOVpJ
         ITfitBaAuwB2p+R6s12YWSJY3ONMnbpzRoiGSQmhcxQcqlWaRu/1MOiBGQLTKMKsULKR
         UlRIXjGwaICzA/5vWdmPKbc7vRGYxAgkqFc81xUW7ijthyPPTiaYIs2BRab2XrNiJKUu
         g2oRVl8ij3AR7c7zTkAjsP8hoSORzn5qW3bvXMRn5zE5CO9SPzI41Mqf21g0lVUhmq5t
         Z5yQ==
X-Gm-Message-State: AJIora8/F5tSNUJC82ETkghI42Yd1baK3Q6+11P/uJlL6sy1R4/RrMQN
        5dUO++jcZp04WFrEqsxwfgPG
X-Google-Smtp-Source: AGRyM1syM2piJxHzgzwmYO+2F/M3+bHsRSC/l80bNxbiOkjZ/DCWE9FGy+Tge1oNYwtQpJp5Yz7jXQ==
X-Received: by 2002:a05:6214:29e6:b0:470:44d9:1ec5 with SMTP id jv6-20020a05621429e600b0047044d91ec5mr36520228qvb.95.1657120020754;
        Wed, 06 Jul 2022 08:07:00 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id d3-20020ac81183000000b0031a2cdab5cesm19492709qtj.37.2022.07.06.08.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:07:00 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:06:58 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Douglas Anderson <dianders@chromium.org>,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        linux-security-module@vger.kernel.org,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v7 1/3] dm: Add verity helpers for LoadPin
Message-ID: <YsWlEmaQsIVUiKC0@redhat.com>
References: <20220627153526.3750341-1-mka@chromium.org>
 <20220627083512.v7.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627083512.v7.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 27 2022 at 11:35P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> LoadPin limits loading of kernel modules, firmware and certain
> other files to a 'pinned' file system (typically a read-only
> rootfs). To provide more flexibility LoadPin is being extended
> to also allow loading these files from trusted dm-verity
> devices. For that purpose LoadPin can be provided with a list
> of verity root digests that it should consider as trusted.
> 
> Add a bunch of helpers to allow LoadPin to check whether a DM
> device is a trusted verity device. The new functions broadly
> fall in two categories: those that need access to verity
> internals (like the root digest), and the 'glue' between
> LoadPin and verity. The new file dm-verity-loadpin.c contains
> the glue functions.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: Mike Snitzer <snitzer@kernel.org>
