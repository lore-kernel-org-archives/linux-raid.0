Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937C4C43334
	for <linux-raid@archiver.kernel.org>; Sat, 23 Jul 2022 04:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiGWEhU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Jul 2022 00:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGWEhU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Jul 2022 00:37:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FE423BD3
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 21:37:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 788361FED9;
        Sat, 23 Jul 2022 04:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658551036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ZXhtahTaf1aqw1qtlzO9QFg0q/FjwK4PmMvjrkW3DQ=;
        b=XHp5iSX+KCP2muZ9KOz7xUYLhqRoQKDfdTXer6pQ9uxbA3g3iyzDLiTQXsFXYHw0hR6sK8
        kvup5PRz9WbEq6LrfA460FSPVMINXxMgYg8FtCNL2k26e3b7tDTVVuTsEAxlIUZrlzXcTw
        d0psM1ZE29W+8FUe3ICfalfe/i7+oQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658551036;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ZXhtahTaf1aqw1qtlzO9QFg0q/FjwK4PmMvjrkW3DQ=;
        b=h59YqBhLhxbHycXZ8GbOOkoZbe4ydFdQWRs0D9PgofXV4FATfuv5PV7nz9y31cNxG/6KEM
        GjcNEmauwGbSr3Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1A47213483;
        Sat, 23 Jul 2022 04:37:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZdXXMfp622KmVAAAMHmgww
        (envelope-from <neilb@suse.de>); Sat, 23 Jul 2022 04:37:14 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>
Cc:     "Paul Menzel" <pmenzel@molgen.mpg.de>,
        "Jes Sorensen" <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH mdadm v2] super1: report truncated device
In-reply-to: <20220721101907.00002fee@linux.intel.com>
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>,
 <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>,
 <165768409124.25184.3270769367375387242@noble.neil.brown.name>,
 <20220721101907.00002fee@linux.intel.com>
Date:   Sat, 23 Jul 2022 14:37:11 +1000
Message-id: <165855103166.25184.12700264207415054726@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 21 Jul 2022, Mariusz Tkaczyk wrote:
> Hi Neil,
>=20
> On Wed, 13 Jul 2022 13:48:11 +1000
> "NeilBrown" <neilb@suse.de> wrote:
>=20
> > When the metadata is at the start of the device, it is possible that it
> > describes a device large than the one it is actually stored on.  When
> > this happens, report it loudly in --examine.
> >=20
> > ....
> >    Unused Space : before=3D1968 sectors, after=3D-2047 sectors DEVICE TOO=
 SMALL
> >           State : clean TRUNCATED DEVICE
> > ....
>=20
> State : clean TRUNCATED DEVICE is enough. "DEVICE TOO SMALL" seems to be
> redundant.

I needed to change the "Unused Space" line because before the patch the
"after=3D" value is close to 2^64.  I needed to make it negative.  But having
a negative value there is strange so I thought it would be good to
highlight it and explain why.

> >=20
> > Also report in --assemble so that the failure which the kernel will
> > report will be explained.
>=20
> Understand but you've added it in load_super1() so it affects all load_supe=
r()
> calls, is it indented? I assume yes but please confirm.=20

Yes, it is intended for all calls to ->load_super() on v1 metadata.
The test is gated on ->ignore_hw_compat so that it does still look like
v1.x metadata (so --examine can report on it), but an error results for
any attempt to use the metadata in an active array.

->ignore_hw_compat isn't a perfect fit for the concept, but it is a
perfect fit for the desired behaviour.  Maybe we should rethink the name
for that field.

> >=20
> > mdadm: Device /dev/sdb is not large enough for data described in superblo=
ck
> > mdadm: no RAID superblock on /dev/sdb
> > mdadm: /dev/sdb has no superblock - assembly aborted
> >=20
> > Scenario can be demonstrated as follows:
> >=20
> > mdadm: Note: this array has metadata at the start and
> >     may not be suitable as a boot device.  If you plan to
> >     store '/boot' on this device please ensure that
> >     your boot-loader understands md/v1.x metadata, or use
> >     --metadata=3D0.90
> > mdadm: Defaulting to version 1.2 metadata
> > mdadm: array /dev/md/test started.
> > mdadm: stopped /dev/md/test
> >    Unused Space : before=3D1968 sectors, after=3D-2047 sectors DEVICE TOO=
 SMALL
> >           State : clean TRUNCATED DEVICE
> >    Unused Space : before=3D1968 sectors, after=3D-2047 sectors DEVICE TOO=
 SMALL
> >           State : clean TRUNCATED DEVICE
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  super1.c | 34 +++++++++++++++++++++++++++-------
> >  1 file changed, 27 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/super1.c b/super1.c
> > index 71af860c0e3e..4d8dba8a5a44 100644
> > --- a/super1.c
> > +++ b/super1.c
> > @@ -406,12 +406,18 @@ static void examine_super1(struct supertype *st, ch=
ar
> > *homehost)=20
> >  	st->ss->getinfo_super(st, &info, NULL);
> >  	if (info.space_after !=3D 1 &&
> > -	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET))
> > -		printf("   Unused Space : before=3D%llu sectors, after=3D%llu
> > sectors\n",
> > -		       info.space_before, info.space_after);
> > -
> > -	printf("          State : %s\n",
> > -	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean");
> > +	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET)) {
> > +		printf("   Unused Space : before=3D%llu sectors, ",
> > +		       info.space_before);
> > +		if (info.space_after < INT64_MAX)
> > +			printf("after=3D%llu sectors\n", info.space_after);
> > +		else
> > +			printf("after=3D-%llu sectors DEVICE TOO SMALL\n",
> > +			       UINT64_MAX - info.space_after);
> As above, for me this else here is not necessary.

The change to report a negative is necessary.

>=20
> > +	}
> > +	printf("          State : %s%s\n",
> > +	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean",
> > +	       info.space_after > INT64_MAX ? " TRUNCATED DEVICE" : "");
>=20
> Could you use standard if instruction to make the code more readable? We are
> avoiding ternary operators if possible now.

I could.  I don't want to.
I think the code is quite readable.  Putting a space before the first
'?' would help, as might lining up the two '?'.

>=20
> >  	printf("    Device UUID : ");
> >  	for (i=3D0; i<16; i++) {
> >  		if ((i&3)=3D=3D0 && i !=3D 0)
> > @@ -2206,6 +2212,7 @@ static int load_super1(struct supertype *st, int fd,
> > char *devname) tst.ss =3D &super1;
> >  		for (tst.minor_version =3D 0; tst.minor_version <=3D 2;
> >  		     tst.minor_version++) {
> > +			tst.ignore_hw_compat =3D st->ignore_hw_compat;
> >  			switch(load_super1(&tst, fd, devname)) {
> >  			case 0: super =3D tst.sb;
> >  				if (bestvers =3D=3D -1 ||
> > @@ -2312,7 +2319,6 @@ static int load_super1(struct supertype *st, int fd,
> > char *devname) free(super);
> >  		return 2;
> >  	}
> > -	st->sb =3D super;
> > =20
> >  	bsb =3D (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
> > =20
> > @@ -2322,6 +2328,20 @@ static int load_super1(struct supertype *st, int f=
d,
> > char *devname) if (st->data_offset =3D=3D INVALID_SECTORS)
> >  		st->data_offset =3D __le64_to_cpu(super->data_offset);
> > =20
> > +	if (st->minor_version >=3D 1 &&
> > +	    st->ignore_hw_compat =3D=3D 0 &&
> > +	    (__le64_to_cpu(super->data_offset) +
> > +	     __le64_to_cpu(super->size) > dsize ||
> > +	     __le64_to_cpu(super->data_offset) +
> > +	     __le64_to_cpu(super->data_size) > dsize)) {
> > +		if (devname)
> > +			pr_err("Device %s is not large enough for data
> > described in superblock\n",
> > +			       devname);
>=20
> why not just:
> if (__le64_to_cpu(super->data_offset) + __le64_to_cpu(super->data_size) > d=
size)
> from my understanding, only this check matters.

It seemed safest to test both.  I don't remember the difference between
->size and ->data_size.  In getinfo_super1() we have

	if (info->array.level <=3D 0)
		data_size =3D __le64_to_cpu(sb->data_size);
	else
		data_size =3D __le64_to_cpu(sb->size);

which suggests that either could be relevant.
I guess ->size should always be less than ->data_size.  But
load_super1() doesn't check that, so it isn't safe to assume it.

Thanks,
NeilBrown


>=20
> Thanks,
> Mariusz
>=20
>=20
