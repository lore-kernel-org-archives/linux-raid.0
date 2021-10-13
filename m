Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35084C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 14:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 150D960E96
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 14:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhJMO3e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 10:29:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235509AbhJMO3e (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 13 Oct 2021 10:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634135250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VVIext3KVvif+yAbmvWrKPlJyxNXz9EcStgL3FWOMp8=;
        b=agkU3v30EyF6LUmbIfG7q+nTfoghw7bUSNwD6WKUElsFSlsMynGxvuxnYGfG91Dl9yZk24
        BZBt3LGDmA65vDAJS1wrlca9bExVHmlZv12G6K0BFRySDWGuo+GXt6CGzMY/MELZMRSqpI
        O9PUVCtOjemHNlzXcDbisOZNDkZMAkA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-I_CEEcaNPw6yXF59HxbCjg-1; Wed, 13 Oct 2021 10:27:29 -0400
X-MC-Unique: I_CEEcaNPw6yXF59HxbCjg-1
Received: by mail-ed1-f70.google.com with SMTP id h19-20020aa7de13000000b003db6ad5245bso2403980edv.9
        for <linux-raid@vger.kernel.org>; Wed, 13 Oct 2021 07:27:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VVIext3KVvif+yAbmvWrKPlJyxNXz9EcStgL3FWOMp8=;
        b=HtraEy1BDSsjbz91Wxm4KHEtHMgtpvltULTc9vzqNVygm+FJpJx3HLN9GanZaDWeQv
         4aqmlQoUCcGERH5zwuKPMd77JKr7nvOnX8Hv5gEQShVzTIYzXdrsPM0b8BWXujGrWvw0
         kQwNkzwf9QCyzA1paGxF2U9IJdMcrxDSQk04kMuGP3/OLZZD4fjdyQnSdWDAg0avGLIe
         MZX/X1MmVdGslYW/uyWzEkzNr8Tc4MUpK+hzRyorhr/l5PYOLqwImoM/L1wltjwRdrwx
         +VJB/EyizdQyf99MW36/e+zh3m88Xra8A0TzV2JFp1nJmcSwLg6qfCiHtv+RnZs2EUS6
         pYSg==
X-Gm-Message-State: AOAM531iotEdUUP9dWKgOIgUBlxElTi4Eu788rprcEQow6RFXhvPEjl1
        6dZISbbbpx1iujJxRvacQ9D++DWawkesvrDnn8DL0c6e//mhaP4EVEDB7dBBuZXJDtd19s/npIw
        XRr2ziUHWsIk+ykhZ6AzQyxk9EvV0X6WAQI8z3A==
X-Received: by 2002:a05:6402:27d0:: with SMTP id c16mr9904919ede.212.1634135247992;
        Wed, 13 Oct 2021 07:27:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfOBZXoKMHPIJjllX9gnaw1zL77ycpX7m9Pqz2GuX5Qx+7dynfvoEjRh3I349kVFGkGpbeS4c1h6gZHmOxggk=
X-Received: by 2002:a05:6402:27d0:: with SMTP id c16mr9904894ede.212.1634135247732;
 Wed, 13 Oct 2021 07:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <1634134851-4275-1-git-send-email-xni@redhat.com>
In-Reply-To: <1634134851-4275-1-git-send-email-xni@redhat.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 13 Oct 2021 22:27:15 +0800
Message-ID: <CALTww2-1qWSjQxb7L0jxq5Z0wWh6EnCNV_=VSYLTd=nF8PNNHw@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: Need to update superblock after changing rdev sb_flags
To:     Song Liu <song@kernel.org>
Cc:     Li Feng <fengli@smartx.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

Please ignore this patch. After thinking, it should be better to call
md_update_sb directly here. So
it doesn't need to consider if mddev->pers is NULL or not. I'll send V2 later

Regards
Xiao

On Wed, Oct 13, 2021 at 10:21 PM Xiao Ni <xni@redhat.com> wrote:
>
> It doesn't update rdev superblock flags to disk after changing these flags.
> This patch does this job. In the process of creating a raid, it creates per
> device sysfs files and then sets value to mddev->pers. There is a interval
> between the two events. If someone changes rdev flags in this interval, it
> needs to record this. So it sets MD_SB_CHANGE_DEVS first. If mddev->pers is
> NULL, it can update superblock after creating mddev->thread.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/md.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6c0c3d0..40d0f50 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2976,7 +2976,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>          *  -write_error - clears WriteErrorSeen
>          *  {,-}failfast - set/clear FailFast
>          */
> +
> +       struct mddev *mddev = rdev->mddev;
>         int err = -EINVAL;
> +       bool need_update_sb = false;
> +
>         if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>                 md_error(rdev->mddev, rdev);
>                 if (test_bit(Faulty, &rdev->flags))
> @@ -2991,7 +2995,6 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>                 if (rdev->raid_disk >= 0)
>                         err = -EBUSY;
>                 else {
> -                       struct mddev *mddev = rdev->mddev;
>                         err = 0;
>                         if (mddev_is_clustered(mddev))
>                                 err = md_cluster_ops->remove_disk(mddev, rdev);
> @@ -3008,10 +3011,12 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>         } else if (cmd_match(buf, "writemostly")) {
>                 set_bit(WriteMostly, &rdev->flags);
>                 mddev_create_serial_pool(rdev->mddev, rdev, false);
> +               need_update_sb = true;
>                 err = 0;
>         } else if (cmd_match(buf, "-writemostly")) {
>                 mddev_destroy_serial_pool(rdev->mddev, rdev, false);
>                 clear_bit(WriteMostly, &rdev->flags);
> +               need_update_sb = true;
>                 err = 0;
>         } else if (cmd_match(buf, "blocked")) {
>                 set_bit(Blocked, &rdev->flags);
> @@ -3037,9 +3042,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>                 err = 0;
>         } else if (cmd_match(buf, "failfast")) {
>                 set_bit(FailFast, &rdev->flags);
> +               need_update_sb = true;
>                 err = 0;
>         } else if (cmd_match(buf, "-failfast")) {
>                 clear_bit(FailFast, &rdev->flags);
> +               need_update_sb = true;
>                 err = 0;
>         } else if (cmd_match(buf, "-insync") && rdev->raid_disk >= 0 &&
>                    !test_bit(Journal, &rdev->flags)) {
> @@ -3118,6 +3125,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>                 clear_bit(ExternalBbl, &rdev->flags);
>                 err = 0;
>         }
> +       if (need_update_sb) {
> +               set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> +               if (mddev->pers)
> +                       md_wakeup_thread(mddev->thread);
> +       }
>         if (!err)
>                 sysfs_notify_dirent_safe(rdev->sysfs_state);
>         return err ? err : len;
> --
> 2.7.5
>

