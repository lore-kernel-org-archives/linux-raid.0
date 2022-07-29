Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFCAC00140
	for <linux-raid@archiver.kernel.org>; Fri, 29 Jul 2022 01:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiG2Bza (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 21:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiG2Bz2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 21:55:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992FD6582D
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 18:55:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 32AC3339F9;
        Fri, 29 Jul 2022 01:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659059724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmDUDGPpPotdkJKmgUyjLNpKCahn3163TIHv3cB6BWc=;
        b=OG4AgNZL5K9m1D66NgABN1N/jKiOEhVoSTlTWIR6S/0qRFy6+uskBDTEzt3NH1agcBRnoo
        NMMtV5zTHtlLZGbquWxQEa40N0PmX/FASNaDMAtQp0hGUoZ26PeR4IxxwCgTo2GvZuLTYY
        x+jC4cW2NQ0Xq4THPnJwXIa2CB8BzxQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659059724;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmDUDGPpPotdkJKmgUyjLNpKCahn3163TIHv3cB6BWc=;
        b=VTSgMzy08XbkgjAMJSiRJ0ym+9eBrzE58ATNN0VSYoGslQZSxaoK9sUtnLe7p17Ml1yYnX
        WYW8JH9RvEMoeEDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F367B133A6;
        Fri, 29 Jul 2022 01:55:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Rw0lKwk+42JkRgAAMHmgww
        (envelope-from <neilb@suse.de>); Fri, 29 Jul 2022 01:55:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>
Cc:     "Coly Li" <colyli@suse.de>, linux-raid@vger.kernel.org,
        "Benjamin Brunner" <bbrunner@suse.com>,
        "Franck Bui" <fbui@suse.de>,
        "Jes Sorensen" <jes@trained-monkey.org>, "Xiao Ni" <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
In-reply-to: <20220728095535.00007b7b@linux.intel.com>
References: <20220215133415.4138-1-colyli@suse.de>,
 <20220728095535.00007b7b@linux.intel.com>
Date:   Fri, 29 Jul 2022 11:55:18 +1000
Message-id: <165905971898.4359.3905352912598347760@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 28 Jul 2022, Mariusz Tkaczyk wrote:
> On Tue, 15 Feb 2022 21:34:15 +0800
> Coly Li <colyli@suse.de> wrote:
>=20
> > For mdadm's systemd configuration, current systemd KillMode is "none" in
> > following service files,
> > - mdadm-grow-continue@.service
> > - mdmon@.service
> >=20
> > This "none" mode is strongly againsted by systemd developers (see man 5
> > systemd.kill for "KillMode=3D" section), and is considering to remove in
> > future systemd version.
> >=20
> > As systemd developer explained in disuccsion, the systemd kill process
> > is,
> > 1. send the signal specified by KillSignal=3D to the list of processes (if
> >    any), TERM is the default
> > 2. wait until either the target of process(es) exit or a timeout expires
> > 3. if the timeout expires send the signal specified by FinalKillSignal=3D,
> >    KILL is the default
> >=20
> > For "control-group", all remaining processes will receive the SIGTERM
> > signal (by default) and if there are still processes after a period f
> > time, they will get the SIGKILL signal.
> >=20
> > For "mixed", only the main process will receive the SIGTERM signal, and
> > if there are still processes after a period of time, all remaining
> > processes (including the main one) will receive the SIGKILL signal.
> >=20
> > From the above comment, currently KillMode=3Dcontrol-group is a proper
> > kill mode. Since control-gropu is the default kill mode, the fix can be
> > simply removing KillMode=3Dnone line from the service file, then the
> > default mode will take effect.
>=20
> Hi All,
> We are experiencing issues with IMSM metadata on RHEL8.7 and 9.1 (the patch
> was picked by Redhat). There are several issues which results in hang task,
> characteristic to missing mdmon:
>=20
> [  619.521440] task:umount state:D stack: 0 pid: 6285 ppid: flags:0x00004084
> [  619.534033] Call Trace:
> [  619.539980]  __schedule+0x2d1/0x830
> [  619.547056]  ? finish_wait+0x80/0x80
> [  619.554261]  schedule+0x35/0xa0
> [  619.560999]  md_write_start+0x14b/0x220
> [  619.568492]  ? finish_wait+0x80/0x80
> [  619.575649]  raid1_make_request+0x3c/0x90 [raid1]
> [  619.584111]  md_handle_request+0x128/0x1b0
> [  619.591891]  md_make_request+0x5b/0xb0
> [  619.599235]  generic_make_request_no_check+0x202/0x330
> [  619.608185]  submit_bio+0x3c/0x160
> [  619.615161]  ? bio_add_page+0x42/0x50
> [  619.622413]  submit_bh_wbc+0x16a/0x190
> [  619.629713]  jbd2_write_superblock+0xf4/0x210 [jbd2]
> [  619.638340]  jbd2_journal_update_sb_log_tail+0x65/0xc0 [jbd2]
> [  619.647773]  __jbd2_update_log_tail+0x3f/0x100 [jbd2]
> [  619.656374]  jbd2_cleanup_journal_tail+0x50/0x90 [jbd2]
> [  619.665107]  jbd2_log_do_checkpoint+0xfa/0x400 [jbd2]
> [  619.673572]  ? prepare_to_wait_event+0xa0/0x180
> [  619.681344]  jbd2_journal_destroy+0x120/0x2a0 [jbd2]
> [  619.689551]  ? finish_wait+0x80/0x80
> [  619.696096]  ext4_put_super+0x76/0x390 [ext4]
> [  619.703584]  generic_shutdown_super+0x6c/0x100
> [  619.711065]  kill_block_super+0x21/0x50
> [  619.717809]  deactivate_locked_super+0x34/0x70
> [  619.725146]  cleanup_mnt+0x3b/0x70
> [  619.731279]  task_work_run+0x8a/0xb0
> [  619.737576]  exit_to_usermode_loop+0xeb/0xf0
> [  619.744657]  do_syscall_64+0x198/0x1a0
> [  619.751155]  entry_SYSCALL_64_after_hwframe+0x65/0xca
>=20
> It can be reproduced by mounting LVM created on IMSM RAID1 array and then
> reboot. I verified that reverting the patch fixes the issue.
>=20
> I understand that from systemd perspective the behavior in not wanted, but
> this is exactly what we need, to have working mdmon process even if systemd=
 was
> stopped. KillMode=3Dnone does the job.
> I searched for alternative way to prevent systemd from stopping the mdmon u=
nit
> but I failed. I tried to change signals, so I configured unit to send SIGPI=
PE
> (because it is ignored by mdmon)- it worked but later system hanged because
> mdmon unit cannot be stopped.
>=20
> I also tried to configure mdmon unit to be stopped after umount.target and I
> failed too. It cannot be achieved by setting After=3D or Before=3D. The one
> objection I have here is that systemd-shutdown tries to stop raid arrays la=
ter,
> so it could be better to have running mdmon there.
>=20
> IMO KillMode=3Dnone is desired in this case. Later, mdmon is restarted in d=
racut
> by mdraid module.
>=20
> If there is no other solution for the problem, I will need to ask Jes to re=
vert
> this patch. For now, I asked Redhat to do it.
> Do you have any suggestions?

We should be able to make this work.
We don't need mdmon after the last array stops, and we should have
dependencies to tell systemd that the various arrays require mdmon.
Ideally systemd wouldn't even try to stop mdmon until the relevant array
was stopped.

Can we change the udev rule to tell systemd that the device WANTS
mdmon@foo.service??
Or add "Before=3Dsys-devices-md-%I.device" or something like that to
mdmon@.service ??

Do you know what exactly is causing systemd to hang because mdmon cannot
be stopped?  What other unit is waiting for it?

Even if the root filesystems is on LVM on IMSM, doesn't systemd chroot
back to the initramfs and then tear down the LVM and MD arrays???


NeilBrown
