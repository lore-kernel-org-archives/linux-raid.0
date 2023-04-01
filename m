Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B96AC6FD1D
	for <linux-raid@archiver.kernel.org>; Sat,  1 Apr 2023 21:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjDAVHy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 1 Apr 2023 17:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDAVHx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 1 Apr 2023 17:07:53 -0400
X-Greylist: delayed 3933 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 01 Apr 2023 14:07:50 PDT
Received: from a1-bg02.venev.name (a1-bg02.venev.name [213.240.239.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3AA72B7
        for <linux-raid@vger.kernel.org>; Sat,  1 Apr 2023 14:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=venev.name;
        s=default; h=Content-Transfer-Encoding:Message-Id:Date:Subject:To:From:
        Content-Type:Reply-To:Sender; bh=rK+tf5hZCcUtIobl689XTDQlN0aPAaBJ9TzKkwwpQJQ=
        ; b=X3Q1fgpvHzmiU4nEWdt+wpDTZQMyH5rMYJdyX0N3qYTHwF9kY8ZOX/hG6VOIImQdY7fpAuw+N
        UJ7/hXO3z7sroC8DyZh+hlQS7O5eoo8agortDqnHWWO45pUpEOZ5gE5eYhSqHAFqY6AWzNQKEdkIW
        eHQwVkWU/yowBIndiNeGMt7tfYOIUOmuWVm9BKiiTDJ8+J3PGWhXhCBZhD66x6fHP9+wUU3ywjPqI
        /XbE7eE1y3/6MXgnBUOQYCp5bd+wNhnoDKi8TvEepWoqq+HESX+vNQycHCwJH0ojBGvwZ6yYow8Ya
        HlXgRnFEA5cx+C5CftNw6tZJFusgjiRqH2lYhX9ZXkEg8JEHSQIZrNjpI4SMDBP4RtMx+amBWbFyS
        0wg/51MyilxoPiU4y0LMpT8MqrqzMthS8wto+kIYWYmbO/+uLwAgnB6Jkfx1bDxc/LP/tPdbZy+c5
        lm9QN7vG/ustVnL9f3CVmzxg2Qq25ymF15wAp9mypIVqLiYhBEBb2O8So3FVENe1PD7+ap4OYnY7a
        MH9QVTT9/Os1Oekzs/9Kh/Kz0J4fI4eLtDiHqSXzg+2RKcMlKpFWd+I+jPVHd9ux38lRhjO/F84Q0
        IIugH2VcBpbzU2XVRiWAxyZGJ/d6imAuVG+JoljpgFlCN0vTFYIS2lApA+r3TWbnyibnfvk=;
Received: from a1-bg02.venev.name ([213.240.239.49] helo=pmx1.venev.name)
        by a1-bg02.venev.name with esmtps
        id 1pihQT-0001l6-0H
        (TLS1.3:TLS_AES_256_GCM_SHA384:256)
        (envelope-from <hristo@venev.name>);
        Sat, 01 Apr 2023 20:02:13 +0000
Received: from venev.name ([213.240.239.49])
        by pmx1.venev.name with ESMTPSA
        id W9FpFcONKGRoGgAAdB6GMg
        (envelope-from <hristo@venev.name>); Sat, 01 Apr 2023 20:02:13 +0000
From:   Hristo Venev <hristo@venev.name>
To:     linux-raid@vger.kernel.org
Cc:     NeilBrown <neilb@suse.de>, Hristo Venev <hristo@venev.name>
Subject: [PATCH] super1: fix truncation check for journal device
Date:   Sat,  1 Apr 2023 23:01:35 +0300
Message-Id: <20230401200134.6688-1-hristo@venev.name>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The journal device can be smaller than the component devices.

Fixes: 171e9743881e ("super1: report truncated device")
Signed-off-by: Hristo Venev <hristo@venev.name>
---
 super1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index f7020320..44d6ecad 100644
--- a/super1.c
+++ b/super1.c
@@ -2359,8 +2359,9 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 
 	if (st->minor_version >= 1 &&
 	    st->ignore_hw_compat == 0 &&
-	    (dsize < (__le64_to_cpu(super->data_offset) +
-		      __le64_to_cpu(super->size))
+	    ((role_from_sb(super) != MD_DISK_ROLE_JOURNAL &&
+		  dsize < (__le64_to_cpu(super->data_offset) +
+		      __le64_to_cpu(super->size)))
 	     ||
 	     dsize < (__le64_to_cpu(super->data_offset) +
 		      __le64_to_cpu(super->data_size)))) {
-- 
2.40.0

