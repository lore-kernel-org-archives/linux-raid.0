Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F843C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 16 Feb 2022 22:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236728AbiBPWKA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Feb 2022 17:10:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiBPWJz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Feb 2022 17:09:55 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04CE2AE735
        for <linux-raid@vger.kernel.org>; Wed, 16 Feb 2022 14:09:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8EE001FD3C;
        Wed, 16 Feb 2022 22:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645049381; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l+4Z7XKwtntMSa45pE5vpAUjRUcRGbkf87E5dJsMVF4=;
        b=ine695aLolLfSf8Ttmxyum2vNXt1f6zmZShrQTbm0uD3jVjnhP4LuGOi2+fSJh2sqZfvr8
        oUCOz+x1F3PyAKF/7V2MDNgdHlQhktpk6nNGCDOzjNBflPuIZHcb8L6V4mUNFjBknt28X4
        QXze9xnINxG5I0Z+uvVUBAArId7yMcM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645049381;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l+4Z7XKwtntMSa45pE5vpAUjRUcRGbkf87E5dJsMVF4=;
        b=Ybhvzo1tb20Y9KvLURw/Z0PmVTwGdzLIG9uBys9+lk8moBZwwtfekHpWkpQLDKPHQ87ojo
        mGjyAIlWi0Afu2Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C32EC13B5C;
        Wed, 16 Feb 2022 22:09:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xwQ4HyJ2DWKOUQAAMHmgww
        (envelope-from <neilb@suse.de>); Wed, 16 Feb 2022 22:09:38 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     mwilck@suse.com
Cc:     "Jes Sorensen" <jsorensen@fb.com>, linux-raid@vger.kernel.org,
        lvm-devel@redhat.com, "Peter Rajnoha" <prajnoha@redhat.com>,
        "Hannes Reinecke" <hare@suse.de>,
        "Heming Zhao" <heming.zhao@suse.com>, "Coly Li" <colyli@suse.com>,
        dm-devel@redhat.com, "Martin Wilck" <mwilck@suse.com>
Subject: Re: [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
In-reply-to: <20220216205914.7575-1-mwilck@suse.com>
References: <20220216205914.7575-1-mwilck@suse.com>
Date:   Thu, 17 Feb 2022 09:09:28 +1100
Message-id: <164504936873.10228.7361167610237544463@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 17 Feb 2022, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> device-mapper sets the flag DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1 for
> devices which are unusable. They may be no set up yet, suspended, or
> otherwise unusable (e.g. multipath maps without usable path). This
> flag does not necessarily imply SYSTEMD_READY=3D0 and must therefore
> be tested separately.

I really don't like this - looks like a hack.  A Kludge.

Can you provide a reference to a detailed discussion that explains why
SYSTEMD_READY=3D0 cannot be used?

Thanks,
NeilBrown


>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  udev-md-raid-assembly.rules | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
> index d668cdd..4568b01 100644
> --- a/udev-md-raid-assembly.rules
> +++ b/udev-md-raid-assembly.rules
> @@ -21,6 +21,11 @@ IMPORT{cmdline}=3D"noiswmd"
>  IMPORT{cmdline}=3D"nodmraid"
> =20
>  ENV{nodmraid}=3D=3D"?*", GOTO=3D"md_inc_end"
> +
> +# device mapper sets DM_UDEV_DISABLE_OTHER_RULES_FLAG for devices which
> +# aren't ready to use
> +KERNEL=3D=3D"dm-*", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=3D=3D"1", GOTO=
=3D"md_inc_end"
> +
>  ENV{ID_FS_TYPE}=3D=3D"ddf_raid_member", GOTO=3D"md_inc"
>  ENV{noiswmd}=3D=3D"?*", GOTO=3D"md_inc_end"
>  ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ACTION!=3D"change", GOTO=3D"md_inc"
> --=20
> 2.35.1
>=20
>=20
