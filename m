Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377B6C64ED6
	for <linux-raid@archiver.kernel.org>; Mon, 27 Feb 2023 00:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjB0AQH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Feb 2023 19:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0AQG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Feb 2023 19:16:06 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369F615554
        for <linux-raid@vger.kernel.org>; Sun, 26 Feb 2023 16:15:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C05F61F8D7;
        Mon, 27 Feb 2023 00:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677456957; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Psue0GUxz2Hf3DaFntJazFuxRNgFNDIcENslsqrnnMc=;
        b=U3Y7WMDfIQqhV0qXSVsDWwD+K8cIAMr2WhU9biWywVnVyvg6k/uYaSKoyTWypCjPfZxbqd
        dMedzzetTRwj1TE9UbHz1U2FRrKn+xWtoh1AuA9dAg1n+25xS9D75/ewNnESiP7HKzit1h
        8pXDFk/S4lCwqtr/rw/LmHObt9+zU4I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677456957;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Psue0GUxz2Hf3DaFntJazFuxRNgFNDIcENslsqrnnMc=;
        b=S+VlNBTdB9kmx5MR0W0HXkHuHR06wjz25Ado8nzJSGctzAbqhAh6p8djdX/Nf1c5FSTyTO
        RITCE65pqcOkfeAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 38CCE13912;
        Mon, 27 Feb 2023 00:15:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K4r7Njv2+2OndQAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 27 Feb 2023 00:15:55 +0000
Subject: [PATCH 0/6] Assorted patches relating to mdmon
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Date:   Mon, 27 Feb 2023 11:13:07 +1100
Message-ID: <167745586347.16565.4353184078424535907.stgit@noble.brown>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

mdmon is a root-storage daemon is the sense defined by systemd
documentation, but it does not follow the practice that systemd
recommends.  Specifically it is run from the root filesystem when
possible.  The instance started in the initrd hands-over to a root-fs
based instance, which then hands-over to an initrd-based instance
started by dracut at shutdown.

Part of the reason that we ignore systemd advise is that mdmon needs
access to the filesystem - specifically /dev and /sys - which is not
available in the initrd context after switchroot.  We could possibly
change mdmon to work in the systemd-preferred way by splitting mdmon
into two processes instead of just having 2 threads.  The "monitor"
process could running entirely in the initrd context, the "manager"
process could safely run in the root-fs context, passing newly opened
file descriptors to the monitor over a unix-domain socket.

But we aren't there yet and may never be.

For now, mdmon doesn't work correctly.  There is no mechanism to ensure
a new instance starts after switchroot.  Until recently the initrd
instance of the systemd mdmon unit would be stopped at switchroot time
because udev would temporarily forget about md devices.  This would
allow the "udevadm trigger" process to start a new instance.  udev was
recently fixed:

Commit: 7ec624147a41 ("udevadm: cleanup-db: don't delete information for kept db entries")

so now the attempt to start mdmon via "udevadm trigger" does nothing as
mdmon already has an active unit.

The net result is that mdmon continues running in the initrd mount
namespace and so cannot access new devices.  Adding a device to a root
md array that depends on mdmon will no longer work.

We want the initrd instance of mdmon to continue running until the
root-fs based instance starts, and that really requires we have two
different systemd units.  This series achieves this in the final patch by
using a different instance name inside or initrd and outside.
"initrd-mdfoo" and "mdfoo".

Other patches in the series are mostly clean-ups and minor improvements
in related code.

NeilBrown



---

NeilBrown (6):
      Use existence of /etc/initrd-release to detect initrd.
      Improvements for IMSM_NO_PLATFORM testing.
      mdmon: don't test both 'all' and 'container_name'.
      mdmon: change systemd unit file to use --foreground
      mdmon: Remove need for KillMode=none
      mdmon improvements for switchroot


 Grow.c                    |  4 ++--
 mdadm.h                   |  4 +++-
 mdmon.c                   | 21 ++++++++++++-------
 super-intel.c             | 43 ++++++++++++++++++++++++++++++++++++---
 systemd/mdmon@.service    | 15 +++++++-------
 udev-md-raid-arrays.rules |  3 ++-
 util.c                    | 17 +++++-----------
 7 files changed, 74 insertions(+), 33 deletions(-)

--
Signature

