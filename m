Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2533C47082
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 23:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA28613F9
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 23:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFCXcz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Jun 2021 19:32:55 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:32774 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCXcz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Jun 2021 19:32:55 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E6EAB1FD30;
        Thu,  3 Jun 2021 23:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622763068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2dvJQ7czwwphvmFOM8Yhaf61tC8CBhWetp+VRV2v5DQ=;
        b=y7AChokVOkDNWpo6hj/B0CfFmm/qa2XB/6WI2ARVZZriaUxO+xS5gSyRALc1W/PmUxlFim
        IvHxzHOlBU4Hd3Un85aoGsb+DqnhsnvM0jHsioPwfTg83Go5QsoBHUpArk3Kk4sL/FnJjW
        aaiojGLsVr+9BF0/ZRUMj8hwurUd+xo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622763068;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2dvJQ7czwwphvmFOM8Yhaf61tC8CBhWetp+VRV2v5DQ=;
        b=EH+R5QlcgHvnWeQrabaebrFZ+wsscHsPDUqB38UJwpRIvKRMJ/i6QzUXYDKh27VyNqNHRl
        5Z28Qeb6ugExRvAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 9CE75118DD;
        Thu,  3 Jun 2021 23:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622763068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2dvJQ7czwwphvmFOM8Yhaf61tC8CBhWetp+VRV2v5DQ=;
        b=y7AChokVOkDNWpo6hj/B0CfFmm/qa2XB/6WI2ARVZZriaUxO+xS5gSyRALc1W/PmUxlFim
        IvHxzHOlBU4Hd3Un85aoGsb+DqnhsnvM0jHsioPwfTg83Go5QsoBHUpArk3Kk4sL/FnJjW
        aaiojGLsVr+9BF0/ZRUMj8hwurUd+xo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622763068;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2dvJQ7czwwphvmFOM8Yhaf61tC8CBhWetp+VRV2v5DQ=;
        b=EH+R5QlcgHvnWeQrabaebrFZ+wsscHsPDUqB38UJwpRIvKRMJ/i6QzUXYDKh27VyNqNHRl
        5Z28Qeb6ugExRvAA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id +YBrEztmuWArGwAALh3uQQ
        (envelope-from <neilb@suse.de>); Thu, 03 Jun 2021 23:31:07 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     gal.ofri@storing.io
Cc:     linux-raid@vger.kernel.org, "Gal Ofri" <gal.ofri@storing.io>,
        "Song Liu" <song@kernel.org>
Subject: Re: [PATCH] md/raid5: reduce lock contention in read_one_chunk()
In-reply-to: <20210603135425.152570-1-gal.ofri@storing.io>
References: <20210603135425.152570-1-gal.ofri@storing.io>
Date:   Fri, 04 Jun 2021 09:31:04 +1000
Message-id: <162276306409.16225.1432054245490518080@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 03 Jun 2021, gal.ofri@storing.io wrote:
> * Note: I tried to use a simple spinlock rather than a rwlock, but contenti=
on
> remains this way.

This surprises me.  I only expect rwlocks to be a benefit when the
readlock is held for significantly longer than the time it takes to get
an uncontended lock, and I don't think that is happening here.
However, you have done the measurements (thanks for that!) and I cannot
argue with numbers.

However it does suggest that the lock is still heavily contented.  I
wonder if we can do better.  Can we make the common case lockless?
e.g. change the read_one_chunk code to something like
 =20
  if (!conf->quiesce) {
         atomic_inc(&conf->active_aligned_reads);
         did_inc =3D true;
  }
  if (smp_load_acquire(&conf->quiesce)) {
            if (did_inc && atomic_dec_and_test(&cnf->active_aligned_reads))
                 wakeup(conf->wait_for_quiescent);
            old code goes here
  }

and probably change the "conf->quiesce =3D 2" in raid5_quiesce() to
    smp_store_release(&conf->quiesce, 2);


Could you try that and report results?  Thanks.

NeilBrown
