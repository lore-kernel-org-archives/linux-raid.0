Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A6EEC43334
	for <linux-raid@archiver.kernel.org>; Fri,  8 Jul 2022 17:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbiGHRsL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Jul 2022 13:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238511AbiGHRsJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Jul 2022 13:48:09 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491EA74DE4
        for <linux-raid@vger.kernel.org>; Fri,  8 Jul 2022 10:48:08 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s206so22947208pgs.3
        for <linux-raid@vger.kernel.org>; Fri, 08 Jul 2022 10:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SCpgoi0bej3E/k3q1Zzvx8WQzQbsCorWnUbIjfYa/X8=;
        b=ml3Kny+TDNHdTGvuVDpKu9tNVsI9rg6LeipWZ5ZOkteqKLFBxM5ekj3E07IlhnmCZV
         QEGA9z/6eokWng2H3lP1krXx7MXUvPNoY40dacqit8ht0YCevulLcYBnXMrbRvrml9OS
         XyUb9Idq8wvH8qCWN0cfxK4yhsSKzD1PJ0xMs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SCpgoi0bej3E/k3q1Zzvx8WQzQbsCorWnUbIjfYa/X8=;
        b=r36PO+EyzCETKp8543xM9+HoLwrlgsei2T6OK9TUaNffY6Lw+pQwkBC4mrxR8yYVcK
         xbOsJpQ85DvAxgPVu7zLCnmk5NSTUp0JMX2vClHQHjlV48fBHwCAZlj8CacR4BzZ0XFM
         yi2ryfsIQk2bDq0rmLXeH5UiZffTYX5J+6lS5f8KxAdb2/gFdsWJetbQliV1W3/Wl49e
         R/7EgBDGxP/yR74jpj1v+Htwh6EnS1MirRQP7TpuyHbHN6AWr/mc5sRnGniD80PxTtyf
         x+iixhUVExSXAhFtUbFGIWIdtfAAY5eGIfAYGm7We6znzCfLu0Z5zOIW0UuUnQL3cVS2
         wTOw==
X-Gm-Message-State: AJIora8N5puqE5eVrJWAxR+akIsHE2F6uqxrfBuHYoKnKUH4EQtXExba
        /tRi9eMPaBwbftVHCfKn17Pz6w==
X-Google-Smtp-Source: AGRyM1sZCb3nACbVv0Xqctc8zBRDdY2BX228aDhc1USUQoc2fpKbCJNkaQ1aAGFkZEau8j+w/Chrcg==
X-Received: by 2002:a63:187:0:b0:411:6434:d017 with SMTP id 129-20020a630187000000b004116434d017mr4274618pgb.350.1657302487803;
        Fri, 08 Jul 2022 10:48:07 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a74-20020a621a4d000000b00528d4f647f2sm3404184pfa.91.2022.07.08.10.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 10:48:07 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     jmorris@namei.org, agk@redhat.com, snitzer@kernel.org,
        mka@chromium.org, serge@hallyn.com
Cc:     Kees Cook <keescook@chromium.org>, linux-raid@vger.kernel.org,
        song@kernel.org, dianders@chromium.org,
        linux-security-module@vger.kernel.org, dm-devel@redhat.com,
        gmazyland@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] LoadPin: Enable loading from trusted dm-verity devices
Date:   Fri,  8 Jul 2022 10:47:59 -0700
Message-Id: <165730247648.3882109.12888837825450019581.b4-ty@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220627153526.3750341-1-mka@chromium.org>
References: <20220627153526.3750341-1-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 27 Jun 2022 08:35:23 -0700, Matthias Kaehlcke wrote:
> As of now LoadPin restricts loading of kernel files to a single pinned
> filesystem, typically the rootfs. This works for many systems, however it
> can result in a bloated rootfs (and OTA updates) on platforms where
> multiple boards with different hardware configurations use the same rootfs
> image. Especially when 'optional' files are large it may be preferable to
> download/install them only when they are actually needed by a given board.
> Chrome OS uses Downloadable Content (DLC) [1] to deploy certain 'packages'
> at runtime. As an example a DLC package could contain firmware for a
> peripheral that is not present on all boards. DLCs use dm-verity [2] to
> verify the integrity of the DLC content.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/3] dm: Add verity helpers for LoadPin
      https://git.kernel.org/kees/c/b6c1c5745ccc
[2/3] LoadPin: Enable loading from trusted dm-verity devices
      https://git.kernel.org/kees/c/3f805f8cc23b
[3/3] dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional compilation
      https://git.kernel.org/kees/c/231af4709018

-- 
Kees Cook

