Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB02C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 22 Feb 2022 14:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiBVOT0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiBVOTZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Feb 2022 09:19:25 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A721151C66
        for <linux-raid@vger.kernel.org>; Tue, 22 Feb 2022 06:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645539539; x=1677075539;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UcmPSOcfaOJXBAOGeZXX34b0TI8LsqO3pEwf4zMykpI=;
  b=Nzb77ANJb6MQQia3GRlqQws5fWEY0kfoLQCsqjRTmuo2EHgidveFBsuf
   /o2ogikT/IlJqKlkcMayCulrsm2wlP4lhP41JW9/hN25qBlHJnGmJ0I3F
   A/osvX3RWkI/L28L+cdSIURjhblmbFNkACQHIvZbFKloECXpYUFUF1kF2
   zr0wy9tjE22OzYPNotXTYsOGlihdEM4jPDFP0VxufZrnxqAc2Tit4H6+C
   hMAqD404qEod2Xq753dGT2cUsheUJMQha6PHgWoYxVPHkGleRFy0/9BSp
   3++NhyrM1/MJSkqtPr8BCFE770pLXWB1hmb3aM4Gp4hnxtt15Dfc9ji09
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="235230044"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="235230044"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 06:18:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="547760058"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.20.61])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 06:18:57 -0800
Date:   Tue, 22 Feb 2022 15:18:51 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] raid5: introduce MD_BROKEN
Message-ID: <20220222151851.0000089a@linux.intel.com>
In-Reply-To: <fbe1ec39-acee-8226-adb2-6c61e3d7fdd0@linux.dev>
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
        <20220127153912.26856-4-mariusz.tkaczyk@linux.intel.com>
        <fbe1ec39-acee-8226-adb2-6c61e3d7fdd0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Guoqing,
Sorry for the delay, I missed it.

On Sat, 12 Feb 2022 09:47:38 +0800
Guoqing Jiang <guoqing.jiang@linux.dev> wrote:

> On 1/27/22 11:39 PM, Mariusz Tkaczyk wrote:
> > Raid456 module had allowed to achieve failed state. It was fixed by
> > fb73b357fb9 ("raid5: block failing device if raid will be failed").
> > This fix introduces a bug, now if raid5 fails during IO, it may
> > result with a hung task without completion. Faulty flag on the
> > device is necessary to process all requests and is checked many
> > times, mainly in analyze_stripe().
> > Allow to set faulty on drive again and set MD_BROKEN if raid is
> > failed.
> >
> > As a result, this level is allowed to achieve failed state again,
> > but communication with userspace (via -EBUSY status) will be
> > preserved.
> >
> > This restores possibility to fail array via #mdadm --set-faulty
> > command and will be fixed by additional verification on mdadm side.
> > =20
>=20
> Again, you better to send mdadm change along with the series.

I understand your objections. Unfortunately, I was unable to handle it
yet. I focused on kernel part first because mdadm was in freeze.
In mdadm, I need to block manual removal which should be simple, there
is already enough() function defined. It is on top of my TODO lst.
 =20
>=20
> > Reproduction steps:
> >   mdadm -CR imsm -e imsm -n 3 /dev/nvme[0-2]n1
> >   mdadm -CR r5 -e imsm -l5 -n3 /dev/nvme[0-2]n1 --assume-clean
> >   mkfs.xfs /dev/md126 -f
> >   mount /dev/md126 /mnt/root/
> >
> >   fio --filename=3D/mnt/root/file --size=3D5GB --direct=3D1 --rw=3Drand=
rw
> > --bs=3D64k --ioengine=3Dlibaio --iodepth=3D64 --runtime=3D240 --numjobs=
=3D4
> > --time_based --group_reporting --name=3Dthroughput-test-job
> > --eta-newline=3D1 &
> >
> >   echo 1 > /sys/block/nvme2n1/device/device/remove
> >   echo 1 > /sys/block/nvme1n1/device/device/remove
> >
> >   [ 1475.787779] Call Trace:
> >   [ 1475.793111] __schedule+0x2a6/0x700
> >   [ 1475.799460] schedule+0x38/0xa0
> >   [ 1475.805454] raid5_get_active_stripe+0x469/0x5f0 [raid456]
> >   [ 1475.813856] ? finish_wait+0x80/0x80
> >   [ 1475.820332] raid5_make_request+0x180/0xb40 [raid456]
> >   [ 1475.828281] ? finish_wait+0x80/0x80
> >   [ 1475.834727] ? finish_wait+0x80/0x80
> >   [ 1475.841127] ? finish_wait+0x80/0x80
> >   [ 1475.847480] md_handle_request+0x119/0x190
> >   [ 1475.854390] md_make_request+0x8a/0x190
> >   [ 1475.861041] generic_make_request+0xcf/0x310
> >   [ 1475.868145] submit_bio+0x3c/0x160
> >   [ 1475.874355] iomap_dio_submit_bio.isra.20+0x51/0x60
> >   [ 1475.882070] iomap_dio_bio_actor+0x175/0x390
> >   [ 1475.889149] iomap_apply+0xff/0x310
> >   [ 1475.895447] ? iomap_dio_bio_actor+0x390/0x390
> >   [ 1475.902736] ? iomap_dio_bio_actor+0x390/0x390
> >   [ 1475.909974] iomap_dio_rw+0x2f2/0x490
> >   [ 1475.916415] ? iomap_dio_bio_actor+0x390/0x390
> >   [ 1475.923680] ? atime_needs_update+0x77/0xe0
> >   [ 1475.930674] ? xfs_file_dio_aio_read+0x6b/0xe0 [xfs]
> >   [ 1475.938455] xfs_file_dio_aio_read+0x6b/0xe0 [xfs]
> >   [ 1475.946084] xfs_file_read_iter+0xba/0xd0 [xfs]
> >   [ 1475.953403] aio_read+0xd5/0x180
> >   [ 1475.959395] ? _cond_resched+0x15/0x30
> >   [ 1475.965907] io_submit_one+0x20b/0x3c0
> >   [ 1475.972398] __x64_sys_io_submit+0xa2/0x180
> >   [ 1475.979335] ? do_io_getevents+0x7c/0xc0
> >   [ 1475.986009] do_syscall_64+0x5b/0x1a0
> >   [ 1475.992419] entry_SYSCALL_64_after_hwframe+0x65/0xca
> >   [ 1476.000255] RIP: 0033:0x7f11fc27978d
> >   [ 1476.006631] Code: Bad RIP value.
> >   [ 1476.073251] INFO: task fio:3877 blocked for more than 120
> > seconds. =20
>=20
> Does it also happen to non imsm array? And did you try to reproduce
> it with revert fb73b357fb? I suppose fb73b357fb9 introduced the
> regression given it is fixed by this one.
>=20
It is reproducible on native and IMSM. Yes, we can fix it by revert.

>=20
> >    * In both cases, &MD_BROKEN will be set in &mddev->flags.
> >    */
> >   static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 1240a5c16af8..bee953c8007f 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -686,17 +686,21 @@ int raid5_calc_degraded(struct r5conf *conf)
> >   	return degraded;
> >   }
> >  =20
> > -static int has_failed(struct r5conf *conf)
> > +static bool has_failed(struct r5conf *conf)
> >   {
> > -	int degraded;
> > +	int degraded =3D conf->mddev->degraded;
> >  =20
> > -	if (conf->mddev->reshape_position =3D=3D MaxSector)
> > -		return conf->mddev->degraded > conf->max_degraded;
> > +	if (test_bit(MD_BROKEN, &conf->mddev->flags))
> > +		return true; =20
>=20
> If one member disk was set Faulty which caused BROKEN was set, is it
> possible to re-add the same member disk again?
>=20
Is possible to re-add drive to failed raid5 array now? From my
understanding of raid5_add_disk it is not possible.

> [root@vm ~]# echo faulty > /sys/block/md0/md/dev-loop1/state
> [root@vm ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 loop2[2] loop1[0](F)
>  =A0=A0=A0=A0=A0 1046528 blocks super 1.2 level 5, 512k chunk, algorithm 2
> [2/1] [_U] bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
> [root@vm ~]# echo re-add > /sys/block/md0/md/dev-loop1/state
> [root@vm ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 loop2[2] loop1[0]
>  =A0=A0=A0=A0=A0 1046528 blocks super 1.2 level 5, 512k chunk, algorithm 2
> [2/2] [UU] bitmap: 0/1 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
>=20
> And have you run mdadm test against the series?
>=20
I run imsm test suite and our internal IMSM scope. I will take the
challenge and will verify with native. Thanks for suggestion.

> > -	degraded =3D raid5_calc_degraded(conf);
> > -	if (degraded > conf->max_degraded)
> > -		return 1;
> > -	return 0;
> > +	if (conf->mddev->reshape_position !=3D MaxSector)
> > +		degraded =3D raid5_calc_degraded(conf);
> > +
> > +	if (degraded > conf->max_degraded) {
> > +		set_bit(MD_BROKEN, &conf->mddev->flags); =20
>=20
> Why not set BROKEN flags in err handler to align with other levels? Or
> do it in md_error only.

https://lore.kernel.org/linux-raid/3da9324e-01e7-2a07-4bcd-14245db56693@lin=
ux.dev/

You suggested that.
Other levels doesn't have dedicates has_failed() routines. For raid5 it
is reasonable to set it in has_failed().

I can't do that in md_error because I don't have such information in
all cases. !test_bit("Faulty", rdev->flags) result varies.

>=20
> > +		return true;
> > +	}
> > +	return false;
> >   }
> >  =20
> >   struct stripe_head *
> > @@ -2877,34 +2881,29 @@ static void raid5_error(struct mddev
> > *mddev, struct md_rdev *rdev) unsigned long flags;
> >   	pr_debug("raid456: error called\n");
> >  =20
> > +	pr_crit("md/raid:%s: Disk failure on %s, disabling
> > device.\n",
> > +		mdname(mddev), bdevname(rdev->bdev, b));
> > +
> >   	spin_lock_irqsave(&conf->device_lock, flags);
> > +	set_bit(Faulty, &rdev->flags);
> > +	clear_bit(In_sync, &rdev->flags);
> > +	mddev->degraded =3D raid5_calc_degraded(conf);
> >  =20
> > -	if (test_bit(In_sync, &rdev->flags) &&
> > -	    mddev->degraded =3D=3D conf->max_degraded) {
> > -		/*
> > -		 * Don't allow to achieve failed state
> > -		 * Don't try to recover this device
> > -		 */
> > +	if (has_failed(conf)) {
> >   		conf->recovery_disabled =3D
> > mddev->recovery_disabled;
> > -		spin_unlock_irqrestore(&conf->device_lock, flags);
> > -		return; =20
>=20
> Ok, I think commit fb73b357fb985cc652a72a41541d25915c7f9635 is
> effectively reverted by this hunk. So I would prefer to separate the
> revert part from this patch, just my 0.02$.

Song,
do you want revert?

Thanks,
Mariusz
