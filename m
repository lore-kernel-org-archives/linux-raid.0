Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C0EC00140
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 16:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239600AbiHXQo7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 12:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238878AbiHXQoz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 12:44:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CACDDC6
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 09:44:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 937A520A38;
        Wed, 24 Aug 2022 16:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661359488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVN6M9sHKHOvI/yPzlwynLhbIIyqkJD0Huf5RW4aXgo=;
        b=Tia0rZYQblOrdyqgtm7nZJcMZ9Kl9l0gMBepsGbCYsMspoWzXt46ASeSgQdU0M22tLwOW1
        DZbCNohNUMJPjhVG0sJUrVGk9SecfJo407eqT0SppmlCqNOfKZGCnDUn1ofIj3bgLIprPP
        OSbmYga/EAZamakYZnvkP+I5p4ARg98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661359488;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVN6M9sHKHOvI/yPzlwynLhbIIyqkJD0Huf5RW4aXgo=;
        b=nB7Z36hs91ZBlymfjf3FLtgZ555InywMT9QA28PIPhfNlywv2Gn3JqKTWEPJscr5m8uEqS
        QWIsF0VySTtaZRAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F0FE13AC0;
        Wed, 24 Aug 2022 16:44:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hAcgD39VBmPyPAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 24 Aug 2022 16:44:47 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v3 2/2] mdadm: replace container level checking with
 inline
From:   Coly Li <colyli@suse.de>
In-Reply-To: <f16e1cc6-e373-13ef-1d3e-b3f3a00d0e80@trained-monkey.org>
Date:   Thu, 25 Aug 2022 00:44:43 +0800
Cc:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F52928B6-9C19-4C30-B6DB-1EAD5DB28624@suse.de>
References: <20220819005547.17343-1-kinga.tanska@intel.com>
 <20220819005547.17343-3-kinga.tanska@intel.com>
 <f16e1cc6-e373-13ef-1d3e-b3f3a00d0e80@trained-monkey.org>
To:     Jes Sorensen <jes@trained-monkey.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8825=E6=97=A5 00:03=EF=BC=8CJes Sorensen =
<jes@trained-monkey.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 8/18/22 20:55, Kinga Tanska wrote:
>> To unify all containers checks in code, is_container() function is
>> added and propagated.
>>=20
>> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
>> ---
>> Assemble.c    |  5 ++---
>> Create.c      |  6 +++---
>> Grow.c        |  6 +++---
>> Incremental.c |  4 ++--
>> mdadm.h       | 14 ++++++++++++++
>> super-ddf.c   |  6 +++---
>> super-intel.c |  4 ++--
>> super0.c      |  2 +-
>> super1.c      |  2 +-
>> sysfs.c       |  2 +-
>> 10 files changed, 32 insertions(+), 19 deletions(-)
>=20
> This one fails to apply for me from patcheworks. That said, a minor =
nit
> below.
>=20
> Mind fixing this and posting an updated version?
>=20
> Thanks,
> Jes
>=20
>=20
>> diff --git a/mdadm.h b/mdadm.h
>> index c7268a71..72abfc50 100644
>> --- a/mdadm.h
>> +++ b/mdadm.h
>> @@ -1885,3 +1885,17 @@ enum r0layout {
>>  * This is true for native and DDF, IMSM allows 16.
>>  */
>> #define MD_NAME_MAX 32
>> +
>> +/**
>> + * is_container() - check if @level is &LEVEL_CONTAINER
>> + * @level: level value
>> + *
>> + * return:
>> + * 1 if level is equal to &LEVEL_CONTAINER, 0 otherwise.
>> + */
>> +static inline int is_container(const int level)
>> +{
>> +	if (level =3D=3D LEVEL_CONTAINER)
>> +		return 1;
>> +	return 0;
>> +}
>> \ No newline at end of file
>=20
> Please add the lost newline

Hi Jes,

This one was fixed in my previous post to you. And it can be found from =
the mdadm-CI tree =
(git://git.kernel.org/pub/scm/linux/kernel/git/colyli/mdadm.git) at =
commit 1065f521f833ebaac1bce934e8dea91fcd8221ae

If you want, I can post a v4 version for this patch.

Coly Li=
