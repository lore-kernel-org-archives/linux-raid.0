Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793636442;
	b=TYDDqWv1KhoxRHgcM0y+BkTviImOcSeCfo8lSbWT0bkBXqLq/D+etiInn2fa05ksozSU
	 8T7ED20/Tt/ABClsyRk7/Kmx2VZTGyo0ZtJJeEtd2tSov2Ri877NzqnfQfp8NVDtumzAH
	 sULe3CKeoG3JR7ngIjTQzwqXHfK281XKzJRVjO1qmndb8tZQYPxd/jC18vGln4yJy022H
	 CVLH69djCCjvuM03ROm0SXCaZsLKmpWxo3u7XQNBaNVooO3tNLK8EMpsnX/J4SPEc9er4
	 yMi4YFB6s2IVhL7onsCFksnJGAy4IdFCmZXzlyTW2UMyic4IFlMcowJS6yI9xUzRvuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793636442;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vhKg+pPQERLt9aQzzC2HGlTOuEoPW93kdVTfIEYOuIc=;
	b=J9PTI5F86DdCW2waRXfc3njRUKucWxaPov/zQWk6n3dDVDY5o9bK1xWiMODJmiIRBtQp
	 djlvErA4e2zXFHai9vq+8+G4BuQYl2mbgDlU6mU9OEnCPt7Rxbvz5Fs3sx5lua8EGLmnW
	 o+S7xDyyDRJp0gJYUl2YDJXSDYLvUdN9xN98fqhKXVRq4tLlsp4O11jY/0COD2xDntXs+
	 wzLtOhpyh17nBwRQnZ7PXhME+9yC7AeFvAXhUuk06XzZ1+mNAP6861/WtkjPYfwKOixxt
	 nnx+tUbh+LJJxtQhzPTiPIlaWqZCyRgo52FZzf62Rw4guK3HMUt90p3A33AKktO47uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h4tMcj16;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F55A60716D2
	for <linux-raid@vger.kernel.org>; Mon,  2 Nov 2026 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h4tMcj16
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AF11F00A1C;
	Mon,  2 Nov 2026 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793636442;
	bh=vhKg+pPQERLt9aQzzC2HGlTOuEoPW93kdVTfIEYOuIc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h4tMcj169GC7z1jDSD9++3BcHvX1UobC7l82YajhxlhGfa62vFsekvM4kN9bhJxYf
	 FYWCOF4nlMiDrBLGAAHoRIRWb+ViSY5DV0wlynXGxynY14APRyYBTBjA7+JLqMEBbU
	 y0lF/FV2c7768UBocnZ4RxqNe4GoYBQbsPdVfJ3qVcyE6YoJaynb51ANVdQzVuL2rq
	 2u8BNbUNagGqQcTQe7THeO0Lk1A99KypDnaMv2XmJITaOKrrySuzu5GHR9kAhdNvM0
	 PnEe7B55yAgrx03x8qhhzbd7IExXg1Q5AXMUWSH0PZNYcLN6M9j+wxSgIIYz5YjhLz
	 8OCjp8jgsNMZg==
Message-ID: <sashiko-outbox-193747@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/1] md: freeze the queue in mddev_suspend()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <20261102154847.198472-2-jinpu.wang@ionos.com>
References: <20261102154847.198472-1-jinpu.wang@ionos.com>
 <20261102154847.198472-2-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:20:41 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] md: deadlock in raid1d() and raid10d() due to queue freeze in mdde=
v_suspend()
- [High] md: deadlock in mddev_freeze_queue() when reshape is interrupted d=
uring wait
--

commit bc4b2b2abc71e036c550ab67e56cbc50b4eb867f
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: freeze the queue in mddev_suspend()

This commit freezes the request queue in mddev_suspend() and unfreezes it in
__mddev_resume() so that bios submitted while the array is suspended block =
in
bio_queue_enter() without holding q_usage_counter, avoiding a deadlock with
concurrent queue_attr_store() limits updates.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..29737a624844a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -472,6 +472,42 @@ static void md_submit_bio(struct bio *bio)
>  	md_handle_request(mddev, bio);
>  }
> =20
> +/*
> + * Freeze the queue so a concurrent blk_mq_freeze_queue() (e.g. a limits
> + * update) can't wait on a bio parked in md_handle_request() while suspe=
nded.
> + * Skip the drain wait when parked bios hold a reference and only progre=
ss
> + * after suspend: the suspend_lo/hi window, or an interrupted raid456 re=
shape.
> + * Resume may run in another task, hence the non_owner variants.
> + */
> +static int mddev_freeze_queue(struct mddev *mddev, bool interruptible)
> +{
> +	struct request_queue *q;
> +
> +	if (mddev_is_dm(mddev))
> +		return 0;
> +
> +	q =3D mddev->gendisk->queue;
> +	blk_freeze_queue_start_non_owner(q);
> +
> +	if (READ_ONCE(mddev->suspend_lo) < READ_ONCE(mddev->suspend_hi) ||
> +	    (mddev->pers && mddev->pers->prepare_suspend &&
> +	     reshape_interrupted(mddev)))
> +		return 0;
> +
> +	if (!interruptible) {
> +		blk_mq_freeze_queue_wait(q);
> +		return 0;
> +	}
> +	return wait_event_interruptible(q->mq_freeze_wq,
> +			percpu_ref_is_zero(&q->q_usage_counter));
> +}

[Severity: High]
Could this wait in mddev_freeze_queue() deadlock if a RAID456 reshape is
interrupted or frozen after the initial reshape_interrupted(mddev) check
passes, while an unsplit bio is already inside md_handle_request()?

Consider an active RAID456 reshape where reshape_interrupted(mddev) is
initially false and an unsplit bio enters:

__submit_bio()
  bio_queue_enter() /* acquires q->q_usage_counter */
  md_submit_bio()
    md_handle_request()
      raid5_make_request()

If mddev_suspend() runs concurrently (for example via suspend_lo_store() or
suspend_hi_store(), which do not hold reconfig_mutex), mddev_freeze_queue()
sees reshape_interrupted(mddev) =3D=3D false and blocks waiting for
q->q_usage_counter to reach zero before mddev_suspend() reaches
percpu_ref_kill(&mddev->active_io) or mddev->pers->prepare_suspend(mddev).

If the reshape is then interrupted or frozen while mddev_freeze_queue() is
waiting (for example via action_store() setting MD_RECOVERY_FROZEN or
MD_RECOVERY_INTR, or md_error() setting MD_RECOVERY_INTR on a disk failure),
make_stripe_request() sees reshape_interrupted(mddev) =3D=3D true and retur=
ns
STRIPE_WAIT_RESHAPE:

drivers/md/raid5.c:raid5_make_request() {
	...
	if (res =3D=3D STRIPE_WAIT_RESHAPE) {
		...
		if (split) {
			submit_bio_noacct(front_bio);
			return true;
		}
		return false;
	}
}

For an unsplit bio, raid5_make_request() returns false to md_handle_request=
():

drivers/md/md.c:md_handle_request() {
	...
	if (!mddev->pers->make_request(mddev, bio)) {
		percpu_ref_put(&mddev->active_io);
		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
			return false;
		goto check_suspended;
	}
}

Previously, mddev_suspend() killed mddev->active_io first, so dropping
mddev->active_io allowed mddev_suspend() to finish while the bio parked in
check_suspended. With the queue freeze wait happening first, the bio loops
back to check_suspended inside md_handle_request() without exiting
md_submit_bio() or dropping q->q_usage_counter (and busy-loops because
mddev->active_io has not been killed yet), or sleeps in conf->wait_for_resh=
ape
because prepare_suspend() has not been called, so q->q_usage_counter never
drains.

> +
> +static void mddev_unfreeze_queue(struct mddev *mddev)
> +{
> +	if (!mddev_is_dm(mddev))
> +		blk_mq_unfreeze_queue_non_owner(mddev->gendisk->queue);
> +}
> +
>  /*
>   * Make sure no new requests are submitted to the device, and any reques=
ts that
>   * have been submitted are completely handled.
> @@ -500,6 +536,13 @@ int mddev_suspend(struct mddev *mddev, bool interrup=
tible)
>  		return 0;
>  	}
> =20
> +	err =3D mddev_freeze_queue(mddev, interruptible);
> +	if (err) {
> +		mddev_unfreeze_queue(mddev);
> +		mutex_unlock(&mddev->suspend_mutex);
> +		return err;
> +	}
> +
>  	percpu_ref_kill(&mddev->active_io);

[Severity: High]
Does freezing mddev->gendisk->queue before mddev->active_io drains cause a
deadlock with raid1d() and raid10d() when handling read errors?

For bio-based MD devices, __submit_bio() drops q->q_usage_counter in
blk_queue_exit() as soon as md_submit_bio() returns, while the cloned
r1_bio->master_bio or r10_bio->master_bio (allocated from mddev->io_clone_s=
et
by md_account_bio()) keeps holding a reference on mddev->active_io until the
underlying member-disk read completes.

If mddev_suspend() is called while a read bio is in flight on a member disk:
1. mddev_freeze_queue() sees q->q_usage_counter is already zero and returns
   with mddev->gendisk->queue frozen.
2. mddev_suspend() kills mddev->active_io and blocks in wait_event() waiting
   for percpu_ref_is_zero(&mddev->active_io).
3. The member-disk read fails, and raid1d() or raid10d() runs
   handle_read_error() -> raid1_read_request() / raid10_read_request() using
   the md_io_clone master_bio:

drivers/md/raid1.c:raid1_read_request() {
	...
	if (max_sectors < bio_sectors(bio)) {
		bio =3D bio_submit_split_bioset(bio, max_sectors,
					      &conf->bio_split);
	...
}

If the surviving mirror has a smaller max_sectors (for example, due to bad
blocks), bio_submit_split_bioset() splits the md_io_clone bio and calls
submit_bio_noacct_nocheck() on the remainder targeting the MD device.

Commit 7b15c24f8053 ("md: don't hang mddev_suspend() on resubmitted bios")
added the md_cloned_bio() check in md_handle_request() so that resubmitted
md_io_clone bios from raid1d() or raid10d() would bypass the suspend wait a=
nd
allow mddev->active_io to drain:

drivers/md/md.c:md_handle_request() {
check_suspended:
	if (unlikely(md_cloned_bio(mddev, bio))) {
		/*
		 * This bio is an MD cloned bio and already holds an
		 * active_io reference, so percpu_ref_get() is safe here.
		 */
		percpu_ref_get(&mddev->active_io);
	} else {
	...
}

However, because raid1d() and raid10d() run with current->bio_list =3D=3D N=
ULL,
submit_bio_noacct_nocheck() synchronously calls __submit_bio() ->
bio_queue_enter() on the frozen MD queue and blocks on q->mq_freeze_wq befo=
re
reaching md_submit_bio() and md_handle_request(). Won't raid1d() or raid10d=
()
wait forever for the queue to be unfrozen by __mddev_resume(), while
mddev_suspend() waits forever for the split md_io_clone bio to complete and
drop mddev->active_io?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102154847.1984=
72-1-jinpu.wang@ionos.com?part=3D1
