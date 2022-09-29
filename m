Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3A9C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 29 Sep 2022 15:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbiI2PTS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbiI2PTP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Sep 2022 11:19:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D405214F8EF
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 08:19:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 50BEC1F86A;
        Thu, 29 Sep 2022 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664464753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GhjRiFHeSTSeN01Hv7ceRbPY3C29AkhsNFDospyupyo=;
        b=SLFGplHmMnyYtY10WMC0Z1a1x/VsjnzQCQET2oL2j0Gabyas1on5rV2xWIlE7mme1oI2+K
        HeDp3Kk2vZ1oQEvAwMU5eMOhPbRtiHs0+HkjgAgPfGrD7OoFBNg6HQaUw6XlVGL2YVkCu+
        Qp/Fgb7ubm0vomUsS40liA7RTYSNiSQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664464753;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GhjRiFHeSTSeN01Hv7ceRbPY3C29AkhsNFDospyupyo=;
        b=eyqPISd0uoYFzj3PdFCw8INbnhbxl3MzXo/Q9zIUltbKvXErMbffNkzdz3upgtnn7fC1JC
        vovG/uzo1/oK9cCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 238EC1348E;
        Thu, 29 Sep 2022 15:19:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id I0akNW+3NWOtWQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 29 Sep 2022 15:19:11 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v4 0/2] Mdmonitor improvements
From:   Coly Li <colyli@suse.de>
In-Reply-To: <08caf2f3-2223-fd3b-82f6-44fee597ddc8@trained-monkey.org>
Date:   Thu, 29 Sep 2022 23:19:08 +0800
Cc:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org,
        pmenzel@molgen.mpg.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <523B910D-50B8-4F2A-9883-60F77B45A3F7@suse.de>
References: <20220606103213.12753-1-kinga.tanska@intel.com>
 <08caf2f3-2223-fd3b-82f6-44fee597ddc8@trained-monkey.org>
To:     Jes Sorensen <jes@trained-monkey.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=8829=E6=97=A5 23:08=EF=BC=8CJes Sorensen =
<jes@trained-monkey.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 6/6/22 06:32, Kinga Tanska wrote:
>> Changes in v4:
>> - fix place where is_mddev is calling
>> - no new changes in "Mdmonitor: Improve logging method" patch
>>=20
>> Kinga Tanska (2):
>>  Mdmonitor: Fix segfault
>>  Mdmonitor: Improve logging method
>>=20
>> Monitor.c | 36 ++++++++++++++++++++++++------------
>> mdadm.h   |  1 +
>> mdopen.c  | 17 +++++++++++++++++
>> util.c    |  2 +-
>> 4 files changed, 43 insertions(+), 13 deletions(-)
>>=20
>=20
> Coly,
>=20
> I am curious why these are marked Changes-requested in patchwork as
> there are no replies in the thread.
>=20
> =
https://patchwork.kernel.org/project/linux-raid/patch/20220907125657.12192=
-2-mateusz.grzonka@intel.com/

Hi Jes,

I noticed this too, and asked Mariusz offline why these patches =
disappeared from my delegation, and he didn=E2=80=99t know why neither. =
So I just continue to review this series regardless its patchwork state. =
This is something I am not familiar with, so the progress is a bit slow.

Thanks.

Coly Li



