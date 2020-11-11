Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3F0C56202
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 11:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF454206FB
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 11:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgKKLqR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 06:46:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52053 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgKKLpm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Nov 2020 06:45:42 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kcoZG-0006zC-DA; Wed, 11 Nov 2020 11:45:38 +0000
From:   Colin Ian King <colin.king@canonical.com>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: re: dm: rename multipath path selector source files to have "dm-ps"
 prefix
Message-ID: <c5c17cba-3bf2-ce07-ed7f-6e5b5e71427c@canonical.com>
Date:   Wed, 11 Nov 2020 11:45:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Static analysis on linux-next has detected an initialized variable issue
with the following recent commit:

commit 28784347451fdbf4671ba97018f816041ba2306a
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Tue Nov 10 13:41:53 2020 -0500

    dm: rename multipath path selector source files to have "dm-ps" prefix

The analysis is as follows:

 43
static int ioa_add_path(struct path_selector *ps, struct dm_path *path,
 44                        int argc, char **argv, char **error)
 45 {
 46        struct selector *s = ps->context;
 47        struct path_info *pi = NULL;
   1. var_decl: Declaring variable cpu without initializer.

 48        unsigned int cpu;
 49        int ret;
 50
   2. Condition argc != 1, taking false branch.

 51        if (argc != 1) {
 52                *error = "io-affinity ps: invalid number of arguments";
 53                return -EINVAL;
 54        }
 55

   Uninitialized scalar variable (UNINIT)
   3. uninit_use_in_call: Using uninitialized value cpu when calling
__cpu_to_node.

 56        pi = kzalloc_node(sizeof(*pi), GFP_KERNEL, cpu_to_node(cpu));
 57        if (!pi) {
 58                *error = "io-affinity ps: Error allocating path context";
 59                return -ENOMEM;
 60        }

Colin
