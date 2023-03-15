Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D44AC6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 14:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbjCOOPy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 10:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjCOOPf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 10:15:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728768F53C
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 07:15:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CE0FF219B6;
        Wed, 15 Mar 2023 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678889669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YRi37vIyMHgz3YYxB4sk+K+TbXjEsEAkdaT9bdCMJHE=;
        b=sRLW2fxUqeWEpG8vpOBYGX9DAKk69L4Q3zL/vkbuqezHXYG9xMLFyt+IKamnIoKVk4T4zh
        wJN01RO3PL4Uo8HrwsokUVuzuZ3NMw+Ma7fTPj/XQRsdRoL5C+mrkNxFC6rza3kKkCWXpW
        o872+EzW9/MyGFZ/1zBcX1dHm9gTzZ8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E60C13A2F;
        Wed, 15 Mar 2023 14:14:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id B0TqGMXSEWQjQgAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 15 Mar 2023 14:14:29 +0000
Message-ID: <c3d451cc0c96d1a8c8d129448c1d7c3e340e8fac.camel@suse.com>
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
Date:   Wed, 15 Mar 2023 15:14:28 +0100
In-Reply-To: <cbea1358-768d-d5f7-5733-06687ad3243a@huawei.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
         <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
         <20230314165938.00003030@linux.intel.com>
         <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
         <20230315111027.0000372d@linux.intel.com>
         <cbea1358-768d-d5f7-5733-06687ad3243a@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 2023-03-15 at 21:10 +0800, Li Xiao Keng wrote:
> >=20
> =A0 I test move close() after ioctl(). The reason of EBUSY is that
> mdadm
> open(sdf) with O_EXCL. So fd should be closed before ioctl. When I
> remove
> O_EXCL, ioctl() will return success.

This makes sense. I suppose mdadm must use O_EXCL if it modifies RAID
meta data, otherwise data corruption is just too likely. It is also
impossible to drop the O_EXCL flag with fcntl() without closing the fd.

So, if mdadm must close the fd before calling ioctl(), the race can
hardly be avoided. The close() will cause a uevent, and nothing
prevents the udev rules from running before the ioctl() returns.

Unless we want to explore the flag-in-tmpfs idea, I think mdadm must
expect this to happen, and deal with -EBUSY accordingly.

But first we should get an answer to Coly's question, which version of
mdadm is in use?

Martin

