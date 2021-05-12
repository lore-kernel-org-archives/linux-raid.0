Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E966C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 08:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1614F6121E
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 08:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhELI7J (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 04:59:09 -0400
Received: from outbound5c.eu.mailhop.org ([3.125.148.246]:47943 "EHLO
        outbound5c.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhELI7I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 04:59:08 -0400
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2021 04:59:07 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1620808917; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=jBYeoCYxoLVy+oLNckmxv2gZF2rTy4fx+RnpOdQVg66mpSNBg03lD0UbH6vh87qy8h4VOLegkyMMK
         EwNPEcpT5VzzPHKZYLpzqUtlkaIWX5hNYH+Pr0cRJRQhXxXK4U3Kz2dxZ+GwWd+FWR4Fq8uP7Ddd+w
         u1yq8Bq5tDU1aLTL/78iWSyViLvCjC9Yj99HCXQg9MnW7xQtOAgO2UG1N+sKGXpvmoPGH8as8eWnqe
         uD9EmqxvXtbQotW272OtQlJkYCD4AlhawSzEFbJd8uVsJpq4Kl0GVt3rc6L3nyY9o9C6TT4Dk1vr+d
         qAmH2vMGg4/ZRHXhnKaFKQJ4iUxOioQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:mime-version:date:message-id:subject:
         from:cc:to:dkim-signature:from;
        bh=5K285XMBVcLfy95LgcVp6KHNfUmXi0cjj8QUMsYknnQ=;
        b=Ek+BcXWyH2R9gAJPbFtLOKTYQJkv4KZ1zl7p7AvGmVTqhdHkNIAwPpYpUj1fy3d2BOhJ9PiwL2iCz
         DzTxUcaSPshDvuyZ4EIPLaZ3DLC1+npTpeU9owv7hb4Y5pZeWxriNG16OCaUrZXEEZTlo16pL1YR2v
         +TOJdaZDrsgObmAsdhe1mK2gfMGArE31H5CQqEh4fU1ibiqVaSMFvFYa04dQPJ9EH31Z5BxjZjpffm
         PegQJqMl0znwgj/r9F98ngi3mPhoSV89N72mo7u+rC5Y/UFcwcNGg05A3ObmzBrK+o1iWQMxZzo1ko
         tHlvGARPD1zFWM/SSyeVpp2/vHXIC9Q==
ARC-Authentication-Results: i=1; outbound3.eu.mailhop.org;
        spf=pass smtp.mailfrom=demonlair.co.uk smtp.remote-ip=81.143.99.161;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:mime-version:date:message-id:subject:
         from:cc:to:from;
        bh=5K285XMBVcLfy95LgcVp6KHNfUmXi0cjj8QUMsYknnQ=;
        b=oRTyR81yWjv+og4nv0CSzBWnOGOU8IFWZnzaVVd0ekyCCT+IMfz/WIOGDquLnTszol4Mc+6dQlxVA
         3VgwftElc3eybwjbEAKAZ/kLTr12oNTUadQYAgie/ZLEd+CfyqKI3b0oV7uBZCj9wIHjoOAGPrhm9y
         U+F1/MrDJJxKxyo8X5aw03ohTEQ5zgrPkPOsyoE2SAkAq9uVnkYKRXwZh5xlC2IQmoA/1ZIvN6wuQq
         fxByxMzmMa3sLfmFvY3C3GRRVnKqg9ETcrDgf3YN10yOcheo0gGJeBzx+mjpDBYCuWor+IVKcVjczX
         jV3LKNFRTs0Cq21CBn42KgAm1cHg8jg==
X-Originating-IP: 81.143.99.161
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: e78bf876-b2fd-11eb-a3fe-d17a12b91375
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from mars.demonlair.co.uk (host81-143-99-161.in-addr.btopenworld.com [81.143.99.161])
        by outbound3.eu.mailhop.org (Halon) with ESMTPA
        id e78bf876-b2fd-11eb-a3fe-d17a12b91375;
        Wed, 12 May 2021 08:41:54 +0000 (UTC)
Received: from [10.57.1.96] (mercury.demonlair.co.uk [10.57.1.96])
        by mars.demonlair.co.uk (Postfix) with ESMTP id 555121FC186;
        Wed, 12 May 2021 09:41:54 +0100 (BST)
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
From:   Geoff Back <geoff@demonlair.co.uk>
Subject: Patch to fix boot from RAID-1 partitioned arrays
Message-ID: <d9e1f759-3a11-1d63-f16c-8b999190c633@demonlair.co.uk>
Date:   Wed, 12 May 2021 09:41:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good morning.

I have had problems in all recent kernels with booting directly from MD 
RAID-1 partitioned arrays (i.e. without using an initrd).
All the usual requirements - building md and raid1 into the kernel, 
correct partition types, etc - are correct.

Deep investigation has led me to conclude that the issue is caused by 
boot-time assembly of the array not reading the partition table, meaning 
that the partitions are not visible and cannot be mounted as root 
filesystem.

The change to drivers/md/md-autodetect.c in commit 
a1d6bc018911390274e3904bdd28240cd96ddc54 appears to be related, although 
this only covers some cases not all, so I have not been able to 
determine exactly what commit led to this problem.

I have implemented a patch that causes the partition table to be read 
immediately after the array is started, for the two boot-time assembly 
paths (from autodetect with raid=part, and from assembly with md=d0,...) 
which is included below.

Regards,

Geoff.

diff -Naur linux-5.12.2.orig/drivers/md/md-autodetect.c 
linux-5.12.2/drivers/md/md-autodetect.c
--- linux-5.12.2.orig/drivers/md/md-autodetect.c    2021-05-12 
09:14:07.096442083 +0100
+++ linux-5.12.2/drivers/md/md-autodetect.c    2021-05-12 
09:22:07.734653840 +0100
@@ -232,8 +232,24 @@
      mddev_unlock(mddev);
  out_blkdev_put:
      blkdev_put(bdev, FMODE_READ);
-}

+    /*
+     * Need to force read of partition table in order for partitioned
+     * arrays to be bootable.  Deliberately done after all cleanup,
+     * and only for successfully loaded arrays.
+     */
+    if (err == 0)
+    {
+        struct block_device *bd;
+
+        bd = blkdev_get_by_dev(mdev, FMODE_READ, NULL);
+        if (IS_ERR(bd))
+            pr_err("md: failed to get md device\n");
+        else
+            blkdev_put(bd, FMODE_READ);
+    }
+}
+
  static int __init raid_setup(char *str)
  {
      int len, pos;
diff -Naur linux-5.12.2.orig/drivers/md/md.c linux-5.12.2/drivers/md/md.c
--- linux-5.12.2.orig/drivers/md/md.c    2021-05-12 09:14:07.127441838 +0100
+++ linux-5.12.2/drivers/md/md.c    2021-05-12 09:34:26.960827487 +0100
@@ -6467,6 +6467,20 @@
          pr_warn("md: do_md_run() returned %d\n", err);
          do_md_stop(mddev, 0, NULL);
      }
+    else
+    {
+        /*
+         * Need to force read of partition table in order for partitioned
+         * arrays to be bootable.
+         */
+        struct block_device *bd;
+
+        bd = blkdev_get_by_dev(mdev, FMODE_READ, NULL);
+        if (IS_ERR(bd))
+            pr_err("md: failed to get md device\n");
+        else
+            blkdev_put(bd, FMODE_READ);
+    }
  }

  /*



-- 
Geoff Back
What if we're all just characters in someone's nightmares?

