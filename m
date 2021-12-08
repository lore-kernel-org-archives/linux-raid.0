Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA35AC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  8 Dec 2021 16:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhLHQ2j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Dec 2021 11:28:39 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:36560 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbhLHQ2i (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Dec 2021 11:28:38 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CE2271FD26;
        Wed,  8 Dec 2021 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638980705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYX4Y2xgjIcBc7thSXJ4z9bdUUD2UFPJg1/AU8UPimo=;
        b=uj9leJqJDwb2P0s7JWfSUfA0ApZySArXNln+cH1qUIf1ECWfCLXqMB841wbuwAFC7HH7FG
        rOIwP3RIODtI+lSj2692FZPo5vnZ9ttczeYeg+GqpmKwSEvD+6wBmWEa220ZwBZW+PHHF3
        JeRXGrv3ImLuc+yyt3ZnjDLEZ/Loi8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638980705;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYX4Y2xgjIcBc7thSXJ4z9bdUUD2UFPJg1/AU8UPimo=;
        b=A1Buw1bCCT7CZG66ZckoU+iMcWiS8N0u0th8CjkDW62SII7tuJ0AYzKOh/TIt48+i37kMU
        KzB4aW64vz1tXZAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 82DA913C9B;
        Wed,  8 Dec 2021 16:25:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7L7oHWHcsGEsbgAAMHmgww
        (envelope-from <fbui@suse.de>); Wed, 08 Dec 2021 16:25:05 +0000
Subject: Re: [PATCH] mdadm/systemd: change KillMode from none to mixed in
 service files
To:     Benjamin Brunner <bbrunner@suse.com>, Coly Li <colyli@suse.de>,
        NeilBrown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org,
        mtkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jsorensen@fb.com>
References: <20211201062245.6636-1-colyli@suse.de>
 <20211201170843.00005f69@linux.intel.com>
 <9ee380c8-e43b-8f58-c7d5-5bddb6f2e688@suse.de>
 <73287b77-33aa-a9bd-7efa-5816e098f02f@suse.com>
 <39d432ad-b451-082a-e52d-ffa32155529b@suse.de>
 <163839547917.26075.6431438000167570600@noble.neil.brown.name>
 <dabe438e-3eca-8ad4-553e-ba8555d126bd@suse.de>
 <28a04276-d338-2db5-bb3d-49616e14206b@suse.com>
From:   Franck Bui <fbui@suse.de>
Message-ID: <4db89d7a-88c1-494f-359b-359e355d9b55@suse.de>
Date:   Wed, 8 Dec 2021 17:25:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <28a04276-d338-2db5-bb3d-49616e14206b@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 12/7/21 1:34 PM, Benjamin Brunner wrote:
>>>> Please correct me if I am wrong, I see the difference of the KillMode is,
>>>> -- KillMode=mixed stops the processes more gentally, it kill the main
>>>> process with SIGTERM and the remaining processes with SIGKILL.
>>>> -- KillMode=control-group kills all in-cgroup processes with SIGKILL,
>>>> which I feel a bit cruel for the main process.

I think there's a miss-understanding here.

Regardless of whether "mixed" or "control-group" mode (or any other mode
actually) is used, the process used to kill processes part of a service is
always the same, only the list of the killed processes differs.

The process is as follow:

 1. send the signal specified by KillSignal= to the list of processes (if
    any), TERM is the default
 2. wait until either the target of process(es) exit or a timeout expires
 3. if the timeout expires send the signal specified by FinalKillSignal=,
    KILL is the default

For "control-group", all remaining processes will receive the SIGTERM signal (by
default) and if there are still processes after a period f time, they will get
the SIGKILL signal.

For "mixed", only the main process will receive the SIGTERM signal, and if there
are still processes after a period of time, all remaining processes (including
the main one) will receive the SIGKILL signal.

>>> There is no point sending SIGTERM to a process which doesn't respond to
>>> it.  mdmon is the only mdadm service which handles SIGTERM.  So it might
>>> make sense to uise KillMode=mixed for that.
>>> For anything else, SIGKILL via KillMode=control-group is perfectly
>>> acceptable.

I don't know enough mdadm to suggest a mode but maybe the clarification above
will help you figuring this out.

That said it sounds a bit strange that some processes don't respond to SIGTERM.
Is that done because some services need to run lately during the shutdown process ?

Thanks.
