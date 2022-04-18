Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02303C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 18 Apr 2022 21:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347970AbiDRVSr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Apr 2022 17:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237371AbiDRVSp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Apr 2022 17:18:45 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755C12CE16
        for <linux-raid@vger.kernel.org>; Mon, 18 Apr 2022 14:16:05 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j70so309590pgd.4
        for <linux-raid@vger.kernel.org>; Mon, 18 Apr 2022 14:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/8XJRkQ+Ngj+SVndYkt5Kqwy78yKeKiW3fonsocHm3g=;
        b=J1vTHu7C5Uh3f4LfAcKQPO/5Pz9IYhPGuzvmzDr/r76LDgWCFm6fpTDSrrFHEEVVIx
         HoP+BhBTxIiOZ7XsJWw/ir1ytJ3YVKtGcIHkRd/zEskK37Gf+Vg1VyHaF6EzqMYxqYqD
         bUrRL1EQr8iUt/oCRE7WlIxQqTZeCfihNOTrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/8XJRkQ+Ngj+SVndYkt5Kqwy78yKeKiW3fonsocHm3g=;
        b=y/rrVY2K1uvA9JAEHt8qtof6aTmX+KzclyXR+wV9uUPeMlzkeEHAtkHRCqtcpCn8N+
         60f90KbfTSTTi2AEA+WxX+tys5pHbRvuwuTD0Xn9VEyfVLZgfnI3rJ9qolJxh7xfRpcP
         8hgg9EqzsgOOEijhRb06xJmNd81CdMmrRGI12+XIjgY1lo5P895KtuIJz3vMnkoP24r4
         VYUPOERDA8EO2tzxT+xGANB/8BLD1pC3DuPdPq5abKg35HC3RhYddFBR/n+3E20F2TKJ
         BSLN8a3NDBMXuH86Ygugc0FHVFolJgJD2CH04YSIQnAZSvAFfqNZZCGGbV5e8xbpHhZA
         5pjg==
X-Gm-Message-State: AOAM5319/DJJUzPHSF0nb65Oz2DJDsx4BWgWGY6bgEZkNWldkqce53t3
        qRO6Evxf5cR3fSNlK2MCtZ+thg==
X-Google-Smtp-Source: ABdhPJy4XB+bbS97AAyRfwYXg0SHO4S5mnpEPALFnmvLrX6gjHaVLEhGa0FV74GcCXM0EQkzZfmXGg==
X-Received: by 2002:a63:1543:0:b0:39d:9729:1992 with SMTP id 3-20020a631543000000b0039d97291992mr11756352pgv.155.1650316565036;
        Mon, 18 Apr 2022 14:16:05 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:6b32:a0a5:ec32:c287])
        by smtp.gmail.com with UTF8SMTPSA id y23-20020a056a00181700b0050839558f4bsm14438421pfa.40.2022.04.18.14.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 14:16:04 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>,
        linux-security-module@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>, dm-devel@redhat.com,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 0/3] LoadPin: Enable loading from trusted dm-verity devices
Date:   Mon, 18 Apr 2022 14:15:56 -0700
Message-Id: <20220418211559.3832724-1-mka@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

As of now LoadPin restricts loading of kernel files to a single
pinned filesystem, typically the rootfs. This works for many
systems, however it can result in a bloated rootfs (and OTA
updates) on platforms where multiple boards with different
hardware configurations use the same rootfs image. Especially
when 'optional' files are large it may be preferable to
download/install them only when they are actually needed by a
given board. Chrome OS uses Downloadable Content (DLC) [1] to
deploy certain 'packages' at runtime. As an example a DLC
package could contain firmware for a peripheral that is not
present on all boards. DLCs use dm-verity [2] to verify the
integrity of the DLC content.

This series extends LoadPin to allow loading of kernel files
from trusted dm-verity devices. It adds the concept of
trusted verity devices to LoadPin. Userspace can use the
new systl file 'loadpin/trusted_verity_root_digests' to
provide LoadPin with a list of root digests from dm-verity
devices that LoadPin should consider as trusted. When a
kernel file is read LoadPin first checks (as usual) whether
the file is located on the pinned root, if so the file can
be loaded. Otherwise, if the verity extension is enabled,
LoadPin determines whether the file is located on a verity
backed device and whether the root digest of that device
is in the list of trusted digests. The file can be loaded
if the verity device has a trusted root digest.

The list of trusted root digests can only be written once
(typically at boot time), to limit the possiblity of
attackers setting up rogue verity devices and marking them
as trusted.

[1] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
[2] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html


Matthias Kaehlcke (3):
  dm: Add verity helpers for LoadPin
  LoadPin: Enable loading from trusted dm-verity devices
  dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional
    compilation

 drivers/md/Makefile               |   1 +
 drivers/md/dm-verity-loadpin.c    |  80 ++++++++++++++
 drivers/md/dm-verity-target.c     |  34 ++++++
 drivers/md/dm-verity.h            |   4 +
 include/linux/dm-verity-loadpin.h |  27 +++++
 security/loadpin/Kconfig          |  11 ++
 security/loadpin/loadpin.c        | 168 +++++++++++++++++++++++++++++-
 7 files changed, 324 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/dm-verity-loadpin.c
 create mode 100644 include/linux/dm-verity-loadpin.h

-- 
2.36.0.rc0.470.gd361397f0d-goog

