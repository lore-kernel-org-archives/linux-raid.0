Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B20AC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 17:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344197AbiEaRvK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 13:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343782AbiEaRvJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 13:51:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD419AE55
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 10:51:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5D91E1FAB6;
        Tue, 31 May 2022 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654019467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Guu45NQegF0LfU0jmVMl/y9C+XhABoDUzSr3vGiaipc=;
        b=aH0jq/TopVY3LOTjq30MTY0zDaWHNbxnGtiy2R8smx0Iif61xR+TozZCA4hA3kcPoEUcdt
        4n8etdljAHvasMSVmJv+7OZVuQSyybpxMpdbteu+Y1fr5C87Gv+rmtRoK4c/3/GFeHOCFH
        ZCl8DguyU2dGbFH4RMn86y8Ce+oHI2s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654019467;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Guu45NQegF0LfU0jmVMl/y9C+XhABoDUzSr3vGiaipc=;
        b=0RJ/+Rv7msLROFGiHMuhb1uHmqLzwiUOoWHMLNSqcb5uvUzJX1iQDj38ivjw/67wTTWuc8
        wrVeHasp647HtDBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 88BEF13AA2;
        Tue, 31 May 2022 17:51:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mM6NFYpVlmJVFwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 31 May 2022 17:51:06 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 3/3 v2] imsm: block changing slots during creation
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220531102727.9315-4-mariusz.tkaczyk@linux.intel.com>
Date:   Wed, 1 Jun 2022 01:51:05 +0800
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4A14219C-5592-4AA5-9B34-6BB716782238@suse.de>
References: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
 <20220531102727.9315-4-mariusz.tkaczyk@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B45=E6=9C=8831=E6=97=A5 18:27=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> If user specifies drives for array creation, then slot order across
> volumes is not preserved.
> Ideally, it should be checked in validate_geometry() but it is not
> possible in current implementation (order is determined later).
> Add verification in add_to_super_imsm_volume() and throw error if
> mismatch is detected.
> IMSM allows to use only same members within container.
> This is not hardware dependency but metadata limitation.
> Therefore, 09-imsm-overlap test is removed. Testing it is pointless.
> After this patch, creation in this scenario is blocked. Offset
> verification is covered in other tests.
>=20
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>


Coly Li


> ---
> super-intel.c        | 33 ++++++++++++++++++++++-----------
> tests/09imsm-overlap | 28 ----------------------------
> 2 files changed, 22 insertions(+), 39 deletions(-)
> delete mode 100644 tests/09imsm-overlap
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 3c02d2f6..053f7e7e 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5760,6 +5760,10 @@ static int add_to_super_imsm_volume(struct =
supertype *st, mdu_disk_info_t *dk,
> 	struct imsm_map *map;
> 	struct dl *dl, *df;
> 	int slot;
> +	int autolayout =3D 0;
> +
> +	if (!is_fd_valid(fd))
> +		autolayout =3D 1;
>=20
> 	dev =3D get_imsm_dev(super, super->current_vol);
> 	map =3D get_imsm_map(dev, MAP_0);
> @@ -5770,25 +5774,32 @@ static int add_to_super_imsm_volume(struct =
supertype *st, mdu_disk_info_t *dk,
> 		return 1;
> 	}
>=20
> -	if (!is_fd_valid(fd)) {
> -		/* we're doing autolayout so grab the pre-marked (in
> -		 * validate_geometry) raid_disk
> -		 */
> -		for (dl =3D super->disks; dl; dl =3D dl->next)
> +	for (dl =3D super->disks; dl ; dl =3D dl->next) {
> +		if (autolayout) {
> 			if (dl->raiddisk =3D=3D dk->raid_disk)
> 				break;
> -	} else {
> -		for (dl =3D super->disks; dl ; dl =3D dl->next)
> -			if (dl->major =3D=3D dk->major &&
> -			    dl->minor =3D=3D dk->minor)
> -				break;
> +		} else if (dl->major =3D=3D dk->major && dl->minor =3D=3D =
dk->minor)
> +			break;
> 	}
>=20
> 	if (!dl) {
> -		pr_err("%s is not a member of the same container\n", =
devname);
> +		if (!autolayout)
> +			pr_err("%s is not a member of the same =
container.\n",
> +			       devname);
> 		return 1;
> 	}
>=20
> +	if (!autolayout && super->current_vol > 0) {
> +		int _slot =3D get_disk_slot_in_dev(super, 0, dl->index);
> +
> +		if (_slot !=3D dk->raid_disk) {
> +			pr_err("Member %s is in %d slot for the first =
volume, but is in %d slot for a new volume.\n",
> +			       dl->devname, _slot, dk->raid_disk);
> +			pr_err("Raid members are in different order than =
for the first volume, aborting.\n");
> +			return 1;
> +		}
> +	}
> +
> 	if (mpb->num_disks =3D=3D 0)
> 		if (!get_dev_sector_size(dl->fd, dl->devname,
> 					 &super->sector_size))
> diff --git a/tests/09imsm-overlap b/tests/09imsm-overlap
> deleted file mode 100644
> index ff5d2093..00000000
> --- a/tests/09imsm-overlap
> +++ /dev/null
> @@ -1,28 +0,0 @@
> -
> -. tests/env-imsm-template
> -
> -# create raid arrays with varying degress of overlap
> -mdadm -CR $container -e imsm -n 6 $dev0 $dev1 $dev2 $dev3 $dev4 $dev5
> -imsm_check container 6
> -
> -size=3D1024
> -level=3D1
> -num_disks=3D2
> -mdadm -CR $member0 $dev0 $dev1 -n $num_disks -l $level -z $size
> -mdadm -CR $member1 $dev1 $dev2 -n $num_disks -l $level -z $size
> -mdadm -CR $member2 $dev2 $dev3 -n $num_disks -l $level -z $size
> -mdadm -CR $member3 $dev3 $dev4 -n $num_disks -l $level -z $size
> -mdadm -CR $member4 $dev4 $dev5 -n $num_disks -l $level -z $size
> -
> -udevadm settle
> -
> -offset=3D0
> -imsm_check member $member0 $num_disks $level $size 1024 $offset
> -offset=3D$((offset+size+4096))
> -imsm_check member $member1 $num_disks $level $size 1024 $offset
> -offset=3D$((offset+size+4096))
> -imsm_check member $member2 $num_disks $level $size 1024 $offset
> -offset=3D$((offset+size+4096))
> -imsm_check member $member3 $num_disks $level $size 1024 $offset
> -offset=3D$((offset+size+4096))
> -imsm_check member $member4 $num_disks $level $size 1024 $offset
> --=20
> 2.26.2
>=20

