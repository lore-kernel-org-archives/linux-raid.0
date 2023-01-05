Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECB9C3DA7A
	for <linux-raid@archiver.kernel.org>; Thu,  5 Jan 2023 14:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbjAEODU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Jan 2023 09:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbjAEODE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 Jan 2023 09:03:04 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF75D321A8
        for <linux-raid@vger.kernel.org>; Thu,  5 Jan 2023 06:03:02 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B804417008;
        Thu,  5 Jan 2023 14:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672927380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GmjRyKyBCG0F94f6rvmpmousy2bhf2n/FHrRKCltPZs=;
        b=SOr/isvb5gNrK0CZCfjBvQU708ySAASmad42hQNPN1bmUz+7xGwqKQlEsg1GpAblAOux2d
        TL2HnI3se7K8NgJlh8+v+Vltuq+GFISz+nySFTyEtBylv7fEyxp2OL8NliNhW2ckpCwYKL
        ccrpakiU41xOy7E5x/SM3RCncOPNcbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672927380;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GmjRyKyBCG0F94f6rvmpmousy2bhf2n/FHrRKCltPZs=;
        b=G+6W+lALWY83BH27FLSTNY1eOTW0aDwH7HqP9ttXIJ3ySDHIA/NhVScu4qc+NKNZc+MHzW
        XA3UmASyIE6xSDCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E15B213338;
        Thu,  5 Jan 2023 14:02:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WU+XKZPYtmPVfQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 05 Jan 2023 14:02:59 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] manage: move comment with function description
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230105053125.31388-1-kinga.tanska@intel.com>
Date:   Thu, 5 Jan 2023 22:02:47 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F40FB753-0E36-4949-B28C-FEEFB35A7993@suse.de>
References: <20230105053125.31388-1-kinga.tanska@intel.com>
To:     Kinga Tanska <kinga.tanska@intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2023=E5=B9=B41=E6=9C=885=E6=97=A5 13:31=EF=BC=8CKinga Tanska =
<kinga.tanska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Move the function description from the function body to outside
> to obey kernel coding style.
>=20
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
> Manage.c | 72 ++++++++++++++++++++++++++++++++++----------------------
> 1 file changed, 44 insertions(+), 28 deletions(-)
>=20
> diff --git a/Manage.c b/Manage.c
> index 594e3d2c..4a980fa0 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1328,38 +1328,54 @@ bool is_remove_safe(mdu_array_info_t *array, =
const int fd, char *devname, const
> return is_enough;
> }
>=20
> +/**
> + * Manage_subdevs() - Execute operation depending on devmode.
> + *
> + * @devname: name of the device.
> + * @fd: file descriptor.
> + * @devlist: list of sub-devices to manage.
> + * @verbose: verbose level.
> + * @test: test flag.
> + * @update: type of update.
> + * @force: force flag.
> + *
> + * This function executes operation defined by devmode
> + * for each dev from devlist.
> + * Devmode can be:
> + * 'a' - add the device
> + * 'S' - add the device as a spare - don't try re-add
> + * 'j' - add the device as a journal device
> + * 'A' - re-add the device
> + * 'r' - remove the device: HOT_REMOVE_DISK
> + *       device can be 'faulty' or 'detached' in which case all
> + *       matching devices are removed.
> + * 'f' - set the device faulty SET_DISK_FAULTY
> + *       device can be 'detached' in which case any device that
> + *       is inaccessible will be marked faulty.
> + * 'I' - remove device by using incremental fail
> + *       which is executed when device is removed surprisingly.
> + * 'R' - mark this device as wanting replacement.
> + * 'W' - this device is added if necessary and activated as
> + *       a replacement for a previous 'R' device.
> + * -----
> + * 'w' - 'W' will be changed to 'w' when it is paired with
> + *       a 'R' device.  If a 'W' is found while walking the list
> + *       it must be unpaired, and is an error.
> + * 'M' - this is created by a 'missing' target.  It is a slight
> + *       variant on 'A'
> + * 'F' - Another variant of 'A', where the device was faulty
> + *       so must be removed from the array first.
> + * 'c' - confirm the device as found (for clustered environments)
> + *
> + * For 'f' and 'r', the device can also be a kernel-internal
> + * name such as 'sdb'.
> + *
> + * Return: 0 on success, otherwise 1 or 2.
> + */
> int Manage_subdevs(char *devname, int fd,
>   struct mddev_dev *devlist, int verbose, int test,
>   enum update_opt update, int force)
> {
> - /* Do something to each dev.
> - * devmode can be
> - *  'a' - add the device
> - *  'S' - add the device as a spare - don't try re-add
> - *  'j' - add the device as a journal device
> - *  'A' - re-add the device
> - *  'r' - remove the device: HOT_REMOVE_DISK
> - *        device can be 'faulty' or 'detached' in which case all
> - *  matching devices are removed.
> - *  'f' - set the device faulty SET_DISK_FAULTY
> - *        device can be 'detached' in which case any device that
> - *  is inaccessible will be marked faulty.
> - *  'R' - mark this device as wanting replacement.
> - *  'W' - this device is added if necessary and activated as
> - *        a replacement for a previous 'R' device.
> - * -----
> - *  'w' - 'W' will be changed to 'w' when it is paired with
> - *        a 'R' device.  If a 'W' is found while walking the list
> - *        it must be unpaired, and is an error.
> - *  'M' - this is created by a 'missing' target.  It is a slight
> - *        variant on 'A'
> - *  'F' - Another variant of 'A', where the device was faulty
> - *        so must be removed from the array first.
> - *  'c' - confirm the device as found (for clustered environments)
> - *
> - * For 'f' and 'r', the device can also be a kernel-internal
> - * name such as 'sdb'.
> - */
> mdu_array_info_t array;
> unsigned long long array_size;
> struct mddev_dev *dv;
> --=20
> 2.26.2
>=20

