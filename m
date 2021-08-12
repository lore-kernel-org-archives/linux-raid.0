Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F71AC4320A
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 17:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53BE760FBF
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 17:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbhHLRJa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:09:30 -0400
Received: from sonic312-30.consmr.mail.ne1.yahoo.com ([66.163.191.211]:44368
        "EHLO sonic312-30.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235208AbhHLRJ1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 12 Aug 2021 13:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628788141; bh=MPkMokadUtlt7BPo+kdIh/oTQNmXWdJk/oeYXYYNVjc=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=TjrMKruPNVpm2dwgNAFJWGfal1QRLZJpvF96a9ocBkAWNdRzCT/QTSUme77+0TYgnH+XOM2YoJbFQO2Tkn+BtLEsi/d3jKtQ9C+5KcJuuyDEcjcGCaC49R9P7/mXAsR+N7T91GyJb6gV8kLO1obhPlXMX16NxMHjEtmMetxUyYYOAcQ4INJXM2cbKj/lieKV5tdwQkRc7FMS21OiLCaaXV/R9CfjS1OaADcq1jJayfJt7XF+F9UtAGJfiUKaPz7jtH8qZFkMZC/n5WBLV1UFj85LfWAUlBGnITHj21SgazRkbp5J1/fX5e/g+2ckPP1oe/4tTJzIxH0tFpDj0BQlEw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628788141; bh=bD1u7qZyjxNI6oC66GkouLUBEeHzvM4X3olAQNxNYsV=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=s0J3SolGnGBALDzhIOBOoZtM4uFYhcNkP363WfF0r1Y8EUTgRWanR46ZbsOLRbLDKba4NU7h20jraaJjoOtvZqQvR/9rQVtSxRYpibJP2UVBVYjfs/OOilCjKZuS3ttFbV6i38O2DopJC0BRirPLlB7uAo7GF4oXhGLLz/fKrSteeeV7mC4xmLXjV5v5nRmMrUvC6MjeWa9kUL7w/48n/qZvtU6mQHPezTS3Xo1HzTkYD9UtAplvQ1Joagt2L63ELlYC3V4qNTdN81wVyJrxqKiyjtONDsqNIac++sZK31whWvK1bQwuwsmvwgLAj/5dIYYM0i+ELNZm9YdrwPm4cA==
X-YMail-OSG: bmKXqYkVM1nPizAch13WDyxi8nc5xfURzIfDwiQisuXPBONxaf7.bUI8_qQZhB0
 NnjwczRVJGWqqsWDqPsx0wkQ7eUFON7LsGfpqyQspyGyYBcZzKzSkA4MiEHK64issjAVPzyA2voS
 G7U8u0A8mWg1iNbrcJKrAZF_B4YCCemIy1tECUqD9jM8ZRpM3soRce..zJjtp46tElGApcgJYsDQ
 J9BzDQdXVTEFnMF15laT0WHgDIiKC8llJLrl9InvQcJwr4yD3vHV2VKM6KJfaYZiRa18tkJTzSLU
 o73C5QXo0qdIdxI_yMtY1_uRh24ufUGL4tJ3rRTOm6V00Zi2VEql9ZiD1KhBJcskroeWztBYKrWm
 .kwAcnCkq0LKlHnRswzmpL.ot.SDYacUKRX0Ui5pFOVV61uB1J5gCUhvzrFGFa7mzZFWeng0miZE
 wXk8TgCmxWTkDXEuVhJI5fn0s.2GsBVDl8Ty.8rNBlSfbEHQ0awLwDY9TKbraJ3vz27vpc1SwFZt
 RYO_0A83BGhmS9zxq5icJvpnJXsb.yyL8phlhVccCJFrkRk3xfzMGBR0FrWuTMjEVQ4u.rfB_ZbW
 6Mb8Jxswlu8xIntJMVz3_WX5zRjgfHRBT75gTNxl13HQ_C5pMPsi3TEnwlV5gMUkAmGftM.2HTto
 .qJfNp97nC7Qy_h94PjT3xRe6EI08cKuUX5ORKRmPuNqEJk.fCTJETrcADcGdTlP7KZOdMqgYdIt
 T0nV6i7SGGPBfxdDyXnPRDp8INKKkhmYoA1EFuku06h4Aou.GU6n3RuNic4tg6L7ZGxgLnp2IVvi
 sYEij17xd.kotl94gDp8cD9LtjwANgPKQ5Z_NnB8J8r5ECk_hmrTZt5QggH24X9FrZ.tJmPJOQBO
 q6NjV.1PYd71Luh8pgguNULxCcBDa7WgaFd9ryyYUVd9UlR.on_jc6H.aXgZq4wVR59G5fhpjj6a
 ck_FnEdenrR.ySTqZj7W0fD1ufQrDCVhkpBn6JdMmWW9QcmsV7F_MhsBI2z6XW57QpLO1nWN71Lj
 IzqRT3J0Y2drogDOYWlWcpl_hqKt4Bk4hAgzvpWgByN.t8dldn.CKvSBSb7IkBhAXeW8vooqedBe
 MkcnGtAJzN2feluONF_kEeCbqhK7MCaU2Jh94HHHLfhXzY9.DeEPxo5G_JJGq3qYxBxtKWRU.nlq
 5fChPPws.8RkHfz9oPULOPu.ESDLoX1KmHxN9ir9hhkHNfnswB.54ImVLuAeagnnmgtGW3Oqeqxw
 B73m6r5KYYLzOwaMrByuCuZ0gLesw0OY3aR8L9pV9Khvkjlt_xy7hyXdZO.KFtlfbALiiBMyqxUN
 cO25TfTwJvdnjD40oMFcf0kOgmXmfgV_2YUE8hCsd0AnGi1ok9XpqYWBIyfQ2FhtLTZ0Yhjv3B0R
 CUguMFstaAHoeTSnLAwIr0fZCvsWBInY2LGpvFK6NNdeZ0NSpFVQJC0nn0rfHCZ.beeFhqfHOaqR
 7bg.XxLfx4PB_gxsAE5CQ3ulappT.nBn0KR.0oNKNr9mbsvsEZCYY7cWaaCcR.ImZEFRe0mCzlzh
 7.jTOwPNo92JC3WvDIEX3EIVgFEybu_N63WX1vM.19l6GBi.ZS6BTv_w2G0DCKLIJv2pfQYfyO8Z
 6AhpmEe5NP05z441WUQxwRx2sVQD1fqlNLUVNEqn4rZJBY8kz.MfOWmztza6QL61cjjJwtC8zcXZ
 NEipD.x1im8We4_5kis2GwUDZsDF2aVov7SnxYpna0jXv5VOCfAbYr05km0Sa4z0.KNTr.65WosE
 iF46XW.KJlREMqXTme.ua5Uz6rP2ajRYC._3.VFlnoDv0a_1zlpDQDmaHKb2zbO27co9Oq3lZvih
 5QGMkPbwohyu3SunErCO6HV1s29YGeeIon39fbqnByeWZnjLO6gPQwbWt3yFWSFmEXyRaXZYdrLS
 DZX5YrHrJXjMPCXx9PNLkvK1_1pKSp3y_5hk.GCgdhHik6swEvRVy6e4ZVovnEnrvmX0YcU9Q2GN
 fDGcwtUY8m5CtoqWHwnCoS9zkS4AGg_lbp.kaZE7.o5i9HZJHwx0kLu_i6iPLhwD0F346HUQHnt2
 wKip7.vhkOxtru1ZmxblwI5e1gr_.p5_NQI2JU9TZ5e0kfgdhOV2B67wt_SpUxbPpyB4eO4yEPhh
 C2wCrx85rore.hjJ5b2XV6RoKKysvrT_3PWohyIO0PBAz9lYfaIqss48SB4NKpaKsi__hDL1XrJN
 t5cTPsfWn_l6I2RbfBGQcgztbsBdfZsVaabFdaP8kG2xdcVrlkiVuzDlr_MLx7tN9_2TImzP9oDl
 6etr5CHonnrOnCVih9kFaZ3eO31vdMXknxx5vNP8U9S38vYi3fHN9g9LKPH98FBqNfoFPhVLlj5x
 t6evg1LBNZ3Qme7r.uXDNEYgvxXfVpNdUynvA7j5IXa95qhLiaVCSIfK8aaIoYmqVMT.cGemQnEK
 QfRrldQPL0l9Nu7iagyKu43IY0giWVNqsc.bUtlo7a.HBoWeoh6ER.Cm7HaGk_Myh0mdiYUiD1rU
 89yrpppayomGi0xaI9xO9plQ.rjW_JcFWE5MYh4o9FLL4aO9BwtXekZCPMATlHPTlpEd4eCzC.46
 3OSX2tUSUBEH_nNdZ0O6dQYpJzbp84H0H3jZsX.WxHKuruF3XdiRzNRtUgbyWEZkPwsX51Qclx_X
 529QJE1VuX_SSA7lo5LFTju2SjzAAh9ILJC60TjfQlLjpima21hdARmdDEwZZ2oIWXXLU5h6ivpp
 wQ_QQnJ5OlhdrHPAH9SmsqWpqA47TIeloL5vrDj4SAVbu_HeRQ332zhEHnqySPcD00eGfaQQArZ1
 NMeGFt7rF1K3aERfxNpzp4ILrND3CIgZohY1uK05OPmiIw9WpSJMRVw8L8tjAiAW7JmzYO2beJKH
 hx9_3nYDes0RL8GCwskYklk5NneQpGR9Yz3fWQhSBBXeofDTpN5a_Zx12pzeY0b2JUUmILuSsbF7
 kXDJ6mbFmFlYIIuzxBY8iwVR10dy99C2_cyi2XxY6wkA_tet9
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Thu, 12 Aug 2021 17:09:01 +0000
Received: by kubenode543.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 707acea1e4460935a4d453e12698b33c;
          Thu, 12 Aug 2021 17:08:58 +0000 (UTC)
Subject: Re: [PATCH 1/3] dm: introduce audit event module for device mapper
To:     =?UTF-8?Q?Michael_Wei=c3=9f?= <michael.weiss@aisec.fraunhofer.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-audit@redhat.com, Alasdair Kergon <agk@redhat.com>
References: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
 <20210812145748.4460-2-michael.weiss@aisec.fraunhofer.de>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <7f28b3b4-c0a2-cb03-09fd-e0705959576a@schaufler-ca.com>
Date:   Thu, 12 Aug 2021 10:08:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210812145748.4460-2-michael.weiss@aisec.fraunhofer.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Mailer: WebService/1.1.18850 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/12/2021 7:57 AM, Michael Weiß wrote:
> To be able to send auditing events to user space, we introduce
> a generic dm-audit module. It provides helper functions to emit
> audit events through the kernel audit subsystem. We claim the
> AUDIT_DM type=1336 out of the audit event messages range in the
> corresponding userspace api in 'include/uapi/linux/audit.h' for
> those events.
>
> Following commits to device mapper targets actually will make
> use of this to emit those events in relevant cases.
>
> Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
> ---
>  drivers/md/Kconfig         | 10 +++++++
>  drivers/md/Makefile        |  4 +++
>  drivers/md/dm-audit.c      | 59 ++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-audit.h      | 33 +++++++++++++++++++++
>  include/uapi/linux/audit.h |  2 ++
>  5 files changed, 108 insertions(+)
>  create mode 100644 drivers/md/dm-audit.c
>  create mode 100644 drivers/md/dm-audit.h
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 0602e82a9516..fd54c713a03e 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -608,6 +608,7 @@ config DM_INTEGRITY
>  	select CRYPTO
>  	select CRYPTO_SKCIPHER
>  	select ASYNC_XOR
> +	select DM_AUDIT if AUDIT
>  	help
>  	  This device-mapper target emulates a block device that has
>  	  additional per-sector tags that can be used for storing
> @@ -640,4 +641,13 @@ config DM_ZONED
>  
>  	  If unsure, say N.
>  
> +config DM_AUDIT
> +	bool "DM audit events"
> +	depends on AUDIT
> +	help
> +	  Generate audit events for device-mapper.
> +
> +	  Enables audit loging of several security relevant events in the

s/loging/logging/

> +	  particular device-mapper targets, especially the integrity target.
> +
>  endif # MD
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index a74aaf8b1445..4cd47623c742 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -103,3 +103,7 @@ endif
>  ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
>  dm-verity-objs			+= dm-verity-verify-sig.o
>  endif
> +
> +ifeq ($(CONFIG_DM_AUDIT),y)
> +dm-mod-objs				+= dm-audit.o
> +endif
> diff --git a/drivers/md/dm-audit.c b/drivers/md/dm-audit.c
> new file mode 100644
> index 000000000000..c7e5824821bb
> --- /dev/null
> +++ b/drivers/md/dm-audit.c
> @@ -0,0 +1,59 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Creating audit records for mapped devices.
> + *
> + * Copyright (C) 2021 Fraunhofer AISEC. All rights reserved.
> + *
> + * Authors: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
> + */
> +
> +#include <linux/audit.h>
> +#include <linux/module.h>
> +#include <linux/device-mapper.h>
> +#include <linux/bio.h>
> +#include <linux/blkdev.h>
> +
> +#include "dm-audit.h"
> +#include "dm-core.h"
> +
> +void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
> +		      struct bio *bio, sector_t sector, int result)
> +{
> +	struct audit_buffer *ab;
> +
> +	if (audit_enabled == AUDIT_OFF)
> +		return;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_DM);
> +	if (unlikely(!ab))
> +		return;
> +
> +	audit_log_format(ab, "module=%s dev=%d:%d op=%s sector=%llu res=%d",
> +			 dm_msg_prefix, MAJOR(bio->bi_bdev->bd_dev),
> +			 MINOR(bio->bi_bdev->bd_dev), op, sector, result);
> +	audit_log_end(ab);
> +}
> +EXPORT_SYMBOL_GPL(dm_audit_log_bio);
> +
> +void dm_audit_log_target(const char *dm_msg_prefix, const char *op,
> +			 struct dm_target *ti, int result)
> +{
> +	struct audit_buffer *ab;
> +	struct mapped_device *md = dm_table_get_md(ti->table);
> +
> +	if (audit_enabled == AUDIT_OFF)
> +		return;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_DM);
> +	if (unlikely(!ab))
> +		return;
> +
> +	audit_log_format(ab, "module=%s dev=%s op=%s",
> +			 dm_msg_prefix, dm_device_name(md), op);
> +
> +	if (!result && !strcmp("ctr", op))
> +		audit_log_format(ab, " error_msg='%s'", ti->error);
> +	audit_log_format(ab, " res=%d", result);
> +	audit_log_end(ab);
> +}
> +EXPORT_SYMBOL_GPL(dm_audit_log_target);
> diff --git a/drivers/md/dm-audit.h b/drivers/md/dm-audit.h
> new file mode 100644
> index 000000000000..9db4955d32e1
> --- /dev/null
> +++ b/drivers/md/dm-audit.h
> @@ -0,0 +1,33 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Creating audit records for mapped devices.
> + *
> + * Copyright (C) 2021 Fraunhofer AISEC. All rights reserved.
> + *
> + * Authors: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
> + */
> +
> +#ifndef DM_AUDIT_H
> +#define DM_AUDIT_H
> +
> +#include <linux/device-mapper.h>
> +
> +#ifdef CONFIG_DM_AUDIT
> +void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
> +		      struct bio *bio, sector_t sector, int result);
> +void dm_audit_log_target(const char *dm_msg_prefix, const char *op,
> +			 struct dm_target *ti, int result);
> +#else
> +static inline void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
> +				    struct bio *bio, sector_t sector,
> +				    int result);
> +{
> +}
> +static inline void dm_audit_log_target(const char *dm_msg_prefix,
> +				       const char *op, struct dm_target *ti,
> +				       int result);
> +{
> +}
> +#endif
> +
> +#endif
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index daa481729e9b..9d766fcbcf62 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -118,6 +118,7 @@
>  #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
>  #define AUDIT_BPF		1334	/* BPF subsystem */
>  #define AUDIT_EVENT_LISTENER	1335	/* Task joined multicast read socket */
> +#define AUDIT_DM		1336	/* Device Mapper events */
>  
>  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> @@ -140,6 +141,7 @@
>  #define AUDIT_MAC_CALIPSO_ADD	1418	/* NetLabel: add CALIPSO DOI entry */
>  #define AUDIT_MAC_CALIPSO_DEL	1419	/* NetLabel: del CALIPSO DOI entry */
>  
> +

Unnecessary additional whitespace.

>  #define AUDIT_FIRST_KERN_ANOM_MSG   1700
>  #define AUDIT_LAST_KERN_ANOM_MSG    1799
>  #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
