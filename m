Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC33FC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 23 Feb 2022 09:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbiBWJsJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Feb 2022 04:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiBWJsI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Feb 2022 04:48:08 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3037485965
        for <linux-raid@vger.kernel.org>; Wed, 23 Feb 2022 01:47:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E063921110;
        Wed, 23 Feb 2022 09:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645609659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eiC0481NuHrVIJ5PPmUgWeysIPdKws/Gm5egAG3N/x8=;
        b=CeCjsADeMztzXSpjp29eYKu5ffddpi3EfjmKdWiPgJk2W0y88ZzTmKJqUBUs0OwgVHnmoO
        USNBIAhykcMT0ldJTVAm0yD2sUWbuRSsNQ9JWk7wCuhTBvxAk5OFHTUiEpFLOwgmWdw4YR
        HvswniJibhGu06hUln91xy9PU+CGbck=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7C1BB13C6E;
        Wed, 23 Feb 2022 09:47:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kAwZHLsCFmK2NAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 23 Feb 2022 09:47:39 +0000
Message-ID: <d3aab8f2318f1438a1f0085eddf9713217d52391.camel@suse.com>
Subject: Re: [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
From:   Martin Wilck <mwilck@suse.com>
To:     NeilBrown <neilb@suse.de>
Cc:     Peter Rajnoha <prajnoha@redhat.com>,
        Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.com>,
        lvm-devel@redhat.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>
Date:   Wed, 23 Feb 2022 10:47:38 +0100
In-Reply-To: <164557016782.28944.17731814770525408828@noble.neil.brown.name>
References: <20220216205914.7575-1-mwilck@suse.com>
        , <164504936873.10228.7361167610237544463@noble.neil.brown.name>
        , <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
        , <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
        , <164548656531.8827.3365536065813085321@noble.neil.brown.name>
        , <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
         <164557016782.28944.17731814770525408828@noble.neil.brown.name>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Neil,

On Wed, 2022-02-23 at 09:49 +1100, NeilBrown wrote:
> > 
> > Peter has provided a link to libdevmapper.h in his previous post in
> > this thread. Is this a request for me to include that link in the
> > patch
> > description?
> 
> If libdevmapper.h is the best documentation there is for this
> variable,
> then hopefully you can see why it feels to an outsider like a hack.
> 

There's also some documentation in the form of comments in the device-
mapper rules files themselves:

https://github.com/lvmteam/lvm2/blob/8dccc2314e2482370bc6e5cf007eb210994abdef/udev/10-dm.rules.in#L137

In general, 10-dm.rules is one of the most extensively commented rule
files. I've always found these comments quite helpful.

> It isn't even immediately clear that the text there is talking about
> environment variables visible in udev.
> If there is an expectation that tools outside of lvm2 will use these,
> then they really should be documented properly.  SYSTEMD_READY is
> documented in "man systemd.device".  How hard would it be to write a
> "dm-udev" man page which explains all this.

I agree that the documentation could be improved. OTOH, the text in
systemd.device(5) only explains how systemd itself interprets
SYSTEMD_READY. It doesn't say a word about how other udev rules are
supposed to deal with the device. IOW, SYSTEMD_READY is part of an API
between udev rules and systemd, and not between different udev rule
sets.

In particular the "don't probe this iff SYSTEMD_READY==0" semantics
that are frequently used in rules files can't be inferred from this
documentation. It makes sense most of the time, but there are some
cases where it doesn't. Here, we have a case where probing should be
skipped, even though SYSTEMD_READY is not 0.

Regards,
Martin

PS: The big issue remains that there is no "official" API in which udev
rule sets can transport information between each other. I guess the
original idea was that every rule set would be self-contained, which
isn't the case any more. If anyone makes an effort redesign udev, they
should consider creating such an API somehow.
