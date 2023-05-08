Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E628C77B75
	for <linux-raid@archiver.kernel.org>; Mon,  8 May 2023 01:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjEHBkX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 7 May 2023 21:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjEHBkW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 7 May 2023 21:40:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EA646A8
        for <linux-raid@vger.kernel.org>; Sun,  7 May 2023 18:40:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 067351FDA7;
        Mon,  8 May 2023 01:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683510019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vkCO815Nm7l52tTk7Y53ge06aA5VRkThNjsnPMi4Wik=;
        b=v/rAlAIo+hZLbELfUIo31BgE5RWtwR2l9R0uJVqAqED1sLJK26WOjUmV9luuGKIkRI2h3p
        UUGWzP4FjA5YX4j/z2DyiJKAg8PIUjBXS0dfjVDJqk/wnZPhqfpRsx62v+xJkJKhgCsx+H
        8/eTLN1PskmAIECGBPFrb1UkuqipfAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683510019;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vkCO815Nm7l52tTk7Y53ge06aA5VRkThNjsnPMi4Wik=;
        b=XdjKnDK4DRt3Trjoufurwu4ZkKwuvfr3oqFamRg1GFc09mn6XidJJbU3iVhlrq+EDuDsh8
        2Q3jE2HIvsuyeGCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 685E41358F;
        Mon,  8 May 2023 01:40:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t+X8DQFTWGT/QAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 08 May 2023 01:40:17 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] Fix race of "mdadm --add" and "mdadm --incremental"
From:   Coly Li <colyli@suse.de>
In-Reply-To: <8c6579f8-4510-a3f9-6161-0ea1ee34fec6@huawei.com>
Date:   Mon, 8 May 2023 09:40:04 +0800
Cc:     jes@trained-monkey.org, mwilck@suse.com, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org, miaoguanqin@huawei.com,
        louhongxiang@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <DB23F26B-DE0E-422F-8973-7E32832E7571@suse.de>
References: <20230417140144.3013024-1-lixiaokeng@huawei.com>
 <b72aacfa-f99f-0322-5247-aa25aa30cd96@huawei.com>
 <8c6579f8-4510-a3f9-6161-0ea1ee34fec6@huawei.com>
To:     Li Xiao Keng <lixiaokeng@huawei.com>
X-Mailer: Apple Mail (2.3731.500.231)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2023=E5=B9=B45=E6=9C=888=E6=97=A5 09:30=EF=BC=8CLi Xiao Keng =
<lixiaokeng@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> ping
>=20
> On 2023/4/23 9:30, Li Xiao Keng wrote:
>> ping
>>=20
>> On 2023/4/17 22:01, Li Xiao Keng wrote:
>>> When we add a new disk to a raid, it may return -EBUSY.
>>>=20
>>> The main process of --add:
>>> 1. dev_open
>>> 2. store_super1(st, di->fd) in write_init_super1
>>> 3. fsync(di->fd) in write_init_super1
>>> 4. close(di->fd)
>>> 5. ioctl(ADD_NEW_DISK)
>>>=20
>>> However, there will be some udev(change) event after step4. Then
>>> "/usr/sbin/mdadm --incremental ..." will be run, and the new disk
>>> will be add to md device. After that, ioctl will return -EBUSY.
>>>=20

Hi Xiao Keng,

The above description of the race is not informative enough, I am aware =
exactly how the race is from, therefore I am not able to response for =
the fix.

Coly Li




>>> Here we add map_lock before write_init_super in "mdadm --add"
>>> to fix this race.
>>>=20
>>> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
>>> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
>>> ---
>>> Assemble.c |  5 ++++-
>>> Manage.c   | 25 +++++++++++++++++--------
>>> 2 files changed, 21 insertions(+), 9 deletions(-)
>>>=20
>>> diff --git a/Assemble.c b/Assemble.c
>>> index 49804941..086890ed 100644
>>> --- a/Assemble.c
>>> +++ b/Assemble.c
>>> @@ -1479,8 +1479,11 @@ try_again:
>>> * to our list.  We flag them so that we don't try to re-add,
>>> * but can remove if they turn out to not be wanted.
>>> */
>>> - if (map_lock(&map))
>>> + if (map_lock(&map)) {
>>> pr_err("failed to get exclusive lock on mapfile - continue =
anyway...\n");
>>> + return 1;
>>> + }
>>> +
>>> if (c->update =3D=3D UOPT_UUID)
>>> mp =3D NULL;
>>> else
>>> diff --git a/Manage.c b/Manage.c
>>> index f54de7c6..6a101bae 100644
>>> --- a/Manage.c
>>> +++ b/Manage.c
>>> @@ -703,6 +703,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev =
*dv,
>>> struct supertype *dev_st;
>>> int j;
>>> mdu_disk_info_t disc;
>>> + struct map_ent *map =3D NULL;
>>>=20
>>> if (!get_dev_size(tfd, dv->devname, &ldsize)) {
>>> if (dv->disposition =3D=3D 'M')
>>> @@ -900,6 +901,10 @@ int Manage_add(int fd, int tfd, struct =
mddev_dev *dv,
>>> disc.raid_disk =3D 0;
>>> }
>>>=20
>>> + if (map_lock(&map)) {
>>> + pr_err("failed to get exclusive lock on mapfile when add disk\n");
>>> + return -1;
>>> + }
>>> if (array->not_persistent=3D=3D0) {
>>> int dfd;
>>> if (dv->disposition =3D=3D 'j')
>>> @@ -911,9 +916,9 @@ int Manage_add(int fd, int tfd, struct mddev_dev =
*dv,
>>> dfd =3D dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
>>> if (tst->ss->add_to_super(tst, &disc, dfd,
>>>  dv->devname, INVALID_SECTORS))
>>> - return -1;
>>> + goto unlock;
>>> if (tst->ss->write_init_super(tst))
>>> - return -1;
>>> + goto unlock;
>>> } else if (dv->disposition =3D=3D 'A') {
>>> /*  this had better be raid1.
>>> * As we are "--re-add"ing we must find a spare slot
>>> @@ -971,14 +976,14 @@ int Manage_add(int fd, int tfd, struct =
mddev_dev *dv,
>>> pr_err("add failed for %s: could not get exclusive access to =
container\n",
>>>       dv->devname);
>>> tst->ss->free_super(tst);
>>> - return -1;
>>> + goto unlock;
>>> }
>>>=20
>>> /* Check if metadata handler is able to accept the drive */
>>> if (!tst->ss->validate_geometry(tst, LEVEL_CONTAINER, 0, 1, NULL,
>>>    0, 0, dv->devname, NULL, 0, 1)) {
>>> close(container_fd);
>>> - return -1;
>>> + goto unlock;
>>> }
>>>=20
>>> Kill(dv->devname, NULL, 0, -1, 0);
>>> @@ -987,7 +992,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev =
*dv,
>>>  dv->devname, INVALID_SECTORS)) {
>>> close(dfd);
>>> close(container_fd);
>>> - return -1;
>>> + goto unlock;
>>> }
>>> if (!mdmon_running(tst->container_devnm))
>>> tst->ss->sync_metadata(tst);
>>> @@ -998,7 +1003,7 @@ int Manage_add(int fd, int tfd, struct =
mddev_dev *dv,
>>>       dv->devname);
>>> close(container_fd);
>>> tst->ss->free_super(tst);
>>> - return -1;
>>> + goto unlock;
>>> }
>>> sra->array.level =3D LEVEL_CONTAINER;
>>> /* Need to set data_offset and component_size */
>>> @@ -1013,7 +1018,7 @@ int Manage_add(int fd, int tfd, struct =
mddev_dev *dv,
>>> pr_err("add new device to external metadata failed for %s\n", =
dv->devname);
>>> close(container_fd);
>>> sysfs_free(sra);
>>> - return -1;
>>> + goto unlock;
>>> }
>>> ping_monitor(devnm);
>>> sysfs_free(sra);
>>> @@ -1027,7 +1032,7 @@ int Manage_add(int fd, int tfd, struct =
mddev_dev *dv,
>>> else
>>> pr_err("add new device failed for %s as %d: %s\n",
>>>       dv->devname, j, strerror(errno));
>>> - return -1;
>>> + goto unlock;
>>> }
>>> if (dv->disposition =3D=3D 'j') {
>>> pr_err("Journal added successfully, making %s read-write\n", =
devname);
>>> @@ -1038,7 +1043,11 @@ int Manage_add(int fd, int tfd, struct =
mddev_dev *dv,
>>> }
>>> if (verbose >=3D 0)
>>> pr_err("added %s\n", dv->devname);
>>> + map_unlock(&map);
>>> return 1;
>>> +unlock:
>>> + map_unlock(&map);
>>> + return -1;
>>> }
>>>=20
>>> int Manage_remove(struct supertype *tst, int fd, struct mddev_dev =
*dv,
>>>=20

