Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D84C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 19 May 2022 00:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiESAsA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 May 2022 20:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiESAr6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 May 2022 20:47:58 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C726CF5BC
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 17:47:57 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c14so3704652pfn.2
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 17:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0dmLJVwCa/DghSPPAq3/ILY1JgWX+nBsu5yiEOAQ9ss=;
        b=XMODawl+7/0Y5Xh+b7gsipx99R4vrMlDVUJhygLFG7mr2rmjqW84L/f6uhId0MVlCM
         +7YHF+QsNYi15C1v725aS6OaBX9ZEjzCjL+F41eoG4Hbu8LlXissF8hjPeLMSl9nNire
         6tWIj/frqGlWx4+/gOTTDSdUVC5q88N9ooLdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0dmLJVwCa/DghSPPAq3/ILY1JgWX+nBsu5yiEOAQ9ss=;
        b=CBpzXXh5dH/XRI1XeEJ7YjTGeT22nrRHGH3mUWLF6Z1V6qfy5N6b9bu7G23KSDpIt1
         AW7bihDn+Yt963/9egf1IBltkzC6psqEUdUBbmlbd6XkMkIHVlypKvrS1L1Gvf4sf43o
         O2UsGNhMwvTSZbgXZI5Twe9W+uUXmxYPVAyEgeNG4J8BEtSUNzaYXN2ku00Q8TGgu9gr
         zdHd2Hk9Rd2GswsV0zOrzRoezmjMSyG/z7xAVZNAsu2xDyk5z0DdvZvzqPiABNkas2aW
         LCBOSpzetyvCxYxb2SvvGvTKjrAImprB4DonPtnq7QvbuBg79Ct6NlDFkmlHwdTDAd/7
         E3TQ==
X-Gm-Message-State: AOAM531SXvTtOFUD/5YhDCdWb5qbdT98U6TuCtUUIAuieKYXJRIWrpnf
        d5cz36L0w62DhFqEJhD+9SuJvw==
X-Google-Smtp-Source: ABdhPJxPgVklbI1Lz7IgXdVY0Dozqllrmq/dawwTwH/MMyxvIe35uXRiIXra8YQiTvV2RUlZEyKpvA==
X-Received: by 2002:a65:554a:0:b0:3f6:885:b291 with SMTP id t10-20020a65554a000000b003f60885b291mr1746494pgr.608.1652921277291;
        Wed, 18 May 2022 17:47:57 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:e229:79ea:227e:d9dd])
        by smtp.gmail.com with UTF8SMTPSA id u26-20020aa7839a000000b0050dc76281c2sm2515274pfm.156.2022.05.18.17.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 17:47:56 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     Song Liu <song@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v5 0/3] LoadPin: Enable loading from trusted dm-verity devices
Date:   Wed, 18 May 2022 17:47:51 -0700
Message-Id: <20220519004754.2174254-1-mka@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

As of now LoadPin restricts loading of kernel files to a single pinned
filesystem, typically the rootfs. This works for many systems, however it
can result in a bloated rootfs (and OTA updates) on platforms where
multiple boards with different hardware configurations use the same rootfs
image. Especially when 'optional' files are large it may be preferable to
download/install them only when they are actually needed by a given board.
Chrome OS uses Downloadable Content (DLC) [1] to deploy certain 'packages'
at runtime. As an example a DLC package could contain firmware for a
peripheral that is not present on all boards. DLCs use dm-verity [2] to
verify the integrity of the DLC content.

This series extends LoadPin to allow loading of kernel files from trusted
dm-verity devices. LoadPin maintains a list of root digests of verity
devices it considers trusted. Userspace can populate this list through an
ioctl on the new LoadPin securityfs entry 'dm-verity'. The ioctl receives
a file descriptor of a file with verity digests as parameter. Verity reads
the digests from this file after confirming that the file is located on the
pinned root. The digest file must contain one digest per line. The list of
trusted digests can only be set up once, which is typically done at boot
time.

When a kernel file is read LoadPin first checks (as usual) whether the file
is located on the pinned root, if so the file can be loaded. Otherwise, if
the verity extension is enabled, LoadPin determines whether the file is
located on a verity backed device and whether the root digest of that
device is in the list of trusted digests. The file can be loaded if the
verity device has a trusted root digest.

[1] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
[2] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html

Changes in v5:
- changed dm_verity_loadpin_is_sb_trusted() to
  dm_verity_loadpin_is_bdev_trusted()
- deleted bad semicolon in declaration of stub for
  dm_verity_loadpin_is_bdev_trusted()
- bumped verity version number to 1.8.1
- added 'Acked-by' tags from Kees

Changes in v4:
- a trusted verity device must have a single target of
  type 'verity'
- changed struct trusted_root_digest to have an unsized
  u8 array instead of a pointer
- use shared list of verity digests, deleted
  dm_verity_loadpin_set_trusted_root_digests()
- use newline as separator in digest file instead of comma
- after reading an invalid/corrupt digest file deny further attempts
  of setting up the list of digests
- added comment to read_trusted_verity_root_digests() explaining that
  an invalid digests entry invalidates the entire list of digests
- minor refactoring of verity related code in LoadPin

Changes in v3:
- added securityfs for LoadPin (currently only populated when
  CONFIG_SECURITY_LOADPIN_VERITY=y)
- added uapi include for LoadPin
- changed the interface for setting up the list of trusted
  digests from sysctl to ioctl on securityfs entry
- added stub for loadpin_is_fs_trusted() to be used
  CONFIG_SECURITY_LOADPIN_VERITY is not select
- depend on CONFIG_SECURITYFS instead of CONFIG_SYSTCL
- updated Kconfig help
- minor changes in read_trusted_verity_root_digests()
- updated commit message

Changes in v2:
- userspace now passes the path of the file with the verity digests
  via systcl, instead of the digests themselves
- renamed sysctl file to 'trusted_verity_root_digests_path'
- have CONFIG_SECURITY_LOADPIN_VERITY depend on CONFIG_SYSCTL
- updated Kconfig doc
- updated commit message

Matthias Kaehlcke (3):
  dm: Add verity helpers for LoadPin
  LoadPin: Enable loading from trusted dm-verity devices
  dm: verity-loadpin: Use CONFIG_SECURITY_LOADPIN_VERITY for conditional
    compilation

 drivers/md/Makefile               |   1 +
 drivers/md/dm-verity-loadpin.c    |  74 +++++++++++++
 drivers/md/dm-verity-target.c     |  35 ++++++-
 drivers/md/dm-verity.h            |   4 +
 include/linux/dm-verity-loadpin.h |  27 +++++
 include/uapi/linux/loadpin.h      |  22 ++++
 security/loadpin/Kconfig          |  16 +++
 security/loadpin/loadpin.c        | 167 +++++++++++++++++++++++++++++-
 8 files changed, 344 insertions(+), 2 deletions(-)
 create mode 100644 drivers/md/dm-verity-loadpin.c
 create mode 100644 include/linux/dm-verity-loadpin.h
 create mode 100644 include/uapi/linux/loadpin.h

-- 
2.36.1.124.g0e6072fb45-goog

