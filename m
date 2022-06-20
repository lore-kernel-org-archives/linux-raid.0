Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB6EC43334
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 16:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244581AbiFTQ2w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbiFTQ20 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 12:28:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D04BE0C
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 09:28:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 43A631F941;
        Mon, 20 Jun 2022 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655742504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AfxDuNgNS9UL/1/65H2X98/dkOgvqhEoq7unBJ1hUV4=;
        b=H5XwLz/9jHwYGLMYuugSUHVDSNI2IxXnj/U396Fq6Q/s1lIjNtCgOhviy6O9Z7LPmgEatn
        ha1U1IXk+Sz1hSJggfTrguvrDDUqg1K51GsLTyrcSC2bIcJeTIFoD0Cpl905AgohV20bkd
        M+kw4kez1OGsagmNp/h6rnbCi/CfBR0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655742504;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AfxDuNgNS9UL/1/65H2X98/dkOgvqhEoq7unBJ1hUV4=;
        b=dfB0ikjaL3sh5TDlEFS2rN1sC24jfiseb1Pgn5fGHf3t49Iwn4singeon7vj/O2dQbstGF
        0k19hvXYMZijl0Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0F974134CA;
        Mon, 20 Jun 2022 16:28:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aedcMCagsGKxGQAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 20 Jun 2022 16:28:22 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 1/2] mdadm: Fix array size mismatch after grow
From:   Coly Li <colyli@suse.de>
In-Reply-To: <7f4525$iu0ds4@fmsmga008-auth.fm.intel.com>
Date:   Tue, 21 Jun 2022 00:28:18 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <2747A949-7F7E-4C44-816B-F2B648EB87C9@suse.de>
References: <20220407142739.60198-1-lukasz.florczak@linux.intel.com>
 <20220407142739.60198-2-lukasz.florczak@linux.intel.com>
 <35B48024-E02A-45EB-AC5C-4C3DDB2055E3@suse.de>
 <7f4525$iu0ds4@fmsmga008-auth.fm.intel.com>
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=883=E6=97=A5 22:30=EF=BC=8CLukasz Florczak =
<lukasz.florczak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, 30 May 2022 18:01:05 +0800, Coly Li <colyli@suse.de> wrote:
>=20
> Hi Coly,
>> Hi Lukasz,
>>=20
>>=20
>>> 2022=E5=B9=B44=E6=9C=887=E6=97=A5 22:27=EF=BC=8CLukasz Florczak
>>> <lukasz.florczak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> imsm_fix_size_mismatch() is invoked to fix the problem, but it
>>> couldn't proceed due to migration check. This patch allows for
>>> intended behavior.
>>=20
>>=20
>> Could you please explain a bit more about why =E2=80=9Cit couldn=E2=80=99=
t proceed
>> due to migration=E2=80=9D, and what is the =E2=80=9Cintended =
behavior=E2=80=9D? It may help
>> me to understand your change and response faster.
>=20
> The intended behavior here is to fix the array size after grow that is
> displayed in mdadm detail, since there can be a mismatch if the raid
> was created in EFI [1]. That is the array size is not consistent with
> the formula:=20
> Array_size * block_size =3D Num_stripes * Chunk_size * =
Num_of_data_drives=20
>=20
> That fix couldn't happen as the metadata update part was efficiently
> omitted with continue statement after the migration type condition was
> met.=20
>=20
> About migration I didn't go that much into detail, but it was an issue
> that dev->vol.migr_type was still in MIGR_GEN_MIGR state even though
> imsm_fix_size_mismatch() was called after migration has been finished,
> at least from the mdadm's point of view. That happens because this
> value is changed later, afaik, by mdmon. The initial idea here must've
> been not to change the array size during migration, but that is not
> valid since its state is just not updated yet.
>=20
> [1]
> =
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D895ffd99=
2954069e4ea67efb8a85bb0fd72c3707

Copied, thanks for the hint.

BTW, now I do the imsm related test with IMSM_NO_PLATFORM=3D1 and =
IMSM_DEVNAME_AS_SERIAL=3D1. To test situation as the above text =
mentioned, do I have to find a real hardware with VROC supported?

Coly Li

