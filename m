Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB42AC4332F
	for <linux-raid@archiver.kernel.org>; Thu, 22 Dec 2022 08:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiLVISL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Dec 2022 03:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiLVISJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Dec 2022 03:18:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC75F10067
        for <linux-raid@vger.kernel.org>; Thu, 22 Dec 2022 00:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671697040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R79QPZKIRetvP7dENpcF1leEO2IFk9biokbxnaVlMZI=;
        b=Bts3hCs53y19cd1+6L28ADzGACAorTSGkd3KCqsu3sUKMcKw0jn3PiYZHWohaT/jvjhRK4
        ZSpc0xhHOOdXHTIOiZcT1TB7G+9eS6AOhbI9BspBzKTMHnCXfoPmtrNg91n7EgyNbIvDy0
        k9ddLpWTf4jno64nDDFTLgMiv1Ef9uI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-299-JyiUlNfYOwixijemGH_nuA-1; Thu, 22 Dec 2022 03:17:19 -0500
X-MC-Unique: JyiUlNfYOwixijemGH_nuA-1
Received: by mail-pj1-f70.google.com with SMTP id z4-20020a17090ab10400b002195a146546so2767243pjq.9
        for <linux-raid@vger.kernel.org>; Thu, 22 Dec 2022 00:17:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R79QPZKIRetvP7dENpcF1leEO2IFk9biokbxnaVlMZI=;
        b=yDAiRZQ0pfUA1yu0qYk/YuQwc6qAYMgA5qAwSw0OBfHrjzgk1HyUORxJII96Gg+uS0
         XxPGNb3N20IkhAoC+c5pWUh5sIizKzQn1qmO9/wZlkCy2F+X3uMbWLc3QtsOGDylNHaR
         4QOHWtUWa7fP1ZQ6SdEagUpWdv36/fGB72xJhY5paNkfJk0/s3uvMlH80dGW+aZNRqOx
         jWuTIJWLQdPYLBnA1JIUTiIfrz8IYxZmVT55yuHXFUga1NJag+EhSoZGle1Hnc3IHgvn
         d/5qWURw8mjT6ZDz7h26vFiVSVcxvIp6O3dLjZzNt+gcG46BlUFTqvJTEhBCqPn/Li5h
         nRaw==
X-Gm-Message-State: AFqh2kqryqF8nn3P/XwJZd89IhhIB5ZwBLB/Od6iHGzD8aoE094doD0L
        tE2Ba6J9JUreq3i8Sndqcnwa1h/YcW3+ozkkfqf8CP/3MaUt4LNMNyJ7bcSUxE30LFx0LrYIL35
        2o6Hj0uNwwn9LTsKACAiDq4eoIgqGe6i8eR3kFw==
X-Received: by 2002:a63:4041:0:b0:478:bc19:a510 with SMTP id n62-20020a634041000000b00478bc19a510mr283553pga.288.1671697038617;
        Thu, 22 Dec 2022 00:17:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvuVJFNkTvkMcer5fCvVb9SyXK9/6SGy5DwYObkAe4h2J3fNScCvPEjB4DK2adxkmMP0Q3hUmkHr3OiWoTzyT4=
X-Received: by 2002:a63:4041:0:b0:478:bc19:a510 with SMTP id
 n62-20020a634041000000b00478bc19a510mr283550pga.288.1671697038385; Thu, 22
 Dec 2022 00:17:18 -0800 (PST)
MIME-Version: 1.0
References: <20221221063846.20710-1-kinga.tanska@intel.com>
In-Reply-To: <20221221063846.20710-1-kinga.tanska@intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 22 Dec 2022 16:17:07 +0800
Message-ID: <CALTww2-yT8QKUzJ0hagehsAy4Hp2+eMfxk-iW9FiZQz3TeGOSA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Incremental mode: remove safety verification
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org, colyli@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Kinga

For the series, it's ok for me.

Do you want to fix another regression problem? Now we can't set a
member disk as faulty when
array is active.

The original patch is used to make sure the admin doesn't remove the
disk and the raid can't work.
So it doesn't need to check the array state. How about

diff --git a/Manage.c b/Manage.c
index 9d85237ceab5..eee25fd8cda0 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1322,8 +1322,7 @@ bool is_remove_safe(mdu_array_info_t *array,
const int fd, char *devname, const
        sysfs_free(mdi);

        bool is_enough = enough(array->level, array->raid_disks,
-                               array->layout, (array->state & 1),
-                               avail);
+                               array->layout, 1, avail);

        free(avail);
        return is_enough;

Regards
Xiao

On Wed, Dec 21, 2022 at 9:37 PM Kinga Tanska <kinga.tanska@intel.com> wrote:
>
> Changes in incremental mode. Removing verification
> if remove is safe, when this mode is triggered. Also
> moving commit description to obey kernel coding style.
>
> Kinga Tanska (2):
>   incremental, manage: do not verify if remove is safe
>   manage: move comment with function description
>
>  Incremental.c |  2 +-
>  Manage.c      | 79 +++++++++++++++++++++++++++++++--------------------
>  2 files changed, 49 insertions(+), 32 deletions(-)
>
> --
> 2.26.2
>

