Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2BFC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 21 Feb 2022 23:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiBUXgl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Feb 2022 18:36:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiBUXgk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Feb 2022 18:36:40 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB6525595
        for <linux-raid@vger.kernel.org>; Mon, 21 Feb 2022 15:36:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3096621100;
        Mon, 21 Feb 2022 23:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645486575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoPTsWGZsubWnpkaPgkDJ13wzvLVMLKE84KgUz1gWbQ=;
        b=uY58L9RSyZxZIkx4U+rfhjyw3JwomRIFJ31V9xY/5vTF3nagp5WiqKaA6tFHZGfBHYGacj
        F+LwYVow1k+EoHj2SS2fwvcBNBa2B+Wg8uET4cURNgihQRUh4CW6dKrif72IKf7jpw3c57
        1SAjMpg3P1o7Vp8yN0+rQAlxVF2X+hk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645486575;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoPTsWGZsubWnpkaPgkDJ13wzvLVMLKE84KgUz1gWbQ=;
        b=ni3aMEmh+FstaPmWShZRYVl9Rsjs6NX9NUuwyToyv3aNx+YB2DBhB5SXiCA4nXRO5NSWdT
        0tAtR1mfvEu9oYBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7871613BA7;
        Mon, 21 Feb 2022 23:36:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xJxkDewhFGInBgAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 21 Feb 2022 23:36:12 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Peter Rajnoha" <prajnoha@redhat.com>
Cc:     "Martin Wilck" <mwilck@suse.com>,
        "Jes Sorensen" <jsorensen@fb.com>, linux-raid@vger.kernel.org,
        lvm-devel@redhat.com, "Hannes Reinecke" <hare@suse.de>,
        "Heming Zhao" <heming.zhao@suse.com>, "Coly Li" <colyli@suse.com>,
        dm-devel@redhat.com
Subject: Re: [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
In-reply-to: <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
References: <20220216205914.7575-1-mwilck@suse.com>,
 <164504936873.10228.7361167610237544463@noble.neil.brown.name>,
 <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>,
 <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
Date:   Tue, 22 Feb 2022 10:36:05 +1100
Message-id: <164548656531.8827.3365536065813085321@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


> The flags that DM use for udev were introduced before systemd project
> even existed. We needed to introduce the DM_UDEV_DISABLE_OTHER_RULES_FLAG
> to have a possibility for all the "other" (non-dm) udev rules to check
> for if there's another subsystem stacking its own devices on top of DM
> ones.

If this is an established API that DM uses, then presumably it is
documented somewhere.  If a link to that documentation were provided, it
would look a a whole lot less like a hack.

Thanks,
NeilBrown

