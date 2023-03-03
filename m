Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE27C64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 14:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCCON3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 09:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjCCON2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 09:13:28 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD1D12059
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 06:13:27 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id u9so10944422edd.2
        for <linux-raid@vger.kernel.org>; Fri, 03 Mar 2023 06:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677852806;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qF9ypWXd9I+kfFlKAtdMHAbqnAvmJ5qXaJx1ob41Ihc=;
        b=PeuthebnzoVV4jqVN488cL9G+p4svCin/4Ku3gruJhr4ZsTuJIHjag3g8bJCJDPz/+
         hk1ZzFBGGH5qeusEIyGjofyphNPC3pxIjpWUqOu5EA1w8wUOgT1923l/CWfsl+kk5APk
         yTVssTbz75u+klF8F5SMi4JuX9fMPYllltu1KPFmfXPsxgs4gHMwnVo4miip0nd9HeOp
         QxC5nb24g88IiJrpKXH4VwE9DILoGMvQPGtrkMETb8CH4eV1SAA3pi8SBYFZwceAD3CE
         YiSO6hbBY7YV730S65ygrpK+DhtgrJnRnemU80SzNnuUD2SFsz6T4tUS6aUQpdR+3Zr1
         4zAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677852806;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qF9ypWXd9I+kfFlKAtdMHAbqnAvmJ5qXaJx1ob41Ihc=;
        b=JgJi1mzgRexmH0SBLRhozdNF4YDUwA4i8cwZbHI4DzM33a5RnJf7a/Lfk+rgXirU+J
         iX9QrCs3bUNDqXhQzD4akWJSXxr6PZDHmFXGXW9J6Dr5bCgCx3qt1Ut3deDgY5lY8MEQ
         g4WPUJ5HYnxdr+4LzX8WRU60fX5UM+nZJo7YDk6iF1sXvQVdiSmu0UbsJJtez7RIshbv
         MMi3FOM5BMbEGPeuZ4Y/KLk2oUzsD3YtNYN0NDDUtUEDxViV1nBjGiE2KpwdZkbE3aIj
         2fNvehJq3Lm/XbvXFr33V1Uqm4fOsdd3P8GSTKdNFy3YBjXHA0FuIeD+R4GyWU08fGEl
         Mmtg==
X-Gm-Message-State: AO0yUKWQoqAa4AcYfUAcNJSBB+4HoxsHMgHCX9YbGkfXni/t2PsY0mTN
        FAW2WPbOpo/pE0MoW0hW2Cw=
X-Google-Smtp-Source: AK7set/qBh8tkRrTWX1Y8p0kGV+un+HEdBzI5+eKe3deX1XpfghiWN644zcvuwlz/kpTjVWhR3SApQ==
X-Received: by 2002:a17:906:33d1:b0:8b1:7ae8:ba79 with SMTP id w17-20020a17090633d100b008b17ae8ba79mr1676145eja.30.1677852806042;
        Fri, 03 Mar 2023 06:13:26 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h17-20020a17090634d100b008ee5356801dsm986944ejb.187.2023.03.03.06.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 06:13:25 -0800 (PST)
Date:   Fri, 3 Mar 2023 17:13:22 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     neilb@suse.de
Cc:     linux-raid@vger.kernel.org, cip-dev <cip-dev@lists.cip-project.org>
Subject: [bug report] md: range check slot number when manually adding a
 spare.
Message-ID: <e664f254-90a0-42df-8fc8-ad808f6dedeb@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[ Ancient code, but you're still at the same email address...  -dan ]

Hello NeilBrown,

The patch ba1b41b6b4e3: "md: range check slot number when manually
adding a spare." from Jan 14, 2011, leads to the following Smatch
static checker warning:

drivers/md/md.c:3170 slot_store() warn: no lower bound on 'slot'
drivers/md/md.c:3172 slot_store() warn: no lower bound on 'slot'
drivers/md/md.c:3190 slot_store() warn: no lower bound on 'slot'

drivers/md/md.c
    3117 static ssize_t
    3118 slot_store(struct md_rdev *rdev, const char *buf, size_t len)
    3119 {
    3120         int slot;
    3121         int err;
    3122 
    3123         if (test_bit(Journal, &rdev->flags))
    3124                 return -EBUSY;
    3125         if (strncmp(buf, "none", 4)==0)
    3126                 slot = -1;
    3127         else {
    3128                 err = kstrtouint(buf, 10, (unsigned int *)&slot);

slot comes from the user.

    3129                 if (err < 0)
    3130                         return err;
    3131         }
    3132         if (rdev->mddev->pers && slot == -1) {
    3133                 /* Setting 'slot' on an active array requires also
    3134                  * updating the 'rd%d' link, and communicating
    3135                  * with the personality with ->hot_*_disk.
    3136                  * For now we only support removing
    3137                  * failed/spare devices.  This normally happens automatically,
    3138                  * but not when the metadata is externally managed.
    3139                  */
    3140                 if (rdev->raid_disk == -1)
    3141                         return -EEXIST;
    3142                 /* personality does all needed checks */
    3143                 if (rdev->mddev->pers->hot_remove_disk == NULL)
    3144                         return -EINVAL;
    3145                 clear_bit(Blocked, &rdev->flags);
    3146                 remove_and_add_spares(rdev->mddev, rdev);
    3147                 if (rdev->raid_disk >= 0)
    3148                         return -EBUSY;
    3149                 set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
    3150                 md_wakeup_thread(rdev->mddev->thread);
    3151         } else if (rdev->mddev->pers) {
    3152                 /* Activating a spare .. or possibly reactivating
    3153                  * if we ever get bitmaps working here.
    3154                  */
    3155                 int err;
    3156 
    3157                 if (rdev->raid_disk != -1)
    3158                         return -EBUSY;
    3159 
    3160                 if (test_bit(MD_RECOVERY_RUNNING, &rdev->mddev->recovery))
    3161                         return -EBUSY;
    3162 
    3163                 if (rdev->mddev->pers->hot_add_disk == NULL)
    3164                         return -EINVAL;
    3165 
    3166                 if (slot >= rdev->mddev->raid_disks &&
    3167                     slot >= rdev->mddev->raid_disks + rdev->mddev->delta_disks)
    3168                         return -ENOSPC;

-1 is valid, but should this check if slot < -1?

    3169 
--> 3170                 rdev->raid_disk = slot;


regards,
dan carpenter
