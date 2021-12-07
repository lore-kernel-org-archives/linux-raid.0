Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC24C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  7 Dec 2021 11:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbhLGMAp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Dec 2021 07:00:45 -0500
Received: from dione.uberspace.de ([185.26.156.222]:37346 "EHLO
        dione.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbhLGMAo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Dec 2021 07:00:44 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2021 07:00:44 EST
Received: (qmail 24982 invoked from network); 7 Dec 2021 11:50:30 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by dione.uberspace.de with SMTP; 7 Dec 2021 11:50:30 -0000
Date:   Tue, 7 Dec 2021 12:50:30 +0100
From:   Andreas Klauer <Andreas.Klauer@metamorpher.de>
To:     linux-raid@vger.kernel.org
Subject: [PATCH] support LUKS2 labels on md raid arrays
Message-ID: <Ya9KhjdYwIyM4JS+@metamorpher.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I noticed that with LUKS2 on mdadm arrays, the by-label symlinks would 
not show up at all, so here is a trivial change to make it work for md.

See also 

* https://gitlab.com/cryptsetup/cryptsetup/-/issues/382
* https://github.com/systemd/systemd/commit/f2bd752215cba2f90697edd7e3ff5e859a6b9a4c

Signed-off-by: Andreas Klauer <Andreas.Klauer@metamorpher.de>
---
 udev-md-raid-arrays.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/udev-md-raid-arrays.rules b/udev-md-raid-arrays.rules
index 13c9076e..bd23abba 100644
--- a/udev-md-raid-arrays.rules
+++ b/udev-md-raid-arrays.rules
@@ -32,7 +32,7 @@ OPTIONS+="link_priority=100"
 OPTIONS+="watch"
 ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
 ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_PART_ENTRY_UUID}=="?*", SYMLINK+="disk/by-partuuid/$env{ID_PART_ENTRY_UUID}"
-ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
+ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_LABEL_ENC}=="?*", SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
 
 ENV{MD_LEVEL}=="raid[1-9]*", ENV{SYSTEMD_WANTS}+="mdmonitor.service"
 
-- 
2.34.1
