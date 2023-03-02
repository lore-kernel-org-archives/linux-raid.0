Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15558C6FA8E
	for <linux-raid@archiver.kernel.org>; Thu,  2 Mar 2023 15:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjCBPxB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Mar 2023 10:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCBPw7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Mar 2023 10:52:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB03639280
        for <linux-raid@vger.kernel.org>; Thu,  2 Mar 2023 07:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677772333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cmCzTmxHV2uZj5pqTfuzTfxAnXBSwmjg8GrPIqmTNhY=;
        b=EekR3C7oocjFD4NvW35sM2l5qMx9ZjRKUSYDuIExjs1K983mhPAlEsi/B1HlrKhO46x9cp
        HaLlHXnRdGXX7v7AT8NS2u56Lg9hy9dSDVmwOJzOKy4H5Ub5RsNLnoOBuT+7B1fYKSBZu6
        kLWVAta0R5Lx21regL72zVKCR6PAKXI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-652-5RyxPDeXOuakWh0v500V7Q-1; Thu, 02 Mar 2023 10:52:11 -0500
X-MC-Unique: 5RyxPDeXOuakWh0v500V7Q-1
Received: by mail-pf1-f197.google.com with SMTP id z19-20020a056a001d9300b005d8fe305d8bso9012306pfw.22
        for <linux-raid@vger.kernel.org>; Thu, 02 Mar 2023 07:52:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cmCzTmxHV2uZj5pqTfuzTfxAnXBSwmjg8GrPIqmTNhY=;
        b=3sfONm0k7dBHXMSptcFSJWL2RDV10k52bhKH1+6vZaiMlKoZ87d46RxkKJNc/8NAIC
         YhlI3e46u9RpsAZLq2W/MXgODj7atGlvIKjufXcRKLVJxG2KA54M94meBU3T0r5tNrQM
         Ziqon4Vg65O0ivxgHXNISlY/iFxLKe06zxTaesCVbv0hwNFUbsztT2VLrnVlA3iCjDy7
         EVbqoY4Aj7gR+/NWwffyhfgj4nroC24I/dBR1whWBKpI1lh6umrnCVX2xo8sLQ1c0QRO
         07AmfYYHKngpXLnDVvtfnuL1b3f2B7JC8D6lCNIU0XMGqDgccZwQAX84qI3dzeIbkkDL
         kemQ==
X-Gm-Message-State: AO0yUKUSp055O7wFShG6SBOCjNM3G0GWd5I2UWsCHAIXcDMMF8pP0eof
        VexgaoWpzreGq2GExpyYDgbY3XY2dbfspDDdw4Y3Pw+Aa5w90bsTDdDiyslpb7m0mLYHTUbqRqD
        0/FPwx4FlUyPkWf67lxIj8QzmgL5tH4irTKq5aQ==
X-Received: by 2002:a17:902:7fc2:b0:19a:e96a:aff5 with SMTP id t2-20020a1709027fc200b0019ae96aaff5mr3990173plb.1.1677772330680;
        Thu, 02 Mar 2023 07:52:10 -0800 (PST)
X-Google-Smtp-Source: AK7set84bdlQzWmK+wk9IEBpzXcwddHUsETeO+nhg6uYIAugfoA5oA5scCMbTueParzRbW6+lSNz+U9/lTZeJMgMwDI=
X-Received: by 2002:a17:902:7fc2:b0:19a:e96a:aff5 with SMTP id
 t2-20020a1709027fc200b0019ae96aaff5mr3990160plb.1.1677772330386; Thu, 02 Mar
 2023 07:52:10 -0800 (PST)
MIME-Version: 1.0
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 2 Mar 2023 23:51:59 +0800
Message-ID: <CALTww28pEdW+f1SaXrG7Umf8uA6fAc9io-WKb_W8mVxEzW8EzA@mail.gmail.com>
Subject: The gendisk of raid can't be released
To:     Christoph Hellwig <hch@infradead.org>, Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Christoph

There is a regression problem which is introduced by 84d7d462b16d
(blk-cgroup: pin the gendisk in struct blkcg_gq).

The test commands below can reproduce this:
mdadm -CR /dev/md0 -l10 -n4 /dev/nvme[0-3]n1 --assume-clean
mdadm --stop /dev/md0
mdadm -CR /dev/md0 -l10 -n4 /dev/nvme[0-3]n1 --assume-clean
mdadm: Fail to create md0 when using
/sys/module/md_mod/parameters/new_array, fallback to creation via node
mdadm: unexpected failure opening /dev/md0

The reason is that the gendisk kobj can't be released, so md_free_disk
can't be called. It looks like the patch mentioned above doesn't have
problem. Before this patch, it didn't add the reference to the kobj of
the gendisk. So all things work well. Now it adds the reference to
the kobj of the gendisk in blkg_alloc, but it can't be decremented in
blkg_release. After adding some debug logs, it only adds the reference
of blkg->refcnt, but it doesn't call blkcg_rstat_flush which calls
percpu_ref_put.

So the patch 84d7d462b16d only exposes the reference problem in
block cgroup.

Best Regards
Xiao

