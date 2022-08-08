Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C4FC00140
	for <linux-raid@archiver.kernel.org>; Mon,  8 Aug 2022 10:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiHHKD6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Aug 2022 06:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiHHKD4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Aug 2022 06:03:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3795247
        for <linux-raid@vger.kernel.org>; Mon,  8 Aug 2022 03:03:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B21D420B28;
        Mon,  8 Aug 2022 10:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659953033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7jxFz7wcX5MOXDf2DCL2z47CKzQ4W5Nd+02cSBmlkXM=;
        b=OZozGDLXptdOytGIGgYe4f/Pw1iY4QxFD+RiIT4ybqlXe9zNv98hNDnsTlq+85h5LeUUJx
        ZPDY3OrgdugHIDRFCbOn6wfBinozWD88AU6eKNfZ5sr41XVFiatCLmk1jvxgpt++2MQBya
        Uab27g7kM9Om+RGTg3RolhzQGG4Y14E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659953033;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7jxFz7wcX5MOXDf2DCL2z47CKzQ4W5Nd+02cSBmlkXM=;
        b=nxAzz4TCPNXRzG1o9cei8RtmjBAa5+Qwyxgr9IdmgLUs639FhlaObwo+YlvgYo6wfx5sNA
        qBxr600DZYPr3RBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E08EC13A7C;
        Mon,  8 Aug 2022 10:03:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8YJkK4jf8GIefgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 08 Aug 2022 10:03:52 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
From:   Coly Li <colyli@suse.de>
In-Reply-To: <9b885a13-21cf-3c9a-f320-c047301294de@trained-monkey.org>
Date:   Mon, 8 Aug 2022 18:03:47 +0800
Cc:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2622AABD-75DC-41D4-9F1E-E958463E9FD0@suse.de>
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
 <9b885a13-21cf-3c9a-f320-c047301294de@trained-monkey.org>
To:     Jes Sorensen <jes@trained-monkey.org>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=888=E6=97=A5 04:41=EF=BC=8CJes Sorensen =
<jes@trained-monkey.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 6/9/22 03:41, Mateusz Kusiak wrote:
>> Grow_reshape should be split into helper functions given its size.
>> - Add helper function for preparing reshape on external metadata.
>> - Close cfd file descriptor.
>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>> ---
>> Changes since v2:
>> - removed dot from commit message
>> - formatted commit description as a list
>> - got rid of returning -1 in prepare_external_reshape()
>> - changed "return" section in prepare_external_reshape() description
>=20
> Hi Mateusz,
>=20
> Changes look good to me, but it no longer applies. Mind sending an =
updated version?

Hi Jes,

Please check the version I post to you in series =E2=80=9Cmdadm-CI =
for-jes/20220728: patches for merge=E2=80=9D (Message-Id: =
<20220728122101.28744-1-colyli@suse.de>), the patch in this series is =
rebased and confirmed with Mateusz, it could be applied to upstream =
mdadm.

Thanks.

Coly Li

