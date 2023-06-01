Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0658C7EE23
	for <linux-raid@archiver.kernel.org>; Thu,  1 Jun 2023 08:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjFAI6m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Jun 2023 04:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbjFAI6l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Jun 2023 04:58:41 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29694119
        for <linux-raid@vger.kernel.org>; Thu,  1 Jun 2023 01:58:38 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D8D0561EA1BFF;
        Thu,  1 Jun 2023 10:57:47 +0200 (CEST)
Message-ID: <e9001902-22aa-0b87-5201-d590738d450d@molgen.mpg.de>
Date:   Thu, 1 Jun 2023 10:57:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 0/6] mdadm: POSIX portable naming rules
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org, colyli@suse.de
References: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Mariusz,


Am 01.06.23 um 09:27 schrieb Mariusz Tkaczyk:

> To avoid problem with udev and VROC UEFI driver I developed stronger
> naming policy, basing on POSIX portable names standard. Verification is

s/basing/based/

> added for names and config entries. In case of an issue, user can update
> name to make it compatible (for IMSM and native).

What is the VROC UEFI driver, and what is the problem exactly to risk 
regressions on the user side? Why can’t the UEFI driver be fixed?


Kind regards,

Paul


> The changes here may cause /dev/md/ link will be different than before
> mdadm update. To make any of that happen user need to use unusual naming
> convention, like:
> - special, non standard signs like, $,%,&,* or space.
> - '-' used as first sign.
> - locals.
> 
> Note: I didn't analyze configurations with "names=1". If name cannot be
> determined mdadm should fallback to default numbered dev creation.
> 
> If you are planning release soon then feel free to merge it after the
> release. It is a potential regression point.
> 
> It is a new version of [1] but it is strongly rebuild. Here is a list
> of changes:
> 1. negative and positive test scenarios for both create and config
>     entries are added.
> 2. Save parsed parameters in dedicated structs. It is a way to control
>     what is parsed, assuming that we should use dedicated set_* function.
> 3. Verification for config entries is added.
> 5. Improved error logging for names:
>     - during creation, these messages are errors, printed to stderr.
>     - for config entries, messages are just a warnings printed to stdout.
> 6. Error messages reworked.
> 7. Updates in manual.
> 
> [1] https://lore.kernel.org/linux-raid/20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com/
> 
> Mariusz Tkaczyk (6):
>    tests: create names_template
>    tests: create 00confnames
>    mdadm: set ident.devname if applicable
>    mdadm: refactor ident->name handling
>    mdadm: define ident_set_devname()
>    mdadm: Follow POSIX Portable Character Set
> 
>   Build.c                        |  21 ++--
>   Create.c                       |  35 +++----
>   Detail.c                       |  17 ++-
>   config.c                       | 184 +++++++++++++++++++++++++++------
>   lib.c                          |  76 +++++++++++---
>   mdadm.8.in                     |  70 ++++++-------
>   mdadm.c                        |  73 +++++--------
>   mdadm.conf.5.in                |   4 -
>   mdadm.h                        |  36 ++++---
>   super-intel.c                  |  47 +++++----
>   tests/00confnames              | 107 +++++++++++++++++++
>   tests/00createnames            |  89 ++++------------
>   tests/templates/names_template |  80 ++++++++++++++
>   13 files changed, 551 insertions(+), 288 deletions(-)
>   create mode 100644 tests/00confnames
>   create mode 100644 tests/templates/names_template
> 
