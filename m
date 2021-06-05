Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7F9C4743E
	for <linux-raid@archiver.kernel.org>; Sat,  5 Jun 2021 00:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C540561208
	for <linux-raid@archiver.kernel.org>; Sat,  5 Jun 2021 00:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFEAcI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Jun 2021 20:32:08 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43106 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhFEAcH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Jun 2021 20:32:07 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0D1671FD49;
        Sat,  5 Jun 2021 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622853020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6DYKjCqCPJDO47Bqb6qUauttd7KnGQHyXdj3A/ZqN4=;
        b=We7vuPwyS7rdEF40zzxktUCeskoF+UbjAifPH8bSB6Behr7eJXiQWn0RqfAMJBoCI3GODH
        kEWNJlsppwR/133I63Q/wuYU0YnGkuIk8ZoUCyYdkMaYhuOh71L6tBfTzaXeVQQHReu0g1
        d+MMg4RJ/xWz0sdASPwddxkWlI3nTd0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622853020;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6DYKjCqCPJDO47Bqb6qUauttd7KnGQHyXdj3A/ZqN4=;
        b=R//tUziGmaJ2YgyKso8LsBER+HDaUWqlMlQgKhh2WgF2szifDw/7sEBQCW2saFTQnheaMo
        OJIjPUSod75F2uCA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id B524A118DD;
        Sat,  5 Jun 2021 00:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622853020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6DYKjCqCPJDO47Bqb6qUauttd7KnGQHyXdj3A/ZqN4=;
        b=We7vuPwyS7rdEF40zzxktUCeskoF+UbjAifPH8bSB6Behr7eJXiQWn0RqfAMJBoCI3GODH
        kEWNJlsppwR/133I63Q/wuYU0YnGkuIk8ZoUCyYdkMaYhuOh71L6tBfTzaXeVQQHReu0g1
        d+MMg4RJ/xWz0sdASPwddxkWlI3nTd0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622853020;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6DYKjCqCPJDO47Bqb6qUauttd7KnGQHyXdj3A/ZqN4=;
        b=R//tUziGmaJ2YgyKso8LsBER+HDaUWqlMlQgKhh2WgF2szifDw/7sEBQCW2saFTQnheaMo
        OJIjPUSod75F2uCA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id qmVmGZrFumDPTwAALh3uQQ
        (envelope-from <neilb@suse.de>); Sat, 05 Jun 2021 00:30:18 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Gal Ofri" <gal.ofri@storing.io>
Cc:     linux-raid@vger.kernel.org, "Song Liu" <song@kernel.org>
Subject: Re: [PATCH] md/raid5: reduce lock contention in read_one_chunk()
In-reply-to: <20210604121950.372672c9@gofri-dell>
References: <20210603135425.152570-1-gal.ofri@storing.io>,
 <162276306409.16225.1432054245490518080@noble.neil.brown.name>,
 <20210604114205.3daf3e68@gofri-dell>, <20210604121950.372672c9@gofri-dell>
Date:   Sat, 05 Jun 2021 10:30:14 +1000
Message-id: <162285301456.16225.18270741645959810726@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 04 Jun 2021, Gal Ofri wrote:
> Just a second thought
>=20
> > Since it only impacts quiesce now, I thought it'd be better to use spinlo=
ck afterall.
> > Please let me know if you think otherwise.
> Since slow path is only at quiesce, I can remove aligned_reads_lock altoget=
her and use device_lock like before.
> What do you think ?
>=20
Yes, I think you should remove aligned_read_lock.  Remove all of your
patch and just make the change I suggested.  Then, of course, review it
carefully to make sure you agree that it is correct.

Thanks
NeilBrown

