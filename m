Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02779C64ED6
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 02:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjBXCLV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 21:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBXCLU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 21:11:20 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49805E844
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 18:11:18 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5692C5CE3B;
        Fri, 24 Feb 2023 02:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677204677; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p7mETbhBTjBSUBik/hFNQVh6YB/2TUcMIN8qo/ngQ68=;
        b=1V7frcV94dS6u9SkpHr41yP90JNvIQAYkOPBgM7Girc1r0JtCKLzjMDB2Rdn34zuEjYCs2
        uIB69iTyempMwDtVJShTnUrGQX2AMNt796+QgIdeWcG2ad1naRwQE3DnXnBblOEdsfgO5K
        FOvVeEEYovRmBSEFCDTl17zVFGiwX58=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677204677;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p7mETbhBTjBSUBik/hFNQVh6YB/2TUcMIN8qo/ngQ68=;
        b=2FjJ1BK3hXEfscQEhSZPnYklV2FNHO3H26mQXy3IMol3rAcVsJiDxK3XyAa7XhwXIdNIt3
        iYdS3Q+O9prK16Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 802071391B;
        Fri, 24 Feb 2023 02:11:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wtuzE8Mc+GPBdQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 24 Feb 2023 02:11:15 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH V4] Fix NULL dereference in super_by_fd
From:   Coly Li <colyli@suse.de>
In-Reply-To: <a4a44d2e-c4a5-4545-16cc-fae51dd37a3d@huawei.com>
Date:   Fri, 24 Feb 2023 10:11:02 +0800
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>,
        linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <168C2F9D-956A-40CE-AE32-56609BA2FD07@suse.de>
References: <1dabb70e-ca1a-bd45-182a-ddaa95821f86@huawei.com>
 <20221221130548.000071e8@linux.intel.com>
 <98968834-e6ee-530a-ebd0-7dba00ac1c78@huawei.com>
 <a4a44d2e-c4a5-4545-16cc-fae51dd37a3d@huawei.com>
To:     Li Xiao Keng <lixiaokeng@huawei.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=8824=E6=97=A5 09:02=EF=BC=8CLi Xiao Keng =
<lixiaokeng@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> ping

Copied. I will take a look soon.

Thanks for reminding.

Coly Li

