Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752E6C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 11:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349860AbiBHLZt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 06:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiBHJ4b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 04:56:31 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E68CC03FEC0
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 01:56:29 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aebc2.dynamic.kabel-deutschland.de [95.90.235.194])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2517D61EA1923;
        Tue,  8 Feb 2022 10:56:28 +0100 (CET)
Message-ID: <92bef5bf-0084-2b29-0eca-bcaf7f743c27@molgen.mpg.de>
Date:   Tue, 8 Feb 2022 10:56:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] Replace error prone signal() with sigaction()
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Lukasz Florczak <lukasz.florczak@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        linux-raid@vger.kernel.org
References: <20220208152915.12858-1-lukasz.florczak@intel.com>
 <17c41b6e-ed53-aeed-87e0-a6cbf96f44a2@molgen.mpg.de>
 <20220208105246.0000602a@linux.intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220208105246.0000602a@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Mariusz,


Am 08.02.22 um 10:52 schrieb Mariusz Tkaczyk:
> On Tue, 8 Feb 2022 09:52:03 +0100 Paul Menzel wrote:

>> Am 08.02.22 um 16:29 schrieb Lukasz Florczak:
>>> Up to this date signal() was used which is deprecated [1].
>>> Sigaction() call is preferred. This commit introduces replacement
>>> from signal() to sigaction() by the use of signal_s() wrapper.
>>> Also remove redundant signal.h header includes.
>>
>> signal(2) also says:
>>
>>>         * By  default, in glibc 2 and later, the signal() wrapper
>>> function does not invoke the kernel system call.  Instead,  it
>>> calls  sigaction(2) using flags that supply BSD semantics.  This
>>> default behavior is pro‐ vided  as  long  as  a  suitable  feature
>>> test  macro  is   defined: _BSD_SOURCE  on  glibc  2.19  and
>>> earlier or _DEFAULT_SOURCE in glibc 2.19 and later.  (By default,
>>> these  macros  are  defined;  see  fea‐ ture_test_macros(7)  for
>>> details.)   If such a feature test macro is not defined, then
>>> signal() provides System V semantics.
>>
>> Does that mean, it should still be replaced?

> Both ways are correct. signal() is not deprecated but the behavior may
> vary. It can be avoided by sigaction(), so it is better to use
> sigaction() then. Do you agree?

I am not experienced enough to comment on this. But I am fine with this, 
if you could rephrase that in the commit message.


Kind regards,

Paul
