Return-Path: <SRS0=ztYz=BW=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90E0C433E0
	for <linux-raid@archiver.kernel.org>; Wed, 12 Aug 2020 14:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EA7620756
	for <linux-raid@archiver.kernel.org>; Wed, 12 Aug 2020 14:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgHLOlo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Aug 2020 10:41:44 -0400
Received: from rin.romanrm.net ([51.158.148.128]:34238 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgHLOln (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 12 Aug 2020 10:41:43 -0400
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id B0C0841F;
        Wed, 12 Aug 2020 14:41:41 +0000 (UTC)
Date:   Wed, 12 Aug 2020 19:41:41 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Nix <nix@esperi.org.uk>
Cc:     George Rapp <george.rapp@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Recommended filesystem for RAID 6
Message-ID: <20200812194141.0b86d7ee@natsu>
In-Reply-To: <87sgcsar0a.fsf@esperi.org.uk>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
        <20200811212305.02fec65a@natsu>
        <87sgcsar0a.fsf@esperi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 12 Aug 2020 15:16:37 +0100
Nix <nix@esperi.org.uk> wrote:

> On 11 Aug 2020, Roman Mamedov stated:
> > For the FS considerations, the dealbreaker of XFS for me is its inability to
> > be shrunk. The ivory tower people do not think that is important enough, but
> > for me that limits the FS applicability severely. Also it loved truncating
> > currently-open files to zero bytes on power loss (dunno if that's been
> > improved).
> 
> I've been using XFS for more than ten years now and have never seen this
> allegedly frequent behaviour at all. It certainly seems to be less
> common than, say, fs damage due to the (unjournalled) RAID write hole.
> 
> I suspect you're talking about this:
> <https://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_see_binary_NULLS_in_some_files_after_recovery_when_I_unplugged_the_power.3F>,
> whicih was fixed in *2007*.

No, it was not nulls inside files, but files becoming zero bytes in size.
Like reported here https://bugzilla.redhat.com/show_bug.cgi?id=845233
Or maybe https://access.redhat.com/solutions/272673 too (don't have an account)
Maybe also fixed since 2012. If so, good for you.

> Shrinking xfs is relatively irrelevant these days: if you want to be
> able to shrink, use thin provisioning and run fstrim periodically. The
> space used by the fs will then shrink whenever fstrim is run, with no
> need to mess about with filesystem resizing.

It also means you can't practically remove drives from that 16-drive RAID6 if
you go with XFS. Cannot shrink the filesystem, cannot reshape to fewer disks.
Cannot switch to a different disk enclosure with fewer slots.
Would you suggest to patch that up with running an array-wide Thin volume as
well? Will not work, as the LVM thin backing volume *itself* cannot be shrunk
either. And even in more suitable conditions, thin has its own overheads and
added complexity.

Well, if we are to mention something positive about XFS, it's another major
Linux FS other than Btrfs (which is not everyone's cup of tea for its own
reasons), that now got support for reflink copies (cp --reflink). Backing up
file-based VMs can be done online and atomically now, like with LVM. And in
general, it's the next-best thing to Btrfs snapshots, but in a mature and
all-around high-performing FS.

-- 
With respect,
Roman
