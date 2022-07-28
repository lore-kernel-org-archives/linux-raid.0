Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25798C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 07:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbiG1Hzp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 03:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiG1Hzo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 03:55:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75D350738
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 00:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658994943; x=1690530943;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f3Oloumf6ZMX/5dOsAzI6xNKe4FDk/QEsEI3BMRPP+Y=;
  b=bf3FvSH40sTGbUafiP+NcZ5zh6A8e82Uoetj9tZGF5QVC9iWIO+8LkSI
   M/MeFomewfwBoBIa9e49ryYHiCIOOPkkmgOOPHhFD5oFc/fwCGFWPt7Et
   RlJ1+FAJHmJ0UHu9+5B+ZJaUnEs5PQ+6DazvSD3U4pI6aGUOkOMcwvGYY
   GPXM0wmeJdt1M/evDNRMhPJ+UsFryvE5gBju4DReT3Dgmi6uDflnnYG0s
   tzfp6Lqtl5GgpwTpsc4bFUZn5z/6+eqttfBDx+qsSEbg7ZroJ69Ju0Esq
   IRl+IRRaejs6voLiSnTHa/7QOwsyjDvHIp15Aecy6+D3w8htlX9pqXy/t
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="288461451"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="288461451"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 00:55:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="659600936"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.45.20])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 00:55:40 -0700
Date:   Thu, 28 Jul 2022 09:55:35 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org, Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>,
        Neil Brown <neilb@suse.de>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <20220728095535.00007b7b@linux.intel.com>
In-Reply-To: <20220215133415.4138-1-colyli@suse.de>
References: <20220215133415.4138-1-colyli@suse.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 15 Feb 2022 21:34:15 +0800
Coly Li <colyli@suse.de> wrote:

> For mdadm's systemd configuration, current systemd KillMode is "none" in
> following service files,
> - mdadm-grow-continue@.service
> - mdmon@.service
> 
> This "none" mode is strongly againsted by systemd developers (see man 5
> systemd.kill for "KillMode=" section), and is considering to remove in
> future systemd version.
> 
> As systemd developer explained in disuccsion, the systemd kill process
> is,
> 1. send the signal specified by KillSignal= to the list of processes (if
>    any), TERM is the default
> 2. wait until either the target of process(es) exit or a timeout expires
> 3. if the timeout expires send the signal specified by FinalKillSignal=,
>    KILL is the default
> 
> For "control-group", all remaining processes will receive the SIGTERM
> signal (by default) and if there are still processes after a period f
> time, they will get the SIGKILL signal.
> 
> For "mixed", only the main process will receive the SIGTERM signal, and
> if there are still processes after a period of time, all remaining
> processes (including the main one) will receive the SIGKILL signal.
> 
> From the above comment, currently KillMode=control-group is a proper
> kill mode. Since control-gropu is the default kill mode, the fix can be
> simply removing KillMode=none line from the service file, then the
> default mode will take effect.

Hi All,
We are experiencing issues with IMSM metadata on RHEL8.7 and 9.1 (the patch
was picked by Redhat). There are several issues which results in hang task,
characteristic to missing mdmon:

[  619.521440] task:umount state:D stack: 0 pid: 6285 ppid: flags:0x00004084
[  619.534033] Call Trace:
[  619.539980]  __schedule+0x2d1/0x830
[  619.547056]  ? finish_wait+0x80/0x80
[  619.554261]  schedule+0x35/0xa0
[  619.560999]  md_write_start+0x14b/0x220
[  619.568492]  ? finish_wait+0x80/0x80
[  619.575649]  raid1_make_request+0x3c/0x90 [raid1]
[  619.584111]  md_handle_request+0x128/0x1b0
[  619.591891]  md_make_request+0x5b/0xb0
[  619.599235]  generic_make_request_no_check+0x202/0x330
[  619.608185]  submit_bio+0x3c/0x160
[  619.615161]  ? bio_add_page+0x42/0x50
[  619.622413]  submit_bh_wbc+0x16a/0x190
[  619.629713]  jbd2_write_superblock+0xf4/0x210 [jbd2]
[  619.638340]  jbd2_journal_update_sb_log_tail+0x65/0xc0 [jbd2]
[  619.647773]  __jbd2_update_log_tail+0x3f/0x100 [jbd2]
[  619.656374]  jbd2_cleanup_journal_tail+0x50/0x90 [jbd2]
[  619.665107]  jbd2_log_do_checkpoint+0xfa/0x400 [jbd2]
[  619.673572]  ? prepare_to_wait_event+0xa0/0x180
[  619.681344]  jbd2_journal_destroy+0x120/0x2a0 [jbd2]
[  619.689551]  ? finish_wait+0x80/0x80
[  619.696096]  ext4_put_super+0x76/0x390 [ext4]
[  619.703584]  generic_shutdown_super+0x6c/0x100
[  619.711065]  kill_block_super+0x21/0x50
[  619.717809]  deactivate_locked_super+0x34/0x70
[  619.725146]  cleanup_mnt+0x3b/0x70
[  619.731279]  task_work_run+0x8a/0xb0
[  619.737576]  exit_to_usermode_loop+0xeb/0xf0
[  619.744657]  do_syscall_64+0x198/0x1a0
[  619.751155]  entry_SYSCALL_64_after_hwframe+0x65/0xca

It can be reproduced by mounting LVM created on IMSM RAID1 array and then
reboot. I verified that reverting the patch fixes the issue.

I understand that from systemd perspective the behavior in not wanted, but
this is exactly what we need, to have working mdmon process even if systemd was
stopped. KillMode=none does the job.
I searched for alternative way to prevent systemd from stopping the mdmon unit
but I failed. I tried to change signals, so I configured unit to send SIGPIPE
(because it is ignored by mdmon)- it worked but later system hanged because
mdmon unit cannot be stopped.

I also tried to configure mdmon unit to be stopped after umount.target and I
failed too. It cannot be achieved by setting After= or Before=. The one
objection I have here is that systemd-shutdown tries to stop raid arrays later,
so it could be better to have running mdmon there.

IMO KillMode=none is desired in this case. Later, mdmon is restarted in dracut
by mdraid module.

If there is no other solution for the problem, I will need to ask Jes to revert
this patch. For now, I asked Redhat to do it.
Do you have any suggestions?

TIA,
Mariusz
