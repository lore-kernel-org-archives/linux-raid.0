Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882E9C00130
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 22:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25CAC223E8
	for <linux-raid@archiver.kernel.org>; Thu,  3 Dec 2020 22:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgLCWdt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 17:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbgLCWds (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 17:33:48 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3950FC08E85E
        for <linux-raid@vger.kernel.org>; Thu,  3 Dec 2020 14:32:27 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t3so2276958pgi.11
        for <linux-raid@vger.kernel.org>; Thu, 03 Dec 2020 14:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=isS72LcXXBRrXr0Ako/fe2G087FHJYFoOicsYh1AWO8=;
        b=n9Tgm2HiezYP/Ask48/IujNV3+jpE7cAZxD1tbqft+4LOAW8/m/e4j9wHEoLavTI4Z
         hSLUicihywE1d/WNoTSMTG5cPEt6IL70OKZXoNWZKKsNB8F8OkFKzDHZqm+f/sOZNYPz
         8j5e+HCi8SdKdA7Xu2RuFpwxLd62E/liW6ieEEDoJO1kbRJ7HadhezHYjY2iSllw8wbQ
         tUkB72H2Css+K9VJVsCYkwSfkLuH324cFrRzdu9C/twxVdfY+7sTOiEDRSZLMsa0UJkB
         wjzzKRldHy8lIsto9UZtLgh7GCR7mYt6IsYqp6pH8Tj46iWzOI8zERroIO9s4oMqIBLi
         zN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding:cc:from:to;
        bh=isS72LcXXBRrXr0Ako/fe2G087FHJYFoOicsYh1AWO8=;
        b=kLTRCSFANb7schWwpSDR7Xy2mReAvKgLY+B5TIDYkzoGh0oVz4oT22LnfgLSKM5qsJ
         OyUAYF3mtHISmCi1rKNWLAxmiMOAKkMEXjRrj7IkqMD7gQ9t8fVeP40VHHX/XCaTFikM
         GyxI4PtFA4wyUUTluMyja1wiRr9feckKsdjHmtlXKVKl240S+AbkKLDev72FfkjKtpTT
         RkWHBvD9dYm6d7DvCqZznNsAd5mXU/aw/LaYz+cOQol65fnLQDJo3o4Hai/gECZ+AdA4
         V30PSwqiR3FJ6xjyOD5yhpks9iULhowjcWh8jOFhbnAZSTndU2W4n1YrJ+VOuuemybOA
         N7iw==
X-Gm-Message-State: AOAM533lSLNU5mJfFCXtkzAVlvohvnHQITYVHnOaYKAhcUc8D3uuPiyy
        FqMxbenM1PXcKcoxLwngq0WGfA==
X-Google-Smtp-Source: ABdhPJxyBjD8G9ISMJWXF9KC/iPnxZEl+jlMD7j47CrGjE+X5vfqNVKfzgCqsSq3L3yisx8iqaM2cQ==
X-Received: by 2002:a65:679a:: with SMTP id e26mr4855403pgr.394.1607034746754;
        Thu, 03 Dec 2020 14:32:26 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id gp14sm333425pjb.6.2020.12.03.14.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 14:32:26 -0800 (PST)
Subject: [PATCH v1 1/5] Documentation: Describe dm-user
Date:   Thu,  3 Dec 2020 13:58:55 -0800
Message-Id: <20201203215859.2719888-2-palmer@dabbelt.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
In-Reply-To: <20201203215859.2719888-1-palmer@dabbelt.com>
References: <20201203215859.2719888-1-palmer@dabbelt.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     corbet@lwn.net, song@kernel.org,
        Palmer Dabbelt <palmerdabbelt@google.com>, shuah@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel-team@android.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Palmer Dabbelt <palmerdabbelt@google.com>

I started by patterning this after the Fuse documentation, which is
located at Documentation/fs/fuse.rst.  There's not a whole lot of that
left, though.

Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

---

This is a work in progress, but nothing in there should be incorrect.
---
 Documentation/block/dm-user.rst | 99 +++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 Documentation/block/dm-user.rst

diff --git a/Documentation/block/dm-user.rst b/Documentation/block/dm-user.rst
new file mode 100644
index 000000000000..5eb3120f3fd5
--- /dev/null
+++ b/Documentation/block/dm-user.rst
@@ -0,0 +1,99 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======
+dm-user
+=======
+
+What is dm-user?
+================
+
+dm-user is a device mapper target that allows block accesses to be satisfied by
+an otherwise unprivileged daemon running in userspace.  Conceptually it is
+FUSE, but for block devices as opposed to file systems.
+
+Creating a dm-user Target
+=========================
+
+dm-user is implemented as a Device Mapper target, which allows for various
+device management tasks.  In general dm-user targets function in the same
+fashion as other device-mapper targets, with the exception that dm-user targets
+handle requests via a userspace daemon as opposed to one of various in-kernel
+mechanisms.  As such there is little difference between creating a dm-user
+target and any other device mapper target: the standard device mapper control
+device and ioctl() calls are used to create a table with at least one target of
+the "user" type.  Like all other targets this table entry needs a start/size
+pair.  The additional required argument is the name of the control device that
+will be associated with this target.  Specifically:
+
+````
+user <start sector> <number of sectors> <path to control device>
+````
+
+As a concrete example, the following `dmsetup` invocation will create a new
+device mapper block device available at `/dev/mapper/blk`, consisting entirely
+of a single target which can be controlled via a stream of messages passed over
+`/dev/dm-user/ctl`.
+
+````
+dmsetup create blk <<EOF
+0 1024 user 0 1024 ctl
+EOF
+dmsetup resume blk
+````
+
+Userspace is expected to spin up a daemon to handle those block requests, which
+will block in the meantime.  The various Device Mapper operations should all
+function as they do for other targets.  If the userspace daemon terminates (or
+otherwise closes the control file descriptor) then the kernel will continue to
+queue up BIOs until userspace either starts a new daemon or destroys the
+target.
+
+Userspace may open each control device multiple times, in which case the kernel
+will distribute messages among each file instance.
+
+Writing a dm-user Daemon
+========================
+
+tools/testing/selftests/dm-user contains a handful of test daemons.
+functional/simple-read-all.c is also suitable as an example.
+
+Kernel - userspace interface
+****************************
+
+FIXME: A description of `struct dm_user_message`
+
+Kernel Implementation
+=====================
+
+BIO Lifecycle
+*************
+
+| "dd if=/dev/mapper/user ...             " | dm-user block server
+|                                           |
+|                                           | >sys_read()
+|                                           |  >dev_read()
+|                                           |   [sleep on c->wq]
+|                                           |
+| >sys_read()                               |
+|  [... block and DM layer ... ]            |
+|  >user_map()                              |
+|   [enqueue message]                       |
+|   [wake up c->wq]                         |
+|  <user_map()                              |   [woken up]
+| [sleep on BIO completion]                 |   [copy message to user]
+|                                           |  <dev_read()
+|                                           | <sys_read()
+|                                           |
+|                                           | [obtain request data]
+|                                           |
+|                                           | >sys_write()
+|                                           |  >dev_write()
+|                                           |   [copy message from user]
+|                                           |   [complete BIO]
+|  [woken up on BIO completion]             |  <dev_write()
+| <sys_read()                               | <sys_write()
+|                                           |
+| [write and loop]                          | [loop for more messages]
+
+Locking Scheme
+**************
-- 
2.29.2.454.gaff20da3a2-goog

