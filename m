Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118EDC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 30 May 2022 06:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbiE3Gao (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 May 2022 02:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiE3Gan (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 May 2022 02:30:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC8B22506
        for <linux-raid@vger.kernel.org>; Sun, 29 May 2022 23:30:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B43B921BD7;
        Mon, 30 May 2022 06:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653892240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0A6r6pKqNGE6e4zFrP10OTnkuJQ6HIGhCgIkwGQPXHQ=;
        b=RIRMVXIqqC//W0rxQO20PWt2JTrIqi6oP/ghefbBAzBHsxlMsZ/ETaBIOQaVT2Ps072PyP
        VWUtbMEMMJ59SmC29DO6a858dgNdpArz1nIfr/L/st3S5KXvuAO3I1ThKtUEE7EMoEh61L
        ARvqDDiEfN1C3/8k7RRkdzlrt+5kV5g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653892240;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0A6r6pKqNGE6e4zFrP10OTnkuJQ6HIGhCgIkwGQPXHQ=;
        b=2YCRl6uqAGXDPl93cQbGV0ak8UpUMFufvE97JPoxnEohwcQl3E4cBNNhdg7gLnIOFhJ/1f
        DpZxlWNvwa8pUABg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B7A113AFD;
        Mon, 30 May 2022 06:30:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sIiPFY9klGJlWwAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 30 May 2022 06:30:39 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] Grow: Split Grow_reshape into helper function.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220404071720.8642-1-mateusz.kusiak@intel.com>
Date:   Mon, 30 May 2022 14:30:36 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2E28E34-B32F-4E42-9BC3-56B5B69B5C00@suse.de>
References: <20220404071720.8642-1-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mateusz,

I reply my comments in line.


> 2022=E5=B9=B44=E6=9C=884=E6=97=A5 15:17=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Grow_reshape should be splitted into helper functions given it's size.
> Add helper function for preparing reshape on external metadata.
> Close cfd file descriptor.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
> Grow.c  | 124 ++++++++++++++++++++++++++++++--------------------------
> mdadm.h |   1 +
> util.c  |  14 +++++++
> 3 files changed, 81 insertions(+), 58 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 9c6fc95e..6bb3d388 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1774,6 +1774,65 @@ static int reshape_container(char *container, =
char *devname,
> 			     char *backup_file, int verbose,
> 			     int forked, int restart, int =
freeze_reshape);
>=20
> +/**
> + * prepare_external_reshape() - prepares update on external metadata =
if supported.
> + * @devname: Device name.
> + * @subarray: Subarray.
> + * @st: Supertype.
> + * @container: Container.
> + * @cfd: Container file descriptor.
> + *
> + * Function checks that the requested reshape is supported on =
external metadata,
> + * and performs an initial check that the container holds the =
pre-requisite
> + * spare devices (mdmon owns final validation).
> + *
> + * Return: 0 on success, else error code
> + */
> +static int prepare_external_reshape(char *devname, char *subarray,
> +				    struct supertype *st, char =
*container,
> +				    const int cfd)
> +{
> +	struct mdinfo *cc =3D NULL;
> +	struct mdinfo *content =3D NULL;
> +
> +	if (st->ss->load_container(st, cfd, NULL)) {
> +		pr_err("Cannot read superblock for %s\n", devname);
> +		return 1;
> +	}
> +
> +	if (!st->ss->container_content)
> +		return -1;
> +
> +	cc =3D st->ss->container_content(st, subarray);
> +	for (content =3D cc; content ; content =3D content->next) {
> +		/*
> +		 * check if reshape is allowed based on metadata
> +		 * indications stored in content.array.status
> +		 */
> +		if (is_bit_set(content->array_state, MD_SB_BLOCK_VOLUME) =
||
> +		    is_bit_set(content->array_state, =
MD_SB_BLOCK_CONTAINER_RESHAPE)) {

Content->array_state should be content->array.state, or =
&content->array.stat if the first parameter in is_bit_set() defined as =
int *val.


> +			pr_err("Cannot reshape arrays in container with =
unsupported metadata: %s(%s)\n",
> +			       devname, container);
> +			goto error;
> +		}
> +		if (content->consistency_policy =3D=3D =
CONSISTENCY_POLICY_PPL) {
> +			pr_err("Operation not supported when ppl =
consistency policy is enabled\n");
> +			goto error;
> +		}
> +		if (content->consistency_policy =3D=3D =
CONSISTENCY_POLICY_BITMAP) {
> +			pr_err("Operation not supported when =
write-intent bitmap consistency policy is enabled\n");
> +			goto error;
> +		}
> +	}
> +	sysfs_free(cc);
> +	if (mdmon_running(container))
> +		st->update_tail =3D &st->updates;
> +	return 0;
> +error:
> +	sysfs_free(cc);
> +	return 1;
> +}
> +
> int Grow_reshape(char *devname, int fd,
> 		 struct mddev_dev *devlist,
> 		 unsigned long long data_offset,
> @@ -1801,7 +1860,7 @@ int Grow_reshape(char *devname, int fd,
> 	struct supertype *st;
> 	char *subarray =3D NULL;
>=20
> -	int frozen;
> +	int frozen =3D 0;
> 	int changed =3D 0;
> 	char *container =3D NULL;
> 	int cfd =3D -1;
> @@ -1810,7 +1869,7 @@ int Grow_reshape(char *devname, int fd,
> 	int added_disks;
>=20
> 	struct mdinfo info;
> -	struct mdinfo *sra;
> +	struct mdinfo *sra =3D NULL;
>=20
> 	if (md_get_array_info(fd, &array) < 0) {
> 		pr_err("%s is not an active md array - aborting\n",
> @@ -1867,13 +1926,7 @@ int Grow_reshape(char *devname, int fd,
> 		}
> 	}
>=20
> -	/* in the external case we need to check that the requested =
reshape is
> -	 * supported, and perform an initial check that the container =
holds the
> -	 * pre-requisite spare devices (mdmon owns final validation)
> -	 */
> 	if (st->ss->external) {
> -		int retval;
> -
> 		if (subarray) {
> 			container =3D st->container_devnm;
> 			cfd =3D open_dev_excl(st->container_devnm);
> @@ -1889,58 +1942,13 @@ int Grow_reshape(char *devname, int fd,
> 			return 1;
> 		}
>=20
> -		retval =3D st->ss->load_container(st, cfd, NULL);
> -
> -		if (retval) {
> -			pr_err("Cannot read superblock for %s\n", =
devname);
> +		rv =3D prepare_external_reshape(devname, subarray, st,
> +					      container, cfd);
> +		if (rv > 0) {
> 			free(subarray);
> -			return 1;
> -		}
> -
> -		/* check if operation is supported for metadata handler =
*/
> -		if (st->ss->container_content) {
> -			struct mdinfo *cc =3D NULL;
> -			struct mdinfo *content =3D NULL;
> -
> -			cc =3D st->ss->container_content(st, subarray);
> -			for (content =3D cc; content ; content =3D =
content->next) {
> -				int allow_reshape =3D 1;
> -
> -				/* check if reshape is allowed based on =
metadata
> -				 * indications stored in =
content.array.status
> -				 */
> -				if (content->array.state &
> -				    (1 << MD_SB_BLOCK_VOLUME))
> -					allow_reshape =3D 0;
> -				if (content->array.state &
> -				    (1 << =
MD_SB_BLOCK_CONTAINER_RESHAPE))
> -					allow_reshape =3D 0;
> -				if (!allow_reshape) {
> -					pr_err("cannot reshape arrays in =
container with unsupported metadata: %s(%s)\n",
> -					       devname, container);
> -					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> -				}
> -				if (content->consistency_policy =3D=3D
> -				    CONSISTENCY_POLICY_PPL) {
> -					pr_err("Operation not supported =
when ppl consistency policy is enabled\n");
> -					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> -				}
> -				if (content->consistency_policy =3D=3D
> -				    CONSISTENCY_POLICY_BITMAP) {
> -					pr_err("Operation not supported =
when write-intent bitmap is enabled\n");
> -					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> -				}
> -			}
> -			sysfs_free(cc);
> +			close(cfd);
> +			goto release;
> 		}
> -		if (mdmon_running(container))
> -			st->update_tail =3D &st->updates;
> 	}
>=20
> 	added_disks =3D 0;
> diff --git a/mdadm.h b/mdadm.h
> index c7268a71..6478a399 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1528,6 +1528,7 @@ extern int stat_is_blkdev(char *devname, dev_t =
*rdev);
> extern bool is_dev_alive(char *path);
> extern int get_mdp_major(void);
> extern int get_maj_min(char *dev, int *major, int *minor);
> +extern bool is_bit_set(int val, int index);
> extern int dev_open(char *dev, int flags);
> extern int open_dev(char *devnm);
> extern void reopen_mddev(int mdfd);
> diff --git a/util.c b/util.c
> index 3d05d074..3ebb48a1 100644
> --- a/util.c
> +++ b/util.c
> @@ -1028,6 +1028,20 @@ int get_maj_min(char *dev, int *major, int =
*minor)
> 		*e =3D=3D 0);
> }
>=20
> +/**
> + * is_bit_set() - get bit value by index.
> + * @val: value.
> + * @index: index of the bit (LSB numering).
> + *
> + * Return: bit value.
> + */
> +bool is_bit_set(int val, int index)
> +{
> +	if (val & (1 << index))
> +		return true;
> +	return false;
> +}

I suggest to define the first parameter to int *val, to avoid =
unnecessary memory copy. And for the index parameter, 32bit value for =
bit position index might be too large, unsigned char should be enough =
already (which indicates 255 bits offset).

For the rested part, they look fine with me.

Thanks.

Coly Li

> +
> int dev_open(char *dev, int flags)
> {
> 	/* like 'open', but if 'dev' matches %d:%d, create a temp
> --=20
> 2.26.2
>=20

