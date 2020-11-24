Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B09C56201
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 07:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFB7E20679
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 07:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mukund.org header.i=@mukund.org header.b="dYZg7ASj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730069AbgKXH0R (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 02:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729915AbgKXH0R (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Nov 2020 02:26:17 -0500
X-Greylist: delayed 331 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Nov 2020 23:26:16 PST
Received: from mx.mukund.org (mx.mukund.org [IPv6:2a01:4f8:241:150e:1::f7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A49C0613CF
        for <linux-raid@vger.kernel.org>; Mon, 23 Nov 2020 23:26:16 -0800 (PST)
Date:   Tue, 24 Nov 2020 12:50:39 +0530
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mukund.org; s=mail;
        t=1606202442; bh=pkf3obF2KyiHDeWOVHNk3SyMoKgtPCIcGr95iJr9Z/M=;
        h=Date:From:To:Subject:From;
        b=dYZg7ASj7gpNRmuNxegLhcj3NKJrXmKfrstNc82qo2zSJo4+fmiLZQZRGnZTqF9BT
         VIluzQUMRGuF0Vq4Uv6/AULbXnOxOd/fSB5zJOeaGUoTW0swexlosgJQIFtG4aCr1w
         vabHq8395Mk6RgzvKA6ZgD9heDBAD9JuLqT+Jrx8=
From:   Mukund Sivaraman <muks@mukund.org>
To:     linux-raid@vger.kernel.org
Subject: RAID-6 and write hole with write-intent bitmap
Message-ID: <20201124072039.GA381531@jurassic.vpn.mukund.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

I am trying to setup a MD RAID-6 array and use the ext4 filesystem in
ordered mode (default) on it. The data gets backed up periodically. I
want the array to be always available.

I prefer not using a write-journal if it is sufficient for my usage. I
want to use the write-intent bitmap only. AIUI the write-hole problem
occurs when there is a crash or abrupt power off *and* disk failures.

* After a crash or abrupt power off, the write-intent bitmap is used to
  rewrite parity where necessary. If there is no disk failure during
  this period, is the RAID-6 array guaranteed to recover without
  corruption?

  With RAID-6, will recovery with write-intent bitmap succeed with 1
  disk failure during the recovery period without a write-journal? i.e.,
  is there a possibility of write hole with 1 disk failure in a RAID-6
  array?

* With RAID-6 with write-intent bitmap in use, ext4 in ordered mode, no
  disk failures, and abrupt power loss, is there any chance of data loss
  in files other than those being written to just before the power loss?

(Apologies if these are silly questions, but I request answers.)

		Mukund
