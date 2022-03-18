Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448BAC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 18 Mar 2022 22:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbiCRWoK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Mar 2022 18:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiCRWoJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Mar 2022 18:44:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F26193148
        for <linux-raid@vger.kernel.org>; Fri, 18 Mar 2022 15:42:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6C49B1F37C;
        Fri, 18 Mar 2022 22:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647643368; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hK+VIFqpMeO+jWoArPz0m3Jg5uy5JzBEDBP0tRVyZvc=;
        b=H36ARSWZrBMJh+K+B5ImHrKq3sJlckp8MSjlrtv7ba3vptkARbEhKBmIFwU59CIkKVwl2I
        nleavfV9b0MWEJXfdto9k+Mj3Bw10Lnl0So6ZH12WOc/ZQIVe2N4HRN9hiSDjBDTlaLMiQ
        VdFInhIP/p1qAS/QmMSvTMn1iO9/zgY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 108DA132C1;
        Fri, 18 Mar 2022 22:42:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +XWTAegKNWJSegAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 18 Mar 2022 22:42:48 +0000
Message-ID: <070c14f1a5e3a57bb45579991447d3267375e48f.camel@suse.com>
Subject: Re: [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
From:   Martin Wilck <mwilck@suse.com>
To:     Jes Sorensen <jsorensen@fb.com>, NeilBrown <neilb@suse.de>
Cc:     Peter Rajnoha <prajnoha@redhat.com>, Coly Li <colyli@suse.com>,
        lvm-devel@redhat.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>
Date:   Fri, 18 Mar 2022 23:42:47 +0100
In-Reply-To: <ff8030340e30963a1772f43e8bdfb6b610219887.camel@suse.com>
References: <20220216205914.7575-1-mwilck@suse.com>
         , <164504936873.10228.7361167610237544463@noble.neil.brown.name>
         , <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
         , <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
         , <164548656531.8827.3365536065813085321@noble.neil.brown.name>
         , <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
         <164557016782.28944.17731814770525408828@noble.neil.brown.name>
         <ff8030340e30963a1772f43e8bdfb6b610219887.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Jes,

On Mon, 2022-02-28 at 09:48 +0100, Martin Wilck wrote:
> On Wed, 2022-02-23 at 09:49 +1100, NeilBrown wrote:
> > 
> > But if libdevmapper.h is the best you have, then maybe it'll have
> > to
> > do.
> > It is up to Jes what he accepts of course.
> 
> Jes, have you made up your mind on this patch yet?
> Please contact me if you have remarks or questions.

Gentle reminder ...

Regards
Martin

