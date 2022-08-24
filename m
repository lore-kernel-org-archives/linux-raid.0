Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A6EC00140
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 16:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbiHXQX5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 12:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238635AbiHXQXv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 12:23:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09039C1F8
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 09:23:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 62EC634568;
        Wed, 24 Aug 2022 16:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661358224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wtw43/986k4UNehFV3h0cYqDKJxuLMdI9cCOYoJKW6Q=;
        b=ZW08gGXugjnU9mZlTTQJi68QcBGL5GdepmM/qSMz0u7IgWOgva8402shS+NJif6aGUxwml
        5pu8VbsX08pYFcMOMkhfC5yeNIWs9j41YlTuMJ+UVvSTTFjo1qHXZuXNKdW5XVs3SZfe/v
        CQxkv26f0CL8m93rh49cXMFC/m5dqrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661358224;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wtw43/986k4UNehFV3h0cYqDKJxuLMdI9cCOYoJKW6Q=;
        b=0YUybIUnLSotZpnK4f+qfg15x8ABUlMd5Wr90MmgaosY0j/lICUoEY5NAMqwaEjFhJ6U+Z
        pxD1Xm/8LHL+TZDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F04EE13780;
        Wed, 24 Aug 2022 16:23:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zVjYLY5QBmNtNQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 24 Aug 2022 16:23:42 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: Python tests
From:   Coly Li <colyli@suse.de>
In-Reply-To: <11ab82$jvatnj@fmsmga008-auth.fm.intel.com>
Date:   Thu, 25 Aug 2022 00:23:40 +0800
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8C1AB1D5-54FD-406C-BBA3-509F669C9116@suse.de>
References: <11ab82$jvatnj@fmsmga008-auth.fm.intel.com>
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8824=E6=97=A5 16:15=EF=BC=8CLukasz Florczak =
<lukasz.florczak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
> I want to write some mdadm tests for assemblation and incremental
> regarding duplicated array names in config and I'd like to do it in
> python. I've seen that some time ago[1] you said that you could try to
> integrate the python tests framework into the mdadm ci. I was =
wondering
> how is it going? Do you need any help with this subject?
>=20
> Thanks,
> Lukasz
>=20
> [1] https://marc.info/?l=3Dlinux-raid&m=3D165277539509464&w=3D2

Hi Lukasz,

Now I just make some of the existed mdadm test scripts running, which =
are copied from upstream mdadm. There won=E2=80=99t be any conflict for =
the python testing code between you and me, because now I am just =
studying Python again and not do any useful thing yet.

As I said if no one works on the testing framework, I will do it, but it =
may take time. How about posting out the python code once you make it, =
then let=E2=80=99s put it into mdadm-test to test mdadm-CI, and improve =
whole things step by step.

Thanks.

Coly Li



