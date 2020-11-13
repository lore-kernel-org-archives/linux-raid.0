Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDFBC2D0E4
	for <linux-raid@archiver.kernel.org>; Fri, 13 Nov 2020 02:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5262C204EF
	for <linux-raid@archiver.kernel.org>; Fri, 13 Nov 2020 02:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rd9gEev1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgKMCuV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Nov 2020 21:50:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726011AbgKMCuV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 12 Nov 2020 21:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605235818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RfI+CkAZmcYgwOG6Hgmh+CPUxshmBNjDNiS3HRJOglg=;
        b=Rd9gEev1fu0pAEIseLPXxA3lCywtwPN0CQwA2NwpAayA9aWJ3oIbcjSAeSHAomHim0xzE1
        lFqJhNbnJA0g4ukSWAaw/496/IIttP1XuUaQ4fwMAmjvxm0u0G5X4jUIZ2elVv3D/yESmu
        xXW3wXMNicB6fTJQeaUH0ieGZg44cMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-iSX5B0zjOi-ioBQQW1Fq4w-1; Thu, 12 Nov 2020 21:50:15 -0500
X-MC-Unique: iSX5B0zjOi-ioBQQW1Fq4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C5981009E2F;
        Fri, 13 Nov 2020 02:50:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CC391002C0E;
        Fri, 13 Nov 2020 02:50:14 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4751C180B657;
        Fri, 13 Nov 2020 02:50:14 +0000 (UTC)
Date:   Thu, 12 Nov 2020 21:50:13 -0500 (EST)
From:   Xiao Ni <xni@redhat.com>
To:     heming zhao <heming.zhao@suse.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing jiang <guoqing.jiang@cloud.ionos.com>,
        lidong zhong <lidong.zhong@suse.com>, neilb@suse.de,
        colyli@suse.de
Message-ID: <738037216.25735601.1605235813114.JavaMail.zimbra@redhat.com>
In-Reply-To: <d606f944-f66f-98f7-498d-f3939a395934@suse.com>
References: <1605109898-14258-1-git-send-email-heming.zhao@suse.com> <a5b45adc-2db2-3429-49f9-ac3fa82f4c87@redhat.com> <d606f944-f66f-98f7-498d-f3939a395934@suse.com>
Subject: Re: [PATCH v2] md/cluster: fix deadlock when doing reshape job
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.41, 10.4.195.3]
Thread-Topic: md/cluster: fix deadlock when doing reshape job
Thread-Index: BAd5JogqQiMQ8CsVQHhK6K4m2MuDhQ==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



----- Original Message -----
> From: "heming zhao" <heming.zhao@suse.com>
> To: "Xiao Ni" <xni@redhat.com>, linux-raid@vger.kernel.org, song@kernel.o=
rg, "guoqing jiang"
> <guoqing.jiang@cloud.ionos.com>
> Cc: "lidong zhong" <lidong.zhong@suse.com>, neilb@suse.de, colyli@suse.de
> Sent: Thursday, November 12, 2020 7:27:46 PM
> Subject: Re: [PATCH v2] md/cluster: fix deadlock when doing reshape job
>=20
> Hello,
>=20
> On 11/12/20 1:08 PM, Xiao Ni wrote:
> >=20
> >=20
> > On 11/11/2020 11:51 PM, Zhao Heming wrote:
> >> There is a similar deadlock in commit 0ba959774e93
> >> ("md-cluster: use sync way to handle METADATA_UPDATED msg")
> >> My patch fixed issue is very like commit 0ba959774e93, except <c>.
> >> 0ba959774e93 step <c> is "update sb", my fix is "mdadm --remove"
> >>
> >> ... ...
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state),
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 msecs_to_jiffies(5000));
> >> +=C2=A0=C2=A0=C2=A0 if (rv)
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return lock_token(cinfo, m=
ddev_locked);
> >> +=C2=A0=C2=A0=C2=A0 else
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
> >> =C2=A0 }
> > Hi Heming
> >=20
> > Can we handle this problem like metadata_update_start? lock_comm and
> > metadata_update_start are two users that
> > want to get token lock. lock_comm can do the same thing as
> > metadata_update_start does. If so, process_recvd_msg
> > can call md_reload_sb without waiting. All threads can work well when t=
he
> > initiated node release token lock. Resync
> > can send message and clear MD_CLUSTER_SEND_LOCK, then lock_comm can go =
on
> > working. In this way, all threads
> > work successfully without failure.
> >=20
>=20
> Currently MD_CLUSTER_SEND_LOCKED_ALREADY only for adding a new disk.
> (please refer Documentation/driver-api/md/md-cluster.rst section: 5. Addi=
ng a
> new Device")
> During ADD_NEW_DISK process, md-cluster will block all other msg sending
> until metadata_update_finish calls
> unlock_comm.
>=20
> With your idea, md-cluster will allow to concurrently send msg. I'm not v=
ery
> familiar with all raid1 scenarios.
> But at least, you break the rule of handling ADD_NEW_DISK. it will allow =
send
> other msg during ADD_NEW_DISK.

Hi Heming

It doesn't need to change MD_CLUSTER_SEND_LOCKED_ALREADY. Is it ok to do so=
mething like this:

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4aaf482..f6f576b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -664,29 +664,12 @@ static void recv_daemon(struct md_thread *thread)
  * Takes the lock on the TOKEN lock resource so no other
  * node can communicate while the operation is underway.
  */
-static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
+static int lock_token(struct md_cluster_info *cinfo)
 {
-=09int error, set_bit =3D 0;
+=09int error;
 =09struct mddev *mddev =3D cinfo->mddev;
=20
-=09/*
-=09 * If resync thread run after raid1d thread, then process_metadata_upda=
te
-=09 * could not continue if raid1d held reconfig_mutex (and raid1d is bloc=
ked
-=09 * since another node already got EX on Token and waitting the EX of Ac=
k),
-=09 * so let resync wake up thread in case flag is set.
-=09 */
-=09if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
-=09=09=09=09      &cinfo->state)) {
-=09=09error =3D test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
-=09=09=09=09=09      &cinfo->state);
-=09=09WARN_ON_ONCE(error);
-=09=09md_wakeup_thread(mddev->thread);
-=09=09set_bit =3D 1;
-=09}
 =09error =3D dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
-=09if (set_bit)
-=09=09clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
-
 =09if (error)
 =09=09pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
 =09=09=09=09__func__, __LINE__, error);
@@ -701,10 +684,30 @@ static int lock_token(struct md_cluster_info *cinfo, =
bool mddev_locked)
  */
 static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
 {
+=09int ret, set_bit =3D 0;
+
+=09/*
+=09 * If resync thread run after raid1d thread, then process_metadata_upda=
te
+=09 * could not continue if raid1d held reconfig_mutex (and raid1d is bloc=
ked
+=09 * since another node already got EX on Token and waitting the EX of Ac=
k),
+=09 * so let resync wake up thread in case flag is set.
+=09 */
+=09if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
+=09=09=09=09      &cinfo->state)) {
+=09=09error =3D test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
+=09=09=09=09=09      &cinfo->state);
+=09=09WARN_ON_ONCE(error);
+=09=09md_wakeup_thread(mddev->thread);
+=09=09set_bit =3D 1;
+=09}
+
 =09wait_event(cinfo->wait,
 =09=09   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
=20
-=09return lock_token(cinfo, mddev_locked);
+=09ret =3D lock_token(cinfo, mddev_locked);
+=09if (ret && set_bit)
+=09=09clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
+=09return ret;
 }
=20
 static void unlock_comm(struct md_cluster_info *cinfo)

>=20
> >> =C2=A0 static void unlock_comm(struct md_cluster_info *cinfo)
> >> @@ -784,9 +789,11 @@ static int sendmsg(struct md_cluster_info *cinfo,
> >> struct cluster_msg *cmsg,
> >> =C2=A0 {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
> >> -=C2=A0=C2=A0=C2=A0 lock_comm(cinfo, mddev_locked);
> >> ... ...
> >> +=C2=A0=C2=A0=C2=A0 if (mddev_is_clustered(mddev)) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (md_cluster_ops->remove=
_disk(mddev, rdev))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to busy;
> >> +=C2=A0=C2=A0=C2=A0 }
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_kick_rdev_from_array(rdev);
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_f=
lags);
> > These codes are not related with this deadlock problem. It's better to =
file
> > a new patch
> > to fix checking the return value problem.
> >=20
>=20
> In my opinion: we should include these code in this patch.
> For totally fix the deadlock, md layer should return error to userspace.
>=20
> But with your comments, I found other potential issues of md-cluster.
> There still have some cluster_ops APIs, which caller doesn't care error
> return:
> .resync_finish - may cause other nodes never clean MD_RESYNCING_REMOTE.
> .resync_info_update - this error could be safely ignore
> .metadata_update_finish - may cause other nodes kernel md info is
> inconsistent with disk metadata.
>=20
> maybe I or other guys fix them in the future.
>=20
> > Best Regards
> > Xiao
> >=20
>=20
>=20

