Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D1AC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbiFVUZz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiFVUZf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:35 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC67136B78
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=OxZgm2PdGJymbM4C+RrnEXkOcp1TiWWPFWsXYDzQObo=; b=MsBO/sHl8/Z0wEdV5nUEOsrFEY
        v6X2cWYE7xa/+57ufvXuPX42vRp5POGLg/VyiTRXnP+2XZMdl8vHbO5iazOpmuO6jA6lN5KQtKBCg
        lk2UN3KMvM41nAp2lLkc9rw9une7YMH11pHFCG5GnSUTuEqNY9cHc4uWV7aI6W466551q0gQ19/tM
        QhsSezrQjxnuL8gNLzIOJuqN8eKjCv2IZk/2NM8KWfsU4RzPy4T6RJvIp1yB+/27zukJehFcyC194
        JPGEHXu1p/DJQL3NvQtKAapOc0rghwq+60cTj5vLsiu3L91n0T5BHwe7eqWGkpzicrbkCblShVQK1
        IxjFdHFg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46up-00EGyc-JH; Wed, 22 Jun 2022 14:25:32 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uh-0009MS-GZ; Wed, 22 Jun 2022 14:25:23 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>
Date:   Wed, 22 Jun 2022 14:25:12 -0600
Message-Id: <20220622202519.35905-8-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mateusz.grzonka@intel.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 07/14] mdadm: Fix optional --write-behind parameter
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The commit noted below changed the behaviour of --write-behind to
require an argument. This broke the 06wrmostly test with the error:

  mdadm: Invalid value for maximum outstanding write-behind writes: (null).
         Must be between 0 and 16383.

To fix this, check if optarg is NULL before parising it, as the origial
code did.

Fixes: 60815698c0ac ("Refactor parse_num and use it to parse optarg.")
Cc: Mateusz Grzonka <mateusz.grzonka@intel.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 mdadm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index d0c5e6def901..56722ed997a2 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1201,8 +1201,9 @@ int main(int argc, char *argv[])
 		case O(BUILD, WriteBehind):
 		case O(CREATE, WriteBehind):
 			s.write_behind = DEFAULT_MAX_WRITE_BEHIND;
-			if (parse_num(&s.write_behind, optarg) != 0 ||
-			s.write_behind < 0 || s.write_behind > 16383) {
+			if (optarg &&
+			    (parse_num(&s.write_behind, optarg) != 0 ||
+			     s.write_behind < 0 || s.write_behind > 16383)) {
 				pr_err("Invalid value for maximum outstanding write-behind writes: %s.\n\tMust be between 0 and 16383.\n",
 						optarg);
 				exit(2);
-- 
2.30.2

