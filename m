Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1EFC6FD1D
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 15:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbjCTPqU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 11:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjCTPpz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 11:45:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921163B0E8
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 08:36:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8E25D21A0D;
        Mon, 20 Mar 2023 15:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679326605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/2n2RlldOmjidiqmJZshvaRk8rKCC5U+gVFlarmkiE0=;
        b=T0hOx8jT8I00OBBO5tPmDAIDF57gkB7nlOki2xVWKdzemFXF+H7Ek6xjTEbbh0wkTPOu+6
        mv2eN6Bh72gIhgoGmo88QecB4/xFvpu780Bpu4r0CxUuRDNMmn+my+outmXjC203YJEypV
        upVGnu0dzoehURV1I1f/xqm0NvdPWRY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3A8B113416;
        Mon, 20 Mar 2023 15:36:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZLndDI19GGQTTAAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 20 Mar 2023 15:36:45 +0000
Message-ID: <b3b124db659115dd2523dab828ad463d88afbe54.camel@suse.com>
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm
 mdadm --incremental --export"
From:   Martin Wilck <mwilck@suse.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Li Xiao Keng <lixiaokeng@huawei.com>, Song Liu <song@kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
        louhongxiang@huawei.com,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
Date:   Mon, 20 Mar 2023 16:36:44 +0100
In-Reply-To: <20230316114314.00003004@linux.intel.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
         <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
         <20230314165938.00003030@linux.intel.com>
         <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
         <20230315111027.0000372d@linux.intel.com>
         <cbea1358-768d-d5f7-5733-06687ad3243a@huawei.com>
         <c3d451cc0c96d1a8c8d129448c1d7c3e340e8fac.camel@suse.com>
         <5fe3dfca-10ad-989a-717d-3007b04163ed@huawei.com>
         <e5e2cf8fc9903aab6a781c5b925d12023a59b387.camel@suse.com>
         <20230316114314.00003004@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 2023-03-16 at 11:44 +0100, Mariusz Tkaczyk wrote:
> On Wed, 15 Mar 2023 16:01:26 +0100
> Martin Wilck <mwilck@suse.com> wrote:
> >=20
> > Normally this is what you want to happen if a change uevent for a
> > MD
> > member device is processed.
> >=20
> > The case you're looking at is the exception, as another instance of
> > mdamn is handling the device right at this point in time.
> >=20
> > Martin
> >=20
> Hi,
> Code snipped from Incremental, devname seems to be our disk:
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0/* 4/ Check if array exists.
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0if (map_lock(&map))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pr_err("failed to get exc=
lusive lock on mapfile\n");
> =A0=A0=A0=A0=A0=A0=A0=A0/* Now check we can get O_EXCL.=A0 If not, probab=
ly "mdadm -A"
> has
> =A0=A0=A0=A0=A0=A0=A0=A0 * taken over
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0dfd =3D dev_open(devname, O_RDONLY|O_EXCL);
>=20
> The map_lock in --add should resolve your issue. It seems to be
> simplest
> option. I we cannot lock udev effectively then it seems to be the
> best one.
> We need to control adding the device because external metadata is
> quite
> different and for example in IMSM the initial metadata doesn't point
> to
> container wanted by user. Hope it clarifies all objections here.
>=20
> I don't see any blocker from using locking mechanism for --add.


AFAICS it would only help if the code snipped above did not only
pr_err() but exit if it can't get an exclusive lock.

Martin

