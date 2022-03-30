Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF663C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 30 Mar 2022 02:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241995AbiC3CfW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Mar 2022 22:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241393AbiC3CfV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Mar 2022 22:35:21 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2079A4E397
        for <linux-raid@vger.kernel.org>; Tue, 29 Mar 2022 19:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7x3vnp7zI9nqt3R5qo09IC1al+LksQJ7F3yH+tQViVw=; b=Aju+PzkUbH9Xg+hVkQEhTw8AgK
        EMdXlTEUZLuPbFCQzjPyFDUIHl55LEnHwY+SK1qqXqwG0YNYHxca65MDZtOtYFAM9xaaKeFm5rT47
        8RzblAnQlZfVmdYh0HIMmooPiF1FGdzml0TC7DnBmg8V12tLA+q3jYpKZhUSjNcvb5lXxTPQhSKeY
        8gBxlBtPD46d4frmkwbirtKifsegNlKc5e4UKG3mz/S/VHWt9juREVFB3u2V3M/sJToVt9pxrSyMb
        zZ/6e4c7JJFxo5T5faik/Hl532p0kGt4/r3YNVZGV1+QmOLDl9dBiaerO2mVKYIW2lQsioO8EzZIJ
        lc/cXBUQ==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1nZO9N-0000qh-V4
        for linux-raid@vger.kernel.org; Wed, 30 Mar 2022 02:33:33 +0000
Date:   Wed, 30 Mar 2022 02:33:33 +0000
From:   Andy Smith <andy@strugglers.net>
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
Message-ID: <20220330023333.durdl4ydb3pz4yab@bitfolk.com>
Mail-Followup-To: list Linux RAID <linux-raid@vger.kernel.org>
References: <20220318030855.GV3131742@merlins.org>
 <CAC6SzHKFga59KpzhRhE-sz3K5z+=LUXfyxSB14KaOj7DCxCj-Q@mail.gmail.com>
 <20220328020512.GP4113@merlins.org>
 <CAJCQCtQyqG_zWhRVXjnc3Prc+J-7hK1hyp28mwyuKWWPJ8Uo5A@mail.gmail.com>
 <CAC6SzHL9Vy2Tz_rVFRphTuAjwPNXg59WAuY8JCXXQ94W09y4sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC6SzHL9Vy2Tz_rVFRphTuAjwPNXg59WAuY8JCXXQ94W09y4sw@mail.gmail.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On Tue, Mar 29, 2022 at 09:55:40AM +0800, d tbsky wrote:
> In the early days different vendors made different capacity harddisks.
> But at some moment, maybe 250GB or 500GB, suddenly every vendor made
> the same capacity harddisks. It's a mystery to me. who decides the
> disk sector numbers?

There is a standard called IDEMA LBA1-03:

    http://www.idema.org/wp-content/downloads/2169.pdf

This says that a certain "marketing capacity" (i.e. when the drive
product description says "2TB" or whatever) will equal an exact
number of 512 or 4096 byte sectors.

It's been over a decade since I personally saw a SATA, SAS or NVMe
drive that did not obey this, so I've felt comfortable that I could
replace drives from one vendor with another without having to worry
about a few sectors different size here or there.

However, I did see people on this and other mailing lists such as
zfs-discuss saying they were still seeing drives that did not comply
with IDEMA LBA1-03 for capacity as recently as last year, so
apparently I did not look hard enough or have just been lucky.

If you want to play at home the formula in IDEMA LBA1-03 boils down
to:

    ($GB * 1000194048) + 10838016 bytes

using powers of ten definitions for "GB", so anything calling itself
a "2TB" drive should be exactly:

    (2000 * 1000194048) + 10838016

    = 2,000,398,934,016 bytes

Capacity presented to the OS might be lower of course if there is
hardware meddling as you mention.

Again, I've not personally seen anything recently that doesn't obey
this, but people have shown me things that don't, so it's
apparently still a thing.

Cheers,
Andy
