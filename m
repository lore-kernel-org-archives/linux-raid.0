Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E28AC83F10
	for <linux-raid@archiver.kernel.org>; Thu, 31 Aug 2023 10:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243738AbjHaKEr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Aug 2023 06:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjHaKEq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Aug 2023 06:04:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050FECED
        for <linux-raid@vger.kernel.org>; Thu, 31 Aug 2023 03:04:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B420521846;
        Thu, 31 Aug 2023 10:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693476282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nzgDR0faIKs260WWb66JufCrXbl4mJkrC1eBw16Q3Yk=;
        b=miXWmEX1SnQ7a/E1iz6UVewdKUrB5fR/sVHhYTAcpKQxVp2z3Z8p51g9fvObWu0014rMXP
        wLXIO5cf99MlQ/16J82MskbcJgxAh8P/HfP78lf8a7jc5bz+sGjukaIbZZH/ZF++o32LeD
        tmyQ/Pm5/R2lv0bICGsTUlS5WbVhUc4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 663EE13587;
        Thu, 31 Aug 2023 10:04:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Jek4F7pl8GQtLQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 31 Aug 2023 10:04:42 +0000
Message-ID: <0837f65fca414498441d6f18904d89f9a09e1a9e.camel@suse.com>
Subject: Re: [Question] mdadm CVE-2023-28736 and CVE-2023-28938 problem
From:   Martin Wilck <mwilck@suse.com>
To:     miaoguanqin <miaoguanqin@huawei.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, colyli@suse.de,
        linux-raid@vger.kernel.org
Cc:     linfeilong <linfeilong@huawei.com>, louhongxiang@huawei.com,
        lixiaokeng@huawei.com
Date:   Thu, 31 Aug 2023 12:04:41 +0200
In-Reply-To: <72867401-8805-4bdb-abe4-c34ff2f06f07@huawei.com>
References: <72867401-8805-4bdb-abe4-c34ff2f06f07@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 2023-08-31 at 17:26 +0800, miaoguanqin wrote:
> Dear mdadm committers:
>=20
> Hi! I noticed that the community did not provide the concrete patch
> that could fix CVE-2023-28736 and CVE-2023-28938. Intel, in specific,
> suggests upgrading mdadm to version 4.2-rc2 or later [1], to get rid
> of
> the issue, however, without finding the root cause or providing
> further
> explanation.I would like to know if there is such a specific patch,
> or a set of patches that actually solve these two CVE problems.
>=20
> [1]=20
> https://www.intel.com/content/www/us/en/security-center/advisory/intel-sa=
-00690.html
>=20

I think it's ced5fa8 ("mdadm: block creation with long names").

Martin

