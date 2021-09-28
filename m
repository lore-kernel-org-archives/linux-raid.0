Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA829C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 28 Sep 2021 23:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94AC860E94
	for <linux-raid@archiver.kernel.org>; Tue, 28 Sep 2021 23:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243233AbhI1X63 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:58:29 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37102 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242094AbhI1X63 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Sep 2021 19:58:29 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 27E8F202D2;
        Tue, 28 Sep 2021 23:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632873408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/6dCMwiDfkHUppAGrFIwTyuNA3WR/p5hOgHWAd/NQxI=;
        b=krzynVZdWKhS9su0PgQBoacGzg7Yq0GeoZ0Ami5G0Fb/lFw8Zqt9lnUQxJNk7Q7mSDKFGB
        6qn5cfI9nnCq7GBnbMsa2CZy8m5Ku7YszuWNzJtGvsclOTnRQWzPNlAr51lggkDlOrJ6lk
        eRP5GpHuhBA7m9du74BhGLHt/l94gds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632873408;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/6dCMwiDfkHUppAGrFIwTyuNA3WR/p5hOgHWAd/NQxI=;
        b=AQA1DqS3UFmFI/9/RvFDET8z7mALKsYiI8MkN+ZU7/6VhAatb55SIgteXmhNhiHn5qb///
        Dd2i+dDAG8YkrLAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0EBC013EB6;
        Tue, 28 Sep 2021 23:56:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MRxUL76rU2EWQgAAMHmgww
        (envelope-from <neilb@suse.de>); Tue, 28 Sep 2021 23:56:46 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Tomasz Majchrzak" <tomasz.majchrzak@intel.com>
Cc:     linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com,
        "Tomasz Majchrzak" <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH 4/4 v4] mdmon: bad block support for external metadata -
 clear bad blocks
In-reply-to: <1477558425-13332-4-git-send-email-tomasz.majchrzak@intel.com>
References: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>,
 <1477558425-13332-4-git-send-email-tomasz.majchrzak@intel.com>
Date:   Wed, 29 Sep 2021 09:56:42 +1000
Message-id: <163287340289.31063.8425995521501370134@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 27 Oct 2016, Tomasz Majchrzak wrote:
> If an update of acknowledged bad blocks file is notified, read entire
> bad block list from sysfs file and compare it against local list of bad
> blocks. If any obsolete entries are found, remove them from metadata.
> 
> As mdmon cannot perform any memory allocation, new superswitch method
> get_bad_blocks is expected to return a list of bad blocks in metadata
> without allocating memory. It's up to metadata handler to allocate all
> required memory in advance.

hi,
 only 5 years late to this party :-)

 I recently had cause the look at this code and ... there are problems.

 Primarily, it assumes that the "bad_blocks" file contains a complete
 list of bad blocks known to the kernel.  This is not correct.
 As the documentation and nearby comments say, the contents of this file
 is truncated to PAGE_SIZE.  It is not meant to be a complete list, only
 an indicative list.
 There is no way to get a complete list from the kernel once the list
 gets too large.  Probably we should design and implement a reliable way
 to extract this information.  I imagine it would be something like
 unacknowledged_bad_blocks, in that mdmon could read some information,
 then confirm that it has been read, then read some more.  But until
 that it done, this code should be careful not to assume that the list
 is complete - at least not without checking.

 Secondly, the interface with the metadata handler is a bit odd.
 The 'check_for_cleared_bb' essentially does:
   - call ->record_bad_block  for all blocks known to the kernel
   - call ->clear_bad_block   for all blocks that were in the metadata
  in that order.
  It isn't quite that simple as there are optimisations:
    if a range from kernel exactly matches a range in metadata, the
      range is neither recorded or cleared
    If a range from the kernel is a subrange of a range in metadata,
      then the larger range is cleared before the new range is added,
      AS WELL AS after.

  If there are other overlaps, then the kernel range is recorded
  before the metadata range is cleared.  This *seems* wrong.  I would
  expect this to clear part of the range that had just been added.

  However, it doesn't.  The ->clear_bad_block interface *DOESN'T* remove
  all the block in the range from the bbl.  Rather, if the exact range
  given appears as one of the ranges in the bbl, then that range is
  deleted.  Otherwise no change happens.
  These semantics are surprising.  The net result is that the code
  probably works with the imsm backend.  However if someone else wrote a
  different backend which implemented ->clear_bad_block to actually
  remove the entire range from the bbl, then it would clear more blocks
  than it should.

  I think it would be really good to re-implement this code in a way
  that was more maintainable.
  I don't think "check_for_cleared_bb()" should *ever* record new bad
  block ranges.  They get recorded through the unacknowledged_bad_block
  processing.  "check_for_cleared_bb()" should ONLY delete blocks from the
  bbl, and it should ONLY do that if it certain that the information in
  "bad_blocks" is complete.

  It should read bad_blocks in a single read().  If the returned data
  ends with a newline, and is not a power-of-2 in size, then it is
  safe to assume that it is complete.
  If it doesn't end with a newline, then it is definitely not complete.
  If it is a power-of-2 less than 4096, then it can be assumed to be
  complete.  If it is exactly 4096 bytes, or a larger power of two, then
  it is not safe to assume that it is complete.

Thanks,
NeilBrown
