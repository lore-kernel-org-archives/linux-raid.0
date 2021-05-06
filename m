Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=BAYES_05,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF1FC433B4
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 11:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7065961164
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 11:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhEFLHr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 07:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbhEFLHq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 07:07:46 -0400
X-Greylist: delayed 1481 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 06 May 2021 04:06:47 PDT
Received: from sabi.co.uk (unknown [IPv6:2002:b911:ff1d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7FAC061574
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 04:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sabi.co.uk;
         s=dkim-00; h=From:References:In-Reply-To:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=E5CNNHh4wTVVOqiXM5f5XDh+AZtppUJoKel/RISRqG0=; b=HyPMYM9DbObts5uOhzhGsiZJNq
        rUjoH9LvsoMBJS89YaI4WX5BKaXc0LxNsuPR1dEua7HkGqFNMgOKc7wlzM2Mc3WSy0OO45DdE4CwH
        is4AUKFdZvlvG8XwDajHm5iKUp/qGQc8o8Y6T+N2Ljq0sz/gC/pXGmQ3Nh9OXR3UbC95Q8cPAZ2oF
        +H08HJTtVNgy88hHQnL9mmG6OvZy4V19DTJjUsyTfT8oJ7+8560mD1e/pkyxrpVxvKIw7jAIWD48j
        F1wfqtShO32sZEThVS7FNbz5n3RUmnpWyGyv0dgH4DSVXB0a6k9IF+zefnxVy3NTTstrhl8KKfuru
        z6AK9hPQ==;
Received: from b2b-37-24-20-172.unitymedia.biz ([37.24.20.172] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1lebSG-000GhD-Cu   id 1lebSG-000GhD-Cuby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 10:42:04 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1lebPy-006DRS-St
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 12:39:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24723.51054.790726.700995@cyme.ty.sabi.co.uk>
Date:   Thu, 6 May 2021 12:39:42 +0200
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: raid10 redundancy
In-Reply-To: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.uk (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>> On Thu, 6 May 2021 13:09:53 +0800, d tbsky <tbskyd@gmail.com> said:

> Hi: I am curious about raid10 redundancy when created with
> disk numbers below: [...]

This looks like a "homework" question... There are a lot of
pages on the WWW that explain that in summary and detail, and
the shortest is: RAID10 only loses data if all devices that
compose one of mirror set become impaired at the same block
addresses.

More in detail I have written some posts that explain the
tradeoffs involved, they seem to be widely "misunderestimated":

https://sabi.co.uk/blog/13-one.html?130117#130117
"Comparing the resilience of RAID6 and RAID 10"

http://www.sabi.co.uk/blog/12-two.html?120218#120218
"When double parity may make some sense"
