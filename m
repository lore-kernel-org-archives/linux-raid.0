Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D49C00140
	for <linux-raid@archiver.kernel.org>; Tue,  2 Aug 2022 15:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiHBPnP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Aug 2022 11:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiHBPnO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Aug 2022 11:43:14 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50907B0F
        for <linux-raid@vger.kernel.org>; Tue,  2 Aug 2022 08:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659454993; x=1690990993;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8IgcSNIvo+VgD/MYF6DNc1kwRSEjxWwuwc6G0h/OdXI=;
  b=MA3ViJEnTB8U65AxWzaX1PWLn3ddXURbEMxF2koHiul+93/QeNdMDIEE
   og0YYQ7kojlqU4FO0nJrRLCA13vqRx4cL/60Wohcpyk0F620ssULamK8j
   HL3UHr4hbVTNs4Hkr3TpsvhS+nXZDYysNgj2UHqEwrOYVrYaOZUzMgHKM
   KKi6eUaJTTsk8MiPsotQqmu+oGzDRk3pkV1igBxtQnrPDlRbsATW6VzIn
   dZbERcrscbpWNyBh/sl2QMxuOyt/sW7bDd0IYKOSB0vh5NUm0MBco8IVR
   juQ8cLgb5fqf7i3bO4TddA9tVhPOx1V/xOcOXyMwMn2Sn9rrP1Bk6HzKN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="269822966"
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="269822966"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 08:43:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="661676902"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.60.82])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 08:43:11 -0700
Date:   Tue, 2 Aug 2022 17:43:05 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     "NeilBrown" <neilb@suse.de>
Cc:     "Coly Li" <colyli@suse.de>, linux-raid@vger.kernel.org,
        "Benjamin Brunner" <bbrunner@suse.com>,
        "Franck Bui" <fbui@suse.de>,
        "Jes Sorensen" <jes@trained-monkey.org>, "Xiao Ni" <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <20220802174305.00000336@linux.intel.com>
In-Reply-To: <165905971898.4359.3905352912598347760@noble.neil.brown.name>
References: <20220215133415.4138-1-colyli@suse.de>
        <20220728095535.00007b7b@linux.intel.com>
        <165905971898.4359.3905352912598347760@noble.neil.brown.name>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 29 Jul 2022 11:55:18 +1000
"NeilBrown" <neilb@suse.de> wrote:

> On Thu, 28 Jul 2022, Mariusz Tkaczyk wrote:
> > On Tue, 15 Feb 2022 21:34:15 +0800
> > Coly Li <colyli@suse.de> wrote:
> >   
> > > For mdadm's systemd configuration, current systemd KillMode is "none" in
> > > following service files,
> > > - mdadm-grow-continue@.service
> > > - mdmon@.service
> > > 
> > > This "none" mode is strongly againsted by systemd developers (see man 5
> > > systemd.kill for "KillMode=" section), and is considering to remove in
> > > future systemd version.
> > > 
> > > As systemd developer explained in disuccsion, the systemd kill process
> > > is,
> > > 1. send the signal specified by KillSignal= to the list of processes (if
> > >    any), TERM is the default
> > > 2. wait until either the target of process(es) exit or a timeout expires
> > > 3. if the timeout expires send the signal specified by FinalKillSignal=,
> > >    KILL is the default
> > > 
> > > For "control-group", all remaining processes will receive the SIGTERM
> > > signal (by default) and if there are still processes after a period f
> > > time, they will get the SIGKILL signal.
> > > 
> > > For "mixed", only the main process will receive the SIGTERM signal, and
> > > if there are still processes after a period of time, all remaining
> > > processes (including the main one) will receive the SIGKILL signal.
> > > 
> > > From the above comment, currently KillMode=control-group is a propervi
> > > kill mode. Since control-gropu is the default kill mode, the fix can be
> > > simply removing KillMode=none line from the service file, then the
> > > default mode will take effect.  
> > 
> > Hi All,
> > We are experiencing issues with IMSM metadata on RHEL8.7 and 9.1 (the patch
> > was picked by Redhat). There are several issues which results in hang task,
> > characteristic to missing mdmon:
> > 
> > [  619.521440] task:umount state:D stack: 0 pid: 6285 ppid: flags:0x00004084
> > [  619.534033] Call Trace:
> > [  619.539980]  __schedule+0x2d1/0x830
> > [  619.547056]  ? finish_wait+0x80/0x80
> > [  619.554261]  schedule+0x35/0xa0
> > [  619.560999]  md_write_start+0x14b/0x220
> > [  619.568492]  ? finish_wait+0x80/0x80
> > [  619.575649]  raid1_make_request+0x3c/0x90 [raid1]
> > [  619.584111]  md_handle_request+0x128/0x1b0
> > [  619.591891]  md_make_request+0x5b/0xb0
> > [  619.599235]  generic_make_request_no_check+0x202/0x330
> > [  619.608185]  submit_bio+0x3c/0x160
> > [  619.615161]  ? bio_add_page+0x42/0x50
> > [  619.622413]  submit_bh_wbc+0x16a/0x190
> > [  619.629713]  jbd2_write_superblock+0xf4/0x210 [jbd2]
> > [  619.638340]  jbd2_journal_update_sb_log_tail+0x65/0xc0 [jbd2]
> > [  619.647773]  __jbd2_update_log_tail+0x3f/0x100 [jbd2]
> > [  619.656374]  jbd2_cleanup_journal_tail+0x50/0x90 [jbd2]
> > [  619.665107]  jbd2_log_do_checkpoint+0xfa/0x400 [jbd2]
> > [  619.673572]  ? prepare_to_wait_event+0xa0/0x180
> > [  619.681344]  jbd2_journal_destroy+0x120/0x2a0 [jbd2]
> > [  619.689551]  ? finish_wait+0x80/0x80
> > [  619.696096]  ext4_put_super+0x76/0x390 [ext4]
> > [  619.703584]  generic_shutdown_super+0x6c/0x100
> > [  619.711065]  kill_block_super+0x21/0x50
> > [  619.717809]  deactivate_locked_super+0x34/0x70
> > [  619.725146]  cleanup_mnt+0x3b/0x70
> > [  619.731279]  task_work_run+0x8a/0xb0
> > [  619.737576]  exit_to_usermode_loop+0xeb/0xf0
> > [  619.744657]  do_syscall_64+0x198/0x1a0
> > [  619.751155]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> > 
> > It can be reproduced by mounting LVM created on IMSM RAID1 array and then
> > reboot. I verified that reverting the patch fixes the issue.
> > 
> > I understand that from systemd perspective the behavior in not wanted, but
> > this is exactly what we need, to have working mdmon process even if systemd
> > was stopped. KillMode=none does the job.
> > I searched for alternative way to prevent systemd from stopping the mdmon
> > unit but I failed. I tried to change signals, so I configured unit to send
> > SIGPIPE (because it is ignored by mdmon)- it worked but later system hanged
> > because mdmon unit cannot be stopped.
> > 
> > I also tried to configure mdmon unit to be stopped after umount.target and I
> > failed too. It cannot be achieved by setting After= or Before=. The one
> > objection I have here is that systemd-shutdown tries to stop raid arrays
> > later, so it could be better to have running mdmon there.
> > 
> > IMO KillMode=none is desired in this case. Later, mdmon is restarted in
> > dracut by mdraid module.
> > 
> > If there is no other solution for the problem, I will need to ask Jes to
> > revert this patch. For now, I asked Redhat to do it.
> > Do you have any suggestions?  
> 
> We should be able to make this work.
> We don't need mdmon after the last array stops, and we should have
> dependencies to tell systemd that the various arrays require mdmon.
> Ideally systemd wouldn't even try to stop mdmon until the relevant array
> was stopped.
> 
> Can we change the udev rule to tell systemd that the device WANTS
> mdmon@foo.service??

Hi Neil,
This is done already:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/udev-md-raid-arrays.rules#n41
but i can't find wants dependency in:
#systemctl show dev-md126.service
#systemctl show dev-md127.service

According to man:
https://www.freedesktop.org/software/systemd/man/systemd.device.html
there is nothing else I can do.

> Or add "Before=sys-devices-md-%I.device" or something like that to
> mdmon@.service ??
> 
I got:
systemd[1]: /usr/lib/systemd/system/mdmon@.service:11: Failed to resolve unit
specifiers in 'dev-%I.device', ignoring: Invalid slot

> Do you know what exactly is causing systemd to hang because mdmon cannot
> be stopped?  What other unit is waiting for it?
There is special umount.target
https://www.freedesktop.org/software/systemd/man/systemd.special.html

Probably it tries to umount every exiting .mount unit, i didn't check deeply.
https://www.freedesktop.org/software/systemd/man/systemd.mount.html

I can see that we can define something for .mount units so I tried both:
# mount -o x-systemd.after=mdmon@md127.service /dev/mapper/vg0-lvm_raid /mnt
# mount -o x-systemd.requires=mdmon@md127.service /dev/mapper/vg0-lvm_raid /mnt

but I doesn't help either. I seems that it is ignored because I cannot find
mdmon dependency in systemctl show output for mnt.mount unit.

Do you have any other ideas?

> 
> Even if the root filesystems is on LVM on IMSM, doesn't systemd chroot
> back to the initramfs and then tear down the LVM and MD arrays???

Yes, this is how it works, mdmon is restarted in initrd later. System will
reboot successfully after timeout.

Thanks,
Mariusz

