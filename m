Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263EDC433ED
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 09:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDBAF611BE
	for <linux-raid@archiver.kernel.org>; Wed, 12 May 2021 09:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhELJ2t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 May 2021 05:28:49 -0400
Received: from outbound5i.eu.mailhop.org ([35.156.234.212]:12545 "EHLO
        outbound5i.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhELJ2s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 May 2021 05:28:48 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2021 05:28:48 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1620810698; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=fYtAVb0jg/0YRw43SZg3TJ+t4B7cxtLE5/HuRfJDyhsjNBc87blyvlD4C/whSLC343XC/5M8Njwcy
         7E9swjKvBIqIJVcarPJT3R8grYQMKh2/Lf3PbHyd6rh9xdZ7XzTYfjI08qSctlVIevFwEP20DZr4WI
         ytEgiCvHnHWua79csVxuCKrJL0WlJQ07j3/oIKz88LH0GN6641w2ZJz62kfszkLAxyt8oX1XjsWFKA
         W5UWDqL9uJniWQ5eXUPL6V/IgLAk/ksYi9ucCJWqGe28iXo3yaPfNUil2SzE+NbvpD5q08YjiNK17+
         u9aPr36/pevtWDUm/sqQZMxF7MXIZ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version:date:
         message-id:references:cc:to:from:subject:dkim-signature:from;
        bh=5Oal0bZ9MT/Kmoej6c9ET4NbPayUalV7QgplvCu3GB4=;
        b=rJiVTcYqDSOphq4RbyfojtyTwsP6iK+tYw6cPjhkfddGJ5e1EURhDCtEGAOrCmeDbsY/TpTrHWi2M
         CPtO1D9PL58EpBTarRsLGB7UaSp1+HBYLGBKquAeACT1nEzB4rV4iAofoimk8IZ2TgYLnoPx9+jFcA
         sgYaf1p/EUj590OMYWyl/dxbklnowtN74MdTRWJZnPh71mETqBQ2eKH7vVzPnpa2LmTC/gh+OOoLgZ
         B9gpt07QuThMWY2r/Bc5VeOrTYtjrr+uDCxMOvB7QDoi20J61HMCWoIC7PvI/GNdZ4oPzqTLSg72V0
         X0FkC7Mv1zpr9Rn5G/ma/89vKw311sA==
ARC-Authentication-Results: i=1; outbound2.eu.mailhop.org;
        spf=pass smtp.mailfrom=demonlair.co.uk smtp.remote-ip=81.143.99.161;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version:date:
         message-id:references:cc:to:from:subject:from;
        bh=5Oal0bZ9MT/Kmoej6c9ET4NbPayUalV7QgplvCu3GB4=;
        b=BLxsuuKgW4rRjerN9tu2JSq8DFg4EPp1oI/RVeviqLfAs2JFbE5Cpufjc9JdZELpfdtoWIgZxxqU9
         c2P3PwE4CcdNh7AjRQ3muW/BgPm2JOM4BtEEVXbJE/SKRtfXhfoKvg9cVv4nBwB61LN6+FG0kavtBV
         wHELXxQqrUEKtGR3Gslf2+Lyg0Z+1/7xEqjWAfscNw9jsnfMSqOfqTr1AUE2JATEd3q/6ikez3YU4R
         t/rYwLxkgLA79kHbdDBhG+4TheZsyrU+Pam66rca6ZXH4PSdfGfVq1ZnTxYJN9ScvBwLNFS52ukAfP
         mi2fD9WAN63abYuWOqRArsi99+gtmZQ==
X-Originating-IP: 81.143.99.161
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: 0d943571-b302-11eb-a04c-973b52397bcb
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from mars.demonlair.co.uk (host81-143-99-161.in-addr.btopenworld.com [81.143.99.161])
        by outbound2.eu.mailhop.org (Halon) with ESMTPA
        id 0d943571-b302-11eb-a04c-973b52397bcb;
        Wed, 12 May 2021 09:11:36 +0000 (UTC)
Received: from [10.57.1.96] (mercury.demonlair.co.uk [10.57.1.96])
        by mars.demonlair.co.uk (Postfix) with ESMTP id 3D43E1FC186;
        Wed, 12 May 2021 10:11:36 +0100 (BST)
Subject: Re: Patch to fix boot from RAID-1 partitioned arrays
From:   Geoff Back <geoff@demonlair.co.uk>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
References: <d9e1f759-3a11-1d63-f16c-8b999190c633@demonlair.co.uk>
Message-ID: <96965d06-f284-a106-0897-3ceb8b6558a4@demonlair.co.uk>
Date:   Wed, 12 May 2021 10:11:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d9e1f759-3a11-1d63-f16c-8b999190c633@demonlair.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

Apologies, just spotted a typo in my patch.  Updated patch below.
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
--- linux-5.12.2.orig/drivers/md/md.c    2021-05-12 09:14:07.127441838 
+0100
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
+        bd = blkdev_get_by_dev(mddev->unit, FMODE_READ, NULL);
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


