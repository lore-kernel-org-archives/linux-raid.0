Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F242DC2D0E4
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 04:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 863BB24682
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 04:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bitfolk.com header.i=@bitfolk.com header.b="PM3749Zw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgKQEmI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Nov 2020 23:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgKQEmH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Nov 2020 23:42:07 -0500
X-Greylist: delayed 912 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 Nov 2020 20:42:07 PST
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4737C0613CF
        for <linux-raid@vger.kernel.org>; Mon, 16 Nov 2020 20:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:Subject:To:From:Date; bh=M02vxiB9cBkirTjF/hnpPz3yXmY0F3/FlZgeRofCJs0=;
        b=PM3749ZwhEi4RKEoWFQ/JGvMC0z7Gj2cunB6vcminwIB9gDuMLDlRLR/6G5z1Xtz8/Z6RnHYJb2NFz+FTMP6kU1635t6PZH+UQvSKYqxBK1HyPdZydUfh43xUxCZnguJDZ+ei7+StdGG9rABCY8PaBySTldQNgR0sDh9KU/hHpfloCxBa+2aQj+OwxnoQBwNksvwlAqN5OyH4iwLBgOqTTjb3KfrDyKYigOhVH8wCJpHPePepFRzsEmZKGEl4hD+9zSHbi6oDVc9TnJ0REvnR56XZzqZXMHw6vDy/AxAVlk54EfLYhgV41UgAv6i2zmb9bHtBm1klDCcBxmxt6T79w==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1kesZw-0001of-Ig
        for linux-raid@vger.kernel.org; Tue, 17 Nov 2020 04:26:52 +0000
Date:   Tue, 17 Nov 2020 04:26:52 +0000
From:   Andy Smith <andy@strugglers.net>
To:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Information request
Message-ID: <20201117042652.GU3103@bitfolk.com>
Mail-Followup-To: Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf5-ji4YSMyCkwr8BRZLE4Jm8835TMOUfWGd2Xg6c=7TYBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPpdf5-ji4YSMyCkwr8BRZLE4Jm8835TMOUfWGd2Xg6c=7TYBg@mail.gmail.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

On Mon, Nov 16, 2020 at 08:43:12PM -0600, o1bigtenor wrote:
> I managed to delete a file that would require a lot of hours to replace.

[…]

> Looking for suggestions on how to recover the file.

This is really a filesystem question - files are not something that
RAID concerns itself with. So, what filesystem and what type of
file? You might get lucky running photorec (it's not just for
images) on the block device while it's unmounted.

    https://www.cgsecurity.org/wiki/PhotoRec_Step_By_Step

Cheers,
Andy
