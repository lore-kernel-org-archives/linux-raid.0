Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79F0C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 12:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbhKXMP3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 07:15:29 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17208 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242261AbhKXMNB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Nov 2021 07:13:01 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637755785; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Xx2SZO6MqhDU+q1fYY/e69wGtlixt1dp51ku6uMh15XFydUXLEDwiZhpvf2WMn8eC95+wIOLgQghra7RU4khYoUi3cgJHbk3u5UHnU0DjaZzjtK2Y99nyXQ3YWaIUDiIrmPQlLtVvNCMf4rWIrbsjgfvONdmgpQNwDWa/oRDzI0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637755785; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=n/mfiakz9ZU6gOO8TiqUocnquyPpVq3rFmgSYBwnYLo=; 
        b=Id00WBn7wYV7/q0OlyAZNVDgGbCxvFn/66aAhAk2FNMrJ6FWsbx+b+Mx3UU7qPhKEoYW7BoajT2RM4+ZxjUvNrxug1tLkgS6uOjueN7Gvb3oA1T0YEloRQEtDPa8P505VAadM6L1tYMld1hLdSgvZDKxRPmhrOmbtByyvF+VupQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1637755783556896.7484700212077; Wed, 24 Nov 2021 13:09:43 +0100 (CET)
To:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Subject: mdadm last call for 4.2
Message-ID: <9508576c-ef82-253b-1e5e-37c7d2f39aad@trained-monkey.org>
Date:   Wed, 24 Nov 2021 07:09:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Any last minute serious bugfixes needed for 4.2?

Thanks,
Jes
