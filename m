Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51BDEB8FB3
	for <linux-raid@archiver.kernel.org>; Wed,  6 Sep 2023 13:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbjIFNcD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Sep 2023 09:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjIFNcC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Sep 2023 09:32:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202F710D7
        for <linux-raid@vger.kernel.org>; Wed,  6 Sep 2023 06:31:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D226A1F74C;
        Wed,  6 Sep 2023 13:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694007103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+no2t8912SKLcNqgIsNLQVzeNU69V+wlfTLoXongQXI=;
        b=hyB1qkCY9ixSb0f3QqiFKmtTgeMfiTYf0pUFLzcSHIkDY/5mtqyPEViJ1OQE3n1FzcSZj3
        YTHah2t8Re0bHZI8HO7jySst9HcgD14qtCvAV34k5g2Ero1WsL2l+uz+oZETeQ/BhJNvJf
        OAOyJqd0FS1r4q6rfIpvvdcfGRJB+Kw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9A15D1333E;
        Wed,  6 Sep 2023 13:31:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 27f+Iz9/+GS2GQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 06 Sep 2023 13:31:43 +0000
Message-ID: <a839c1d1ad6df3a0ab60a1ea2d83ace7d7e7979b.camel@suse.com>
Subject: Re: [PATCH v2] Fix race of "mdadm --add" and "mdadm --incremental"
From:   Martin Wilck <mwilck@suse.com>
To:     Li Xiao Keng <lixiaokeng@huawei.com>, Coly Li <colyli@suse.de>
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        louhongxiang@huawei.com, miaoguanqin <miaoguanqin@huawei.com>
Date:   Wed, 06 Sep 2023 15:31:42 +0200
In-Reply-To: <a56df487-ef9a-9c90-87a6-5ae0a0ffe9f0@huawei.com>
References: <bcc2d161-521b-ea19-b090-9822925645e5@huawei.com>
         <kjdwwbkqj6fuaijow2nldh5ofbxymto2mzqcullb57jtx6q6h2@46kropdd4lql>
         <12823520a0fe774908bd0830f59d05d2e7c06126.camel@suse.com>
         <a56df487-ef9a-9c90-87a6-5ae0a0ffe9f0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 2023-09-06 at 16:51 +0800, Li Xiao Keng wrote:
>=20
>=20
> On 2023/9/6 3:08, Martin Wilck wrote:
> > On Wed, 2023-09-06 at 00:17 +0800, Coly Li wrote:
> > > Hi Xiao Keng,
> > >=20
> > > Thanks for the updated version, I add my comments inline.
> > >=20
> > > On Tue, Sep 05, 2023 at 08:02:06PM +0800, Li Xiao Keng wrote:
> > > > When we add a new disk to a raid, it may return -EBUSY.
> > >=20
> > > Where is above -EBUSY from? do you mean mdadm command returns
> > > -EBUSY or it is returned by some specific function in mdadm
> > > source code.
> > >=20
>=20
> Because the new disk is added to the raid by "mdadm --incremental",
> the "mdadm --add" will return the err.
>=20
> > > >=20
> > > > The main process of --add:
> > > > 1. dev_open
> > > > 2. store_super1(st, di->fd) in write_init_super1
> > > > 3. fsync(di->fd) in write_init_super1
> > > > 4. close(di->fd)
> > > > 5. ioctl(ADD_NEW_DISK)
> > > >=20
> > > > However, there will be some udev(change) event after step4.
> > > > Then
> > > > "/usr/sbin/mdadm --incremental ..." will be run, and the new
> > > > disk
> > > > will be add to md device. After that, ioctl will return -EBUSY.
> > > >=20
> > >=20
> > > Dose returning -EBUSY hurt anything? Or only returns -EBUSY and
> > > other stuffs all work as expected?
> >=20
> > IIUC, it does not. The manual --add command will fail. Li Xiao Keng
> > has
> > described the problem in earlier emails.
> Yes=EF=BC=81 The disk is add to the raid, but the manual --add command wi=
ll
> fail.
> We will decide the next action based on the return value.
>=20
> > =C2=A0
> > > > Here we add map_lock before write_init_super in "mdadm --add"
> > > > to fix this race.
> > > >=20
> > >=20
> > > I am not familiar this part of code, but I see ignoring the
> > > failure
> > > from map_lock() in Assemble() is on purpose by Neil. Therefore I
> > > just guess simply return from Assemble when map_lock() fails
> > > might
> > > not be what you wanted.
> > >=20
> > >=20
> > > > Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> > > > Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> > > > ---
> > > > =C2=A0Assemble.c |=C2=A0 5 ++++-
> > > > =C2=A0Manage.c=C2=A0=C2=A0 | 25 +++++++++++++++++--------
> > > > =C2=A02 files changed, 21 insertions(+), 9 deletions(-)
> > > >=20
> > > > diff --git a/Assemble.c b/Assemble.c
> > > > index 49804941..086890ed 100644
> > > > --- a/Assemble.c
> > > > +++ b/Assemble.c
> > > > @@ -1479,8 +1479,11 @@ try_again:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * to our list.=C2=
=A0 We flag them so that we don't try to
> > > > re-
> > > > add,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * but can remove i=
f they turn out to not be wanted.
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (map_lock(&map))
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (map_lock(&map)) {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pr_err("failed to get exclusive lock on mapfi=
le
> > > > -
> > > > continue anyway...\n");
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return 1;
> > >=20
> > > Especially when the error message noticed "continue anyway" but a
> > > return 1
> > > followed, the behavior might be still confusing.
> >=20
> > Now as you're saying it, I recall I had the same comment last time
> > ;-)
> >=20
> I'm very sorry for this stupid mistake. I I find I send v1 patch but
> not
> v2. I will send patch v2 to instead of it.
>=20
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (map_lock(&map))
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0pr_err("failed to get exclusive lock on mapfile -
> continue anyway...\n");
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (map_lock(&map)) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0pr_err("failed to get exclusive lock on mapfile when
> assemble raid.\n");
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return 1;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
>=20
> > I might add that "return 1" is dangerous, as it pretends that
> > Manage_add() was successful and actually added a device, which is
> > not
> > the case. In the special case that Li Xiao Keng wants to fix, it's
> > true
> > (sort of) because the asynchronous "mdadm -I" will have added the
> > device already. But there could be other races where Assemble_map()
> > can't obtain the lock and still the device will not be added later.
> >=20
>=20
> Do I missunstandings
> "AFAICS it would only help if the code snipped above did not only
> pr_err() but exit if it can't get an exclusive lock." ?
>=20

> Anyway, map_lock is a blocking function. If it can't get the lock, it
blocks.
> If map_lock() return error, Assemble() return 1. When -add unlock it,
> Assemble() will go ahead but not return at map_lock().

Maybe *I* was misunderstanding. I thought map_lock() returned error if
the lock was held by the other process. What exactly does an error
return from map_lock() mean? If it does not mean "lock held by another
process", why does your patch solve the race issue?

Martin


