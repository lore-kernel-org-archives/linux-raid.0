Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D60C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 16:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383560AbiBHQvc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 11:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352392AbiBHQvc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 11:51:32 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A55FC061578
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 08:51:32 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id ED3DC210FF;
        Tue,  8 Feb 2022 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644339090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHH/88UX7WLl3K3TpYHGDWPNU8IY6bF0y7mGF2g32pk=;
        b=i/trnZ0sXIHbhKMGT/bQJ3O+ZYRvJP162sI0DBz7BQA5Cf6EnhZhUEKG/BdMARHter122e
        QT29dbcvCJHtYCxsgrOdkKciDwC98h2lT/ILv6U/0EN7RwBI/xx6lPJmY/j2SdUbdEuXLC
        ZSK4lPo4zBPOQ9CBgQVSpRqaCnzxbHw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644339090;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHH/88UX7WLl3K3TpYHGDWPNU8IY6bF0y7mGF2g32pk=;
        b=5+l220907oqXHX2/VsP7DhN8VOvgv4wHmRB60I2sZQXdoE5ZkAZBfAAqQVL7VUVEKy5Qix
        wOxW8h2XNxeLI4Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DAA7B13A1A;
        Tue,  8 Feb 2022 16:51:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 52xsNJKfAmLCUgAAMHmgww
        (envelope-from <dmueller@suse.de>); Tue, 08 Feb 2022 16:51:30 +0000
From:   Dirk =?ISO-8859-1?Q?M=FCller?= <dmueller@suse.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] fix multiple definition linking error due to missing extern
Date:   Tue, 08 Feb 2022 17:51:30 +0100
Message-ID: <2235987.xdJb8MTqgy@magnolia>
Organization: SUSE Software Solutions Germany GmbH; GF: Ivo Totev; HRB 36809 (AG =?UTF-8?B?TsO8cm5iZXJnKQ==?=
In-Reply-To: <CAPhsuW58UrCJMgKiW0mRSMbc00UoZtY=944Ut1SvjDHewM+gmA@mail.gmail.com>
References: <20220206205137.21717-1-dmueller@suse.de> <CAPhsuW58UrCJMgKiW0mRSMbc00UoZtY=944Ut1SvjDHewM+gmA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Dienstag, 8. Februar 2022 06:45:45 CET Song Liu wrote:

Hi Song,

> > -struct raid6_calls raid6_call;
> > +extern struct raid6_calls raid6_call;
> 
> Can we just remove this line?

oh yes indeed, it is already declared in the header file. that is much simpler. 
I've sent a PATCH v2 just now. 

Thank you,
Dirk



