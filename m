Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630C8C6FA86
	for <linux-raid@archiver.kernel.org>; Tue,  6 Sep 2022 13:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240447AbiIFNUZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Sep 2022 09:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240405AbiIFNUL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Sep 2022 09:20:11 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484F72613E
        for <linux-raid@vger.kernel.org>; Tue,  6 Sep 2022 06:20:06 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5A13961EA192A;
        Tue,  6 Sep 2022 15:20:03 +0200 (CEST)
Message-ID: <8c81bb5e-dd0d-3454-f0e9-fe0f14d6d4fd@molgen.mpg.de>
Date:   Tue, 6 Sep 2022 15:20:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 1/2] mdadm: systemd services adjustments
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, colyli@suse.de, linux-raid@vger.kernel.org,
        felix.lechner@lease-up.com
References: <20220906125932.15214-1-mariusz.tkaczyk@linux.intel.com>
 <20220906125932.15214-2-mariusz.tkaczyk@linux.intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220906125932.15214-2-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Mariusz,


Thank you for the patches. Maybe use the summary/subject/title below:

mdadm: Add Documentation entries to systemd services


Kind regards,

Paul
