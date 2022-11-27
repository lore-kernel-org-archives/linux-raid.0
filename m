Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93983C4321E
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 19:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiK0The (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 14:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiK0Thd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 14:37:33 -0500
Received: from mr3.vodafonemail.de (mr3.vodafonemail.de [145.253.228.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2034FC7A
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 11:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
        s=vfde-smtpout-mb-15sep; t=1669577849;
        bh=6ljmmDahmzu2C4zb825brGw2NvdSixrGMir5W0Q3q8E=;
        h=Date:From:To:Subject:Message-ID:References:Content-Type:
         In-Reply-To:From;
        b=PkbfTkS40El8+jw0IU0dfgniXaJmfmcdnx4IcfSKF7VnSHyQqWe/Z1kCptB1HudZT
         RhF6ANqMlEbfN9oINI6hLi0gBBz7Jw8gsoho7sqphKC2fUEnWkKod153iVnIr3AK6g
         hKY1AoPLjdZqI5Cm3NEr+qHJI61oov89dGl2RvTY=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mr3.vodafonemail.de (Postfix) with ESMTPS id 4NKzQK2Wd2z211f;
        Sun, 27 Nov 2022 19:37:29 +0000 (UTC)
Received: from lazy.lzy (p4fd6dceb.dip0.t-ipconnect.de [79.214.220.235])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4NKzQ11kpPz9s7l;
        Sun, 27 Nov 2022 19:37:10 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
        by lazy.lzy (8.17.1/8.14.5) with ESMTPS id 2ARJb9bb014109
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sun, 27 Nov 2022 20:37:09 +0100
Received: (from red@localhost)
        by lazy.lzy (8.17.1/8.17.1/Submit) id 2ARJb6fo014106;
        Sun, 27 Nov 2022 20:37:06 +0100
Date:   Sun, 27 Nov 2022 20:37:06 +0100
From:   Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     piergiorgio.sartor@nexgo.de, John Stoffel <john@stoffel.org>,
        Wols Lists <antlists@youngman.org.uk>,
        David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i fix these RAID5 arrays?
Message-ID: <Y4O8YimjIgXIaudh@lazy.lzy>
References: <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
 <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
 <25474.28874.952381.412636@quad.stoffel.home>
 <0c7ad6eff626c8440734909300ebc50d9b1bf615@nexgo.de>
 <4379b4f4-9e7f-a7dc-fc29-6c22b12bf3ea@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4379b4f4-9e7f-a7dc-fc29-6c22b12bf3ea@thelounge.net>
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 2010
X-purgate-ID: 155817::1669577848-EAFFC4F8-39D14117/0/0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Nov 27, 2022 at 07:21:16PM +0100, Reindl Harald wrote:
> 
> 
> Am 27.11.22 um 15:10 schrieb piergiorgio.sartor@nexgo.de:
> > November 27, 2022 at 12:46 PM, "Reindl Harald" <h.reindl@thelounge.net> wrote:
> > 
> > > 
> > > Am 26.11.22 um 21:02 schrieb John Stoffel:
> > > 
> > > > 
> > > > I call it a failure of the layering model. If you want RAID, use MD.
> > > >   If you want logical volumes, then put LVM on top. Then put
> > > >   filesystems into logical volumes.
> > > >   So much simpler...
> > > > 
> > > 
> > > have you ever replaced a 6 TB drive and waited for the resync of mdadm in the hope in all that hours no other drive goes down?
> > > 
> > > when your array is 10% used it's braindead
> > > when your array is new and empty it's braindead
> > > 
> > > ZFS/BTRFS don't neeed to mirror/restore 90% nulls
> > > 
> > 
> > You cannot consider the amount of data in the
> > array as parameter for reliability
> > 
> > If the array is 99% full, MD or ZFS/BTRFS have
> > same behaviour, in terms of reliability.
> > If the array is 0% full, as well
> 
> you completly miss the point!
> 
> if your mdadm-array is built with 6 TB drivres wehn you replace a drive you
> need to sync 6 TB no matter if 10 MB or 5 TB are actually used

I'm not missing the point, you're not
understanding the consequences of
your way of thinking.

If the ZFS/BTRFS is 99% full, how much
time will it need to be synched?

The same (more or less) of MD.

So, what's the difference in *this* case?

None.

This means the risk of (you wrote, I believe)
an other disk to go down is the same.

This means that you're considering the
reliability as function of how much
the array is full (or empty).

No matter if MD takes *always* full time.
It's not the point, in relation to reliability.

In other word, ZFS/BTRFS optimize the sync
time, for sure, but this should *not* be
considered when thinking in terms of
reliability.

bye,

-- 

piergiorgio
