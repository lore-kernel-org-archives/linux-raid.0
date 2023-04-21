Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05ECAC7618E
	for <linux-raid@archiver.kernel.org>; Fri, 21 Apr 2023 10:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjDUKp2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Apr 2023 06:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjDUKp0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Apr 2023 06:45:26 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CE69016
        for <linux-raid@vger.kernel.org>; Fri, 21 Apr 2023 03:45:24 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f178da21b5so11070265e9.3
        for <linux-raid@vger.kernel.org>; Fri, 21 Apr 2023 03:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682073923; x=1684665923;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QGO8tJzaq5Ckyew1VqOJukCjoia4S1t87VkO8sAjhVM=;
        b=bqiu4PVxrACFQUPzyRn6LFV25Z8qqWhFBezyiEDQOhFiz2gMe7ptsVlABBDMK57Ct5
         p8h0+4+Xset1G42WfWdEnQH2xaGRYEsIBcpdl9HVP2ARy4IiVeA9ORyjlGUXABd1n5QZ
         9EfpdZlTSBl0i8RH60bbFHSzP+hfxCpT4PqD1XiBOV/u0dHXjUNPMkdyTpP/lJZSxEqn
         d3iKXmbWCS67j1gRDFKhNAR1Cm16IvHTeLXaTZCJs9qhohzzHfg/8fZlzCyf90j9z4Dz
         23NC42lHbGZzNhyzRO/bZGt1+eMbG7DjJ9QbY/qWftn8YwbMsE4MR1Oot9Z1cOX7eSfn
         6T3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682073923; x=1684665923;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QGO8tJzaq5Ckyew1VqOJukCjoia4S1t87VkO8sAjhVM=;
        b=FaYLVoadZGWxd7rp0FPsOFoAawJsRHzIr3eGJifWEUVU9WmVUt8YjVRi57i1923MZ3
         QNUmajMKePTU7mA8NVV4rEplqSG/d74uZpHoC4+NVqwQxx/rzMWY30FZirSyoufjSY06
         kEajz6G89MxZzghfLrp78UpbYVFrWvl2Qe/okVW1R9JuDecgM7YD+QjjygnxMWEmSn0d
         n/jqBIGPW5n25DUusaHj5u17yEnPSdivUzx220wHxbjM1JFtVwcGgwylOh7TTiV+xqLF
         NoxLa9dnOlOQVX3arJtr24tlRhYiAZMbdea1nq019zo2DUwLrxlg2JFzfKHjax4tbg34
         Uskw==
X-Gm-Message-State: AAQBX9dRNDKseSfrn8jcHTAYomVYlmMujjIjrq8gMULbLNb5mvrDZOQG
        yROac8ksogy5ZahIr3rWNqiIkOtSnOsHAQb4BH0=
X-Google-Smtp-Source: AKy350YqZme1GT786fqfmxeuS59JkEFCoLvEfmHZgo+WF3dJSGpV+AH6UxuOB23LkEI0hEoT5Tw2Uw==
X-Received: by 2002:a05:600c:284:b0:3f1:8173:fc1a with SMTP id 4-20020a05600c028400b003f18173fc1amr1453155wmk.28.1682073923047;
        Fri, 21 Apr 2023 03:45:23 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h19-20020a05600c351300b003f1958eeadcsm375256wmq.17.2023.04.21.03.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 03:45:22 -0700 (PDT)
Date:   Fri, 21 Apr 2023 13:45:20 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     jonathan.derrick@linux.dev
Cc:     linux-raid@vger.kernel.org
Subject: [bug report] md: Fix types in sb writer
Message-ID: <2dc52026-8261-49da-90c8-55cd5c5c6959@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Jon Derrick,

The patch 10172f200b67: "md: Fix types in sb writer" from Feb 24,
2023, leads to the following Smatch static checker warning:

	drivers/md/md-bitmap.c:265 __write_sb_page()
	warn: unsigned 'offset' is never less than zero.

drivers/md/md-bitmap.c
    234 static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
    235                            struct page *page)
    236 {
    237         struct block_device *bdev;
    238         struct mddev *mddev = bitmap->mddev;
    239         struct bitmap_storage *store = &bitmap->storage;
    240         sector_t offset = mddev->bitmap_info.offset;
                ^^^^^^^^
offset used to be llof_t which is s64.

    241         sector_t ps, sboff, doff;
    242         unsigned int size = PAGE_SIZE;
    243         unsigned int opt_size = PAGE_SIZE;
    244 
    245         bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
    246         if (page->index == store->file_pages - 1) {
    247                 unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
    248 
    249                 if (last_page_size == 0)
    250                         last_page_size = PAGE_SIZE;
    251                 size = roundup(last_page_size, bdev_logical_block_size(bdev));
    252                 opt_size = optimal_io_size(bdev, last_page_size, size);
    253         }
    254 
    255         ps = page->index * PAGE_SIZE / SECTOR_SIZE;
    256         sboff = rdev->sb_start + offset;
    257         doff = rdev->data_offset;
    258 
    259         /* Just make sure we aren't corrupting data or metadata */
    260         if (mddev->external) {
    261                 /* Bitmap could be anywhere. */
    262                 if (sboff + ps > doff &&
    263                     sboff < (doff + mddev->dev_sectors + PAGE_SIZE / SECTOR_SIZE))
    264                         return -EINVAL;
--> 265         } else if (offset < 0) {
                           ^^^^^^^^^^
Now that it's a sector_t this is impossible.

    266                 /* DATA  BITMAP METADATA  */
    267                 size = bitmap_io_size(size, opt_size, offset + ps, 0);
    268                 if (size == 0)
    269                         /* bitmap runs in to metadata */
    270                         return -EINVAL;
    271 
    272                 if (doff + mddev->dev_sectors > sboff)
    273                         /* data runs in to bitmap */
    274                         return -EINVAL;
    275         } else if (rdev->sb_start < rdev->data_offset) {
    276                 /* METADATA BITMAP DATA */
    277                 size = bitmap_io_size(size, opt_size, sboff + ps, doff);
    278                 if (size == 0)
    279                         /* bitmap runs in to data */
    280                         return -EINVAL;
    281         } else {
    282                 /* DATA METADATA BITMAP - no problems */
    283         }
    284 
    285         md_super_write(mddev, rdev, sboff + ps, (int) size, page);
    286         return 0;
    287 }

regards,
dan carpenter
