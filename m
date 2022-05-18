Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D66C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 18 May 2022 15:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239208AbiERPNk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 May 2022 11:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiERPNj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 May 2022 11:13:39 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE671DFDBF
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 08:13:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id bo5so2434175pfb.4
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 08:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R6GKon/CB8AHTG2BVleTAVkCbJAIy+Ec31rGL7OpKrA=;
        b=ZsuolC/u6gVSVbsjl80xIx9d92sVwUDm1BDTXCnzgAFODiEOkChMaPBr7zQUMfYsht
         SSH+xklDOFhrdNLYvsq0Y8M9re/iu2wBG9DbpNQVk4p8RpbiOaJJNrkyRR4wSiJDPbPH
         V7V19n7NzwXmmsj8U31P/+1xRFdHTgxMOiSlw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R6GKon/CB8AHTG2BVleTAVkCbJAIy+Ec31rGL7OpKrA=;
        b=AltD3fDCYFY2T3oTvhuq3rGl3g+GhvhgYZNPDCDXILNcbPxED1qIryW+e6kx4LvBDi
         t4FpM4UgEnneReRSJyKlF371eSDW7jL50YnfXD0ZNvptlpYMNuW1lldfz5uz8kXxxnsZ
         5d0yiKJRjs4jUh0KPgzn0xp/E0yOCVFkwGna+MWCzbFT0l9vvnFFPpeZIZt0TEKTb9lK
         9F/gxaPEe0GGGuUKczUUNaA7nb90iCxwgvxsnB7zlBmpxiiVm3W+wslo4m7ytI7nQpg/
         nEqx1fYWqYklS97D7qwDhg7JiNmJGQYs7uE20KvN5t+D33xl50GI86Tlo3RrFLopx0Cw
         /bEQ==
X-Gm-Message-State: AOAM531mgwhZ1piwJYDLbFIZylPZ7uHR9Fh6aSBwNVzPSSEKvaARuMvs
        132FuGdjV/u3nvs/s9Qrfqsieg==
X-Google-Smtp-Source: ABdhPJyFOeC90y1HStFFR+BKQhegBQbMZrwLsSMlHpm5O9PYUeML8M3eBG6IOYh/5ylSnQ2jWSXYFw==
X-Received: by 2002:a65:4bc5:0:b0:3da:ec0c:c5f2 with SMTP id p5-20020a654bc5000000b003daec0cc5f2mr23770774pgr.221.1652886817386;
        Wed, 18 May 2022 08:13:37 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:a14:3166:4b67:b688])
        by smtp.gmail.com with UTF8SMTPSA id j128-20020a62c586000000b005182e39038csm1629435pfg.38.2022.05.18.08.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 08:13:36 -0700 (PDT)
Date:   Wed, 18 May 2022 08:13:35 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>, dm-devel@redhat.com,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 1/3] dm: Add verity helpers for LoadPin
Message-ID: <YoUNH7MrfEb844ft@google.com>
References: <20220517233457.1123309-1-mka@chromium.org>
 <20220517163437.v4.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <19149028-ec94-8f64-aed4-1e58f29942a8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19149028-ec94-8f64-aed4-1e58f29942a8@gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Milan,

On Wed, May 18, 2022 at 09:57:43AM +0200, Milan Broz wrote:
> On 18/05/2022 01:34, Matthias Kaehlcke wrote:
> > LoadPin limits loading of kernel modules, firmware and certain
> > other files to a 'pinned' file system (typically a read-only
> > rootfs). To provide more flexibility LoadPin is being extended
> > to also allow loading these files from trusted dm-verity
> > devices. For that purpose LoadPin can be provided with a list
> > of verity root digests that it should consider as trusted.
> > 
> > Add a bunch of helpers to allow LoadPin to check whether a DM
> > device is a trusted verity device. The new functions broadly
> > fall in two categories: those that need access to verity
> > internals (like the root digest), and the 'glue' between
> > LoadPin and verity. The new file dm-verity-loadpin.c contains
> > the glue functions.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> 
> ...
> 
> > +
> > +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> > +		return false;
> 
> Almost unrelated note, but as there are more and more situations
> that checks verity root digest, shouldn't we export this as read-only
> sysfs attribute for DM verity devices?
> 
> Attacker can always calculate (but not change) Merkle tree, so this
> is not something that need to be hidden.
> 
> It would allow userspace to easily enumerate trusted DM devices without
> calling kernel ioctls...

I guess that's an option if there are scenarios where it is useful. It
should probably be a separate patch, since it isn't directly related with
extending LoadPin support to trusted verity devices.

> > +
> > +	table = dm_get_live_table(md, &srcu_idx);
> > +
> > +	if (dm_table_get_num_targets(table) != 1)
> > +		goto out;
> > +
> > +	ti = dm_table_get_target(table, 0);
> > +
> > +	if (is_trusted_verity_target(ti))
> > +		trusted = true;
> 
> What happens is someone reloads verity table later with
> a different content (or even different target type)?
> Does LoadPin even care here?

LoadPin cares, but only when new kernel files are loaded. It will then check
against the new verity table, and only allow loading of the file if it comes
from a verity target with a trusted digest.

> >   static struct target_type verity_target = {
> >   	.name		= "verity",
> >   	.version	= {1, 8, 0},
> 
> Please increase the minor version, it is very useful to detect (in logs)
> that the target driver has compatible extensions.

I can do that, but would like to confirm that this is really needed/desired.
This patch adds kernel-internal APIs which aren't accessible to userspace,
that don't impact verity directly, so I'm not sure an increased minor version
would be useful.

> I guess this change does not affect userspace veristysetup
> (as it is used handled by different tooling), right?

Correct, from the verity side this is effectively a NOP, the new
kernel-internal APIs only provide information to LoadPin, but don't
change any verity specific behavior.
