Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB36C00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 22:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344691AbiHRWAw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 18:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiHRWAv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 18:00:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E1CD11FD
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 15:00:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7253D5C4A0;
        Thu, 18 Aug 2022 22:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660860049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BMqDMC7tETwjQCI+sLGK6JQTvDP+hE4jqHQyD+MUQRE=;
        b=ha6/1Yp0Qb4ZvkKSm1rz+xgnj5iIEvyZ7vJReMwbRzSQl8zAfLcOtDRAI7LjnnjKaX/Y13
        u1z/leN+CAbT5wLfeamJMZTLBwbMe9HqaPALStpq6fhm09WBEgL7uZOV5nucOxFZhNOXuZ
        D1JDrRlxcGi5RfPcO8lLvf/cU2eS8II=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 31BDF133B5;
        Thu, 18 Aug 2022 22:00:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4p2cCpG2/mKzHwAAMHmgww
        (envelope-from <mkoutny@suse.com>); Thu, 18 Aug 2022 22:00:49 +0000
Date:   Fri, 19 Aug 2022 00:00:47 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org, Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <Yv62jwZwp7kNPSUF@blackbook>
References: <20220215133415.4138-1-colyli@suse.de>
 <20220728095535.00007b7b@linux.intel.com>
 <165905971898.4359.3905352912598347760@noble.neil.brown.name>
 <20220802174305.00000336@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802174305.00000336@linux.intel.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello.

(Coming via
https://lists.freedesktop.org/archives/systemd-devel/2022-August/048201.html.)

On Tue, Aug 02, 2022 at 05:43:05PM +0200, Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/udev-md-raid-arrays.rules#n41
> but i can't find wants dependency in:
> #systemctl show dev-md126.service
> #systemctl show dev-md127.service

Typo here

s/service/device/

But the Wants dependency won't help with shutdown ordering.

> I got:
> systemd[1]: /usr/lib/systemd/system/mdmon@.service:11: Failed to resolve unit
> specifiers in 'dev-%I.device', ignoring: Invalid slot

What was your exact directive in service unit file and what was the
template parameter?
(This may not work though, since there'd be no stop job for .device unit
during shutdown to order against. (not tested))

> Probably it tries to umount every exiting .mount unit, i didn't check deeply.
> https://www.freedesktop.org/software/systemd/man/systemd.mount.html
> 
> I can see that we can define something for .mount units so I tried both:
> # mount -o x-systemd.after=mdmon@md127.service /dev/mapper/vg0-lvm_raid /mnt
> # mount -o x-systemd.requires=mdmon@md127.service /dev/mapper/vg0-lvm_raid /mnt
> 
> but I doesn't help either. I seems that it is ignored because I cannot find
> mdmon dependency in systemctl show output for mnt.mount unit.

These x-* options are parsed from fstab. If you mount manually like
this, systemd won't learn about these non-kernel options (they don't get
through /proc/mountinfo).

Actually, I think if you add the .mount:After=mdmon@....service
(via fstab), it should properly order the stop of mdmon after the
particular unmount during shutdown. 

HTH,
Michal
