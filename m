Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CCD2C433E0
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 15:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDABE61A10
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 15:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbhCXPEj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbhCXPER (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Mar 2021 11:04:17 -0400
X-Greylist: delayed 1202 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 24 Mar 2021 08:04:14 PDT
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612FAC0613DE
        for <linux-raid@vger.kernel.org>; Wed, 24 Mar 2021 08:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com; s=alpha;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:To:From:Date; bh=64UUlszQGzQAHle1epLi+ss3If7MclC8aObpD0W4FHo=;
        b=fuUE7nnJv8ZrrYklVRRpN19/k0Ccde6ibKTjrh94Rgkuc4LEycjG1uCjFYuoYLJ8BraP1URXI8fKfsfIER1BWNZbUEMEmoDT6s+7dn6QfDQytSoJ7nXvOsz0myBa89T1S2S7I3aqvfhcZXFVmXaLfYi0zPIT9vJgsKDABY8n8F9rkgFEzJwW0MFHH3RqDxuCwDv7/J/18LthJRlb3uqXei4Qbh6YPUmXN4HJWBuawU8A5C/yQ4B1hHZ0MoYCyYET2npzQhwAnLQnC45FCb2MhdezaR82vak32ButLbhnVyPfJdLajT7rqu9zQuF4v+Bx772318he2Ui80plBoDcVNQ==;
Received: from andy by mail.bitfolk.com with local (Exim 4.84_2)
        (envelope-from <andy@strugglers.net>)
        id 1lP4jv-0007xJ-9N
        for linux-raid@vger.kernel.org; Wed, 24 Mar 2021 14:44:07 +0000
Date:   Wed, 24 Mar 2021 14:44:07 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: MDRaid Rollback
Message-ID: <20210324144407.GL3712@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <CA+OzjxLW2Vw-ecs7jNELecpYxoBbK767pXEV8rFVaQp_HXfjOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+OzjxLW2Vw-ecs7jNELecpYxoBbK767pXEV8rFVaQp_HXfjOg@mail.gmail.com>
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

On Wed, Mar 24, 2021 at 01:04:07PM +0200, Shaun Glass wrote:
> Would just like to know if it is possible at all to break a mirror and
> convert a md device back to its original state without losing data ?

The default metadata version (1.2) is placed at the start of an
array, so even if zeroed this will prevent the array member being
used as the filesystem that is on top of it.

If you have metadata version 0,9 or 1.0 which are at the end then I
don't see why it wouldn't work. I've never done it though so try it
out first on loop devices.

Don't forget to "mdadm --zero-superblock /dev/sda1" (or whatever
devices) for the member device that you have failed out of the
array, so it is no longer treated as part of an array,

But, this being a RAID-1 you have at least two devices so wouldn't
it be safer to:

- Fail out one device
- Zero that device
- Create new filesystem on the removed device
- Copy data onto it from the still-running array that is currently
  degraded
- Use new filesystem for whatever you wanted

?

Depending on what you are trying to achieve you could also import
the broken our device as ANOTHER MD RAID-1 array so both arrays are
running degraded (and now divergent).

Finally, if you are on superblock versions 1.1 or 1.2 you may be
able to work out the offset into the device and use a loop device to
skip that, so treating it as a normal filesystem:

    https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_version-1_Superblock_Format

Cheers,
Andy

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting
