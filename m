Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8326C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Jun 2022 11:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352690AbiFAL3Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Jun 2022 07:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352625AbiFAL3Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Jun 2022 07:29:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627F36EB2A
        for <linux-raid@vger.kernel.org>; Wed,  1 Jun 2022 04:29:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1CCA11F8CE;
        Wed,  1 Jun 2022 11:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654082961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lBej9tn5rv7LRcg0CN6wPuuL5fh3IQqnMreRPm7laTg=;
        b=cWO4HZTlWetNstBZp19uPt5MLV5XqJtf2C2BkG6wMadlz+9TVj+bHnMdhdLm9xz9fi8fod
        G9nFGRuTcu9FBxUVAiapwgFalXf1KyzynnMieS5pWU+C0dHKOmn9hY1IztT+9XSn07QW4c
        c4SgZ59wtmRft2LYWJRbicgcHNqnpBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654082961;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lBej9tn5rv7LRcg0CN6wPuuL5fh3IQqnMreRPm7laTg=;
        b=Okt3cNRIEoC2JcDsyeCos3pxbRrE8UUr2i4b8hwMAehcP+kd5MsMZW0371q4JyQjJlQa6u
        MvClm2UtLavNIEAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1178F13A8F;
        Wed,  1 Jun 2022 11:29:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id E7IGNI9Nl2JaMwAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 01 Jun 2022 11:29:19 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v2] Grow: Split Grow_reshape into helper function.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <21a8b838-fc20-3657-6ee9-45b5aed10b62@molgen.mpg.de>
Date:   Wed, 1 Jun 2022 19:29:17 +0800
Cc:     Mateusz Kusiak <mateusz.kusiak@intel.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BC62A57E-71ED-42A8-A156-9875A6578E92@suse.de>
References: <20220601092840.19986-1-mateusz.kusiak@intel.com>
 <21a8b838-fc20-3657-6ee9-45b5aed10b62@molgen.mpg.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=881=E6=97=A5 19:22=EF=BC=8CPaul Menzel =
<pmenzel@molgen.mpg.de> =E5=86=99=E9=81=93=EF=BC=9A
>>=20

[snipped]
>>  +/**
>> + * is_bit_set() - get bit value by index.
>> + * @val: value.
>> + * @index: index of the bit (LSB numbering).
>> + *
>> + * Return: bit value.
>> + */
>> +bool is_bit_set(int *val, unsigned char index)
>> +{
>> +	if ((*val) & (1 << index))
>> +		return true;
>> +	return false;
>=20
> Maybe:
>=20
>    return (*val) & (1 << index)

The above line doesn=E2=80=99t return bool value range, otherwise it =
returns !!((*val) & (1 << index). I am OK with either of them, what the =
patch does is fine to me.

Coly Li


[snipped]

