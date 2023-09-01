Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852B6CA0FE9
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 08:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348585AbjIAIFB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 04:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240849AbjIAIFA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 04:05:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A043E56
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 01:04:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 47A702183A;
        Fri,  1 Sep 2023 08:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693555496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4t5xvki63577YuGaTCESG7L+CxKk0i+s7+vMNPLKcik=;
        b=Bw42zbNKycnJojqPhUCWJcAk50Tr+VEuiIF1iTaRmDmqOgyTrUqoTzkAl2uCkrl5cdpOH+
        An+tY/1AfuELUA9XbKB0Ak+aWLlhl16FgCBL5hBrwLz6vUh+00emPRzOWreLySzp0dxW/f
        OLnC06L5sPTe6arKOyFEFix+86zryJ8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 016021358B;
        Fri,  1 Sep 2023 08:04:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xsaEOieb8WTQEgAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 08:04:55 +0000
Message-ID: <c0cf475b190e7ab85061a9f462f4ea07587fa7eb.camel@suse.com>
Subject: Re: [Question] mdadm CVE-2023-28736 and CVE-2023-28938 problem
From:   Martin Wilck <mwilck@suse.com>
To:     miaoguanqin <miaoguanqin@huawei.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, colyli@suse.de,
        linux-raid@vger.kernel.org
Cc:     linfeilong <linfeilong@huawei.com>, louhongxiang@huawei.com,
        lixiaokeng@huawei.com
Date:   Fri, 01 Sep 2023 10:04:55 +0200
In-Reply-To: <0837f65fca414498441d6f18904d89f9a09e1a9e.camel@suse.com>
References: <72867401-8805-4bdb-abe4-c34ff2f06f07@huawei.com>
         <0837f65fca414498441d6f18904d89f9a09e1a9e.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 2023-08-31 at 12:04 +0200, Martin Wilck wrote:
> On Thu, 2023-08-31 at 17:26 +0800, miaoguanqin wrote:
> > Dear mdadm committers:
> >=20
> > Hi! I noticed that the community did not provide the concrete patch
> > that could fix CVE-2023-28736 and CVE-2023-28938. Intel, in
> > specific,
> > suggests upgrading mdadm to version 4.2-rc2 or later [1], to get
> > rid
> > of
> > the issue, however, without finding the root cause or providing
> > further
> > explanation.I would like to know if there is such a specific patch,
> > or a set of patches that actually solve these two CVE problems.
> >=20
> > [1]=20
> > https://www.intel.com/content/www/us/en/security-center/advisory/intel-=
sa-00690.html
> >=20
>=20
> I think it's ced5fa8 ("mdadm: block creation with long names").

... and the other was  7d374a1 ("Fix memory leak after "mdadm --
detail"")

Martin

