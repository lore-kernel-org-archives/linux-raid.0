Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7EAC433FE
	for <linux-raid@archiver.kernel.org>; Tue,  4 Oct 2022 10:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJDKYT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJDKYR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Oct 2022 06:24:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F982BE04
        for <linux-raid@vger.kernel.org>; Tue,  4 Oct 2022 03:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664879056; x=1696415056;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/jLNmTbFqPQbNFfvNT9QCK9HPZVa9yovmkdoa0b23D4=;
  b=hwlZQk2dgkKDU1x3gfsWp68Z6lN78VyaD117bc0tGT9pld53FYlhSNnq
   A9qHmkE0rOFcjXAyUJQUQn110TeMGjWgvqHXbD7zS5M7JcmUdcX27rrq6
   PBiabv4Vsu9p6w4S6RObwGiphyJix18DcChgG5GBAbY95TAXSxGV1s7fO
   /W6YjjSgeHnMgHRGzU+VvrEW9FPwKJGvahBBVSLcqSOnuMRFdmtZXOCLF
   SlqkSeK5zmbkMC3+JOSL3D5p7OzoowkGwqK24hUvowhG9W69jtBSws5Lx
   8q6Flr8Ofu187HbuB8BJ5jw3gmADRDwOsh4/RwYSLnSCb4Id6hgYNDLzw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="302854465"
X-IronPort-AV: E=Sophos;i="5.93,367,1654585200"; 
   d="scan'208";a="302854465"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 03:24:15 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="749328300"
X-IronPort-AV: E=Sophos;i="5.93,367,1654585200"; 
   d="scan'208";a="749328300"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.213.20.65])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 03:24:13 -0700
Date:   Tue, 4 Oct 2022 12:24:08 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org, Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>,
        Neil Brown <neilb@suse.de>, Xiao Ni <xni@redhat.com>,
        Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <20221004122408.000029cd@linux.intel.com>
In-Reply-To: <20220728095535.00007b7b@linux.intel.com>
References: <20220215133415.4138-1-colyli@suse.de>
        <20220728095535.00007b7b@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 28 Jul 2022 09:55:35 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> On Tue, 15 Feb 2022 21:34:15 +0800
> Coly Li <colyli@suse.de> wrote:
> 
> > For mdadm's systemd configuration, current systemd KillMode is "none" in
> > following service files,
> > - mdadm-grow-continue@.service
> > - mdmon@.service
> > 
> > This "none" mode is strongly againsted by systemd developers (see man 5
> > systemd.kill for "KillMode=" section), and is considering to remove in
> > future systemd version.
> > 
> > As systemd developer explained in disuccsion, the systemd kill process
> > is,
> > 1. send the signal specified by KillSignal= to the list of processes (if
> >    any), TERM is the default
> > 2. wait until either the target of process(es) exit or a timeout expires
> > 3. if the timeout expires send the signal specified by FinalKillSignal=,
> >    KILL is the default
> > 
> > For "control-group", all remaining processes will receive the SIGTERM
> > signal (by default) and if there are still processes after a period f
> > time, they will get the SIGKILL signal.
> > 
> > For "mixed", only the main process will receive the SIGTERM signal, and
> > if there are still processes after a period of time, all remaining
> > processes (including the main one) will receive the SIGKILL signal.
> > 
> > From the above comment, currently KillMode=control-group is a proper
> > kill mode. Since control-gropu is the default kill mode, the fix can be
> > simply removing KillMode=none line from the service file, then the
> > default mode will take effect.  
> 
> Hi All,
> We are experiencing issues with IMSM metadata on RHEL8.7 and 9.1 (the patch
> was picked by Redhat). There are several issues which results in hang task,
> characteristic to missing mdmon:
> 
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
> 
> It can be reproduced by mounting LVM created on IMSM RAID1 array and then
> reboot. I verified that reverting the patch fixes the issue.
> 
> I understand that from systemd perspective the behavior in not wanted, but
> this is exactly what we need, to have working mdmon process even if systemd
> was stopped. KillMode=none does the job.
> I searched for alternative way to prevent systemd from stopping the mdmon unit
> but I failed. I tried to change signals, so I configured unit to send SIGPIPE
> (because it is ignored by mdmon)- it worked but later system hanged because
> mdmon unit cannot be stopped.
> 
> I also tried to configure mdmon unit to be stopped after umount.target and I
> failed too. It cannot be achieved by setting After= or Before=. The one
> objection I have here is that systemd-shutdown tries to stop raid arrays
> later, so it could be better to have running mdmon there.
> 
> IMO KillMode=none is desired in this case. Later, mdmon is restarted in dracut
> by mdraid module.
> 
> If there is no other solution for the problem, I will need to ask Jes to
> revert this patch. For now, I asked Redhat to do it.
> Do you have any suggestions?
> 
Hi all,
I would like to recommend reverting this for now. Fixing that seems to not be
trivial, we need more time. For user experience it will be better to have
upstream working.
Jes, could you please revert this patch for now?

Thanks,
Mariusz
