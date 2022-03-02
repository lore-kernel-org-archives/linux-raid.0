Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27829C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  2 Mar 2022 07:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiCBH1l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Mar 2022 02:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239799AbiCBH1k (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Mar 2022 02:27:40 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1377B5608
        for <linux-raid@vger.kernel.org>; Tue,  1 Mar 2022 23:26:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7D2F7210EF
        for <linux-raid@vger.kernel.org>; Wed,  2 Mar 2022 07:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646206016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rPGOQM2cvzQH6RRI4QfuY/W095T6jPieCsAIQhBOpDU=;
        b=xufNIZlDv7w0Y2sTYoDpth8m9U99wxG72v8CJuu1BbbquGd7R5imqcNuy2nxkHUTsy6nYQ
        6KJjap2iZaZkiqtOnRQ5fr/Hp2rdAnuPBAIqbFSzDMm/ABClNk/sWUwOGwRg/ZhCP+RmAS
        tp9rGoJZzYcHK6G9E6J6nz4pI3MGuKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646206016;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rPGOQM2cvzQH6RRI4QfuY/W095T6jPieCsAIQhBOpDU=;
        b=x2qnX/0MZcQqIeRC+AFY+0fWciEaE4CbS+ERGdf5wuqNfH4B5ReUAki9qcx2sf7yRWoLVa
        DUqUKMmZPZ4A9aAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D624F13345
        for <linux-raid@vger.kernel.org>; Wed,  2 Mar 2022 07:26:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LftbHz8cH2LJLwAAMHmgww
        (envelope-from <colyli@suse.de>)
        for <linux-raid@vger.kernel.org>; Wed, 02 Mar 2022 07:26:55 +0000
Message-ID: <49e78e8f-080e-9c62-4cd6-6fcf902dcb7e@suse.de>
Date:   Wed, 2 Mar 2022 15:26:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
To:     linux-raid <linux-raid@vger.kernel.org>
From:   Coly Li <colyli@suse.de>
Subject: mdadm clone for continuous integration
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes, and other mdadm and md raid developers,


In order to help Jes to miantain mdadm more convenient, I decide to 
spend my time on the code review and integration testing, to (try my 
best to) help the Jes' maintenance process to be faster.

The current plan is, all mdadm patches posted on 
linux-raid@vger.kenrel.org, will be applied on a mdadm clone, and some 
simple testing will be performed on the patches, e.g. compiling and 
basic md raid operation. If problem detected, a warning will be sent to 
the patch author. And further more, I will start to help to review the 
patches. I am not very familiar with mdadm code yet, so at the first one 
or two years, review might be slow, but it can be faster and faster 
while I get more familiar with the code. And of course I will ask help 
to the patch author to learn how/why the patch is formed in its way.


After all the process accomplished, I will apply the reviewed/tested 
patches to be branch maybe named for-jes, against the latest upstream 
mdadm tree. Then Jes may avoid to spend his valuable time on simple 
problems.


The mdadm clone for continuous integration can be found on,

https://git.kernel.org/pub/scm/linux/kernel/git/colyli/mdadm.git/


You don't need to do anything, I just fetch all patches on mailing list 
and handle them and let you know the result. The result is a reference 
or Jes' maintenance work.

Let me start it from scratch now, and see how it goes after next 2 or 3 
years. Thank you all in advance, for all necessary help in future.


Coly Li

