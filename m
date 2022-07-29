Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BBBC00144
	for <linux-raid@archiver.kernel.org>; Fri, 29 Jul 2022 07:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiG2H4C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Jul 2022 03:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiG2H4B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Jul 2022 03:56:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EAC7E02A
        for <linux-raid@vger.kernel.org>; Fri, 29 Jul 2022 00:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659081360; x=1690617360;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lhR4G8xf2biZAVDbRkCs+qimM/Gz71UF0FmUk8wV2Go=;
  b=YtCPIqCkyoJoAuLjKMN5hbyLr9LhXC6F7S2psg8FUdelPv/DbtGaksAH
   vPffOurz0oirUo6cUISvDzLT6uDpDzInTykw5vbRsoFBIaujtxv254gmU
   Z1DCm/HuIa48d0CS5lq8kTgY/pIvlFsmGlq37IMAkfyw6FZWmrxBtSV07
   AWeSVWW+BQnkeSrSrIlnt3dtztRGX82X8Qh58nKeeFyUs1XdawXKrqlxt
   05SefqBaQq4MiciP4AXT9hM1wK+9WnK8q5R0r1ObN4knlExogpuiURZtU
   QTbEchYu2Ce+M4i0Tfk1H5U0geHJXOtmAFMtBdyWzI1LnqZOQy33/6ruZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="289487580"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="289487580"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 00:56:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="660138772"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.45.210])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 00:55:56 -0700
Date:   Fri, 29 Jul 2022 09:55:52 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Benjamin Brunner <bbrunner@suse.com>,
        Franck Bui <fbui@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>,
        Neil Brown <neilb@suse.de>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm/systemd: remove KillMode=none from service file
Message-ID: <20220729095552.00004f30@linux.intel.com>
In-Reply-To: <475B7F58-EB5E-4305-8447-67C3CAF2DD76@suse.de>
References: <20220215133415.4138-1-colyli@suse.de>
        <20220728095535.00007b7b@linux.intel.com>
        <19888116-2ED0-4183-B104-E53027AA1A65@suse.de>
        <20220728110140.0000305a@linux.intel.com>
        <475B7F58-EB5E-4305-8447-67C3CAF2DD76@suse.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 28 Jul 2022 18:55:04 +0800
Coly Li <colyli@suse.de> wrote:

> > 2022=E5=B9=B47=E6=9C=8828=E6=97=A5 17:01=EF=BC=8CMariusz Tkaczyk <mariu=
sz.tkaczyk@linux.intel.com>
> > =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > On Thu, 28 Jul 2022 16:39:56 +0800
> > Coly Li <colyli@suse.de> wrote:
> >  =20
> >>> 2022=E5=B9=B47=E6=9C=8828=E6=97=A5 15:55=EF=BC=8CMariusz Tkaczyk <mar=
iusz.tkaczyk@linux.intel.com>
> >>> =E5=86=99=E9=81=93=EF=BC=9A
> >>>=20
> >>> On Tue, 15 Feb 2022 21:34:15 +0800
> >>> Coly Li <colyli@suse.de> wrote:
> >>>  =20
> >>>> For mdadm's systemd configuration, current systemd KillMode is "none=
" in
> >>>> following service files,
> >>>> - mdadm-grow-continue@.service
> >>>> - mdmon@.service
> >>>>=20
> >>>> This "none" mode is strongly againsted by systemd developers (see ma=
n 5
> >>>> systemd.kill for "KillMode=3D" section), and is considering to remov=
e in
> >>>> future systemd version.
> >>>>=20
> >>>> As systemd developer explained in disuccsion, the systemd kill proce=
ss
> >>>> is,
> >>>> 1. send the signal specified by KillSignal=3D to the list of process=
es (if
> >>>> any), TERM is the default
> >>>> 2. wait until either the target of process(es) exit or a timeout exp=
ires
> >>>> 3. if the timeout expires send the signal specified by FinalKillSign=
al=3D,
> >>>> KILL is the default
> >>>>=20
> >>>> For "control-group", all remaining processes will receive the SIGTERM
> >>>> signal (by default) and if there are still processes after a period f
> >>>> time, they will get the SIGKILL signal.
> >>>>=20
> >>>> For "mixed", only the main process will receive the SIGTERM signal, =
and
> >>>> if there are still processes after a period of time, all remaining
> >>>> processes (including the main one) will receive the SIGKILL signal.
> >>>>=20
> >>>> From the above comment, currently KillMode=3Dcontrol-group is a prop=
er
> >>>> kill mode. Since control-gropu is the default kill mode, the fix can=
 be
> >>>> simply removing KillMode=3Dnone line from the service file, then the
> >>>> default mode will take effect.   =20
> >>>=20
> >>> Hi All,
> >>> We are experiencing issues with IMSM metadata on RHEL8.7 and 9.1 (the
> >>> patch was picked by Redhat). There are several issues which results in
> >>> hang task, characteristic to missing mdmon:
> >>>=20
> >>> [ 619.521440] task:umount state:D stack: 0 pid: 6285 ppid:
> >>> flags:0x00004084 [ 619.534033] Call Trace:
> >>> [ 619.539980] __schedule+0x2d1/0x830
> >>> [ 619.547056] ? finish_wait+0x80/0x80
> >>> [ 619.554261] schedule+0x35/0xa0
> >>> [ 619.560999] md_write_start+0x14b/0x220
> >>> [ 619.568492] ? finish_wait+0x80/0x80
> >>> [ 619.575649] raid1_make_request+0x3c/0x90 [raid1]
> >>> [ 619.584111] md_handle_request+0x128/0x1b0
> >>> [ 619.591891] md_make_request+0x5b/0xb0
> >>> [ 619.599235] generic_make_request_no_check+0x202/0x330
> >>> [ 619.608185] submit_bio+0x3c/0x160
> >>> [ 619.615161] ? bio_add_page+0x42/0x50
> >>> [ 619.622413] submit_bh_wbc+0x16a/0x190
> >>> [ 619.629713] jbd2_write_superblock+0xf4/0x210 [jbd2]
> >>> [ 619.638340] jbd2_journal_update_sb_log_tail+0x65/0xc0 [jbd2]
> >>> [ 619.647773] __jbd2_update_log_tail+0x3f/0x100 [jbd2]
> >>> [ 619.656374] jbd2_cleanup_journal_tail+0x50/0x90 [jbd2]
> >>> [ 619.665107] jbd2_log_do_checkpoint+0xfa/0x400 [jbd2]
> >>> [ 619.673572] ? prepare_to_wait_event+0xa0/0x180
> >>> [ 619.681344] jbd2_journal_destroy+0x120/0x2a0 [jbd2]
> >>> [ 619.689551] ? finish_wait+0x80/0x80
> >>> [ 619.696096] ext4_put_super+0x76/0x390 [ext4]
> >>> [ 619.703584] generic_shutdown_super+0x6c/0x100
> >>> [ 619.711065] kill_block_super+0x21/0x50
> >>> [ 619.717809] deactivate_locked_super+0x34/0x70
> >>> [ 619.725146] cleanup_mnt+0x3b/0x70
> >>> [ 619.731279] task_work_run+0x8a/0xb0
> >>> [ 619.737576] exit_to_usermode_loop+0xeb/0xf0
> >>> [ 619.744657] do_syscall_64+0x198/0x1a0
> >>> [ 619.751155] entry_SYSCALL_64_after_hwframe+0x65/0xca
> >>>=20
> >>> It can be reproduced by mounting LVM created on IMSM RAID1 array and =
then
> >>> reboot. I verified that reverting the patch fixes the issue.
> >>>=20
> >>> I understand that from systemd perspective the behavior in not wanted=
, but
> >>> this is exactly what we need, to have working mdmon process even if
> >>> systemd was stopped. KillMode=3Dnone does the job.
> >>> I searched for alternative way to prevent systemd from stopping the m=
dmon
> >>> unit but I failed. I tried to change signals, so I configured unit to=
 send
> >>> SIGPIPE (because it is ignored by mdmon)- it worked but later system
> >>> hanged because mdmon unit cannot be stopped.
> >>>=20
> >>> I also tried to configure mdmon unit to be stopped after umount.target
> >>> and I failed too. It cannot be achieved by setting After=3D or Before=
=3D. The
> >>> one objection I have here is that systemd-shutdown tries to stop raid
> >>> arrays later, so it could be better to have running mdmon there.
> >>>=20
> >>> IMO KillMode=3Dnone is desired in this case. Later, mdmon is restarte=
d in
> >>> dracut by mdraid module.
> >>>=20
> >>> If there is no other solution for the problem, I will need to ask Jes=
 to
> >>> revert this patch. For now, I asked Redhat to do it.
> >>> Do you have any suggestions?   =20
> >>=20
> >>=20
> >> If Redhat doesn=E2=80=99t use the latest systemd, they should drop thi=
s patch. For
> >> mdadm upstream we should keep this because it was suggested by systemd
> >> developer.
> >>  =20
> >=20
> > If we want to keep this, we need to resolve reboot problem. I described
> > problem and now I'm waiting for feedback. I hope that it can be fixed in
> > mdmon service fast and easy. =20
>=20
>=20
> Hmm, in the latest systemd source code, unit_kill_context() just simply
> ignores KILL_NONE (KillMode=3Dnone) like this,
>=20
> 4776         /* Kill the processes belonging to this unit, in preparation=
 for
> shutting the unit down. 4777          * Returns > 0 if we killed something
> worth waiting for, 0 otherwise. */ 4778
> 4779         if (c->kill_mode =3D=3D KILL_NONE)
> 4780                 return 0;
>=20
> And no signal sent to target unit. Since there is no other location
> references KILL_NONE, it is not clear to me how KillMode=3Dnone may help =
more.
>=20
> I have no too much understanding to systemd, I guess maybe (correct me if=
 I
> am wrong) it was because the systemd used in RHEL is not the latest versi=
on?
>=20
Hi Coly,

It seems to be clear for me. When "none" is set then 0 is returned up. 0 me=
ans
that there is nothing to wait for, so systemd doesn't check if process is r=
eally
killed by pinging it. It assumes that process is dead/stopped already and
systemd unit can be stopped too. And that happens- unit is stopped, but mdm=
on@
process works in background.
>=20
> > If we will determine that mdmon design update is needed then I will req=
uest
> > to revert it, until fix is not ready to minimize impact on users (distr=
os
> > may pull this). =20
>=20
> Yes I agree. But for mdadm package in RHEL, I guess they don=E2=80=99t al=
ways use
> upstream mdadm, and just do backport for selected patches as other enterp=
rise
> distributions do. If the latest mdadm and latest systemd work fine togeth=
er,
> maybe the fast fix for RHEL is to just drop this patch from their backpor=
t,
> it is unnecessary to wait until the patch is reverted or fixed by upstrea=
m.
>=20
Yes, I recommended to revert it. But I don't think that it will be fixed
automatically in systemd. We need to find solution and implement it on our =
side.
=20
> BTW, can I know the exact version of systemd from RHEL 8.7 and 9.1? On my
> openSUSE 15.4, the systemd version is 249.11, I will try to reproduce the
> operations as well, and try to find some clue if I am lucky.
>=20
I don't think that systemd version matters here. To reproduce it you need t=
o:
1. remove KillMode line from service (/lib/sysytemd/system/mdmon@.service)-=
 you
don't need to reinstall mdadm at all.
2. systemctl daemon-reload or reboot
3. systemctl restart mdmon@md127 (generally it is IMSM container)
4. create LVM volume and mount it somewhere.
5. Do reboot

RHEL 8.7 systemd rpm version is 238.
RHEL 9.1 systemd rpm version is 250.

They are using systemd-stable repo:
https://github.com/systemd/systemd-stable
so please find the latest tag for a release and you should be close.

Thanks,
Mariusz




