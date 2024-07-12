Received: from forward500d.mail.yandex.net (forward500d.mail.yandex.net [178.154.239.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3AD512;
	Fri, 12 Jul 2024 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720786317; cv=none; b=iu2dmp9ktE4xCs40B8ynJnM/vJuBjOlevfBJ4/qHpyl2lHC4GPoa+qzr3GcEk4QyBK7d+7sP7XZBjiMlpPIvTTeEC4SuvCNnRFCi0l0ClAc81+LNj2XRaOW4YMFEsmImd9WpU00x0do/u2m1CWpR9jH7Ogb7ZYelndq2UtD4wUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720786317; c=relaxed/simple;
	bh=lbepUqJQH1HG/AU4fHTXjtEDbHlzy4/Dxv4+YpO0OX8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dzkn85ZNf0cH9mXobkNDxfdDReFHdm/mp4hD27vxt4vu+DhFH6fcU6tWhSwkIYju8XXPCtk/gAKRf04jtJIG5TGkc1aEuAh/KJwZB26ZnaPcR0yhIj1cyYc8FrQn9tXuj+/D6EX5w7rbyBf/CqeDKtEEouIrazlvbac3Srwuy4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=NJ4se4Hd; arc=none smtp.client-ip=178.154.239.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="NJ4se4Hd"
Received: from mail-nwsmtp-smtp-production-main-45.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-45.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:8727:0:640:c3e5:0])
	by forward500d.mail.yandex.net (Yandex) with ESMTPS id BCD4460FB9;
	Fri, 12 Jul 2024 15:11:44 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-45.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id gBfTHN9vMqM0-S7Pw1iKM;
	Fri, 12 Jul 2024 15:11:44 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1720786304; bh=T/uuLDxBG8EFU4C+k5A0E+zLwx//O11hgx8tBHr0oLM=;
	h=In-Reply-To:Date:References:To:From:Subject:Message-ID;
	b=NJ4se4Hdfl0AWFMwXjKTCSidwvx9SMSGuVXsPy+qxFXokpgMkkVdCkNG4I9NCMZGD
	 Hk+pCeflfTRSYTtU7DovPbMYz2nNjkwsH2AXrPRTCB8S5r+lrHhxwDd2YRkL0ucsF1
	 /kbRXqwj/Y14tfFNg+N5typjEq1XCjImKgv/mfDA=
Authentication-Results: mail-nwsmtp-smtp-production-main-45.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under
 load
From: Konstantin Kharlamov <Hi-Angel@yandex.ru>
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "yukuai (C)"
	 <yukuai3@huawei.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>
Date: Fri, 12 Jul 2024 15:11:42 +0300
In-Reply-To: <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
	 <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-07-12 at 16:35 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2024/07/12 14:53, Konstantin Kharlamov =E5=86=99=E9=81=93:
>
> > # Steps to reproduce
> >
> > 1. Create raid5 LV + VDO by executing a `./mk_lvm_raid5.sh
> > /dev/sdX1
> > /dev/sdY1 /dev/sdZ1` where `mk_lvm_raid5.sh` has the following
> > content:
> >
> > =C2=A0=C2=A0=C2=A0=C2=A0 #!/bin/bash
> >
> > =C2=A0=C2=A0=C2=A0=C2=A0 set -exu
> >
> > =C2=A0=C2=A0=C2=A0=C2=A0 if [ "$#" -ne 3 ]; then
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo "Wrong number of =
parameters.
> > =C2=A0=C2=A0=C2=A0=C2=A0 Usage: $(basename $0) disk1 disk2 disk3"
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exit 1
> > =C2=A0=C2=A0=C2=A0=C2=A0 fi
> >
> > =C2=A0=C2=A0=C2=A0=C2=A0 # create the VG
> > =C2=A0=C2=A0=C2=A0=C2=A0 pvcreate -f "$1" "$2" "$3"
> > =C2=A0=C2=A0=C2=A0=C2=A0 vgcreate p_r5 "$1" "$2" "$3"
> >
> > =C2=A0=C2=A0=C2=A0=C2=A0 # create the LV
> > =C2=A0=C2=A0=C2=A0=C2=A0 lvcreate --type raid5 -i 2 -L 21474836480b -I =
64K -n
> > vdo_internal_deco_vol p_r5 -y
> > =C2=A0=C2=A0=C2=A0=C2=A0 lvconvert -y --type vdo-pool --virtualsize 107=
374182400B -n
> > deco_vol p_r5/vdo_internal_deco_vol
> >
> > 2. Start load by executing `fio ./fio-30%write.fio` with the `fio-
> > 30%write.fio` having the following content:
> >
> > =C2=A0=C2=A0=C2=A0=C2=A0 [test IOPS]
> > =C2=A0=C2=A0=C2=A0=C2=A0 blocksize=3D8k
> > =C2=A0=C2=A0=C2=A0=C2=A0 filename=3D/dev/p_r5/deco_vol
> > =C2=A0=C2=A0=C2=A0=C2=A0 filesize=3D100G
> > =C2=A0=C2=A0=C2=A0=C2=A0 direct=3D1
> > =C2=A0=C2=A0=C2=A0=C2=A0 buffered=3D0
> > =C2=A0=C2=A0=C2=A0=C2=A0 ioengine=3Dlibaio
> > =C2=A0=C2=A0=C2=A0=C2=A0 iodepth=3D32
> > =C2=A0=C2=A0=C2=A0=C2=A0 rw=3Drandrw
> > =C2=A0=C2=A0=C2=A0=C2=A0 rwmixwrite=3D30
> > =C2=A0=C2=A0=C2=A0=C2=A0 numjobs=3D4
> > =C2=A0=C2=A0=C2=A0=C2=A0 group_reporting
> > =C2=A0=C2=A0=C2=A0=C2=A0 time_based
> > =C2=A0=C2=A0=C2=A0=C2=A0 runtime=3D99h
> > =C2=A0=C2=A0=C2=A0=C2=A0 clat_percentiles=3D0
> > =C2=A0=C2=A0=C2=A0=C2=A0 unlink=3D1
> >
> > 3. Wait for about a minute
> > 4. Remove a disk of the volume group, either physically, or by
> > turning
> > off jbod slot's power (DO NOT use /=E2=80=A6/device/delete).
>
> Looks like this is because IO is failed from raid level, and then dm
> level keep retry this IO(This will be related to the step 4), hence
> raid5d stuck in the loop to hanlde new IO.
>
> Can you give the following patch a test to confirm this?
>
> Thanks!
> Kuai
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c14cf2410365..a0f784cd664c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6776,7 +6776,9 @@ static void raid5d(struct md_thread *thread)
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 while ((bio =3D remove_bio_from_retry(conf, &offse=
t)))
> {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in=
t ok;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sp=
in_unlock_irq(&conf->device_lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cond_resched()=
;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ok=
 =3D retry_aligned_read(conf, bio, offset);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sp=
in_lock_irq(&conf->device_lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (!ok)
> @@ -6790,11 +6792,11 @@ static void raid5d(struct md_thread *thread)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 br=
eak;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 handled +=3D batch_size;
>
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_ir=
q(&conf->device_lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 spin_unlock_irq(&conf->device_lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md=
_check_recovery(mddev);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irq(=
&conf->device_lock);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 cond_resched();
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 spin_lock_irq(&conf->device_lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_debug("%d stripes han=
dled\n", handled);

Thank you for the quick answer! FTR, I had applied the diff by manually
editing the code because tabs got converted to spaces in the text, so
it wasn't applicable. Hopefully I got everything correct. (in
retrospection, I could've used `--ignore-whitespace`. Oh, well=E2=80=A6)

So, there are both good and bad news.

Good news: you diff seems to have fixed the problem! I would have to
test more extensively in another environment to be completely sure, but
by following the minimal steps-to-reproduce I can no longer reproduce
the problem, so it seems to have fixed the problem.

Bad news: there's a new lockup now =F0=9F=98=84 This one seems to happen af=
ter
the disk is returned back; unless the action of returning back matches
accidentally the appearing stacktraces, which still might be possible
even though I re-tested multiple times. It's because the traces=20
(below) seems not to always appear. However, even when traces do not
appear, IO load on the fio that's running in the background drops to
zero, so something seems definitely wrong.

    [  475.353727] sd 0:0:25:0: [sdbu] Attached SCSI disk
    [  615.173084] INFO: task dm-vdo0:bioQ0:11500 blocked for more than 122=
 seconds.
    [  615.173326]       Not tainted 6.9.8-bstrg #4
    [  615.173525] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
    [  615.173735] task:dm-vdo0:bioQ0   state:D stack:0     pid:11500 tgid:=
11500 ppid:2      flags:0x00004000
    [  615.173961] Call Trace:
    [  615.174180]  <TASK>
    [  615.174402]  __schedule+0x376/0xb30
    [  615.174636]  schedule+0x2f/0x110
    [  615.174862]  schedule_timeout+0x15a/0x170
    [  615.175092]  ? _raw_spin_unlock_irqrestore+0x1e/0x40
    [  615.175326]  ? __wake_up+0x40/0x60
    [  615.175563]  wait_woken+0x73/0x80
    [  615.175793]  raid5_make_request+0x5dc/0x12f0 [raid456]
    [  615.176033]  ? kmem_cache_alloc+0x4e/0x2f0
    [  615.176257]  ? __pfx_woken_wake_function+0x10/0x10
    [  615.176496]  md_handle_request+0x15e/0x2a0
    [  615.176730]  raid_map+0x31/0x60 [dm_raid]
    [  615.176966]  __map_bio+0x181/0x1b0
    [  615.177203]  dm_submit_bio+0x194/0x550
    [  615.177440]  __submit_bio+0x97/0x130
    [  615.177680]  submit_bio_noacct_nocheck+0x18c/0x3c0
    [  615.177925]  submit_data_vio+0xba/0x100
    [  615.178171]  work_queue_runner+0x215/0x290
    [  615.178416]  ? __pfx_autoremove_wake_function+0x10/0x10
    [  615.178664]  ? __pfx_work_queue_runner+0x10/0x10
    [  615.178914]  kthread+0xff/0x130
    [  615.179168]  ? __pfx_kthread+0x10/0x10
    [  615.179422]  ret_from_fork+0x30/0x50
    [  615.179687]  ? __pfx_kthread+0x10/0x10
    [  615.179947]  ret_from_fork_asm+0x1a/0x30
    [  615.180215]  </TASK>
    [  615.180475] INFO: task dm-vdo0:bioQ1:11501 blocked for more than 122=
 seconds.
    [  615.180750]       Not tainted 6.9.8-bstrg #4
    [  615.181028] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
    [  615.181319] task:dm-vdo0:bioQ1   state:D stack:0     pid:11501 tgid:=
11501 ppid:2      flags:0x00004000
    [  615.181624] Call Trace:
    [  615.181926]  <TASK>
    [  615.182228]  __schedule+0x376/0xb30
    [  615.182529]  schedule+0x2f/0x110
    [  615.182821]  schedule_timeout+0x15a/0x170
    [  615.183117]  ? _raw_spin_unlock_irqrestore+0x1e/0x40
    [  615.183410]  ? __wake_up+0x40/0x60
    [  615.183701]  wait_woken+0x73/0x80
    [  615.183987]  raid5_make_request+0x5dc/0x12f0 [raid456]
    [  615.184280]  ? mempool_alloc+0x61/0x1b0
    [  615.184565]  ? kmem_cache_alloc+0x4e/0x2f0
    [  615.184845]  ? __pfx_woken_wake_function+0x10/0x10
    [  615.185126]  md_handle_request+0x15e/0x2a0
    [  615.185402]  raid_map+0x31/0x60 [dm_raid]
    [  615.185695]  __map_bio+0x181/0x1b0
    [  615.185979]  dm_submit_bio+0x194/0x550
    [  615.186255]  __submit_bio+0x97/0x130
    [  615.186529]  submit_bio_noacct_nocheck+0x18c/0x3c0
    [  615.186804]  submit_data_vio+0xba/0x100
    [  615.187076]  work_queue_runner+0x215/0x290
    [  615.187350]  ? __pfx_autoremove_wake_function+0x10/0x10
    [  615.187628]  ? __pfx_work_queue_runner+0x10/0x10
    [  615.187905]  kthread+0xff/0x130
    [  615.188180]  ? __pfx_kthread+0x10/0x10
    [  615.188456]  ret_from_fork+0x30/0x50
    [  615.188729]  ? __pfx_kthread+0x10/0x10
    [  615.189002]  ret_from_fork_asm+0x1a/0x30
    [  615.189276]  </TASK>
    [  615.189541] INFO: task dm-vdo0:bioQ3:11504 blocked for more than 122=
 seconds.
    [  615.189823]       Not tainted 6.9.8-bstrg #4
    [  615.190102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
    [  615.190392] task:dm-vdo0:bioQ3   state:D stack:0     pid:11504 tgid:=
11504 ppid:2      flags:0x00004000
    [  615.190694] Call Trace:
    [  615.190989]  <TASK>
    [  615.191283]  __schedule+0x376/0xb30
    [  615.191580]  schedule+0x2f/0x110
    [  615.191875]  schedule_timeout+0x15a/0x170
    [  615.192168]  ? _raw_spin_unlock_irqrestore+0x1e/0x40
    [  615.192463]  ? __wake_up+0x40/0x60
    [  615.192757]  wait_woken+0x73/0x80
    [  615.193057]  raid5_make_request+0x5dc/0x12f0 [raid456]
    [  615.193365]  ? mempool_alloc+0x61/0x1b0
    [  615.193663]  ? kmem_cache_alloc+0x4e/0x2f0
    [  615.193961]  ? __pfx_woken_wake_function+0x10/0x10
    [  615.194257]  md_handle_request+0x15e/0x2a0
    [  615.194548]  raid_map+0x31/0x60 [dm_raid]
    [  615.194836]  __map_bio+0x181/0x1b0
    [  615.195114]  dm_submit_bio+0x194/0x550
    [  615.195386]  __submit_bio+0x97/0x130
    [  615.195657]  submit_bio_noacct_nocheck+0x18c/0x3c0
    [  615.195932]  submit_data_vio+0xba/0x100
    [  615.196206]  work_queue_runner+0x215/0x290
    [  615.196488]  ? __pfx_autoremove_wake_function+0x10/0x10
    [  615.196767]  ? __pfx_work_queue_runner+0x10/0x10
    [  615.197044]  kthread+0xff/0x130
    [  615.197321]  ? __pfx_kthread+0x10/0x10
    [  615.197596]  ret_from_fork+0x30/0x50
    [  615.197868]  ? __pfx_kthread+0x10/0x10
    [  615.198141]  ret_from_fork_asm+0x1a/0x30
    [  615.198415]  </TASK>
