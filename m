Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B51C43334
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jul 2022 22:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbiGNWiD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jul 2022 18:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiGNWiC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Jul 2022 18:38:02 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE3A6D9EB
        for <linux-raid@vger.kernel.org>; Thu, 14 Jul 2022 15:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=O1nO7OkmWNn8vt4pC27Q1yJyBQeyDOJwrtvl+ogTtDE=; b=lPL6h6+qnm+yqPjMRnSaBBRmls
        hB+DDaCL5JwjEqu3HBMX2IOWJ2WYhZb47uYocOSM5R1qmEi1EmtmAqs1CtssyXHnq33mCMcl1aD97
        qhn/1qPgI0L7Z711psq/XEwYI3HGT7KCp+buuElTUskwMQd5AK+Y/QNOqUze1C1cFidqXuxHhtHw4
        SUvLfYwJmEhmeSTkwUh0w1vZLdGsaft3UgX5bkoxZz9Oazpj/KV6Ovx6RISUrVc+7isYORtW0UwcK
        AM9OMyT1TmV+fkHdGvVnU7TcYFkWjmGL7Eq/EYYdH1RVQTeVKhAa1ge1q3tD7LTa6mvFb06TKNilx
        dsdClaiA==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oC7T3-00F2ep-4w; Thu, 14 Jul 2022 16:37:57 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oC7Sw-0004V1-Pz; Thu, 14 Jul 2022 16:37:50 -0600
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
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu, 14 Jul 2022 16:37:49 -0600
Message-Id: <20220714223749.17250-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm] mdadm: Don't open md device for CREATE and ASSEMBLE
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The mdadm command tries to open the md device for most modes, first
thing, no matter what. When running to create or assemble an array,
in most cases, the md device will not exist, the open call will fail
and everything will proceed correctly.

However, when running tests, a create or assembly command may be run
shortly after stopping an array and the old md device file may still
be around. Then, if create_on_open is set in the kernel, a new md
device will be created when mdadm does its initial open.

When mdadm gets around to creating the new device with the new_array
parameter it issues this error:

   mdadm: Fail to create md0 when using
   /sys/module/md_mod/parameters/new_array, fallback to creation via node

This is because an mddev was already created by the kernel with the
earlier open() call and thus the new one being created will fail with
EEXIST. The mdadm command will still successfully be created due to
falling back to the node creation method. However, the error message
itself will fail any test that's running it.

This issue is a race condition that is very rare, but a recent change
in the kernel caused this to happen more frequently: about 1 in 50
times.

To fix this, don't bother trying to open the md device for CREATE and
ASSEMBLE commands, as the file descriptor will never be used anyway
even if it is successfully openned.

Side note: it would be nice to disable create_on_open as well to help
solve this, but it seems the work for this was never finished. By default,
mdadm will create using the old node interface when a name is specified
unless the user specifically puts names=yes in a config file, which
doesn't seem to be very common yet.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 mdadm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index 56722ed997a2..3b886b5c0639 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1347,8 +1347,7 @@ int main(int argc, char *argv[])
 	 * an md device.  We check that here and open it.
 	 */
 
-	if (mode == MANAGE || mode == BUILD || mode == CREATE ||
-	    mode == GROW || (mode == ASSEMBLE && ! c.scan)) {
+	if (mode == MANAGE || mode == BUILD || mode == GROW) {
 		if (devs_found < 1) {
 			pr_err("an md device must be given in this mode\n");
 			exit(2);
-- 
2.30.2

