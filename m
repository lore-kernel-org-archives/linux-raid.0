Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE279C83F3E
	for <linux-raid@archiver.kernel.org>; Tue,  5 Sep 2023 19:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbjIETPa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Sep 2023 15:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242097AbjIETP3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Sep 2023 15:15:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F521711
        for <linux-raid@vger.kernel.org>; Tue,  5 Sep 2023 12:15:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6AAEE21EC9;
        Tue,  5 Sep 2023 19:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693940927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hWjaOyLuZ4okHQizhRU8R5CMgSdCDKaNHzvRk7UNbZ8=;
        b=mrBcyEZtYdQp1EHU3mq9rOSrQEEXjq704iF1feH7vuAbMEKMaJmjqoAlSdc9SO/DtZ3Xpa
        qNYXabkqiBViL6HcSo528cWJkigsZJi3KL9KyUUvrxr9qbj+D03hJB7N7TQRihV/PokhnD
        SF4iXIm40fWcjTUSn593diXRuwe204s=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E940A13911;
        Tue,  5 Sep 2023 19:08:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MMuINb5892Q3aAAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 05 Sep 2023 19:08:46 +0000
Message-ID: <12823520a0fe774908bd0830f59d05d2e7c06126.camel@suse.com>
Subject: Re: [PATCH v2] Fix race of "mdadm --add" and "mdadm --incremental"
From:   Martin Wilck <mwilck@suse.com>
To:     Coly Li <colyli@suse.de>, Li Xiao Keng <lixiaokeng@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        louhongxiang@huawei.com, miaoguanqin <miaoguanqin@huawei.com>
Date:   Tue, 05 Sep 2023 21:08:45 +0200
In-Reply-To: <kjdwwbkqj6fuaijow2nldh5ofbxymto2mzqcullb57jtx6q6h2@46kropdd4lql>
References: <bcc2d161-521b-ea19-b090-9822925645e5@huawei.com>
         <kjdwwbkqj6fuaijow2nldh5ofbxymto2mzqcullb57jtx6q6h2@46kropdd4lql>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 2023-09-06 at 00:17 +0800, Coly Li wrote:
> Hi Xiao Keng,
>=20
> Thanks for the updated version, I add my comments inline.
>=20
> On Tue, Sep 05, 2023 at 08:02:06PM +0800, Li Xiao Keng wrote:
> > When we add a new disk to a raid, it may return -EBUSY.
>=20
> Where is above -EBUSY from? do you mean mdadm command returns
> -EBUSY or it is returned by some specific function in mdadm
> source code.
>=20
> >=20
> > The main process of --add:
> > 1. dev_open
> > 2. store_super1(st, di->fd) in write_init_super1
> > 3. fsync(di->fd) in write_init_super1
> > 4. close(di->fd)
> > 5. ioctl(ADD_NEW_DISK)
> >=20
> > However, there will be some udev(change) event after step4. Then
> > "/usr/sbin/mdadm --incremental ..." will be run, and the new disk
> > will be add to md device. After that, ioctl will return -EBUSY.
> >=20
>=20
> Dose returning -EBUSY hurt anything? Or only returns -EBUSY and
> other stuffs all work as expected?

IIUC, it does not. The manual --add command will fail. Li Xiao Keng has
described the problem in earlier emails.
=A0
> > Here we add map_lock before write_init_super in "mdadm --add"
> > to fix this race.
> >=20
>=20
> I am not familiar this part of code, but I see ignoring the failure
> from map_lock() in Assemble() is on purpose by Neil. Therefore I
> just guess simply return from Assemble when map_lock() fails might
> not be what you wanted.
>=20
>=20
> > Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> > Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> > ---
> > =A0Assemble.c |=A0 5 ++++-
> > =A0Manage.c=A0=A0 | 25 +++++++++++++++++--------
> > =A02 files changed, 21 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/Assemble.c b/Assemble.c
> > index 49804941..086890ed 100644
> > --- a/Assemble.c
> > +++ b/Assemble.c
> > @@ -1479,8 +1479,11 @@ try_again:
> > =A0=A0=A0=A0=A0=A0=A0=A0 * to our list.=A0 We flag them so that we don'=
t try to re-
> > add,
> > =A0=A0=A0=A0=A0=A0=A0=A0 * but can remove if they turn out to not be wa=
nted.
> > =A0=A0=A0=A0=A0=A0=A0=A0 */
> > -=A0=A0=A0=A0=A0=A0=A0if (map_lock(&map))
> > +=A0=A0=A0=A0=A0=A0=A0if (map_lock(&map)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pr_err("failed to get e=
xclusive lock on mapfile -
> > continue anyway...\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
>=20
> Especially when the error message noticed "continue anyway" but a
> return 1
> followed, the behavior might be still confusing.

Now as you're saying it, I recall I had the same comment last time ;-)

I might add that "return 1" is dangerous, as it pretends that
Manage_add() was successful and actually added a device, which is not
the case. In the special case that Li Xiao Keng wants to fix, it's true
(sort of) because the asynchronous "mdadm -I" will have added the
device already. But there could be other races where Assemble_map()
can't obtain the lock and still the device will not be added later.

Regards
Martin

>=20
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0if (c->update =3D=3D UOPT_UUID)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp =3D NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0else
> > diff --git a/Manage.c b/Manage.c
> > index f54de7c6..6a101bae 100644
> > --- a/Manage.c
> > +++ b/Manage.c
> > @@ -703,6 +703,7 @@ int Manage_add(int fd, int tfd, struct
> > mddev_dev *dv,
> > =A0=A0=A0=A0=A0=A0=A0=A0struct supertype *dev_st;
> > =A0=A0=A0=A0=A0=A0=A0=A0int j;
> > =A0=A0=A0=A0=A0=A0=A0=A0mdu_disk_info_t disc;
> > +=A0=A0=A0=A0=A0=A0=A0struct map_ent *map =3D NULL;
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!get_dev_size(tfd, dv->devname, &ldsize)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (dv->disposition =3D=
=3D 'M')
> > @@ -900,6 +901,10 @@ int Manage_add(int fd, int tfd, struct
> > mddev_dev *dv,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0disc.raid_disk =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> >=20
> > +=A0=A0=A0=A0=A0=A0=A0if (map_lock(&map)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pr_err("failed to get exc=
lusive lock on mapfile
> > when add disk\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0if (array->not_persistent=3D=3D0) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int dfd;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (dv->disposition =3D=
=3D 'j')
> > @@ -911,9 +916,9 @@ int Manage_add(int fd, int tfd, struct
> > mddev_dev *dv,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dfd =3D dev_open(dv->de=
vname, O_RDWR |
> > O_EXCL|O_DIRECT);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (tst->ss->add_to_sup=
er(tst, &disc, dfd,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dv->devname,
> > INVALID_SECTORS))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto unlock;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (tst->ss->write_init=
_super(tst))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto unlock;
> > =A0=A0=A0=A0=A0=A0=A0=A0} else if (dv->disposition =3D=3D 'A') {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*=A0 this had better b=
e raid1.
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * As we are "--re-add"=
ing we must find a spare
> > slot
> > @@ -971,14 +976,14 @@ int Manage_add(int fd, int tfd, struct
> > mddev_dev *dv,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pr_err("add failed for %s: could not get
> > exclusive access to container\n",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 dv->devname);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0tst->ss->free_super(tst);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto unlock;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Check if metadata ha=
ndler is able to accept the
> > drive */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!tst->ss->validate_=
geometry(tst,
> > LEVEL_CONTAINER, 0, 1, NULL,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0, 0, dv->dev=
name, NULL, 0, 1)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0close(container_fd);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto unlock;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> >=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0Kill(dv->devname, NULL,=
 0, -1, 0);
> > @@ -987,7 +992,7 @@ int Manage_add(int fd, int tfd, struct
> > mddev_dev *dv,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dv->devname,
> > INVALID_SECTORS)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0close(dfd);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0close(container_fd);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto unlock;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!mdmon_running(tst-=
>container_devnm))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0tst->ss->sync_metadata(tst);
> > @@ -998,7 +1003,7 @@ int Manage_add(int fd, int tfd, struct
> > mddev_dev *dv,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 dv->devname);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0close(container_fd);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0tst->ss->free_super(tst);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto unlock;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sra->array.level =3D LE=
VEL_CONTAINER;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Need to set data_off=
set and component_size */
> > @@ -1013,7 +1018,7 @@ int Manage_add(int fd, int tfd, struct
> > mddev_dev *dv,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pr_err("add new device to external metadata
> > failed for %s\n", dv->devname);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0close(container_fd);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0sysfs_free(sra);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto unlock;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ping_monitor(devnm);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sysfs_free(sra);
> > @@ -1027,7 +1032,7 @@ int Manage_add(int fd, int tfd, struct
> > mddev_dev *dv,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0else
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pr_err("add new device failed for
> > %s as %d: %s\n",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dv->devname, j,
> > strerror(errno));
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto unlock;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (dv->disposition =3D=
=3D 'j') {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pr_err("Journal added successfully, making
> > %s read-write\n", devname);
> > @@ -1038,7 +1043,11 @@ int Manage_add(int fd, int tfd, struct
> > mddev_dev *dv,
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0if (verbose >=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pr_err("added %s\n", dv=
->devname);
> > +=A0=A0=A0=A0=A0=A0=A0map_unlock(&map);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +unlock:
> > +=A0=A0=A0=A0=A0=A0=A0map_unlock(&map);
> > +=A0=A0=A0=A0=A0=A0=A0return -1;
> > =A0}
> >=20
> > =A0int Manage_remove(struct supertype *tst, int fd, struct mddev_dev
> > *dv,
>=20
> I am not challenging, just before I understand what you are trying to
> fix,
> it is quite hard for me to join the discussion with you for this
> change.
>=20
> And, this version is much more informative, and thank you for the
> effort.
>=20

