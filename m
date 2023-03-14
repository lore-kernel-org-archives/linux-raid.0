Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B51C6FD1F
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 16:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCNQkp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 12:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjCNQko (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 12:40:44 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B1144AB
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 09:40:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 40D811F8A3;
        Tue, 14 Mar 2023 16:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678812041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZvBvOnHUaHkegpQLr6jDY/40bp9lWULSZt660AYBBA=;
        b=dNkWOugmoJHevW9dK+14hUkq8RGO5cp9I7m+ATVwmWT2rF55NH5V/gt7TlH08jDqy7yiF/
        9wt1B42vK56nxE1tX6CPhpQ7H1e3+5dIEJXsE3Uj/Oe9SN6zzVKx03zaYWcd7e40TAlwEY
        c1g8h2FytPaX3W8z+K6avpDhPeTD164=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678812041;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZvBvOnHUaHkegpQLr6jDY/40bp9lWULSZt660AYBBA=;
        b=vNpfe+7fWYjhM7V0rzMIqZWfJMxaZxWJQ2H48qB5rrX5VkW4c2Z1pepe2y672HhqBIzih+
        diJrsOhyMllanoBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 36E9C13A26;
        Tue, 14 Mar 2023 16:40:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id l8WdAYejEGT1awAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 14 Mar 2023 16:40:39 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm mdadm
 --incremental --export"
From:   Coly Li <colyli@suse.de>
In-Reply-To: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
Date:   Wed, 15 Mar 2023 00:40:26 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        linux-raid@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
        louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D83807D8-A971-4503-9D77-7496EE59E597@suse.de>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
To:     Li Xiao Keng <lixiaokeng@huawei.com>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2023=E5=B9=B43=E6=9C=8814=E6=97=A5 22:58=EF=BC=8CLi Xiao Keng =
<lixiaokeng@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi,
>   Here we meet a question. When we add a new disk to a raid, it may =
return
> -EBUSY.
>   The main process of --add=EF=BC=88for example md0, sdf):
>       1.dev_open(sdf)
>       2.add_to_super
>       3.write_init_super
>       4.fsync(fd)
>       5.close(fd)
>       6.ioctl(ADD_NEW_DISK).
>   However, there will be some udev(change of sdf) event after step5. =
Then
> "/usr/sbin/mdadm --incremental --export $devnode --offroot =
$env{DEVLINKS}"
> will be run, and the sdf will be added to md0. After that, step6 will =
return
> -EBUSY.
>   It is a problem to user. First time adding disk does not return =
success
> but disk is actually added. And I have no good idea to deal with it. =
Please
> give some great advice.

BTW, may I ask what is the mdadm version used in the above scenario?

Thanks.

Coly Li

