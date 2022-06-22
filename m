Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371D3C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 22:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359223AbiFVWdG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 18:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359258AbiFVWdF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 18:33:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477231D4;
        Wed, 22 Jun 2022 15:33:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DFEF021C32;
        Wed, 22 Jun 2022 22:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655937182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tFFlgdtMbxqCCiBmvbaPZhJLTIE1HC8AS1KDq/eMzIo=;
        b=VjvJl0+gCVkpdIXwuytqKkWaUxOkswb8S9VoKuMP9Xzovc+xyOfDzeu3e52LAG07Y6ugNW
        p29ma+mehcITcHuGLR3oL6edqJNQ7j2RFP8NLFxBH4XxZna7/mlrDov2ObJGzJrgbhvdHY
        TWn47QEFjBfo8rgG6QpcHUKSG/mXWS4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655937182;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tFFlgdtMbxqCCiBmvbaPZhJLTIE1HC8AS1KDq/eMzIo=;
        b=Fg5wiWIc/bV9f0m0VgtJQODmiKvcBguJozuQXd2VZV2HPus+wU05ofbsMoD6E7Oh2fGfTb
        CCDRnI4B/ZbqYjCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 51AB2134A9;
        Wed, 22 Jun 2022 22:33:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pZOFBJ2Ys2KXGQAAMHmgww
        (envelope-from <neilb@suse.de>); Wed, 22 Jun 2022 22:33:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Qu Wenruo" <quwenruo.btrfs@gmx.com>
Cc:     "Doug Ledford" <dledford@redhat.com>,
        "Wols Lists" <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: About the md-bitmap behavior
In-reply-to: <d15f352d-41b8-8ade-4724-8370ef17db8d@gmx.com>
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com>,
 <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>,
 <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com>,
 <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>,
 <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>,
 <d15f352d-41b8-8ade-4724-8370ef17db8d@gmx.com>
Date:   Thu, 23 Jun 2022 08:32:55 +1000
Message-id: <165593717589.4786.11549155199368866575@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 22 Jun 2022, Qu Wenruo wrote:
> 
> On 2022/6/22 10:15, Doug Ledford wrote:
> > On Mon, 2022-06-20 at 10:56 +0100, Wols Lists wrote:
> >> On 20/06/2022 08:56, Qu Wenruo wrote:
> >>>> The write-hole has been addressed with journaling already, and
> >>>> this will
> >>>> be adding a new and not-needed feature - not saying it wouldn't be
> >>>> nice
> >>>> to have, but do we need another way to skin this cat?
> >>>
> >>> I'm talking about the BTRFS RAID56, not md-raid RAID56, which is a
> >>> completely different thing.
> >>>
> >>> Here I'm just trying to understand how the md-bitmap works, so that
> >>> I
> >>> can do a proper bitmap for btrfs RAID56.
> >>
> >> Ah. Okay.
> >>
> >> Neil Brown is likely to be the best help here as I believe he wrote a
> >> lot of the code, although I don't think he's much involved with md-
> >> raid
> >> any more.
> >
> > I can't speak to how it is today, but I know it was *designed* to be
> > sync flush of the dirty bit setting, then lazy, async write out of the
> > clear bits.  But, yes, in order for the design to be reliable, you must
> > flush out the dirty bits before you put writes in flight.
> 
> Thank you very much confirming my concern.
> 
> So maybe it's me not checking the md-bitmap code carefully enough to
> expose the full picture.
> 
> >
> > One thing I'm not sure about though, is that MD RAID5/6 uses fixed
> > stripes.  I thought btrfs, since it was an allocation filesystem, didn't
> > have to use full stripes?  Am I wrong about that?
> 
> Unfortunately, we only go allocation for the RAID56 chunks. In side a
> RAID56 the underlying devices still need to go the regular RAID56 full
> stripe scheme.
> 
> Thus the btrfs RAID56 is still the same regular RAID56 inside one btrfs
> RAID56 chunk, but without bitmap/journal.
> 
> >  Because it would seem
> > that if your data isn't necessarily in full stripes, then a bitmap might
> > not work so well since it just marks a range of full stripes as
> > "possibly dirty, we were writing to them, do a parity resync to make
> > sure".
> 
> For the resync part is where btrfs shines, as the extra csum (for the
> untouched part) and metadata COW ensures us only see the old untouched
> data, and with the extra csum, we can safely rebuild the full stripe.
> 
> Thus as long as no device is missing, a write-intent-bitmap is enough to
> address the write hole in btrfs (at least for COW protected data and all
> metadata).
> 
> >
> > In any case, Wols is right, probably want to ping Neil on this.  Might
> > need to ping him directly though.  Not sure he'll see it just on the
> > list.
> >
> 
> Adding Neil into this thread. Any clue on the existing
> md_bitmap_startwrite() behavior?

md_bitmap_startwrite() is used to tell the bitmap code that the raid
module is about to start writing at a location.  This may result in
md_bitmap_file_set_bit() being called to set a bit in the in-memory copy
of the bitmap, and to make that page of the bitmap as BITMAP_PAGE_DIRTY.

Before raid actually submits the writes to the device it will call
md_bitmap_unplug() which will submit the writes and wait for them to
complete.

The is a comment at the top of md/raid5.c titled "BITMAP UNPLUGGING"
which says a few things about how raid5 ensure things happen in the
right order.

However I don't think if any sort of bitmap can solve the write-hole
problem for RAID5 - even in btrfs.

The problem is that if the host crashes while the array is degraded and
while some write requests were in-flight, then you might have lost data.
i.e.  to update a block you must write both that block and the parity
block.  If you actually wrote neither or both, everything is fine.  If
you wrote one but not the other then you CANNOT recover the data that
was on the missing device (there must be a missing device as the array
is degraded).  Even having checksums of everything is not enough to
recover that missing block.

You must either:
 1/ have a safe duplicate of the blocks being written, so they can be
   recovered and re-written after a crash.  This is what journalling
   does.  Or
 2/ Only write to location which don't contain valid data.  i.e.  always
   write full stripes to locations which are unused on each device.
   This way you cannot lose existing data.  Worst case: that whole
   stripe is ignored.  This is how I would handle RAID5 in a
   copy-on-write filesystem.

However, I see you wrote:
> Thus as long as no device is missing, a write-intent-bitmap is enough to
> address the write hole in btrfs (at least for COW protected data and all
> metadata).

That doesn't make sense.  If no device is missing, then there is no
write hole.
If no device is missing, all you need to do is recalculate the parity
blocks on any stripe that was recently written.  In md with use the
write-intent-bitmap.  In btrfs I would expect that you would already
have some way of knowing where recent writes happened, so you can
validiate the various checksums.  That should be sufficient to
recalculate the parity.  I've be very surprised if btrfs doesn't already
do this.

So I'm somewhat confuses as to what your real goal is.

NeilBrown
