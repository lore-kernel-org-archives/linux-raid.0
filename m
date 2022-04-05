Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E8DC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 01:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349476AbiDFBWW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450283AbiDEWZA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 18:25:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB1B1788E6
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 14:24:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7F5461F37D;
        Tue,  5 Apr 2022 21:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649193846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mZO2Hf6or89F8u3EhDa2AP1VOa0DNuSXf5xCG9Cgeso=;
        b=V2vla/fHA/xcBMlOOIvMfEnwuS6JQGWrloVp7QqZ7SK14dJWjwYlp7mQVOpN8DRzfJ1hgj
        +HQEwi8z94xR+nL2+asEu0Kfl6SBxb+CBfSSJTuxEaIBxg5+2tLvccNiyLqLJAEXZg1+Ut
        sXaiLD6/wWyiTDZr65lSscmuk542+Sc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649193846;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mZO2Hf6or89F8u3EhDa2AP1VOa0DNuSXf5xCG9Cgeso=;
        b=+rH0TUaAoW7IGCsh9Pt3N3Mf8EEaKGduTAIUdGOSuhzqWLcj6LzvLiWHvz54gSFWD83Vww
        Ekzd7vWztP2OV3Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AF5B213A04;
        Tue,  5 Apr 2022 21:24:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Cm5KG3WzTGLPAQAAMHmgww
        (envelope-from <neilb@suse.de>); Tue, 05 Apr 2022 21:24:05 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Pascal Hambourg" <pascal@plouf.fr.eu.org>
Cc:     linux-raid@vger.kernel.org
Subject: Re: RAID0 layout if strip_zone[1].nb_dev=1 ?
In-reply-to: <7fb90df2-8913-717f-7078-550d59c94054@plouf.fr.eu.org>
References: <7fb90df2-8913-717f-7078-550d59c94054@plouf.fr.eu.org>
Date:   Wed, 06 Apr 2022 07:24:02 +1000
Message-id: <164919384282.10985.10644950304504061908@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 06 Apr 2022, Pascal Hambourg wrote:
> [Please Cc me, I am not subscribed to the list]
> 
> Hello,
> 
> This is a question about original/alternate layout enforcement for RAID0 
> arrays with members of different sizes introduced by commits
> c84a1372df929033cb1a0441fb57bd3932f39ac9 ("md/raid0: avoid RAID0 data 
> corruption due to layout confusion.)" and
> 33f2c35a54dfd75ad0e7e86918dcbe4de799a56c ("md: add feature flag 
> MD_FEATURE_RAID0_LAYOUT").
> 
> The layout is irrelevant if all members have the same size so the array 
> has only one zone. But isn't it also irrelevant if the array has two 
> zones and the second zone has only one device, for example if the array 
> has two members of different sizes ?
> 
Yes.

Thanks,
NeilBrown
