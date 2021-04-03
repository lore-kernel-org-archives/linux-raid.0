Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8A4C433B4
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 12:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BE09611CE
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 12:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbhDCMtq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Apr 2021 08:49:46 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:38226 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhDCMtp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Apr 2021 08:49:45 -0400
Date:   Sat, 03 Apr 2021 12:49:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1617454181;
        bh=vC7F9V5oBVfcyC+4DWBvHlYWHWiza4PMNs3qzFeK+HM=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=Z98SL6Q01od3loeMGHMLfK/FZLzPPhbk0zXvWRCgprI7XjlmOnHoLUEhb/uiiyGKo
         kD2eZvvffHwsqQcUVxsbMbWndg4gCPzh79jJ/IcrIFYpLapWflUa7owSBUATDBLOch
         WhTXV1/Cbs2CcxkYw8a94bd9/R53ytjJQnJwrG2g=
To:     Borislav Petkov <bp@alien8.de>, Paul Menzel <pmenzel@molgen.mpg.de>
From:   Thomas Backlund <tmb@tmb.nu>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, it+linux-x86@molgen.mpg.de
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: =?utf-8?Q?Re:_[regression_5.4.97_=E2=86=92_5.10.24]:_raid6_avx2x4_speed_drops_from_18429_MB/s_to_6155_MB/s?=
Message-ID: <42011184-de0b-25d1-534f-a0d412d287a2@tmb.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Den 2021-04-02 kl. 17:05, skrev Borislav Petkov:
> On Fri, Apr 02, 2021 at 10:33:51AM +0200, Paul Menzel wrote:
>> Dear Linux folks,
>>
>>
>> On an two socket AMD EPYC 7601, we noticed a decrease in raid6 avx2x4 sp=
eed
>> shown at the beginning of the boot.
>>
>>                         5.4.95        5.10.24
>> ----------------------------------------------
>> raid6: avx2x4 gen()   18429 MB/s     6155 MB/s
>> raid6: avx2x4 xor()    6644 MB/s     4274 MB/s
>> raid6: avx2x2 gen()   17894 MB/s    18744 MB/s
>> raid6: avx2x2 xor()   11642 MB/s    11950 MB/s
>> raid6: avx2x1 gen()   13992 MB/s    17112 MB/s
>> raid6: avx2x1 xor()   10855 MB/s    11143 MB/s
>
> Looks like those two might help:
>

That would mean only this is missing:
> 49200d17d27d x86/fpu/64: Don't FNINIT in kernel_fpu_begin()


as this one landed in 5.10.11:
> e45122893a98 x86/fpu: Add kernel_fpu_begin_mask() to selectively initiali=
ze state
>

--
Thomas

