Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA75C433B4
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 16:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9232D6115A
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 16:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbhDBQBP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 12:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236096AbhDBQBO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 2 Apr 2021 12:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A66B61184
        for <linux-raid@vger.kernel.org>; Fri,  2 Apr 2021 16:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617379273;
        bh=vj5+iwAMbfGvuq//cjwc3HFmnDjVAadxNu6npXcG2E0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b/kaWe+kRFLqN5GypANyE6PsnIKqVbKjhUGUw7APV8muKxswt07GWMJEW8VT1x7/y
         L3w6vYu2S1LxahBKjxLeC7qXotxHAYozOqlBYVMPJHTZD/4VjvRReEoLqpP7JDCUnF
         xZZ3vxqJ/0A8PHzVRTrhpCoZMpYqi95N8ParTNgYwuF5y9JtMTohNuaAQMZhQ4czCQ
         4JvApVczZ23CZutzsGAxCzTY66wSQqGOHsTQ1OGOtSRjbJReE9n9QkMaD9VT143lFD
         VVoIKJmA6CWKI6L4m3W2+IZsYRW92+sk+YFyhh4yEy/vXbIhOGeWYllsNmFiGhkz8Q
         WDwA64JgEZPaw==
Received: by mail-lf1-f50.google.com with SMTP id m12so8155630lfq.10
        for <linux-raid@vger.kernel.org>; Fri, 02 Apr 2021 09:01:13 -0700 (PDT)
X-Gm-Message-State: AOAM531aTrJX+cl4lMHSfaIf4grzrYutm+87ZoWp9qJtVt+G2UuCB2dl
        GCzhAJiGeOVD9IiGeXGXE+SrbvvlEzhy18l4kQ4=
X-Google-Smtp-Source: ABdhPJyv7uyaTZ0/Rz/dBhCmhxF62EfJf9QzBGjYU/hWHLRccrdvi3Azqjg4g6T6HhjIYP3ocdAix9heIPLgmckKG+A=
X-Received: by 2002:a19:bce:: with SMTP id 197mr9152340lfl.281.1617379271389;
 Fri, 02 Apr 2021 09:01:11 -0700 (PDT)
MIME-Version: 1.0
References: <1617240896-15343-1-git-send-email-heming.zhao@suse.com>
 <20210401061722.GA1355765@infradead.org> <a96554cc-abbd-347c-ea24-37d2a41e6073@suse.com>
 <CAPhsuW6_9av6H=1LkD5qqpyOcA8j2jj8d660FUpadn3Jfd79Vw@mail.gmail.com> <b2288ab4-1da0-612d-8988-637cc33db99a@suse.com>
In-Reply-To: <b2288ab4-1da0-612d-8988-637cc33db99a@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 2 Apr 2021 09:01:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6RKA66Nj6ncW3+dmx6tjEzP4yZnifQiyHPoy1NSdM_7w@mail.gmail.com>
Message-ID: <CAPhsuW6RKA66Nj6ncW3+dmx6tjEzP4yZnifQiyHPoy1NSdM_7w@mail.gmail.com>
Subject: Re: [PATCH v2] md: don't create mddev in md_open
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Apr 2, 2021 at 1:58 AM heming.zhao@suse.com
<heming.zhao@suse.com> wrote:
>
> On 4/2/21 1:58 PM, Song Liu wrote:
> > On Thu, Apr 1, 2021 at 6:03 AM heming.zhao@suse.com
> > <heming.zhao@suse.com> wrote:
> >>
> >> On 4/1/21 2:17 PM, Christoph Hellwig wrote:
> >>> On Thu, Apr 01, 2021 at 09:34:56AM +0800, Zhao Heming wrote:
> >>>> commit d3374825ce57 ("md: make devices disappear when they are no longer
> >>>> needed.") introduced protection between mddev creating & removing. The
> >>>> md_open shouldn't create mddev when all_mddevs list doesn't contain
> >>>> mddev. With currently code logic, there will be very easy to trigger
> >>>> soft lockup in non-preempt env.
> >>>
> >>> As mention below, please don't make this even more of a mess than it
> >>> needs to.  We can just pick the two patches doing this from the series
> >>> I sent:
> >>>
> >>
> >> Hi,
> >>
> >> I already got your meaning on previously email.
> >> I sent v2 patch for Song's review comment. My patch is bugfix, it may need
> >> to back port into branch maintenance.
> >>
> >> Your attachment patch files is partly my patch.
> >> The left part is in md_open (response [PATCH 01/15] md: remove the code to flush
> >> an old instance in md_open)
> >> I still think you directly use bdev->bd_disk->private_data as mddev pointer is not safe.
> >>
> >
> > Hi Christoph and Heming,
> >
> > Trying to understand the whole picture here. Please let me know if I
> > misunderstood anything.
> >
> > IIUC, the primary goal of Christoph's set is to get rid of the
> > ERESTARTSYS hack from md,
> > and eventually move bd_mutext. 02/15 to 07/15 of this set cleans up
> > code in md.c, and they
> > are not very important for the rest of the set (is this correct?).
> >
> > Heming, you mentioned "the solution may simply return -EBUSY (instead
> > of -ENODEV) to
> > fail the open path". Could you please show the code? Maybe that would
> > be enough to unblock
> > the second half of Christoph's set (08/15 to 15/15)?
> >
>
> I already sent the whole picture of md_open (email data: 2021-4-1,
> subject: Re: [PATCH] md: don't create mddev in md_open).
> My mail may fail to be delivered (at least, I got the "can't be delivered"
> info on my last mail for linux-raid & guoqing's address). I put the related
> email on attachment, anyone can read it again.
>
> For the convenience of discussion, I also pasted **patched** md_open below.
> (I added more comments than enclosed email)
>
> ```
> static int md_open(struct block_device *bdev, fmode_t mode)
> {
>     /* section 1 */
>     struct mddev *mddev = mddev_find(bdev->bd_dev); //hm: the new style, only do searching job
>     int err;
>
>     if (!mddev) //hm: this will cover freeing path 2.2 (refer enclosed file)
>         return -ENODEV;
>
>     if (mddev->gendisk != bdev->bd_disk) { //hm: for freeing path 2.1 (refer enclosed file)
>         /* we are racing with mddev_put which is discarding this
>          * bd_disk.
>          */
>         mddev_put(mddev);
>         /* Wait until bdev->bd_disk is definitely gone */
>         if (work_pending(&mddev->del_work))
>             flush_workqueue(md_misc_wq);
>         return -EBUSY; //hm: fail this path. it also makes __blkdev_get return fail, userspace can try later.
>                        //
>                        // the legacy code flow:
>                        //   return -ERESTARTSYS here, later __blkdev_get reentry.
>                        //   it will trigger first 'if' in this functioin, then
>                        //   return -ENODEV.
>     }
>
>     /* section 2 */
>     /* hm: below same as Christoph's [PATCH 01/15] */
>     err = mutex_lock_interruptible(&mddev->open_mutex);
>     if (err)
>         return err;
>
>     if (test_bit(MD_CLOSING, &mddev->flags)) {
>         mutex_unlock(&mddev->open_mutex);
>         return -ENODEV;
>     }
>
>     mddev_get(mddev);
>     atomic_inc(&mddev->openers);
>     mutex_unlock(&mddev->open_mutex);
>
>     bdev_check_media_change(bdev);
>     return 0;
> }
> ```
>
> I wrote again:
> > Christoph's patch [01/15] totally dropped <section 1>, and use bdev->bd_disk->private_data
> > to get mddev pointer, it's not safe.
>
> And with above **patched** md_open, Christoph's patches 02-07 can be work happily.
> He only needs to adjust/modify 01 patch.
> The md layer behavior will change from return -ENODEV to -EBUSY in some racing scenario.

Thanks for the explanation.

Could you please send official patch of modified 01/15 and your fix
(either in a set or merge into
one patch)? This patch(set) would go to stable. Then, we can apply
Christoph's 02 - 15 on top of
it.

Thanks,
Song
