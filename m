Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC85C4320A
	for <linux-raid@archiver.kernel.org>; Wed, 11 Aug 2021 22:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA77C61008
	for <linux-raid@archiver.kernel.org>; Wed, 11 Aug 2021 22:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhHKWx2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Aug 2021 18:53:28 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58892 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbhHKWx2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Aug 2021 18:53:28 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 75C4B1FEF2;
        Wed, 11 Aug 2021 22:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628722383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WMXOjopPdEkz64jj0WKVtBzevRFTRWfYbR3mBn6vmQs=;
        b=epXOvS4XFdm1bI0O2ASPvDVveAdzhAJWl+awfnfRrnbkpcSYyXg2wjL6ik/q7gO+9wRnMO
        L5tyaqX0xMS+DB7fKuBlyoY1ROC44utu3CDQZUAxgjqfKShd3aKVIGZ8vjDyDfbBAvXTSa
        qg0KnUYvPsQN/y7YRRks9VnTb2b9SN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628722383;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WMXOjopPdEkz64jj0WKVtBzevRFTRWfYbR3mBn6vmQs=;
        b=4DwpMDm8WizdxJpvvsn0VMer7T8oMas6XRXLvAcNcRCYAHTWvbRfds9dDP7UOyz8KB0dFq
        XW7UxRSR5rnEMnCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 20B9A13BF7;
        Wed, 11 Aug 2021 22:53:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EmC2M81UFGHSMwAAMHmgww
        (envelope-from <neilb@suse.de>); Wed, 11 Aug 2021 22:53:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Nigel Croxon" <ncroxon@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org, xni@redhat.com
Subject: Re: [PATCH V2] Fix return value from fstat calls
In-reply-to: <20210811190930.1822317-1-ncroxon@redhat.com>
References: <20210810151507.1667518-1-ncroxon@redhat.com>,
 <20210811190930.1822317-1-ncroxon@redhat.com>
Date:   Thu, 12 Aug 2021 08:52:58 +1000
Message-id: <162872237888.31578.18083659195262526588@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 12 Aug 2021, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerablility
> assessment. Static code analysis has been run and found the following
> errors:
> check_return: Calling "fstat(fd, &dstb)" without checking return value.
> This library function may fail and return an error code.

In what circumstances might it fail and return an error code?

NeilBrown
