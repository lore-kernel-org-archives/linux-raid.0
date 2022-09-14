Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07775C6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 14:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiINO5A (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 10:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiINO46 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 10:56:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4988D67142
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 07:56:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EF3B03396E;
        Wed, 14 Sep 2022 14:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lL21f8eBLDoKRQ3w+WTJc2gLKp4yn/mUPsveDfg260E=;
        b=uZSRphVr/nsLNNnARGlI8DEaDJfYq18ZctGs3LuJga44BOGooJScnvgFIrmGeZ4Mo+jWpS
        MdJDA1ytwuqpIV+oWRI6S+oIcxFHZD3X4Sphuj3TzVE+5qihB2IzT20MCOm2hMxQwlsedG
        YNDKO84SMvJVL9RMgR3s4C7noiXphFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167415;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lL21f8eBLDoKRQ3w+WTJc2gLKp4yn/mUPsveDfg260E=;
        b=EW+2VhhM+DjKDazgStvACsiakyErp4yAA+zOA75fm2YyuK+s3c6yumD97ljw+lCE/7TB7F
        PaLHeJY5UMubJICA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4B602134B3;
        Wed, 14 Sep 2022 14:56:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id s0ghBbbrIWPqQQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 14:56:54 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 5/5 v2] get_vd_num_of_subarray: fix memleak
From:   Coly Li <colyli@suse.de>
In-Reply-To: <33C0CE99-29C7-488B-A318-D8F08C57FDC2@suse.de>
Date:   Wed, 14 Sep 2022 22:56:51 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linfeilong <linfeilong@huawei.com>, lixiaokeng@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5A207147-81B2-4FB9-A81D-A82AA61D6658@suse.de>
References: <11b7eff6-56a0-49ee-b2fd-50b402c3dde1@huawei.com>
 <62b32172-f3b5-8c32-0a74-77e8b18927d1@huawei.com>
 <33C0CE99-29C7-488B-A318-D8F08C57FDC2@suse.de>
To:     Wu Guanghao <wuguanghao3@huawei.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=883=E6=97=A5 16:25=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
>> 2022=E5=B9=B48=E6=9C=882=E6=97=A5 10:17=EF=BC=8CWu Guanghao =
<wuguanghao3@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> sra =3D sysfs_read() should be free before return in
>> get_vd_num_of_subarray()
>>=20
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>=20
> Hi Guanghao,
>=20
> I have a question for this patch, please correct me if I am wrong.
>=20
>=20
>=20
>> ---
>> super-ddf.c | 9 +++++++--
>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/super-ddf.c b/super-ddf.c
>> index abbc8b09..6d4618fe 100644
>> --- a/super-ddf.c
>> +++ b/super-ddf.c
>> @@ -1599,15 +1599,20 @@ static unsigned int =
get_vd_num_of_subarray(struct supertype *st)
>>       sra =3D sysfs_read(-1, st->devnm, GET_VERSION);
>>       if (!sra || sra->array.major_version !=3D -1 ||
>>           sra->array.minor_version !=3D -2 ||
>> -           !is_subarray(sra->text_version))
>> +           !is_subarray(sra->text_version)) {
>> +               if (sra)
>> +                       sysfs_free(sra);
>>               return DDF_NOTFOUND;
>> +       }
>>=20
>>       sub =3D strchr(sra->text_version + 1, '/');
>>       if (sub !=3D NULL)
>>               vcnum =3D strtoul(sub + 1, &end, 10);
>>       if (sub =3D=3D NULL || *sub =3D=3D '\0' || *end !=3D '\0' ||
>> -           vcnum >=3D be16_to_cpu(ddf->active->max_vd_entries))
>> +           vcnum >=3D be16_to_cpu(ddf->active->max_vd_entries)) {
>> +               sysfs_free(sra);
>>               return DDF_NOTFOUND;
>> +       }
>>=20
>>       return vcnum;
>=20
>=20
> Before return vcnum, should call sysfs_free(sra) ?
>=20
> Thank you in advance.

Ping?

Coly Li

