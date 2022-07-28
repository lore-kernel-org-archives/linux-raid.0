Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D37BC19F29
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 09:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbiG1JBt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 05:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbiG1JBs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 05:01:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE06765581
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 02:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658998907; x=1690534907;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6N0jHgakJt760Si7IWYEOZXpUTiRpWKqBMCcC9so3jA=;
  b=jm9CYGkCWhzlt+htV636f411ro9xt6rKm8C3804CpVtxtZdxQVQOTBpa
   tj5xwzc4+XaqoY2xE70Y12N832sZWPbYYFZhB9tl6RizvlGse5OgKMOwA
   uZlEkt6/QZoazftMYR5w+a+boTiPkiQ0L0g02UMZMEAsi/1yZ+Vkp7P2s
   U8nyu/takkWgQD0CexvVAbtVWSZW+N91TmqeWaq+2r+/vmpYHO9iOwlFJ
   UEtxkwQvch3z0OTyO4vpLxmWQsCTiZQwVfyL8g7BiICi3PyuDu3PJN7J+
   5XJjYQ9UHNGXThVmqu4rGoU/JcVFCDfkAQoAZRh62MmHPwpuk5yUriRfL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="374765681"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="374765681"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 02:01:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="659627484"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.45.20])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 02:01:45 -0700
Date:   Thu, 28 Jul 2022 11:01:40 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>,
        Neil Brown <neilb@suse.de>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <20220728110140.0000305a@linux.intel.com>
In-Reply-To: <19888116-2ED0-4183-B104-E53027AA1A65@suse.de>
References: <20220215133415.4138-1-colyli@suse.de>
        <20220728095535.00007b7b@linux.intel.com>
        <19888116-2ED0-4183-B104-E53027AA1A65@suse.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 28 Jul 2022 16:39:56 +0800
Coly Li <colyli@suse.de> wrote:

> > 2022=E5=B9=B47=E6=9C=8828=E6=97=A5 15:55=EF=BC=8CMariusz Tkaczyk <mariu=
sz.tkaczyk@linux.intel.com>
> > =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > On Tue, 15 Feb 2022 21:34:15 +0800
> > Coly Li <colyli@suse.de> wrote:
> >  =20
> >> For mdadm's systemd configuration, current systemd KillMode is "none" =
in
> >> following service files,
> >> - mdadm-grow-continue@.service
> >> - mdmon@.service
> >>=20
> >> This "none" mode is strongly againsted by systemd developers (see man 5
> >> systemd.kill for "KillMode=3D" section), and is considering to remove =
in
> >> future systemd version.
> >>=20
> >> As systemd developer explained in disuccsion, the systemd kill process
> >> is,
> >> 1. send the signal specified by KillSignal=3D to the list of processes=
 (if
> >> any), TERM is the default
> >> 2. wait until either the target of process(es) exit or a timeout expir=
es
> >> 3. if the timeout expires send the signal specified by FinalKillSignal=
=3D,
> >> KILL is the default
> >>=20
> >> For "control-group", all remaining processes will receive the SIGTERM
> >> signal (by default) and if there are still processes after a period f
> >> time, they will get the SIGKILL signal.
> >>=20
> >> For "mixed", only the main process will receive the SIGTERM signal, and
> >> if there are still processes after a period of time, all remaining
> >> processes (including the main one) will receive the SIGKILL signal.
> >>=20
> >> From the above comment, currently KillMode=3Dcontrol-group is a proper
> >> kill mode. Since control-gropu is the default kill mode, the fix can be
> >> simply removing KillMode=3Dnone line from the service file, then the
> >> default mode will take effect. =20
> >=20
> > Hi All,
> > We are experiencing issues with IMSM metadata on RHEL8.7 and 9.1 (the p=
atch
> > was picked by Redhat). There are several issues which results in hang t=
ask,
> > characteristic to missing mdmon:
> >=20
> > [ 619.521440] task:umount state:D stack: 0 pid: 6285 ppid: flags:0x0000=
4084
> > [ 619.534033] Call Trace:
> > [ 619.539980] __schedule+0x2d1/0x830
> > [ 619.547056] ? finish_wait+0x80/0x80
> > [ 619.554261] schedule+0x35/0xa0
> > [ 619.560999] md_write_start+0x14b/0x220
> > [ 619.568492] ? finish_wait+0x80/0x80
> > [ 619.575649] raid1_make_request+0x3c/0x90 [raid1]
> > [ 619.584111] md_handle_request+0x128/0x1b0
> > [ 619.591891] md_make_request+0x5b/0xb0
> > [ 619.599235] generic_make_request_no_check+0x202/0x330
> > [ 619.608185] submit_bio+0x3c/0x160
> > [ 619.615161] ? bio_add_page+0x42/0x50
> > [ 619.622413] submit_bh_wbc+0x16a/0x190
> > [ 619.629713] jbd2_write_superblock+0xf4/0x210 [jbd2]
> > [ 619.638340] jbd2_journal_update_sb_log_tail+0x65/0xc0 [jbd2]
> > [ 619.647773] __jbd2_update_log_tail+0x3f/0x100 [jbd2]
> > [ 619.656374] jbd2_cleanup_journal_tail+0x50/0x90 [jbd2]
> > [ 619.665107] jbd2_log_do_checkpoint+0xfa/0x400 [jbd2]
> > [ 619.673572] ? prepare_to_wait_event+0xa0/0x180
> > [ 619.681344] jbd2_journal_destroy+0x120/0x2a0 [jbd2]
> > [ 619.689551] ? finish_wait+0x80/0x80
> > [ 619.696096] ext4_put_super+0x76/0x390 [ext4]
> > [ 619.703584] generic_shutdown_super+0x6c/0x100
> > [ 619.711065] kill_block_super+0x21/0x50
> > [ 619.717809] deactivate_locked_super+0x34/0x70
> > [ 619.725146] cleanup_mnt+0x3b/0x70
> > [ 619.731279] task_work_run+0x8a/0xb0
> > [ 619.737576] exit_to_usermode_loop+0xeb/0xf0
> > [ 619.744657] do_syscall_64+0x198/0x1a0
> > [ 619.751155] entry_SYSCALL_64_after_hwframe+0x65/0xca
> >=20
> > It can be reproduced by mounting LVM created on IMSM RAID1 array and th=
en
> > reboot. I verified that reverting the patch fixes the issue.
> >=20
> > I understand that from systemd perspective the behavior in not wanted, =
but
> > this is exactly what we need, to have working mdmon process even if sys=
temd
> > was stopped. KillMode=3Dnone does the job.
> > I searched for alternative way to prevent systemd from stopping the mdm=
on
> > unit but I failed. I tried to change signals, so I configured unit to s=
end
> > SIGPIPE (because it is ignored by mdmon)- it worked but later system ha=
nged
> > because mdmon unit cannot be stopped.
> >=20
> > I also tried to configure mdmon unit to be stopped after umount.target =
and I
> > failed too. It cannot be achieved by setting After=3D or Before=3D. The=
 one
> > objection I have here is that systemd-shutdown tries to stop raid arrays
> > later, so it could be better to have running mdmon there.
> >=20
> > IMO KillMode=3Dnone is desired in this case. Later, mdmon is restarted =
in
> > dracut by mdraid module.
> >=20
> > If there is no other solution for the problem, I will need to ask Jes to
> > revert this patch. For now, I asked Redhat to do it.
> > Do you have any suggestions? =20
>=20
>=20
> If Redhat doesn=E2=80=99t use the latest systemd, they should drop this p=
atch. For
> mdadm upstream we should keep this because it was suggested by systemd
> developer.
>=20

If we want to keep this, we need to resolve reboot problem. I described pro=
blem
and now I'm waiting for feedback. I hope that it can be fixed in mdmon serv=
ice
fast and easy.
I we will determine that mdmon design update is needed then I will request =
to
revert it, until fix is not ready to minimize impact on users (distros may
pull this).

Thanks
Mariusz
