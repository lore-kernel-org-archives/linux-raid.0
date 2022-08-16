Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3101AC2BB41
	for <linux-raid@archiver.kernel.org>; Tue, 16 Aug 2022 06:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiHPGey (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Aug 2022 02:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiHPGeh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Aug 2022 02:34:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3480FDAECF
        for <linux-raid@vger.kernel.org>; Mon, 15 Aug 2022 17:58:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4A22134FC9;
        Tue, 16 Aug 2022 00:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660611531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/2VUdJMtbSMBE2GjT/OGgCGq72AjDA5aHzsANfVQmQ=;
        b=hQQwH7PGZO+ms46fXkmhcp81bnd4gxAJHzQQjm0MQk/XhEiNr9IfsTEcX2NnYMTF3KwKj+
        wOUnZ2kb/tHcLCSQBIDgHW0RMLfc1RsDTucuK4S0/eBlTTBMY2vEJMv/Zr/zg0w4yfyxPO
        ovz12l2z3Y7O+p6oCVbZ/z/oqINC1GY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660611531;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/2VUdJMtbSMBE2GjT/OGgCGq72AjDA5aHzsANfVQmQ=;
        b=gjBLY1Fpdi4duUhI/0puptrERt6EomUySxcHuuVnYqDYygDGyt8blrj9V6HP6iUN4Fu1Dt
        TZ0rKxZcVyUeOaCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2EC0D13A93;
        Tue, 16 Aug 2022 00:58:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MSvHNsnr+mJWSAAAMHmgww
        (envelope-from <neilb@suse.de>); Tue, 16 Aug 2022 00:58:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Guoqing Jiang" <guoqing.jiang@linux.dev>
Cc:     "Song Liu" <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH RFC] md: call md_cluster_stop() in __md_stop()
In-reply-to: <d45190a8-fffe-3a96-19ff-bdeccbc31945@linux.dev>
References: <166027061107.20931.13490156249149223084@noble.neil.brown.name>,
 <d45190a8-fffe-3a96-19ff-bdeccbc31945@linux.dev>
Date:   Tue, 16 Aug 2022 10:58:47 +1000
Message-id: <166061152702.5425.9507699881285566239@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 15 Aug 2022, Guoqing Jiang wrote:
> Hi Neil,
>=20
> Sorry for later reply since I was on vacation last week.
>=20
> On 8/12/22 10:16 AM, NeilBrown wrote:
> > [[ I noticed the e151 patch recently which seems to admit that it broke
> >     something.  So I looked into it and came up with this.
>=20
> I just noticed it ...
>=20
> >     It seems to make sense, but I'm not in a position to test it.
> >     Guoqing: does it look OK to you?
> >     - NeilBrown
> > ]]
> >
> > As described in Commit: 48df498daf62 ("md: move bitmap_destroy to the
> > beginning of __md_stop") md_cluster_stop() needs to run before the
> > mdddev->thread is stopped.
> > The change to make this happen was reverted in Commit: e151db8ecfb0
> > ("md-raid: destroy the bitmap after destroying the thread") due to
> > problems it caused.
> >
> > To restore correct behaviour, make md_cluster_stop() reentrant and
> > explicitly call it at the start of __md_stop(), after first calling
> > md_bitmap_wait_behind_writes().
> >
> > Fixes: e151db8ecfb0 ("md-raid: destroy the bitmap after destroying the th=
read")
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >   drivers/md/md-cluster.c | 1 +
> >   drivers/md/md.c         | 3 +++
> >   2 files changed, 4 insertions(+)
> >
> > diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> > index 742b2349fea3..37bf0aa4ed71 100644
> > --- a/drivers/md/md-cluster.c
> > +++ b/drivers/md/md-cluster.c
> > @@ -1009,6 +1009,7 @@ static int leave(struct mddev *mddev)
> >   	     test_bit(MD_CLOSING, &mddev->flags)))
> >   		resync_bitmap(mddev);
> >  =20
> > +	mddev->cluster_info =3D NULL;
>=20
> The above makes sense.

Thanks.

>=20
> >   	set_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
> >   	md_unregister_thread(&cinfo->recovery_thread);
> >   	md_unregister_thread(&cinfo->recv_thread);
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index afaf36b2f6ab..a57b2dff64dd 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -6238,6 +6238,9 @@ static void mddev_detach(struct mddev *mddev)
> >   static void __md_stop(struct mddev *mddev)
> >   {
> >   	struct md_personality *pers =3D mddev->pers;
> > +
> > +	md_bitmap_wait_behind_writes(mddev);
> > +	md_cluster_stop(mddev);
> >   	mddev_detach(mddev);
> >   	/* Ensure ->event_work is done */
> >   	if (mddev->event_work.func)
>=20
> The md_bitmap_destroy is called in __md_stop with or without e151db8ecfb0,
> and it already invokes md_bitmap_wait_behind_writes and md_cluster_stop by
> md_bitmap_free. So the above is sort of redundant to me.

The point is that md_cluster_stop() needs to run before mddev_detach()
shuts down the thread.  If we don't call all of md_bitmap_destroy()
before mddev_detach() we need to at least run md_cluster_stop(), and I
think we need to run md_bitmap_wait_behind_writes() before that.


>=20
> For the issue described in e151db8ecfb, looks like raid1d was running after
> __md_stop, I am wondering if dm-raid should stop write first just like=20
> normal
> md-raid.

That looks like a really good idea, that should make it safe to move
md_bitmap_destroy() back before mddev_detach().
Would you like to post a patch to make those two changes, and include
Mikulas Patocka, or should I?

Thanks,
NeilBrown


>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index afaf36b2f6ab..afc8d638eba0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6260,6 +6260,7 @@ void md_stop(struct mddev *mddev)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* stop the array and free an a=
ttached data structures.
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * This is called from dm-=
raid
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __md_stop_writes(mddev);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __md_stop(mddev);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bioset_exit(&mddev->bio_set);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bioset_exit(&mddev->sync_set);
>=20
> Thanks,
> Guoqing
>=20
