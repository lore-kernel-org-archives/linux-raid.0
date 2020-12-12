Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7046FC4361B
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 14:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D8FB20684
	for <linux-raid@archiver.kernel.org>; Sat, 12 Dec 2020 14:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439213AbgLLOoH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Dec 2020 09:44:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727406AbgLLOoH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 12 Dec 2020 09:44:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607784160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ACuS1m8ChMH9QhaRZdfi63NxoJwXWVEGB1SyF+MzNDY=;
        b=ftIm4ZtCLdD/a+1wNJFB54B/LOoyIXJX8/v4NrlO2kE7wrU4nlqTFcXSeqVpjNXpVDxnrs
        ZUiGgfalfYGzIMYlnH0ruZaIDaw2X+5NPhyqooYzlDNJ91e9q02E0+4kJhwwJMHUzNmeyh
        3s145iFvM7vww3M6IFomhhBDVfUUflE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-E1XXpYyxP_OxDy8bWfDMeA-1; Sat, 12 Dec 2020 09:42:35 -0500
X-MC-Unique: E1XXpYyxP_OxDy8bWfDMeA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71B4C1005D44;
        Sat, 12 Dec 2020 14:42:34 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B85371F069;
        Sat, 12 Dec 2020 14:42:30 +0000 (UTC)
Date:   Sat, 12 Dec 2020 09:42:30 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Xiao Ni <xni@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
Subject: Re: [GIT PULL v3] md-fixes 20201212
Message-ID: <20201212144229.GB21863@redhat.com>
References: <D6749568-4ED2-49A7-B0D3-F0969B934BF6@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D6749568-4ED2-49A7-B0D3-F0969B934BF6@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Dec 12 2020 at  4:12am -0500,
Song Liu <songliubraving@fb.com> wrote:

> Hi Jens, 
> 
> Please consider pulling the following changes on top of tag
> block-5.10-2020-12-05. This is to fix raid10 data corruption [1] in 5.10-rc7. 
> 
> Tests run on this change: 
> 
> 1. md raid10: tested discard on raid10 device works properly (zero mismatch_cnt).
> 2. dm raid10: tested discard_granularity and discard_max_bytes was set properly. 
> 
> Thanks,
> Song
> 
> 
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/
> 
> 
> The following changes since commit 7e7986f9d3ba69a7375a41080a1f8c8012cb0923:
> 
>   block: use gcd() to fix chunk_sectors limit stacking (2020-12-01 11:02:55 -0700)
> 
> are available in the Git repository at:
> 
>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
> 
> for you to fetch changes up to 0d5c7b890229f8a9bb4b588b34ffe70c62691143:
> 
>   Revert "md: add md_submit_discard_bio() for submitting discard bio" (2020-12-12 00:51:41 -0800)
> 
> ----------------------------------------------------------------
> Song Liu (7):
>       Revert "dm raid: remove unnecessary discard limits for raid10"
>       Revert "dm raid: fix discard limits for raid1 and raid10"
>       Revert "md/raid10: improve discard request for far layout"
>       Revert "md/raid10: improve raid10 discard request"
>       Revert "md/raid10: pull codes that wait for blocked dev into one function"
>       Revert "md/raid10: extend r10bio devs to raid disks"
>       Revert "md: add md_submit_discard_bio() for submitting discard bio"
> 
>  drivers/md/dm-raid.c |   9 +++++
>  drivers/md/md.c      |  20 ----------
>  drivers/md/md.h      |   2 -
>  drivers/md/raid0.c   |  14 ++++++-
>  drivers/md/raid10.c  | 423 +++++++++++++++++++++++++++++------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>  drivers/md/raid10.h  |   1 -
>  6 files changed, 78 insertions(+), 391 deletions(-)
> 

Jens already pulled 95% of these changes no? why are you sending a pull
that ignores that fact?

And as I stated here:
https://www.redhat.com/archives/dm-devel/2020-December/msg00253.html

I don't agree with reverting commit e0910c8e4f87bb9 ("dm raid: fix
discard limits for raid1 and raid10").  Espeiclaly not like you've done,
given it was marked for stable any follow-on fix/revert needs to be as
well.

Simply changing 'struct mddev' chunk_sectors members from int to
'unsigned int' is the better way forward I think.

Mike

