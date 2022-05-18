Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0042C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 18 May 2022 20:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242693AbiERUe1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 May 2022 16:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242647AbiERUeZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 May 2022 16:34:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDD0128176
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 13:34:24 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pq9-20020a17090b3d8900b001df622bf81dso3194714pjb.3
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 13:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=66dr9Y4+nGAythBm/U+gBptPm1LvULEFY+Acr0MuJSw=;
        b=IFIIjOZP8JMz9UkUvzfqKSCnU028VvXg61mf6KVfqaQsH8r2nfSUQP8Q2iqstDxtAc
         g+5H+E3NLGNM7MivtBuS+BGfWyqcdEdlizi5T744PxohMf1uFK6VRnxlqGIYesC9uI5s
         7z6/kkpPrnCb0pEH0pxHKN6ZAtfUBKr/dDXL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=66dr9Y4+nGAythBm/U+gBptPm1LvULEFY+Acr0MuJSw=;
        b=0I9oPyMNDz/Gg+LfKHgVdibw/ZLer7RBYQl4bYXebHhJ8TRgHbXzkFrMXIsUVCBm8r
         j48Z06bdJEEcDry0Xkko6VMYu9eILVB0EMJ6TKtjDyi6IjnSNm0LI9ySicVgec5UZSye
         6EbzrVhM11nmDhdjB7hJNS8DdGB30Y/dl9ZM+PAB3E6PhcGnnOoRfgENUY3jDg6ICN6d
         u2jtgmdLRrkFf0TzlIs92HWbzThyKGx7mCl607CEveMSxMGzL7fJjhii3/AzjRb3a42z
         kMbWB3tTf7PukvDGuqBg2vu2tvDt54hvUNBtsp+edmvJDukWhMzU3ec3ah3NeQsDYNtP
         iTsw==
X-Gm-Message-State: AOAM530oKVdbcZFoGzn8KGT2suyxoaI3y6xdoDshTzAG6Bf5aQbHJ+Sq
        IzF4ogQkTxHV/uwpaX/1pndkbg==
X-Google-Smtp-Source: ABdhPJwCOuHJM7T0rMcLBaHOW9wPJYWpAE1ug6I4fbANLq4cLIwuxoLqQF+SDIvDnlzyTgKdZun+3Q==
X-Received: by 2002:a17:903:228e:b0:161:8632:2725 with SMTP id b14-20020a170903228e00b0016186322725mr1358741plh.126.1652906064039;
        Wed, 18 May 2022 13:34:24 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:a14:3166:4b67:b688])
        by smtp.gmail.com with UTF8SMTPSA id m1-20020a17090a858100b001d792761e2esm4020445pjn.47.2022.05.18.13.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 13:34:23 -0700 (PDT)
Date:   Wed, 18 May 2022 13:34:21 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Mike Snitzer <snitzer@kernel.org>
Cc:     Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>, dm-devel@redhat.com,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dm: Add verity helpers for LoadPin
Message-ID: <YoVYTf7oI4FNVHAJ@google.com>
References: <20220517233457.1123309-1-mka@chromium.org>
 <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <19149028-ec94-8f64-aed4-1e58f29942a8@gmail.com>
 <YoUNH7MrfEb844ft@google.com>
 <YoVRIHfXPa7+e1Zh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YoVRIHfXPa7+e1Zh@redhat.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 18, 2022 at 04:03:44PM -0400, Mike Snitzer wrote:
> On Wed, May 18 2022 at 11:13P -0400,
> Matthias Kaehlcke <mka@chromium.org> wrote:
> 
> > Hi Milan,
> > 
> > On Wed, May 18, 2022 at 09:57:43AM +0200, Milan Broz wrote:
> > > On 18/05/2022 01:34, Matthias Kaehlcke wrote:
> > > > LoadPin limits loading of kernel modules, firmware and certain
> > > > other files to a 'pinned' file system (typically a read-only
> > > > rootfs). To provide more flexibility LoadPin is being extended
> > > > to also allow loading these files from trusted dm-verity
> > > > devices. For that purpose LoadPin can be provided with a list
> > > > of verity root digests that it should consider as trusted.
> > > > 
> > > > Add a bunch of helpers to allow LoadPin to check whether a DM
> > > > device is a trusted verity device. The new functions broadly
> > > > fall in two categories: those that need access to verity
> > > > internals (like the root digest), and the 'glue' between
> > > > LoadPin and verity. The new file dm-verity-loadpin.c contains
> > > > the glue functions.
> > > > 
> > > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > 
> > > ...
> > > 
> > > > +
> > > > +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> > > > +		return false;
> > > 
> > > Almost unrelated note, but as there are more and more situations
> > > that checks verity root digest, shouldn't we export this as read-only
> > > sysfs attribute for DM verity devices?
> > > 
> > > Attacker can always calculate (but not change) Merkle tree, so this
> > > is not something that need to be hidden.
> > > 
> > > It would allow userspace to easily enumerate trusted DM devices without
> > > calling kernel ioctls...
> > 
> > I guess that's an option if there are scenarios where it is useful. It
> > should probably be a separate patch, since it isn't directly related with
> > extending LoadPin support to trusted verity devices.
> > 
> > > > +
> > > > +	table = dm_get_live_table(md, &srcu_idx);
> > > > +
> > > > +	if (dm_table_get_num_targets(table) != 1)
> > > > +		goto out;
> > > > +
> > > > +	ti = dm_table_get_target(table, 0);
> > > > +
> > > > +	if (is_trusted_verity_target(ti))
> > > > +		trusted = true;
> > > 
> > > What happens is someone reloads verity table later with
> > > a different content (or even different target type)?
> > > Does LoadPin even care here?
> > 
> > LoadPin cares, but only when new kernel files are loaded. It will then check
> > against the new verity table, and only allow loading of the file if it comes
> > from a verity target with a trusted digest.
> > 
> > > >   static struct target_type verity_target = {
> > > >   	.name		= "verity",
> > > >   	.version	= {1, 8, 0},
> > > 
> > > Please increase the minor version, it is very useful to detect (in logs)
> > > that the target driver has compatible extensions.
> > 
> > I can do that, but would like to confirm that this is really needed/desired.
> > This patch adds kernel-internal APIs which aren't accessible to userspace,
> > that don't impact verity directly, so I'm not sure an increased minor version
> > would be useful.
> 
> Bumping to 1.8.1 is useful to indicate new changes that offer expanded
> use of the verity target (even if by LoadPin).

Ok, I'll bump the version, thanks for the confirmation.
