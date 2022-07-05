Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5248BC43334
	for <linux-raid@archiver.kernel.org>; Tue,  5 Jul 2022 14:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbiGEOM7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Jul 2022 10:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiGEOMo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Jul 2022 10:12:44 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FE914D0A
        for <linux-raid@vger.kernel.org>; Tue,  5 Jul 2022 07:06:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A2A942035F;
        Tue,  5 Jul 2022 14:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657029987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t04QiYyaLrazP612EtY+PDdpbi85t8xhFwqyB1LGZAw=;
        b=Egnno023zZpyzfmOHiHl2+cd+WS1vZxBPAofWfKVYjy1ImC1cykgD4lB5zoEuyxo2wyOge
        d1QMbLRQBd84XTL4qRoR91PJ93VnL86oMy5paMyLk6YfVKaL9nLrX01cnnwREobK0IOztW
        PV0uzieALDxRW8uZcoxzqCVHecVToHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657029987;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t04QiYyaLrazP612EtY+PDdpbi85t8xhFwqyB1LGZAw=;
        b=m0bIoxUpoRL2R8YNgSzFmDO3zxy5Yri186DDRH7D9Y4wq/D4gUG/T/9jTUiuFrsFHayHaS
        dAqgm/cmpvdiQsCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C9AF71339A;
        Tue,  5 Jul 2022 14:06:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KofjI2JFxGJMdQAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 05 Jul 2022 14:06:26 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v3] Monitor: use devname as char array instead of pointer
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220705140501.00007ad3@intel.linux.com>
Date:   Tue, 5 Jul 2022 22:06:22 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <56B084C4-136B-4DF0-938D-762AB16F96FD@suse.de>
References: <20220620140659.20822-1-kinga.tanska@intel.com>
 <393687D9-6540-48FE-A4B2-E0A85A3C519A@suse.de>
 <20220705140501.00007ad3@intel.linux.com>
To:     Kinga Tanska <kinga.tanska@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=885=E6=97=A5 20:05=EF=BC=8CKinga Tanska =
<kinga.tanska@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sat, 25 Jun 2022 15:03:32 +0800
> Coly Li <colyli@suse.de> wrote:
>=20
>>> 2022=E5=B9=B46=E6=9C=8820=E6=97=A5 22:06=EF=BC=8CKinga Tanska =
<kinga.tanska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Device name wasn't filled properly due to incorrect use of strcpy.
>>> Strcpy was used twice. Firstly to fill devname with "/dev/md/"
>>> and then to add chosen name. First strcpy result was overwritten by
>>> second one (as a result <device_name> instead of
>>> "/dev/md/<device_name>" was assigned). This commit changes this
>>> implementation to use snprintf and devname with fixed size. Also
>>> safer string functions are propagated.
>>>=20
>>> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
>>> ---
>>> Monitor.c | 30 +++++++++++-------------------
>>> 1 file changed, 11 insertions(+), 19 deletions(-)
>>>=20
>>> diff --git a/Monitor.c b/Monitor.c
>>> index 6ca1ebe5..04112791 100644
>>> --- a/Monitor.c
>>> +++ b/Monitor.c
>>> @@ -33,8 +33,8 @@
>>> #endif
>>>=20
>>> struct state {
>>> -	char *devname;
>>> -	char devnm[32];	/* to sync with mdstat info */
>>> +	char devname[MD_NAME_MAX + 8];
>>> +	char devnm[MD_NAME_MAX];	/* to sync with mdstat
>>> info */ unsigned int utime;
>>> 	int err;
>>> 	char *spare_group;
>>> @@ -45,7 +45,7 @@ struct state {
>>> 	int devstate[MAX_DISKS];
>>> 	dev_t devid[MAX_DISKS];
>>> 	int percent;
>>> -	char parent_devnm[32]; /* For subarray, devnm of parent.
>>> +	char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of
>>> parent.
>>> 				* For others, ""
>>> 				*/
>>> 	struct supertype *metadata;
>>> @@ -187,13 +187,7 @@ int Monitor(struct mddev_dev *devlist,
>>> 				continue;
>>>=20
>>> 			st =3D xcalloc(1, sizeof *st);
>>> -			if (mdlist->devname[0] =3D=3D '/')
>>> -				st->devname =3D
>>> xstrdup(mdlist->devname);
>>> -			else {
>>> -				st->devname =3D
>>> xmalloc(8+strlen(mdlist->devname)+1);
>>> -				strcpy(strcpy(st->devname,
>>> "/dev/md/"),
>>> -				       mdlist->devname);
>>> -			}
>>> +			snprintf(st->devname, MD_NAME_MAX + 8,
>>> "/dev/md/%s", basename(mdlist->devname)); =20
>>=20
>> Hi Kinga,
>>=20
>> The above location is what the whole patch wants to fix. It is not
>> worth to change other locations. IMHO the change set is a bit large
>> than what it should be, just a suggestion maybe a following style
>> change is enough (not test it),
>>=20
>> @@ -190,9 +190,13 @@ int Monitor(struct mddev_dev *devlist,
>>                        if (mdlist->devname[0] =3D=3D '/')
>>                                st->devname =3D
>> xstrdup(mdlist->devname); else {
>> -                               st->devname =3D
>> xmalloc(8+strlen(mdlist->devname)+1);
>> -                               strcpy(strcpy(st->devname,
>> "/dev/md/"),
>> -                                      mdlist->devname);
>> +                               int _len;
>> +
>> +                               _len =3D 8 + strlen(mdlist->devname);
>> +                               st->devname =3D xmalloc(_len + 1);
>> +                               memset(st->devname, 0, _len + 1);
>> +                               snprintf(st->devname, _len,
>> "/dev/md/%s",
>> +                                        mdlist->devname);
>>                        }
>>                        if (!is_mddev(mdlist->devname))
>>                                return 1;
>>=20
>> Thanks.
>>=20
>> Coly Li
>>=20
>>=20
>>=20
>>> 			if (!is_mddev(mdlist->devname))
>>> 				return 1;
>>> 			st->next =3D statelist;
>>> @@ -216,7 +210,7 @@ int Monitor(struct mddev_dev *devlist,
>>>=20
>>> 			st =3D xcalloc(1, sizeof *st);
>>> 			mdlist =3D conf_get_ident(dv->devname);
>>> -			st->devname =3D xstrdup(dv->devname);
>>> +			snprintf(st->devname, MD_NAME_MAX + 8,
>>> "%s", dv->devname); st->next =3D statelist;
>>> 			st->devnm[0] =3D 0;
>>> 			st->percent =3D RESYNC_UNKNOWN;
>>> @@ -299,7 +293,6 @@ int Monitor(struct mddev_dev *devlist,
>>> 		for (stp =3D &statelist; (st =3D *stp) !=3D NULL; ) {
>>> 			if (st->from_auto && st->err > 5) {
>>> 				*stp =3D st->next;
>>> -				free(st->devname);
>>> 				free(st->spare_group);
>>> 				free(st);
>>> 			} else
>>> @@ -552,7 +545,7 @@ static int check_array(struct state *st, struct
>>> mdstat_ent *mdstat, goto disappeared;
>>>=20
>>> 	if (st->devnm[0] =3D=3D 0)
>>> -		strcpy(st->devnm, fd2devnm(fd));
>>> +		snprintf(st->devnm, MD_NAME_MAX, "%s",
>>> fd2devnm(fd));
>>>=20
>>> 	for (mse2 =3D mdstat; mse2; mse2 =3D mse2->next)
>>> 		if (strcmp(mse2->devnm, st->devnm) =3D=3D 0) {
>>> @@ -682,7 +675,7 @@ static int check_array(struct state *st, struct
>>> mdstat_ent *mdstat, strncmp(mse->metadata_version, "external:", 9)
>>> =3D=3D 0 && is_subarray(mse->metadata_version+9)) {
>>> 		char *sl;
>>> -		strcpy(st->parent_devnm, mse->metadata_version +
>>> 10);
>>> +		snprintf(st->parent_devnm, MD_NAME_MAX, "%s",
>>> mse->metadata_version + 10); sl =3D strchr(st->parent_devnm, '/');
>>> 		if (sl)
>>> 			*sl =3D 0;
>>> @@ -770,14 +763,13 @@ static int add_new_arrays(struct mdstat_ent
>>> *mdstat, struct state **statelist, continue;
>>> 			}
>>>=20
>>> -			st->devname =3D xstrdup(name);
>>> +			snprintf(st->devname, MD_NAME_MAX + 8,
>>> "%s", name); if ((fd =3D open(st->devname, O_RDONLY)) < 0 ||
>>> 			    md_get_array_info(fd, &array) < 0) {
>>> 				/* no such array */
>>> 				if (fd >=3D 0)
>>> 					close(fd);
>>> 				put_md_name(st->devname);
>>> -				free(st->devname);
>>> 				if (st->metadata) {
>>> 					=
st->metadata->ss->free_super(st->metadata);
>>> 					free(st->metadata);
>>> @@ -789,7 +781,7 @@ static int add_new_arrays(struct mdstat_ent
>>> *mdstat, struct state **statelist, st->next =3D *statelist;
>>> 			st->err =3D 1;
>>> 			st->from_auto =3D 1;
>>> -			strcpy(st->devnm, mse->devnm);
>>> +			snprintf(st->devnm, MD_NAME_MAX, "%s",
>>> mse->devnm); st->percent =3D RESYNC_UNKNOWN;
>>> 			st->expected_spares =3D -1;
>>> 			if (mse->metadata_version &&
>>> @@ -797,8 +789,8 @@ static int add_new_arrays(struct mdstat_ent
>>> *mdstat, struct state **statelist, "external:", 9) =3D=3D 0 &&
>>> 			    is_subarray(mse->metadata_version+9)) {
>>> 				char *sl;
>>> -				strcpy(st->parent_devnm,
>>> -					mse->metadata_version+10);
>>> +				snprintf(st->parent_devnm,
>>> MD_NAME_MAX,
>>> +					 "%s",
>>> mse->metadata_version + 10); sl =3D strchr(st->parent_devnm, '/');
>>> 				*sl =3D 0;
>>> 			} else
>>> --=20
>>> 2.26.2
>>>=20
>>=20
>=20
> Hi Coly,
>=20
> Yes, fragment of code, which you selected, is enough to fix it. I have
> changed also 32 to define, and fixed unsafe functions in this file to
> improve code quality and avoid magic number. What's your opinion, is
> this change worth to add?
> Would you mind getting two patches, one with this specific fix, and
> other one with another improvements in this file?

It will be cool, if the patch can be split into read-fix and =
code-clean-up parts.

So I can provide my feedback fast for the real fix part.

Thanks.

Coly Li

