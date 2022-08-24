Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5820FC32793
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 12:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbiHXMDb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 08:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236223AbiHXMDa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 08:03:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B60F5B074
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 05:03:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 456B133D5B;
        Wed, 24 Aug 2022 12:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661342607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=onW2ocuP/+mpNGWmP1kQDm1MP5EAMEVHbWd9ZNBWIAA=;
        b=ckG5XyB1Y0QhJ9rFd5h/y2MQZ50sGXw16m4HzoTQ+tjE4jbX/wgObr3fPuzM7q93kUSCJw
        q1fBSG5xGuMLk1YNDefrzOMwyppqHVxbxwiTFcxoz21G2ycSxH+tljdZzmG7sJ5I4I+e+N
        OFNqTqhU33rTiasFlL6TyRVVzmdnunY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 15F2613AC0;
        Wed, 24 Aug 2022 12:03:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id x5pPBI8TBmPuRQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 24 Aug 2022 12:03:27 +0000
Date:   Wed, 24 Aug 2022 14:03:25 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <20220824120325.GA19154@blackbody.suse.cz>
References: <20220215133415.4138-1-colyli@suse.de>
 <20220728095535.00007b7b@linux.intel.com>
 <165905971898.4359.3905352912598347760@noble.neil.brown.name>
 <20220802174305.00000336@linux.intel.com>
 <Yv62jwZwp7kNPSUF@blackbook>
 <20220824115239.00004ac4@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824115239.00004ac4@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 24, 2022 at 11:52:39AM +0200, Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
> I removed those setting but it was something like:
> 
> Before=initrd-switch-root.target dev-%I.device
> 
> I can test more if you have suggestions.

Sorry, I realize it won't work, device deps are restricted [1]. (I
considered relaxing that [2] in order to terminate loop devs properly.)

> Will check but it can be considered as workaround, not as a solution. VROC
> arrays are automatically configured in installers, also users may mount them
> manually, without any additional settings (as standalone disk). We need to
> resolve it globally.

It's not the only setup when a device requires a userspace daemon.
There is a generic solution for root devices [3] (when the daemon is
marked to run indefinitely).

The device job ordering dependencies during shutdown would need better
handling in systemd. (But I don't understand how much
mdmon@.serice is necessary for device existence and teardown.)

HTH,
Michal

[1] https://github.com/systemd/systemd/blob/98f3e84342dbb9da48ffa22bfdf122bdae4da1c6/src/core/unit.c#L3101
[2] https://github.com/Werkov/systemd/commit/bdaa49d34e78981f3535c42ec19ac0f314135c07
    (forked repo, not an upstream commit)
[3] https://systemd.io/ROOT_STORAGE_DAEMONS/
