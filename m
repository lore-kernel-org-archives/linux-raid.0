Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF905C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 22 Feb 2022 13:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiBVNzB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Feb 2022 08:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiBVNzA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Feb 2022 08:55:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C558510E047
        for <linux-raid@vger.kernel.org>; Tue, 22 Feb 2022 05:54:35 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6C7E621124;
        Tue, 22 Feb 2022 13:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645538074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZu74FgSjB/rpCfXa1jks7r8htM6rIeqjm2pKN6NurI=;
        b=bdfz+CLTCg7YcB/WYiXQGF4DhpFrTNGreYShKgefEbksolPOuyrZuOQtfLI2bZq75MehYK
        7IPct8jxLmMx0hHgmYqQjUxWgDWR9LKXvl5P4Rr2xb8o8UryP/eXNnPFSExFVnSG/OLNWK
        dBObsY+of2qfkXWnbHJg2lkezOF8v00=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1225313B98;
        Tue, 22 Feb 2022 13:54:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7116AhrrFGJrbwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 22 Feb 2022 13:54:34 +0000
Message-ID: <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
Subject: Re: [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
From:   Martin Wilck <mwilck@suse.com>
To:     NeilBrown <neilb@suse.de>, Peter Rajnoha <prajnoha@redhat.com>
Cc:     Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.com>,
        lvm-devel@redhat.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>
Date:   Tue, 22 Feb 2022 14:54:33 +0100
In-Reply-To: <164548656531.8827.3365536065813085321@noble.neil.brown.name>
References: <20220216205914.7575-1-mwilck@suse.com>
        , <164504936873.10228.7361167610237544463@noble.neil.brown.name>
        , <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
        , <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
         <164548656531.8827.3365536065813085321@noble.neil.brown.name>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Neil,

On Tue, 2022-02-22 at 10:36 +1100, NeilBrown wrote:
> 
> > The flags that DM use for udev were introduced before systemd
> > project
> > even existed. We needed to introduce the
> > DM_UDEV_DISABLE_OTHER_RULES_FLAG
> > to have a possibility for all the "other" (non-dm) udev rules to
> > check
> > for if there's another subsystem stacking its own devices on top of
> > DM
> > ones.
> 
> If this is an established API that DM uses, then presumably it is
> documented somewhere.  If a link to that documentation were provided,
> it
> would look a a whole lot less like a hack.

Peter has provided a link to libdevmapper.h in his previous post in
this thread. Is this a request for me to include that link in the patch
description?

Regards,
Martin

