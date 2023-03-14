Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DEDC6FD1D
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 15:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCNPE1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 11:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCNPE0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 11:04:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418049F06A
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 08:04:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EB9501F899;
        Tue, 14 Mar 2023 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678806263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p04vrQzAB+lkqXv14PcJ5zyeqfr2X0umwJUhGoxjfF0=;
        b=ATN6d4nkX/JOlTe61TXx8q9JSNtCklMo48N3rq6Qvwp+BMpzZ+KjCNRNjZCE64C/TP3zV0
        hIzawAlv1QQtk0DqrXIxJ/qtrXdnZZJ8IRvjm2Y0A/CZ2PqJvoxzRpsO5Z2z2IBd9BKOSZ
        ZhWc5SWVcaJLSvnIRn2EYl6WbtZiwXk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9A64F13A1B;
        Tue, 14 Mar 2023 15:04:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id USHzI/eMEGT7MwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 14 Mar 2023 15:04:23 +0000
Message-ID: <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm
 mdadm --incremental --export"
From:   Martin Wilck <mwilck@suse.com>
To:     Li Xiao Keng <lixiaokeng@huawei.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org
Cc:     linfeilong <linfeilong@huawei.com>, louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Date:   Tue, 14 Mar 2023 16:04:23 +0100
In-Reply-To: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 2023-03-14 at 22:58 +0800, Li Xiao Keng wrote:
> Hi,
> =C2=A0=C2=A0 Here we meet a question. When we add a new disk to a raid, i=
t may
> return
> -EBUSY.
> =C2=A0=C2=A0 The main process of --add=EF=BC=88for example md0, sdf):
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.dev_open(sdf)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.add_to_super
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.write_init_super
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.fsync(fd)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.close(fd)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.ioctl(ADD_NEW_DISK).
> =C2=A0=C2=A0 However, there will be some udev(change of sdf) event after =
step5.
> Then
> "/usr/sbin/mdadm --incremental --export $devnode --offroot
> $env{DEVLINKS}"
> will be run, and the sdf will be added to md0. After that, step6 will
> return
> -EBUSY.
> =C2=A0=C2=A0 It is a problem to user. First time adding disk does not ret=
urn
> success
> but disk is actually added. And I have no good idea to deal with it.
> Please
> give some great advice.

I haven't looked at the code in detail, but off the top of my head, it
should help to execute step 5 after step 6. The close() in step 5
triggers the uevent via inotify; doing it after the ioctl should avoid
the above problem.

Another obvious workaround in mdadm would be to check the state of the
array in the EBUSY case and find out that the disk had already been
added.

But again, this was just a high-level guess.

Martin

