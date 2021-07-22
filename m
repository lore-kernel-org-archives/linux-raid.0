Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9125C6377D
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 09:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B15AC610F7
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 09:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhGVIh6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Jul 2021 04:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbhGVIhy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Jul 2021 04:37:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7D5C061757
        for <linux-raid@vger.kernel.org>; Thu, 22 Jul 2021 02:18:30 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1m6UqE-0001NK-VX; Thu, 22 Jul 2021 11:18:06 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1m6UqC-0001Ch-DB; Thu, 22 Jul 2021 11:18:04 +0200
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Richard Weinberger <richard@nod.at>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-integrity@vger.kernel.org,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v1 0/4] keys: introduce key_extract_material helper
Date:   Thu, 22 Jul 2021 11:17:58 +0200
Message-Id: <cover.b2fdd70b830d12853b12a12e32ceb0c8162c1346.1626945419.git-series.a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-raid@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

While keys of differing type have a common struct key definition, there is
no common scheme to the payload and key material extraction differs.

For kernel functionality that supports different key types,
this means duplicated code for key material extraction and because key type
is discriminated by a pointer to a global, users need to replicate
reachability checks as well, so builtin code doesn't depend on a key
type symbol offered by a module.

Make this easier by adding a common helper with initial support for
user, logon, encrypted and trusted keys.

This series contains two example of its use: dm-crypt uses it to reduce
boilerplate and ubifs authentication uses it to gain support for trusted
and encrypted keys alongside the already supported logon keys.

Looking forward to your feedback,
Ahmad

---
To: David Howells <dhowells@redhat.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
To: Alasdair Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
To: Song Liu <song@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: keyrings@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-security-module@vger.kernel.org

Ahmad Fatoum (4):
  keys: introduce key_extract_material helper
  dm: crypt: use new key_extract_material helper
  ubifs: auth: remove never hit key type error check
  ubifs: auth: consult encrypted and trusted keys if no logon key was found

 Documentation/filesystems/ubifs.rst |  2 +-
 drivers/md/dm-crypt.c               | 65 ++++--------------------------
 fs/ubifs/auth.c                     | 25 +++++-------
 include/linux/key.h                 | 45 +++++++++++++++++++++-
 security/keys/key.c                 | 40 ++++++++++++++++++-
 5 files changed, 107 insertions(+), 70 deletions(-)

base-commit: 2734d6c1b1a089fb593ef6a23d4b70903526fe0c
-- 
git-series 0.9.1
