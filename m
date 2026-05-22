Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF582030A
	for <linux-raid@vger.kernel.org>; Fri, 22 May 2026 04:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779425901; cv=none; b=BBdOekeAzJnokcpGRI72HX2YsqMwlKG5nkqw9kKa+AoM6drNn5gMmAcWG3Bv9Nqt4G/S9JBqSdTKYdZxUmj3G+FCxrCAOCCJEIA2/KaQ53So4cTBAtTfd/J7Jt9NjgNguJsmzEv+NOAf8b7BDjH5LFEIvZWy3tws7m9uJh3qZKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779425901; c=relaxed/simple;
	bh=/FOz+Vu81gB3pnZ3NKZFq/XkrZ05c3Kx++ZM1B/1J+U=;
	h=Cc:Mime-Version:Date:References:Content-Type:In-Reply-To:To:From:
	 Subject:Message-Id; b=J2mytM3xH+8A6FDq6dyrvIzFib8qc+psGi+wWeYMQMOg8+laABZRGHhlqWh/eDKAGjBCjxFx38HvFnC99KXEuMu2/9sSTVw/TqeEZxQZcb6kT9+LakELKHhy0JT06EuQZWYMfku74R5dFANOhSeZmjrA/bD8Q74GsFLxQMHbuPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=HgqdD1Av; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="HgqdD1Av"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779425887;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=F5joeOKTMAzcxyAh1ZDjsP3i88477QztNVKQopcSfDM=;
 b=HgqdD1AvYAYI+jQ70ZNyQvbSaVOCJvsajFx9c48D0Dp4hVD89CEDcRrhIZrT9Em0gNqlS5
 y/u7nnZPQSy7xTG6oa1fKd5iDbuk2Hf3AP9PdHxtYETLKNrlsPnzFIbfmTS9rhbEKvHZ+6
 QFFO/P4yiC15mjyDqMm4XESlKSDxjFRdyQM84SyRNse/y+YY+zk49tM81Sx39JaQRsYRYa
 rBagAk0Z2JSHPd12JRroVdrwNzKN4Ge94kj2mSKIRwFouNPMuTf8KURW89iHqOdKz5edNf
 P0hmZUGZlkv/amCPuxFLLEA9+s/DKaJpPYQSkahpZQC7+4+JNvMXcLLfWaYvZQ==
Cc: <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Fri, 22 May 2026 12:58:04 +0800
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Date: Fri, 22 May 2026 12:58:02 +0800
References: <20260518123449.534287-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260518123449.534287-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a0fe25d+2d5c2c+vger.kernel.org+yukuai@fnnas.com>
Content-Language: en-US
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid5: cleanup reshape stripes when too many devices fail
Message-Id: <a8db05df-b7b5-4fed-bb3f-1b68f65e0989@fygo.io>

Hi,

=E5=9C=A8 2026/5/18 20:34, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> When a raid5/6 reshape is in progress and the array loses more than
> max_degraded devices, raid5_error() sets MD_BROKEN and MD_RECOVERY_INTR,
> but the reshape stripes reshape_request() handed out are never released.
> The "s.failed > conf->max_degraded" branch of handle_stripe() calls
> handle_failed_stripe() / handle_failed_sync() for user IO and resync,
> but has no equivalent for the expand case, so three kinds of stripes
> leak conf->reshape_stripes and mddev->recovery_active:
>
>    1. Destination stripes with skipped_disk =3D=3D 0: STRIPE_EXPANDING +
>       STRIPE_EXPAND_READY set, but on a broken array the normal
>       completion at "s.expanded && !reconstruct_state && s.locked =3D=3D =
0"
>       may never fire.
>
>    2. Destination stripes with skipped_disk =3D=3D 1: only STRIPE_EXPANDI=
NG
>       set, no STRIPE_HANDLE.  They sit idle in the cache waiting for
>       source data that can no longer be read; handle_stripe() is never
>       called on them directly.
>
>    3. Source stripes (STRIPE_EXPAND_SOURCE) hit the failure branch but
>       the bit is never cleared and the destinations they feed are never
>       released.
>
> md_do_sync() exits its main loop on MD_RECOVERY_INTR but then blocks
> forever at
>
>      wait_event(mddev->recovery_wait,
>                 !atomic_read(&mddev->recovery_active));
>
> A concurrent "echo frozen > sync_action" then blocks in
> stop_sync_thread() waiting for MD_RECOVERY_RUNNING to clear, and the
> array becomes unstoppable without a reboot.
>
> Reproducer:
>
>      DEVS=3D(/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf)
>      for i in 0 1 2 3 4; do
>          s=3D$(blockdev --getsz ${DEVS[$i]})
>          dmsetup create dust$i --table "0 $s dust ${DEVS[$i]} 0 4096"
>          dmsetup message dust$i 0 quiet
>      done
>      mdadm -C /dev/md0 -e 1.2 -l 5 -n 4 -c 64 --assume-clean \
>          /dev/mapper/dust{0..3}
>      for b in $(seq 0 8191); do
>          dmsetup message dust0 0 addbadblock $b
>          dmsetup message dust1 0 addbadblock $b
>      done
>      mdadm --manage /dev/md0 --add /dev/mapper/dust4
>      mdadm --grow /dev/md0 -n 5 --backup-file=3D/tmp/grow.backup &
>      while [[ $(cat /sys/block/md0/md/sync_action) !=3D reshape ]]; do
>          sleep 0.1
>      done
>      dmsetup message dust0 0 enable
>      dmsetup message dust1 0 enable
>      sleep 5
>      echo frozen > /sys/block/md0/md/sync_action     # hangs forever
>
> Before the fix, the two tasks deadlock against each other:
>
>      task:md0_reshape  state:D
>        schedule
>        md_do_sync.cold+0x818/0xc25       # wait_event(recovery_wait,
>        md_thread                         #            !recovery_active)
>        kthread
>
>      task:bash         state:D
>        schedule
>        stop_sync_thread+0x1a3/0x350      # wait_event(resync_wait,
>        action_store                      #            !MD_RECOVERY_RUNNIN=
G)
>        md_attr_store
>        kernfs_fop_write_iter
>        vfs_write
>        ksys_write
>
> After the fix handle_stripe() releases the leaked reshape stripes via
> the new handle_failed_reshape(), recovery_active drains to zero,
> md_do_sync() prints
>
>      md/raid:md0: Cannot continue operation (2/5 failed).
>      md: md0: reshape interrupted.
>
> clears MD_RECOVERY_RUNNING and returns; the "echo frozen" write
> returns in <1s; "mdadm --stop /dev/md0" completes normally and no
> task is left in D state.
>
> Fix it by adding handle_failed_reshape(), called from handle_stripe()
> when the failure branch fires on a reshape stripe.  If sh is a
> destination, the helper drops STRIPE_EXPANDING / STRIPE_EXPAND_READY,
> decrements conf->reshape_stripes, wakes wait_for_reshape and calls
> md_done_sync() to return the sectors reshape_request() accounted on
> recovery_active.  If sh is a source, the helper drops
> STRIPE_EXPAND_SOURCE and walks sh's non-parity data disks using the
> same raid5_compute_blocknr() / raid5_compute_sector() mapping
> handle_stripe_expansion() uses to forward data, looks up each matching
> destination with R5_GAS_NOBLOCK | R5_GAS_NOQUIESCE and applies the
> destination cleanup to it.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 91 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0d76e82f4506..f7d159b46a01 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4594,10 +4594,96 @@ static void handle_stripe_expansion(struct r5conf=
 *conf, struct stripe_head *sh)
>   		}
>   	/* done submitting copies, wait for them to complete */
>   	async_tx_quiesce(&tx);
>   }
>  =20
> +/*
> + * handle_failed_reshape - drop reshape state when too many devices have=
 failed
> + *
> + * Called from handle_stripe() in the "s.failed > conf->max_degraded" br=
anch
> + * when sh is participating in a reshape. raid5_error() has set MD_BROKE=
N
> + * and MD_RECOVERY_INTR); The reshape stripes that reshape_request() han=
ded out
> + * must be released, otherwise they leak conf->reshape_stripes and
> + * mddev->recovery_active, and md_do_sync() hangs forever at
> + * wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active=
)).
> + *
> + * Three kinds of stripes can reach this path:
> + *
> + *  1. Destination stripes with skipped_disk =3D 0 in reshape_request()
> + *     - the new stripe maps entirely past the old array end, so its
> + *     blocks are zero-filled in place without any source read.
> + *     STRIPE_EXPANDING, STRIPE_EXPAND_READY and STRIPE_HANDLE are all s=
et,
> + *     handle_stripe() sees them with s.expanded =3D=3D 1.
> + *
> + *  2. Destination stripes with skipped_disk =3D 1 - the new stripe
> + *     overlaps existing data and still needs source blocks copied in by
> + *     handle_stripe_expansion().  Only STRIPE_EXPANDING is set, *not*
> + *     STRIPE_HANDLE, so they sit idle in the stripe cache until a succe=
ssful
> + *     source expand re-handles them.  In the failure path no one ever d=
oes,
> + *     so handle_stripe() will never see them on its own; they are clean=
ed up
> + *     from the source side in step (b) below.
> + *
> + *  3. Source stripes (STRIPE_EXPAND_SOURCE) - reach handle_stripe() via=
 the
> + *     read-error path once the source members start returning EIO and
> + *     raid5_error() marks them Faulty.
> + *
> + * Handling:
> + *
> + *  (a) If STRIPE_EXPANDING is set on sh, clear it together with
> + *      STRIPE_EXPAND_READY, atomic_dec conf->reshape_stripes, wake
> + *      wait_for_reshape and md_done_sync(RAID5_STRIPE_SECTORS) to retur=
n
> + *      the sectors reshape_request() accounted on recovery_active.
> + *
> + *  (b) If STRIPE_EXPAND_SOURCE is set on sh, clear it and walk sh's
> + *      non-parity disks the same way handle_stripe_expansion() does
> + *      (raid5_compute_blocknr previous=3D1 -> raid5_compute_sector prev=
ious=3D0)
> + *      to find each destination, look it up with
> + *      R5_GAS_NOBLOCK | R5_GAS_NOQUIESCE and apply step (a) to it.
> + *      A NULL lookup means the destination never contributed to
> + *      reshape_stripes - nothing to release.
> + */
> +static void handle_failed_reshape(struct r5conf *conf, struct stripe_hea=
d *sh)
> +{
> +	int i;
> +
> +	if (test_and_clear_bit(STRIPE_EXPANDING, &sh->state)) {
> +		atomic_dec(&conf->reshape_stripes);
> +		wake_up(&conf->wait_for_reshape);
> +		md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf));
> +	}
> +
> +	clear_bit(STRIPE_EXPAND_READY, &sh->state);

I feel this is not that simple, can you first describe reshape sh lifetime
first? And then we can check in each state the handle is correct, for examp=
le:

After setting STRIPE_EXPAND_READY, and new writes submitted, the STRIPE_EXP=
ANDING
is cleared while STRIPE_EXPAND_READY is still set.

Normally if write succeed, the STRIPE_EXPAND_READY will be cleared, also
reshape_stripes and recovery_active counters will be decreased. However,
If the array is broken in this case, and above write failed, then is it pos=
sible
the sh will be analysed again and the above checking miss this case.

> +
> +	if (test_and_clear_bit(STRIPE_EXPAND_SOURCE, &sh->state)) {
> +		for (i =3D 0; i < sh->disks; i++) {
> +			int dd_idx;
> +			struct stripe_head *sh2;
> +			sector_t bn, sec;
> +
> +			if (i =3D=3D sh->pd_idx)
> +				continue;
> +			if (conf->level =3D=3D 6 && i =3D=3D sh->qd_idx)
> +				continue;
> +
> +			bn =3D raid5_compute_blocknr(sh, i, 1);
> +			sec =3D raid5_compute_sector(conf, bn, 0, &dd_idx, NULL);
> +			sh2 =3D raid5_get_active_stripe(conf, NULL, sec,
> +					R5_GAS_NOBLOCK | R5_GAS_NOQUIESCE);
> +			if (!sh2)
> +				continue;
> +			if (test_and_clear_bit(STRIPE_EXPANDING, &sh2->state)) {
> +				atomic_dec(&conf->reshape_stripes);
> +				wake_up(&conf->wait_for_reshape);
> +				md_done_sync(conf->mddev,
> +					     RAID5_STRIPE_SECTORS(conf));
> +			}
> +			clear_bit(STRIPE_EXPAND_READY, &sh2->state);
> +			raid5_release_stripe(sh2);
> +		}
> +	}
> +}
> +
>   static void analyse_stripe(struct stripe_head *sh, struct stripe_head_s=
tate *s)
>   {
>   	struct r5conf *conf =3D sh->raid_conf;
>   	int disks =3D sh->disks;
>   	struct r5dev *dev;
> @@ -5001,10 +5087,15 @@ static void handle_stripe(struct stripe_head *sh)
>   		break_stripe_batch_list(sh, 0);
>   		if (s.to_read+s.to_write+s.written)
>   			handle_failed_stripe(conf, sh, &s, disks);
>   		if (s.syncing + s.replacing)
>   			handle_failed_sync(conf, sh, &s);
> +		if (s.expanding || s.expanded) {
> +			handle_failed_reshape(conf, sh);
> +			s.expanding =3D 0;
> +			s.expanded =3D 0;
> +		}
>   	}
>  =20
>   	/* Now we check to see if any write operations have recently
>   	 * completed
>   	 */

--=20
Thansk,
Kuai
