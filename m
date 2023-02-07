Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F3BC636CC
	for <linux-raid@archiver.kernel.org>; Tue,  7 Feb 2023 18:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjBGSMf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Feb 2023 13:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBGSMe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Feb 2023 13:12:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1233A876
        for <linux-raid@vger.kernel.org>; Tue,  7 Feb 2023 10:12:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5B5BB80AED
        for <linux-raid@vger.kernel.org>; Tue,  7 Feb 2023 18:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415C6C433EF
        for <linux-raid@vger.kernel.org>; Tue,  7 Feb 2023 18:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675793551;
        bh=cwdct/sugDevBPVRATw8t4tTasgEzsVowI/v1v2+PUY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TqCXEd/XFwIZ12XSD559xgVyRWf7rXkHWqectcsYSklSjS5NIOLxxjTx02i0C0USi
         HC1idrgn62QTN3ClNorWv53rZ0dLKGxVmTOhlIgmBACC7ImHKu+ms0D1aqSraNdXuR
         cdLPmN6+TCeW7xnCvVHgT0AFEGfn1eSDw95ngrhoHNPfFwEmznALMDwSjrqdPpAV3+
         Of5iS2HRGFIOxn429W1MqbPc37sMgyQS2o6irnBBZiVR8XVYaX83qzTjcWng+IdAYv
         3OsIn7cVDzk9wdSPt13iWF/67A0je3b3zHeLXZiX6O/jejl0LwWxu3HPU8g+HJ6/rX
         U9MZdUegxq3/w==
Received: by mail-lf1-f50.google.com with SMTP id cf42so23526302lfb.1
        for <linux-raid@vger.kernel.org>; Tue, 07 Feb 2023 10:12:31 -0800 (PST)
X-Gm-Message-State: AO0yUKWbUY6MDFQfqCBY3a/oZA3XZrp3MCDxem69LSiygGWnOTe0/UNk
        +gxWSfBwYmUoAn7/E03j1grszEMfBacMVzt2JOA=
X-Google-Smtp-Source: AK7set9odP28GNslcQ6EAiV/EdP/GgUzDVeedgeFBsugHXDTXjBE7hzoLqr2XyrCNPESkqKVWcAvskpOK1yUAvHh950=
X-Received: by 2002:ac2:4e4c:0:b0:4cc:a1e3:c04b with SMTP id
 f12-20020ac24e4c000000b004cca1e3c04bmr699730lfr.15.1675793549200; Tue, 07 Feb
 2023 10:12:29 -0800 (PST)
MIME-Version: 1.0
References: <20230203051344.19328-1-xni@redhat.com> <CALTww28SZ+3uP_6+Y058fvQqLC1fc9GjTDAUC440kd++ZnUTcg@mail.gmail.com>
In-Reply-To: <CALTww28SZ+3uP_6+Y058fvQqLC1fc9GjTDAUC440kd++ZnUTcg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 7 Feb 2023 10:12:17 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5is9zyYCq09y=fHcPLWfVEADMey+FLV70E224G1M2n-g@mail.gmail.com>
Message-ID: <CAPhsuW5is9zyYCq09y=fHcPLWfVEADMey+FLV70E224G1M2n-g@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: Increase active_io to count acct_io
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Feb 7, 2023 at 5:49 AM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Song
>
> Is the patch ok? If so, are there chances to merge this into md-next this week?
>

I rewrote the commit log and applied it to md-next. Please double check
the new commit log is accurate.

Thanks,
Song
