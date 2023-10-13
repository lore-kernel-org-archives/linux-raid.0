Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A88CCDB47E
	for <linux-raid@archiver.kernel.org>; Fri, 13 Oct 2023 15:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbjJMPyb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Oct 2023 11:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjJMPyb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Oct 2023 11:54:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E58BB
        for <linux-raid@vger.kernel.org>; Fri, 13 Oct 2023 08:54:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A8D941FDA2;
        Fri, 13 Oct 2023 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697212467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9lcmCgHwUjHiyVierdQGNvxmwKF4vIwhvqeEXn2X2YE=;
        b=tdtwd2wPxYSioR9VgDDzs/4R6kpvvyV+rsav8Tv7Yx8TjAmBRh2JlyhGuvV2DnzVdkZaAu
        dg4I3oKFzyZWrtCTtyhrPMtqI+7+8TX2uOxZVgtoHygCczAMB2s10zY/QxOKGhk5EH3DSp
        pLSNS4L4iyFYem9Ifl8ShCCHbjpCqg4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697212467;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9lcmCgHwUjHiyVierdQGNvxmwKF4vIwhvqeEXn2X2YE=;
        b=RxbH3dnOMGVAkV1vdKYuGB99p2ia9TWjsTsdYegLGfQpFcTs+tuEHQdSzE2DvshETpOhmK
        ONd+MiMVDnwWDmAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69B341358F;
        Fri, 13 Oct 2023 15:54:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OFuiDTJoKWXnWgAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 13 Oct 2023 15:54:26 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: [PATCH 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if
 sb->layout is set
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20231013154402.00003976@linux.intel.com>
Date:   Fri, 13 Oct 2023 23:54:13 +0800
Cc:     jes@trained-monkey.org, linux-raid <linux-raid@vger.kernel.org>,
        NeilBrown <neilb@suse.de>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <645BDF69-0798-4CBB-B2FF-65B1AEF3A787@suse.de>
References: <20231011130522.78994-1-xni@redhat.com>
 <20231013113034.0000298a@linux.intel.com>
 <CALTww282t6UMePRPPmoxyxBpedbjWC=9ojjHQx8o8sJttnzvSA@mail.gmail.com>
 <20231013135935.00005679@linux.intel.com>
 <CALTww29C_kS9e9hxbz+GFWVvAci1CZSfHxWTigD3zCYdZghmYw@mail.gmail.com>
 <20231013154402.00003976@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
X-Mailer: Apple Mail (2.3731.700.6)
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-3.64 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         BAYES_HAM(-0.04)[58.51%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         MV_CASE(0.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         RCPT_COUNT_FIVE(0.00)[5];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2023=E5=B9=B410=E6=9C=8813=E6=97=A5 21:44=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, 13 Oct 2023 20:12:38 +0800
> Xiao Ni <xni@redhat.com> wrote:
>=20
>>>>> So, it forces the calculations made by Neil back but I think that =
we can
>>>>> simply compare dev_size and data_offset between members. =20
>>>>=20
>>>> We don't need to consider the compatibility anymore in future?
>>>>=20
>>> Not sure if I get your question correctly. This property is =
supported now so
>>> why we should? It is already there so we are safe to set it. =20
>>=20
>> I asked because you said we can remove the check in future. So I =
don't
>> know why we don't need the check in future. The check here should be
>> the kernel version check, right?
>=20
>=20
> We are not supporting old kernels forever. At some point of time, we =
would
> decide that kernels older than 5.5 are no longer a valid case and then =
we will
> free to remove verification. If we are not supporting something older =
than the
> version where it was added, we can assume that MD_RAID0_LAYOUT is =
always
> available and we don't need to care anymore, right?
>=20
> Here a recent example:
> =
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3Df8d2c428=
6a

Just FYI, we still support Linux v4.12 based kernel for SLES12-SP5.

Coly Li

