Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F06EC54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 17:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiIMRWx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 13:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiIMRW0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 13:22:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A1BEB3
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 09:09:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 79D235C2BE;
        Tue, 13 Sep 2022 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663081955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4x5LhXqSaphnDZsJxk6/1qV24Yul9Sq/d93g7cKTCg=;
        b=XdmTlTkL1ForODjdJQf4NXkG1TArrK6EMeFqXsemSKJOXUllQck8/A41X1NrvN8HyrYo5L
        yNEYGCIrIS3x43/VKX3m4EXs29DAZwzCn323F7eYagFDN/mwIlHpaRi2YRHOdglO2vFr14
        w8AgZ469L3eUOHnkqeITqqXXf1sG5W8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663081955;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4x5LhXqSaphnDZsJxk6/1qV24Yul9Sq/d93g7cKTCg=;
        b=5MVxt2QCKlLozwlGjUffVlUhBMo9W3X53bSerkezTpDXEw94wxmppRLf1CE577vYKnLdf8
        Xm1lo9vsmKKRsrBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D580F139B3;
        Tue, 13 Sep 2022 15:12:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7hLKJOGdIGMdTwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 13 Sep 2022 15:12:33 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 01/10] mdadm: Add option validation for --update-subarray
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-2-mateusz.kusiak@intel.com>
Date:   Tue, 13 Sep 2022 23:12:28 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D32199F4-907F-4B73-9D87-0DB0997A6739@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-2-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Subset of options available for "--update" is not same as for =
"--update-subarray".
> Define maps and enum for update options and use them instead of direct =
comparisons.
> Add proper error message.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>


Hi Mateusz,

I place my questions in line with code,


> ---
> ReadMe.c | 31 ++++++++++++++++++
> maps.c   | 31 ++++++++++++++++++
> mdadm.c  | 99 ++++++++++++++++----------------------------------------
> mdadm.h  | 32 +++++++++++++++++-
> 4 files changed, 121 insertions(+), 72 deletions(-)
>=20
> diff --git a/ReadMe.c b/ReadMe.c
> index 7518a32a..50e6f987 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -656,3 +656,34 @@ char *mode_help[mode_count] =3D {
> 	[GROW]		=3D Help_grow,
> 	[INCREMENTAL]	=3D Help_incr,
> };
> +
> +/**
> + * fprint_update_options() - Print valid update options depending on =
the mode.
> + * @outf: File (output stream)
> + * @update_mode: Used to distinguish update and update_subarray
> + */
> +void fprint_update_options(FILE *outf, enum update_opt update_mode)
> +{
> +	int counter =3D UOPT_NAME, breakpoint =3D UOPT_HELP;
> +	mapping_t *map =3D update_options;
> +
> +	if (!outf)
> +		return;
> +	if (update_mode =3D=3D UOPT_SUBARRAY_ONLY) {
> +		breakpoint =3D UOPT_SUBARRAY_ONLY;
> +		fprintf(outf, "Valid --update options for =
update-subarray are:\n\t");
> +	} else
> +		fprintf(outf, "Valid --update options are:\n\t");
> +	while (map->num) {
> +		if (map->num >=3D breakpoint)
> +			break;
> +		fprintf(outf, "'%s', ", map->name);
> +		if (counter % 5 =3D=3D 0)
> +			fprintf(outf, "\n\t");
> +		counter++;
> +		map++;
> +	}
> +	if ((counter - 1) % 5)
> +		fprintf(outf, "\n");
> +	fprintf(outf, "\r");


Why =E2=80=98\r=E2=80=99 is used here? I feel =E2=80=98\n=E2=80=99 =
should work fine as well.




> +}
> diff --git a/maps.c b/maps.c
> index 20fcf719..b586679a 100644
> --- a/maps.c
> +++ b/maps.c
> @@ -165,6 +165,37 @@ mapping_t sysfs_array_states[] =3D {
> 	{ "broken", ARRAY_BROKEN },
> 	{ NULL, ARRAY_UNKNOWN_STATE }
> };
> +/**
> + * mapping_t update_options - stores supported update options.
> + */
> +mapping_t update_options[] =3D {
> +	{ "name", UOPT_NAME },
> +	{ "ppl", UOPT_PPL },
> +	{ "no-ppl", UOPT_NO_PPL },
> +	{ "bitmap", UOPT_BITMAP },
> +	{ "no-bitmap", UOPT_NO_BITMAP },
> +	{ "sparc2.2", UOPT_SPARC22 },
> +	{ "super-minor", UOPT_SUPER_MINOR },
> +	{ "summaries", UOPT_SUMMARIES },
> +	{ "resync", UOPT_RESYNC },
> +	{ "uuid", UOPT_UUID },
> +	{ "homehost", UOPT_HOMEHOST },
> +	{ "home-cluster", UOPT_HOME_CLUSTER },
> +	{ "nodes", UOPT_NODES },
> +	{ "devicesize", UOPT_DEVICESIZE },
> +	{ "bbl", UOPT_BBL },
> +	{ "no-bbl", UOPT_NO_BBL },
> +	{ "force-no-bbl", UOPT_FORCE_NO_BBL },
> +	{ "metadata", UOPT_METADATA },
> +	{ "revert-reshape", UOPT_REVERT_RESHAPE },
> +	{ "layout-original", UOPT_LAYOUT_ORIGINAL },
> +	{ "layout-alternate", UOPT_LAYOUT_ALTERNATE },
> +	{ "layout-unspecified", UOPT_LAYOUT_UNSPECIFIED },
> +	{ "byteorder", UOPT_BYTEORDER },
> +	{ "help", UOPT_HELP },
> +	{ "?", UOPT_HELP },
> +	{ NULL, UOPT_UNDEFINED}
> +};
>=20
> /**
>  * map_num_s() - Safer alternative of map_num() function.
> diff --git a/mdadm.c b/mdadm.c
> index 56722ed9..3705d114 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -101,7 +101,7 @@ int main(int argc, char *argv[])
> 	char *dump_directory =3D NULL;
>=20
> 	int print_help =3D 0;
> -	FILE *outf;
> +	FILE *outf =3D NULL;
>=20
> 	int mdfd =3D -1;
> 	int locked =3D 0;
> @@ -753,82 +753,39 @@ int main(int argc, char *argv[])
> 				pr_err("Only subarrays can be updated in =
misc mode\n");
> 				exit(2);
> 			}
> +
> 			c.update =3D optarg;
> -			if (strcmp(c.update, "sparc2.2") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "super-minor") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "summaries") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "resync") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "uuid") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "name") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "homehost") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "home-cluster") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "nodes") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "devicesize") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "bitmap") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "no-bitmap") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "bbl") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "no-bbl") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "force-no-bbl") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "ppl") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "no-ppl") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "metadata") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "revert-reshape") =3D=3D 0)
> -				continue;
> -			if (strcmp(c.update, "layout-original") =3D=3D 0 =
||
> -			    strcmp(c.update, "layout-alternate") =3D=3D =
0 ||
> -			    strcmp(c.update, "layout-unspecified") =3D=3D =
0)
> -				continue;
> -			if (strcmp(c.update, "byteorder") =3D=3D 0) {
> +			enum update_opt updateopt =3D =
map_name(update_options, c.update);
> +			enum update_opt print_mode =3D UOPT_HELP;
> +			const char *error_addon =3D "update option";
> +

Could you please move the local variables declaration to the beginning =
of the case O(MISC,'U=E2=80=99) code block?



> +			if (devmode =3D=3D UpdateSubarray) {
> +				print_mode =3D UOPT_SUBARRAY_ONLY;
> +				error_addon =3D "update-subarray =
option";
> +
> +				if (updateopt > UOPT_SUBARRAY_ONLY && =
updateopt < UOPT_HELP)
> +					updateopt =3D UOPT_UNDEFINED;
> +			}
> +
> +			switch (updateopt) {
> +			case UOPT_UNDEFINED:
> +				pr_err("'--update=3D%s' is invalid %s. =
",
> +					c.update, error_addon);
> +				outf =3D stderr;
> +			case UOPT_HELP:
> +				if (!outf)
> +					outf =3D stdout;
> +				fprint_update_options(outf, print_mode);
> +				exit(outf =3D=3D stdout ? 0 : 2);


I tried to run update-subarray parameter but failed, obviously wrong =
command line format. Could you please give me a hint, on how to test the =
=E2=80=94update-subarray parameter? Then I can provide more feed back =
after experience the command.

The comments for rested patches will be posted after can I run and =
verify the change with my eyes.

Thanks.

Coly Li

> +			case UOPT_BYTEORDER:
> 				if (ss) {
> 					pr_err("must not set metadata =
type with --update=3Dbyteorder.\n");
> 					exit(2);
> 				}
> -				for(i =3D 0; !ss && superlist[i]; i++)
> -					ss =3D =
superlist[i]->match_metadata_desc(
> -						"0.swap");
> -				if (!ss) {
> -					pr_err("INTERNAL ERROR cannot =
find 0.swap\n");
> -					exit(2);
> -				}
> -
> -				continue;
> +			default:
> +				break;
> 			}
> -			if (strcmp(c.update,"?") =3D=3D 0 ||
> -			    strcmp(c.update, "help") =3D=3D 0) {
> -				outf =3D stdout;
> -				fprintf(outf, "%s: ", Name);
> -			} else {
> -				outf =3D stderr;
> -				fprintf(outf,
> -					"%s: '--update=3D%s' is invalid. =
 ",
> -					Name, c.update);
> -			}
> -			fprintf(outf, "Valid --update options are:\n"
> -		"     'sparc2.2', 'super-minor', 'uuid', 'name', =
'nodes', 'resync',\n"
> -		"     'summaries', 'homehost', 'home-cluster', =
'byteorder', 'devicesize',\n"
> -		"     'bitmap', 'no-bitmap', 'metadata', =
'revert-reshape'\n"
> -		"     'bbl', 'no-bbl', 'force-no-bbl', 'ppl', =
'no-ppl'\n"
> -		"     'layout-original', 'layout-alternate', =
'layout-unspecified'\n"
> -				);
> -			exit(outf =3D=3D stdout ? 0 : 2);
> +			continue;
>=20
> 		case O(MANAGE,'U'):
> 			/* update=3Ddevicesize is allowed with --re-add =
*/
> diff --git a/mdadm.h b/mdadm.h
> index 163f4a49..43e6b544 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -497,6 +497,36 @@ enum special_options {
> 	ConsistencyPolicy,
> };
>=20
> +enum update_opt {
> +	UOPT_NAME =3D 1,
> +	UOPT_PPL,
> +	UOPT_NO_PPL,
> +	UOPT_BITMAP,
> +	UOPT_NO_BITMAP,
> +	UOPT_SUBARRAY_ONLY,
> +	UOPT_SPARC22,
> +	UOPT_SUPER_MINOR,
> +	UOPT_SUMMARIES,
> +	UOPT_RESYNC,
> +	UOPT_UUID,
> +	UOPT_HOMEHOST,
> +	UOPT_HOME_CLUSTER,
> +	UOPT_NODES,
> +	UOPT_DEVICESIZE,
> +	UOPT_BBL,
> +	UOPT_NO_BBL,
> +	UOPT_FORCE_NO_BBL,
> +	UOPT_METADATA,
> +	UOPT_REVERT_RESHAPE,
> +	UOPT_LAYOUT_ORIGINAL,
> +	UOPT_LAYOUT_ALTERNATE,
> +	UOPT_LAYOUT_UNSPECIFIED,
> +	UOPT_BYTEORDER,
> +	UOPT_HELP,
> +	UOPT_UNDEFINED
> +};
> +extern void fprint_update_options(FILE *outf, enum update_opt =
update_mode);
> +
> enum prefix_standard {
> 	JEDEC,
> 	IEC
> @@ -776,7 +806,7 @@ extern char *map_num(mapping_t *map, int num);
> extern int map_name(mapping_t *map, char *name);
> extern mapping_t r0layout[], r5layout[], r6layout[],
> 	pers[], modes[], faultylayout[];
> -extern mapping_t consistency_policies[], sysfs_array_states[];
> +extern mapping_t consistency_policies[], sysfs_array_states[], =
update_options[];
>=20
> extern char *map_dev_preferred(int major, int minor, int create,
> 			       char *prefer);
> --=20
> 2.26.2
>=20

