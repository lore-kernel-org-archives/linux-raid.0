Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6327FC433C1
	for <linux-raid@archiver.kernel.org>; Fri, 19 Mar 2021 23:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21E5B6197B
	for <linux-raid@archiver.kernel.org>; Fri, 19 Mar 2021 23:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCSXAv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 19 Mar 2021 19:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:32932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhCSXAe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 19 Mar 2021 19:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46F7461970
        for <linux-raid@vger.kernel.org>; Fri, 19 Mar 2021 23:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616194834;
        bh=MD0N4UR/1CK4v75w5SUj0D5fSIrNjlOzJrnHP4S+rio=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mBBSpql1lGtNb01fqQdd7vR8i0chZhE0bbZ/Fb8tspdU5hiAIOoJcLorrCEHBuWxt
         6eczALcgdarxmShtaj/BXkTCl8JUcbDwn5zJ6A5I/2Ev5uOAAKy4QANGcwanROwXNC
         wvPdL8bUYLxrvBqvYbPU9N+Ky3kUVfqSe313wLYgU8ud66Dvjnx52iFUXucmbCxrvh
         Ck0tYjPVnJPTI1Jyd4znjBHwg6JDaxBqEzCkuF6pSDlW8wjewibbBFskToTLW00Gw9
         F7TMPDaOVnEC3msYarL8+U87k4RA2eaXvmQx7OTVqoTAZlR5irQr7jeauokbcoE8/0
         xU7ZH6uKo5Vnw==
Received: by mail-lf1-f49.google.com with SMTP id n138so12382151lfa.3
        for <linux-raid@vger.kernel.org>; Fri, 19 Mar 2021 16:00:34 -0700 (PDT)
X-Gm-Message-State: AOAM533GxslfSEvobJhcz5KjlwS+U0TDRbW3EM7AJfclVxzYEIdKyfos
        LmlF9wuEfKokZxyEaf8zwOMYxq7Dtunc0DNdx6c=
X-Google-Smtp-Source: ABdhPJyuYpsBckXvuNGEwrJFRxOMsLjC17aINViOKRnv3rEyRl44Dyv9TvN5AqSbrH/x7YstV/yjnxFmW3yF2TJTtkM=
X-Received: by 2002:a05:6512:3582:: with SMTP id m2mr2121239lfr.10.1616194832629;
 Fri, 19 Mar 2021 16:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de> <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
 <9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
In-Reply-To: <9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 19 Mar 2021 16:00:21 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
Message-ID: <CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex held
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 24, 2021 at 1:26 AM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
>
>
> On 2/24/21 10:09, Song Liu wrote:
> > On Mon, Feb 15, 2021 at 3:08 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >>
> >> [+cc Donald]
> >>
> >> Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
> >>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> >>> doesn't reconfigure array.
> >>>
> >>> And it could cause deadlock problem for raid5 as follows:
> >>>
> >>> 1. process A tried to reap sync thread with reconfig_mutex held after echo
> >>>      idle to sync_action.
> >>> 2. raid5 sync thread was blocked if there were too many active stripes.
> >>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
> >>>      which causes the number of active stripes can't be decreased.
> >>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
> >>>      to hold reconfig_mutex.
> >>>
> >>> More details in the link:
> >>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
> >>>
> >>> And add one parameter to md_reap_sync_thread since it could be called by
> >>> dm-raid which doesn't hold reconfig_mutex.
> >>>
> >>> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
> >>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> >
> > I don't really like this fix. But I haven't got a better (and not too
> > complicated)
> > alternative.
> >
> >>> ---
> >>> V2:
> >>> 1. add one parameter to md_reap_sync_thread per Jack's suggestion.
> >>>
> >>>    drivers/md/dm-raid.c |  2 +-
> >>>    drivers/md/md.c      | 14 +++++++++-----
> >>>    drivers/md/md.h      |  2 +-
> >>>    3 files changed, 11 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> >>> index cab12b2..0c4cbba 100644
> >>> --- a/drivers/md/dm-raid.c
> >>> +++ b/drivers/md/dm-raid.c
> >>> @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
> >>>        if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
> >>>                if (mddev->sync_thread) {
> >>>                        set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> >>> -                     md_reap_sync_thread(mddev);
> >>> +                     md_reap_sync_thread(mddev, false);
> >
> > I think we can add mddev_lock() and mddev_unlock() here and then we don't
> > need the extra parameter?
> >
>
> I thought it too, but I would prefer get the input from DM people first.
>
> @ Mike or Alasdair

Hi Mike and Alasdair,

Could you please comment on this option: adding mddev_lock() and mddev_unlock()
to raid_message() around md_reap_sync_thread()?

Thanks,
Song
