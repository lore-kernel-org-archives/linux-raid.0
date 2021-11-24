Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F584C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 15:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346986AbhKXP6U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 10:58:20 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17206 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241748AbhKXP6T (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Nov 2021 10:58:19 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637769302; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=R6+ynpwTs+miQHPkfRWjTT7EifQPj/Xuk4ZU/w/Z9rzuxy4aArmUVgOnjjeP2HdNCu+WxuJqd2nWPTTKkYsGh/2fp+HNnqukgVhHpHq/gfDqyT2uZcB0dJAgLCP0/Yl7fWSPKdTEeiUTyWoKxHFlMEKeV7Mq+tK5tiNhnuVdYWs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637769302; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qHNAFQVA/qzQkt4HK40T/jTeyqNl71DFFOL/336sgkM=; 
        b=Dwbu/ZSLAwLmwO8Rw6+eh4puoN+aPGOcsaRSKTD5zWkCoeV4j0rI21BJZx05kge/Kj4xkH5tZIWDKiZCgq/2axtueqaMjZ9d7rrMwq7aWURvTXdT4my/6WbUWiv5A6Jo6kFSYZv4aPDd6jPW3bcCBjwbR9EruqTnaIHrEeOxmUQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [IPV6:2607:fb90:e821:2e9:aeed:11b0:b175:8954] (172.58.229.207 [172.58.229.207]) by mx.zoho.eu
        with SMTPS id 1637769299181876.7039546614966; Wed, 24 Nov 2021 16:54:59 +0100 (CET)
Date:   Wed, 24 Nov 2021 10:54:54 -0500
From:   jes@trained-monkey.org
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Message-ID: <285f7faf-c40e-4484-9256-8732f07c7335.maildroid@localhost>
In-Reply-To: <7A27EF9C-0844-4ED5-9C07-F0BAE9EDBD72@getmailspring.com>
References: <9508576c-ef82-253b-1e5e-37c7d2f39aad@trained-monkey.org>
 <7A27EF9C-0844-4ED5-9C07-F0BAE9EDBD72@getmailspring.com>
Subject: Re: mdadm last call for 4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: MailDroid/5.11 (Android 11)
User-Agent: MailDroid/5.11 (Android 11)
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sure, let me know when you're ready.

Jes

Sent from MailDroid

-----Original Message-----
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Jes Sorensen <jes@trained-monkey.org>
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Sent: Wed, 24 Nov 2021 10:47
Subject: Re: mdadm last call for 4.2


Hi Jes,

> Any last minute serious bugfixes needed for 4.2?
Yes, there is one. We are valdating name length limitation to
prevent buffer overflows in create_mddev().
Could you wait for it?

Thanks,
Mariusz

