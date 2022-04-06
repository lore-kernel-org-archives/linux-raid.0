Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B20C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 22:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbiDFW6D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 18:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237483AbiDFW5b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 18:57:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428636212E
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 15:55:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C46931F85A;
        Wed,  6 Apr 2022 22:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649285731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efio6wirR9Gt/5apr7rvzSrof+TIXx8+lQU4QBZWiZg=;
        b=H03FDTTulqoZ4VtYUKXHt4L8jc+eG/JZ90SY9KyOqCL1nahou+fgkNC4USt321PDwSUacO
        EQuD3oCmJiA/oABCNb6fsr8VQOz/6xX2rWXKJXUk0lvt2Q9TcFNzq/tUSTOo3F0JErRvxa
        v6KTzFfMf9fjy8Imr8CIi60Rz9ps220=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649285731;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efio6wirR9Gt/5apr7rvzSrof+TIXx8+lQU4QBZWiZg=;
        b=RTH78ehk23alTMFdBiqtfXSVRQzSiufnpPXVmZpjtZsMgvmOD94v5STkh1RWHKutr1x6s7
        BSNVYagsfojSyiBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EDFD8139F5;
        Wed,  6 Apr 2022 22:55:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id m0A8KmIaTmIBVgAAMHmgww
        (envelope-from <neilb@suse.de>); Wed, 06 Apr 2022 22:55:30 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Pascal Hambourg" <pascal@plouf.fr.eu.org>
Cc:     linux-raid@vger.kernel.org
Subject: Re: RAID0 layout if strip_zone[1].nb_dev=1 ?
In-reply-to: <3d16d210-2077-26bf-1eb7-6b9c5ab5fd24@plouf.fr.eu.org>
References: <7fb90df2-8913-717f-7078-550d59c94054@plouf.fr.eu.org>,
 <164919384282.10985.10644950304504061908@noble.neil.brown.name>,
 <3d16d210-2077-26bf-1eb7-6b9c5ab5fd24@plouf.fr.eu.org>
Date:   Thu, 07 Apr 2022 08:55:27 +1000
Message-id: <164928572784.10985.3756904836293591231@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 06 Apr 2022, Pascal Hambourg wrote:
> On 05/04/2022, NeilBrown wrote:
> > On Wed, 06 Apr 2022, Pascal Hambourg wrote:
> >>
> >> This is a question about original/alternate layout enforcement for RAID0
> >> arrays with members of different sizes introduced by commits
> >> c84a1372df929033cb1a0441fb57bd3932f39ac9 ("md/raid0: avoid RAID0 data
> >> corruption due to layout confusion.)" and
> >> 33f2c35a54dfd75ad0e7e86918dcbe4de799a56c ("md: add feature flag
> >> MD_FEATURE_RAID0_LAYOUT").
> >>
> >> The layout is irrelevant if all members have the same size so the array
> >> has only one zone. But isn't it also irrelevant if the array has two
> >> zones and the second zone has only one device, for example if the array
> >> has two members of different sizes ?
> >
> > Yes.
> 
> So wouldn't it make sense to allow assembly even when the layout is 
> undefined, like what is done when the array has only one zone ?
> 
Yes.

NeilBrown


P.S.  maybe you would like to try making the code change yourself, and
posting the patch.
