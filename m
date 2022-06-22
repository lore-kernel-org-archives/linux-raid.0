Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835C1C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 23:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358717AbiFVXBM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 19:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiFVXBL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 19:01:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D3A3EF1D;
        Wed, 22 Jun 2022 16:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4A6761B40;
        Wed, 22 Jun 2022 23:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529D0C341C6;
        Wed, 22 Jun 2022 23:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655938869;
        bh=lmsmTpOSB9w0vu6jej3bavOzhVzJ8bQtqHKHVR00KL4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=j+UzSt6cLcGDBPDahpQWfPg5l+ESjpI0RyeqG+I3V0g8RTUltlUFsoyL1SAx0QxEz
         9y1v0biwXUuCF0St9e7dgZ9Z0ZzU5ENtL6nE6PysLzlekZJLWtFBe66fYcX/k3S0gu
         LyeGqH2LQSXKC+UFZ7GwJNuF4ty0mvcwLKsSoPeeI6hcFLYtTvvdvenDDtSjLdGLtl
         XZpiQEhJjKl++gG5/ZbSfv8mUkUeR5D8t7YZm6UvPC6ScmdlsYUW3dIQN9GT153+TZ
         Dyxl6VG/sdS4xjLiO+OC0/UWec+4qaxIhkTo4Fpf3sJfXXYggM7ilGXYbYJyqEmBdY
         SH0tiOXT/a1fA==
Received: by mail-yb1-f170.google.com with SMTP id t1so32771006ybd.2;
        Wed, 22 Jun 2022 16:01:09 -0700 (PDT)
X-Gm-Message-State: AJIora8MFBW6lrz8KQna5IGtTZR6+oLy3bFGVJVo4Gb/18QqlCNoiYZW
        jMy/3saCgtreLBv2WsztFzxPPxkZgG9gLUZJx/k=
X-Google-Smtp-Source: AGRyM1sn/FDCVEINhVldGVWvlew95jEVW4ir1ZYrkG9uJa8qWckdnhiOkyXuWsg6MbNeyd8BRFkhX/v6g7Hbs9oiA0Q=
X-Received: by 2002:a05:6902:1543:b0:665:493b:e7f5 with SMTP id
 r3-20020a056902154300b00665493be7f5mr6482387ybu.322.1655938868295; Wed, 22
 Jun 2022 16:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com> <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
 <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com> <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>
 <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>
 <d15f352d-41b8-8ade-4724-8370ef17db8d@gmx.com> <165593717589.4786.11549155199368866575@noble.neil.brown.name>
In-Reply-To: <165593717589.4786.11549155199368866575@noble.neil.brown.name>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Jun 2022 16:00:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6CZwhUVw7iE7GhTRkuQmRfu9i+O6_V2C5buTNFvZ76mA@mail.gmail.com>
Message-ID: <CAPhsuW6CZwhUVw7iE7GhTRkuQmRfu9i+O6_V2C5buTNFvZ76mA@mail.gmail.com>
Subject: Re: About the md-bitmap behavior
To:     NeilBrown <neilb@suse.de>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Doug Ledford <dledford@redhat.com>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 22, 2022 at 3:33 PM NeilBrown <neilb@suse.de> wrote:
>
> On Wed, 22 Jun 2022, Qu Wenruo wrote:
> >
> > On 2022/6/22 10:15, Doug Ledford wrote:
> > > On Mon, 2022-06-20 at 10:56 +0100, Wols Lists wrote:
> > >> On 20/06/2022 08:56, Qu Wenruo wrote:
> > >>>> The write-hole has been addressed with journaling already, and
> > >>>> this will
> > >>>> be adding a new and not-needed feature - not saying it wouldn't be
> > >>>> nice
> > >>>> to have, but do we need another way to skin this cat?
> > >>>
> > >>> I'm talking about the BTRFS RAID56, not md-raid RAID56, which is a
> > >>> completely different thing.
> > >>>
> > >>> Here I'm just trying to understand how the md-bitmap works, so that
> > >>> I
> > >>> can do a proper bitmap for btrfs RAID56.
> > >>
> > >> Ah. Okay.
> > >>
> > >> Neil Brown is likely to be the best help here as I believe he wrote a
> > >> lot of the code, although I don't think he's much involved with md-
> > >> raid
> > >> any more.
> > >
> > > I can't speak to how it is today, but I know it was *designed* to be
> > > sync flush of the dirty bit setting, then lazy, async write out of the
> > > clear bits.  But, yes, in order for the design to be reliable, you must
> > > flush out the dirty bits before you put writes in flight.
> >
> > Thank you very much confirming my concern.
> >
> > So maybe it's me not checking the md-bitmap code carefully enough to
> > expose the full picture.
> >
> > >
> > > One thing I'm not sure about though, is that MD RAID5/6 uses fixed
> > > stripes.  I thought btrfs, since it was an allocation filesystem, didn't
> > > have to use full stripes?  Am I wrong about that?
> >
> > Unfortunately, we only go allocation for the RAID56 chunks. In side a
> > RAID56 the underlying devices still need to go the regular RAID56 full
> > stripe scheme.
> >
> > Thus the btrfs RAID56 is still the same regular RAID56 inside one btrfs
> > RAID56 chunk, but without bitmap/journal.
> >
> > >  Because it would seem
> > > that if your data isn't necessarily in full stripes, then a bitmap might
> > > not work so well since it just marks a range of full stripes as
> > > "possibly dirty, we were writing to them, do a parity resync to make
> > > sure".
> >
> > For the resync part is where btrfs shines, as the extra csum (for the
> > untouched part) and metadata COW ensures us only see the old untouched
> > data, and with the extra csum, we can safely rebuild the full stripe.
> >
> > Thus as long as no device is missing, a write-intent-bitmap is enough to
> > address the write hole in btrfs (at least for COW protected data and all
> > metadata).
> >
> > >
> > > In any case, Wols is right, probably want to ping Neil on this.  Might
> > > need to ping him directly though.  Not sure he'll see it just on the
> > > list.
> > >
> >
> > Adding Neil into this thread. Any clue on the existing
> > md_bitmap_startwrite() behavior?
>
> md_bitmap_startwrite() is used to tell the bitmap code that the raid
> module is about to start writing at a location.  This may result in
> md_bitmap_file_set_bit() being called to set a bit in the in-memory copy
> of the bitmap, and to make that page of the bitmap as BITMAP_PAGE_DIRTY.
>
> Before raid actually submits the writes to the device it will call
> md_bitmap_unplug() which will submit the writes and wait for them to
> complete.
>
> The is a comment at the top of md/raid5.c titled "BITMAP UNPLUGGING"
> which says a few things about how raid5 ensure things happen in the
> right order.
>
> However I don't think if any sort of bitmap can solve the write-hole
> problem for RAID5 - even in btrfs.
>
> The problem is that if the host crashes while the array is degraded and
> while some write requests were in-flight, then you might have lost data.
> i.e.  to update a block you must write both that block and the parity
> block.  If you actually wrote neither or both, everything is fine.  If
> you wrote one but not the other then you CANNOT recover the data that
> was on the missing device (there must be a missing device as the array
> is degraded).  Even having checksums of everything is not enough to
> recover that missing block.
>
> You must either:
>  1/ have a safe duplicate of the blocks being written, so they can be
>    recovered and re-written after a crash.  This is what journalling
>    does.  Or
>  2/ Only write to location which don't contain valid data.  i.e.  always
>    write full stripes to locations which are unused on each device.
>    This way you cannot lose existing data.  Worst case: that whole
>    stripe is ignored.  This is how I would handle RAID5 in a
>    copy-on-write filesystem.

Thanks Neil for explaining this. I was about to say the same idea, but
couldn't phrase it well.

md raid5 suffers from write hole because the mapping from array-LBA to
component-LBA is fixed. As a result, we have to update the data in place.
btrfs already has file-to-LBA mapping, so it shouldn't be too expensive to
make btrfs free of write hole. (no need for maintain extra mapping, or
add journaling).

Thanks,
Song

>
> However, I see you wrote:
> > Thus as long as no device is missing, a write-intent-bitmap is enough to
> > address the write hole in btrfs (at least for COW protected data and all
> > metadata).
>
> That doesn't make sense.  If no device is missing, then there is no
> write hole.
> If no device is missing, all you need to do is recalculate the parity
> blocks on any stripe that was recently written.  In md with use the
> write-intent-bitmap.  In btrfs I would expect that you would already
> have some way of knowing where recent writes happened, so you can
> validiate the various checksums.  That should be sufficient to
> recalculate the parity.  I've be very surprised if btrfs doesn't already
> do this.
>
> So I'm somewhat confuses as to what your real goal is.
>
> NeilBrown
