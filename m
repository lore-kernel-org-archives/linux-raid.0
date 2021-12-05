Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8128C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  5 Dec 2021 13:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhLENoG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 5 Dec 2021 08:44:06 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35310 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhLENoF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 5 Dec 2021 08:44:05 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A71C5212FE;
        Sun,  5 Dec 2021 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638711637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=47XOffwOhxLvp2hcUyNKzTL4rLYx75c+SmDKwQOPW2U=;
        b=pFiXG/oIZ5KX6R5MFl3c1oItNldDqUM6qIVmQDPkbCVoweaBG+F6FrZMXGxPSuWDAgXm6T
        ECzndoG9QK/VNHu2zEDoMY+CboPesN56GJSO9nfghs/7ksCocooka4xUphyA95+ClgiUQ0
        W2yv+MYqmbFHC/hv+cQk4tp1HVh8Ay0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638711637;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=47XOffwOhxLvp2hcUyNKzTL4rLYx75c+SmDKwQOPW2U=;
        b=qtGaA+yxW0ybUnectFrDGZz8xKNBu5ZtMtRRqW7KFp2wSKvoNmKSQRjYH70opuF/wD58Pt
        nvlHn2YmnQqhChCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DA13413466;
        Sun,  5 Dec 2021 13:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6+EJKlTBrGEyewAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 05 Dec 2021 13:40:36 +0000
Message-ID: <39624b30-e1ae-eb90-501e-86ad8b842199@suse.de>
Date:   Sun, 5 Dec 2021 21:40:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: mdadm last call for 4.2
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>
References: <9508576c-ef82-253b-1e5e-37c7d2f39aad@trained-monkey.org>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <9508576c-ef82-253b-1e5e-37c7d2f39aad@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/21 8:09 PM, Jes Sorensen wrote:
> Hi,
>
> Any last minute serious bugfixes needed for 4.2?
>

Hi Jes,

Could you please take this one for 4.2?  Thanks.

https://lore.kernel.org/linux-raid/20210902073220.19177-1-colyli@suse.de/

Coly Li
