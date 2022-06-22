Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514E9C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiFVUZv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiFVUZf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:35 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3EF36B6A
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=g9PZt9mIeE3qPJDoJLsVDb502wp3/KMKsBka6HhiMVk=; b=FbjAj3qQw2eMSo72pSVTxFSR9o
        eE3ITddmJx0DNM74AsnE6bxs0XRDGHjc8C+doRaqpbbsLaUI4jJ8o+AK22DRQORgxKaTS4eXeMmMi
        Snvh0I/2WnxhzozF2c9dgqMXkEUpA9+RKDSQFcem7gd7xEkLbQdphv5hghfEN9DqKdvLtXijwNZAd
        HDPbajoh3gYZry1v3VMiYIn6Nm5m0Tq5Dzw6/w8pQd9VDBuX6973tepaj4ncJx2ZITGPLr7/2z17N
        OYWuRDv4cbNNwLJfe8rl5zio2lj1KRhtbs4JbPKXdCS3IKOcWL3/n9ejxFI3tWf10K7ZTl4ZMyXBn
        SFPj4YzQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uo-00EGyY-Cu; Wed, 22 Jun 2022 14:25:31 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uh-0009MP-DD; Wed, 22 Jun 2022 14:25:23 -0600
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
        Wu Guanghao <wuguanghao3@huawei.com>
Date:   Wed, 22 Jun 2022 14:25:11 -0600
Message-Id: <20220622202519.35905-7-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, wuguanghao3@huawei.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 06/14] mdadm: Fix mdadm -r remove option regression
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The commit noted below globally adds a parameter to the -r option but missed
the fact that -r is used for another purpose: --remove.

After that commit, a command such as:

  mdadm /dev/md0 -r /dev/loop0

will do nothing seeing the device parameter will be consumed as a
argument to the -r option; thus, there will only be one device
seen one the command line, devs_found will only be 1 and nothing will
happen.

This caused the 01r5integ and 01raid6integ tests to hang indefinitely
as mdadm did not remove the failed device. With the device not removed,
it would not be readded. Then the loop waiting for the array status to
change would loop forever.

This commit was recently reverted, but the legitimate fix for the
monitor operations was still not fixed. So add specific monitor
short ops to re-fix the --monitor -r option.

Fixes: 546047688e1c ("mdadm: fix coredump of mdadm --monitor -r")
Fixes: 190dc029b141 ("Revert "mdadm: fix coredump of mdadm --monitor -r"")
Cc: Wu Guanghao <wuguanghao3@huawei.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 ReadMe.c | 1 +
 mdadm.c  | 1 +
 mdadm.h  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/ReadMe.c b/ReadMe.c
index bec1be9ab26f..7518a32a9869 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -82,6 +82,7 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
  */
 
 char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
+char short_monitor_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k:";
 char short_bitmap_options[]=
 		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_auto_options[]=
diff --git a/mdadm.c b/mdadm.c
index be40686cf91b..d0c5e6def901 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -227,6 +227,7 @@ int main(int argc, char *argv[])
 			shortopt = short_bitmap_auto_options;
 			break;
 		case 'F': newmode = MONITOR;
+			shortopt = short_monitor_options;
 			break;
 		case 'G': newmode = GROW;
 			shortopt = short_bitmap_options;
diff --git a/mdadm.h b/mdadm.h
index d53df1697f88..05ef881f4709 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -419,6 +419,7 @@ enum mode {
 };
 
 extern char short_options[];
+extern char short_monitor_options[];
 extern char short_bitmap_options[];
 extern char short_bitmap_auto_options[];
 extern struct option long_options[];
-- 
2.30.2

