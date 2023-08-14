Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D0DEB64DD
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 09:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbjHNJ2H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbjHNJ1y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 05:27:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A37D10E5
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 02:27:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 46FD41FD5F;
        Mon, 14 Aug 2023 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1692005241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=WPCecHx/X5o2QLBa71xyOJ5n76FRecdKSSeNuEogV0U=;
        b=DN5/tzOT+vDmtmp1co5amWhbl6JemKKeCJc68g3oUwPde7AuvEYvDXQq/lL47RisIZMg0o
        DG4PaX9plNsDwHRUVAXpv8j95JCE+YUJ800OsNSYyl2TFfgDF1KVsW1fpWBjMSjxJXbpKP
        a19DFkEsuXnQiat1uBp7C3hHh1uDgNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1692005241;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=WPCecHx/X5o2QLBa71xyOJ5n76FRecdKSSeNuEogV0U=;
        b=XkF0CYSyfDBxfyo2gqQgFMv502zIwTRDSBWzbMupxkAbAm4yUEjjAC9lPMeqDZXJMiD7lm
        UyGXruZ47FU1OKCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3370E13AA6;
        Mon, 14 Aug 2023 09:27:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hoo5DHnz2WRKbAAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 14 Aug 2023 09:27:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 6C793A0769; Mon, 14 Aug 2023 11:27:20 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] md/raid0: Fix performance regression for large sequential IO
Date:   Mon, 14 Aug 2023 11:27:06 +0200
Message-Id: <20230814091452.9670-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=795; i=jack@suse.cz; h=from:subject:message-id; bh=+/3G/Eb6HMaomoT23p+VYSEUj01IlUGXx+HeU5Zuo80=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGFJufo4r2VPX90l04XPW/QKSx39bRThcDHjHt/Nu3cOTTPrn ixTNOxmNWRgYORhkxRRZVkde1L42z6hra6iGDMwgViaQKQxcnAJwERMOhrkXam9sNpDVkTTtOCYgaW v8yjhG81LgxC0az+fqS/0RZp0R11RVNy+Q/UaT7EyxWXb3NM+GNa9VdYv37vCc1BlU/3hducdz+/Nq 01dPSe89qPqedaXOyRcl3lemqp+VPF6u63jqUaCRXnSZ8Kk3N0PbtJ3uTC3TnthQWrr6xOborA0yHR mewcxC+kHemYuFH11wYv+z91/JLR7TlTNsX/Ll3O51Pqv2it/36UPXvun8HrbMDya0q7EHKb3VvzJ9 12nR+MJnazTu+XXqnWgxZ/tfoGS4eIqTvP+BkK7HJT++5X9ZnFxV+WXD7Mn3YvKrHNZvXTmXT9myvv PTjTM/Gt4oNsTbX/x+VSN140QWAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

one of our customers reported a noticeable performance regression with his
raid0 setup after updating to newer kernels. After investigation of the block
traces it was obvious that raid0 code generates very suboptimal IO pattern for
large requests that are not properly aligned to the raid chunk boundary (see
patch 2 for detailed description). The regression has been introduced already 6
years ago by commit f00d7c85be9e ("md/raid0: fix up bio splitting.") but likely
because it requires multimegabyte requests (only possible after multipage bvec
work) which are not aligned to the chunk boundary (which is usually possible
only if the filesystems are created with suboptimal parameters) it went
unnoticed for a long time. These patches fix the regression.

								Honza
