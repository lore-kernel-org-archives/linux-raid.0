Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CFFC61DA4
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 15:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjCOPCv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 11:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjCOPCc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 11:02:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5539C6F4B3
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 08:01:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0D79F1FD7C;
        Wed, 15 Mar 2023 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678892487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhekvPnw88JecXtqKAPfB8BWggLLDulP9x+6ZfxYjX8=;
        b=g3WLLOw/UDWheQsqpUwgZ6E7Ri0smPE7tknW795cFUPWRSGzdMvBH8g4eEHGA2kI6gwEF8
        kzMA4Q6jt9yLC393SGiLmfebFV20hi9CpTIrTYiM3pJmbXhZ35pS0zC/505QyZGFuNPAjl
        gd7bxZLLmnCqh10Sx9BpwQ6YWG1jafQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A724213A00;
        Wed, 15 Mar 2023 15:01:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oCcyJ8bdEWS1WwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 15 Mar 2023 15:01:26 +0000
Message-ID: <e5e2cf8fc9903aab6a781c5b925d12023a59b387.camel@suse.com>
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm
 mdadm --incremental --export"
From:   Martin Wilck <mwilck@suse.com>
To:     Li Xiao Keng <lixiaokeng@huawei.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Song Liu <song@kernel.org>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
        louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Date:   Wed, 15 Mar 2023 16:01:26 +0100
In-Reply-To: <5fe3dfca-10ad-989a-717d-3007b04163ed@huawei.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
         <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
         <20230314165938.00003030@linux.intel.com>
         <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
         <20230315111027.0000372d@linux.intel.com>
         <cbea1358-768d-d5f7-5733-06687ad3243a@huawei.com>
         <c3d451cc0c96d1a8c8d129448c1d7c3e340e8fac.camel@suse.com>
         <5fe3dfca-10ad-989a-717d-3007b04163ed@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 2023-03-15 at 22:57 +0800, Li Xiao Keng wrote:
>=20
>=20
> On 2023/3/15 22:14, Martin Wilck wrote:
> > On Wed, 2023-03-15 at 21:10 +0800, Li Xiao Keng wrote:
> > > >=20
> > > =A0 I test move close() after ioctl(). The reason of EBUSY is that
> > > mdadm
> > > open(sdf) with O_EXCL. So fd should be closed before ioctl. When
> > > I
> > > remove
> > > O_EXCL, ioctl() will return success.
> >=20
> > This makes sense. I suppose mdadm must use O_EXCL if it modifies
> > RAID
> > meta data, otherwise data corruption is just too likely. It is also
> > impossible to drop the O_EXCL flag with fcntl() without closing the
> > fd.
> >=20
> > So, if mdadm must close the fd before calling ioctl(), the race can
> > hardly be avoided. The close() will cause a uevent, and nothing
> > prevents the udev rules from running before the ioctl() returns.
> >=20
> =A0 Now I find that close() cause a change udev. Is it necessary to
> import
> "mdadm --incremental --export" when change udev cause? Can we ignore
> it?

Normally this is what you want to happen if a change uevent for a MD
member device is processed.

The case you're looking at is the exception, as another instance of
mdamn is handling the device right at this point in time.

Martin

