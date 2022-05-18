Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90FFC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 18 May 2022 20:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242209AbiERUDt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 May 2022 16:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242110AbiERUDs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 May 2022 16:03:48 -0400
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA7C2370F8
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 13:03:46 -0700 (PDT)
Received: by mail-qk1-f174.google.com with SMTP id a22so2357998qkl.5
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 13:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Qpd/J7A8SCSKU6yZw0hxy+iztL0Wu+jzDVTa+YGvyo=;
        b=QuSybfOTcI5PhXb0dq+09mxRifQsN9HGRwYB/Sj4AEbmf7SRd1W50g0SNmqmsZs2v7
         0V/jytS3v827Qd0pz4RxQ/4shb4puizPOFamxW9Ds6LMZVrXGiEgtFxoDZeR7lQZw6Y1
         xylMB/8QkqNC5ErG+kxsE7c1J1BqCeIBYjXGlfPQy+JZLfXDNsbjqeA0vjfcrgnyKprk
         1BCLoYp42S7jIeCOokAP/yT15ZaOedVXOYxJWsUS/cWgxl7Yhq3+xuAWKJ3VAs7QWnS/
         +UNsOakYat1xB878yusOPyUKEai+1HP71D6U1u7/yzTpTcTiGfublWfxSyPRjls1MHhw
         uZnQ==
X-Gm-Message-State: AOAM530d+9RmUj8Z8XWYWhFXZV73MjIlh1iY/1aPfwaiFMlZrnX9Ha9I
        5g9aYRynOaD2x906J1J+3X0J
X-Google-Smtp-Source: ABdhPJwEU5F9uKrOZEN4PLvxlHlsC7JKL94tfNkKx/c8tpQgbDVfOXmn74Adm6rOuDC33973uwbA2A==
X-Received: by 2002:a05:620a:4612:b0:6a0:125b:56be with SMTP id br18-20020a05620a461200b006a0125b56bemr821947qkb.369.1652904225547;
        Wed, 18 May 2022 13:03:45 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id w140-20020a376292000000b006a10aa7908dsm108133qkb.38.2022.05.18.13.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 13:03:45 -0700 (PDT)
Date:   Wed, 18 May 2022 16:03:44 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>, dm-devel@redhat.com,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dm: Add verity helpers for LoadPin
Message-ID: <YoVRIHfXPa7+e1Zh@redhat.com>
References: <20220517233457.1123309-1-mka@chromium.org>
 <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <19149028-ec94-8f64-aed4-1e58f29942a8@gmail.com>
 <YoUNH7MrfEb844ft@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoUNH7MrfEb844ft@google.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, May 18 2022 at 11:13P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> Hi Milan,
> 
> On Wed, May 18, 2022 at 09:57:43AM +0200, Milan Broz wrote:
> > On 18/05/2022 01:34, Matthias Kaehlcke wrote:
> > > LoadPin limits loading of kernel modules, firmware and certain
> > > other files to a 'pinned' file system (typically a read-only
> > > rootfs). To provide more flexibility LoadPin is being extended
> > > to also allow loading these files from trusted dm-verity
> > > devices. For that purpose LoadPin can be provided with a list
> > > of verity root digests that it should consider as trusted.
> > > 
> > > Add a bunch of helpers to allow LoadPin to check whether a DM
> > > device is a trusted verity device. The new functions broadly
> > > fall in two categories: those that need access to verity
> > > internals (like the root digest), and the 'glue' between
> > > LoadPin and verity. The new file dm-verity-loadpin.c contains
> > > the glue functions.
> > > 
> > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > 
> > ...
> > 
> > > +
> > > +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> > > +		return false;
> > 
> > Almost unrelated note, but as there are more and more situations
> > that checks verity root digest, shouldn't we export this as read-only
> > sysfs attribute for DM verity devices?
> > 
> > Attacker can always calculate (but not change) Merkle tree, so this
> > is not something that need to be hidden.
> > 
> > It would allow userspace to easily enumerate trusted DM devices without
> > calling kernel ioctls...
> 
> I guess that's an option if there are scenarios where it is useful. It
> should probably be a separate patch, since it isn't directly related with
> extending LoadPin support to trusted verity devices.
> 
> > > +
> > > +	table = dm_get_live_table(md, &srcu_idx);
> > > +
> > > +	if (dm_table_get_num_targets(table) != 1)
> > > +		goto out;
> > > +
> > > +	ti = dm_table_get_target(table, 0);
> > > +
> > > +	if (is_trusted_verity_target(ti))
> > > +		trusted = true;
> > 
> > What happens is someone reloads verity table later with
> > a different content (or even different target type)?
> > Does LoadPin even care here?
> 
> LoadPin cares, but only when new kernel files are loaded. It will then check
> against the new verity table, and only allow loading of the file if it comes
> from a verity target with a trusted digest.
> 
> > >   static struct target_type verity_target = {
> > >   	.name		= "verity",
> > >   	.version	= {1, 8, 0},
> > 
> > Please increase the minor version, it is very useful to detect (in logs)
> > that the target driver has compatible extensions.
> 
> I can do that, but would like to confirm that this is really needed/desired.
> This patch adds kernel-internal APIs which aren't accessible to userspace,
> that don't impact verity directly, so I'm not sure an increased minor version
> would be useful.

Bumping to 1.8.1 is useful to indicate new changes that offer expanded
use of the verity target (even if by LoadPin).
