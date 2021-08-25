Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80967C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 14:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6238861073
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 14:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241768AbhHYOgc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Aug 2021 10:36:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42434 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240114AbhHYOgb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Aug 2021 10:36:31 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 427E222207;
        Wed, 25 Aug 2021 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629902145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=X8n1ifp2+Ye3e+kZcawyYARbkg48KaNoOeYTKrAJvlg=;
        b=2V4CYc7b89OHh4QTVCdrGxsuaky9pfxEtMnFtsL4NLCZTIrYDJYLHmUTXwss9XolWFIdjd
        lvRhaYmVpgVS8ocRLX6ZSWzvfrvSSMaAsAbOgMLVkm9t4CuTYDrIAZQNoX8Udhczuut8bF
        z2tszf4CtJg75Cwr/FNQuZ1Khr4hmEU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629902145;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=X8n1ifp2+Ye3e+kZcawyYARbkg48KaNoOeYTKrAJvlg=;
        b=cehA0XDVC4h8AmskuUI9G7QUT9nX+XvKUCbm3ONh+Wdnptb49ny6OKuP9fhhEVLrHkYQWY
        3vurhhbMrjeZvHBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 37F2413C28;
        Wed, 25 Aug 2021 14:35:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kYxQDUFVJmFWbAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 25 Aug 2021 14:35:45 +0000
To:     Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.de>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Subject: [PATCH] mdadm: split off shared library
Message-ID: <7461b27b-2a4b-fbbb-5cfd-8fab416cbc9f@suse.de>
Date:   Wed, 25 Aug 2021 16:35:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,

this is, contrary to the subject, not a patch, but rather a question on
how to submit a patchset.
I've been working on splitting off a shared library from mdadm, with the
aim that it can be included from other programs.
Reasoning behind it that I've written a monitor program
(github.com:/hreinecke/md_monitor) and found it a major pain having to
exec() mdadm, and then keep fingers crossed that things succeed; error
recovery from _that_ turned out to be a major drag. And so I figured
that a shared library is possibly the best way to go.

(And, as a side note: having a shared library would also allow to build
a python binding, which possibly will have even more use-cases ...)

So I've build a patchset to split off a shared library from mdadm, and
build mdadm against that:

git://git.kernel.org/pub/scm/linux/kernel/git/hare/mdadm.git
branch shlib

But as it turns out, these are 30+ patches, and I didn't want to flood
the mailinglist with that.
So what are the procedures here?

Are you okay with having the entire patchset on the mailing list?
Or are there other ways?

Thanks for your help.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
