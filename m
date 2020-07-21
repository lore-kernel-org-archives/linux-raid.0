From: Nigel Croxon <ncroxon@redhat.com>
Subject: Re: [PATCH 1/1] md/raid10: avoid deadlock on recovery.
Date: Tue, 21 Jul 2020 10:26:35 -0400
Message-ID: <D5A36675-8344-4D67-9836-64F9BA78D78E@redhat.com>
References: <1583259280-124995-1-git-send-email-vmayatskikh@digitalocean.com>
 <1583259280-124995-2-git-send-email-vmayatskikh@digitalocean.com>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1583259280-124995-2-git-send-email-vmayatskikh@digitalocean.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vitaly Mayatskikh <vmayatskikh@digitalocean.com>
Cc: linux-raid@vger.kernel.org, Song Liu <liu.song.a23@gmail.com>
List-Id: linux-raid.ids


> On Mar 3, 2020, at 1:14 PM, Vitaly Mayatskikh =
<vmayatskikh@digitalocean.com> wrote:
>=20
> When disk failure happens and the array has a spare drive, resync =
thread
> kicks in and starts to refill the spare. However it may get blocked by
> a retry thread that resubmits failed IO to a mirror and itself can get
> blocked on a barrier raised by the resync thread.
>=20
> Signed-off-by: Vitaly Mayatskikh <vmayatskikh@digitalocean.com>
> ---
> drivers/md/raid10.c | 14 +++++++++++---
> 1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index ec136e4..f1a8e26 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -980,6 +980,7 @@ static void wait_barrier(struct r10conf *conf)
> {
> 	spin_lock_irq(&conf->resync_lock);
> 	if (conf->barrier) {
> +		struct bio_list *bio_list =3D current->bio_list;
> 		conf->nr_waiting++;
> 		/* Wait for the barrier to drop.
> 		 * However if there are already pending
> @@ -994,9 +995,16 @@ static void wait_barrier(struct r10conf *conf)
> 		wait_event_lock_irq(conf->wait_barrier,
> 				    !conf->barrier ||
> 				    (atomic_read(&conf->nr_pending) &&
> -				     current->bio_list &&
> -				     =
(!bio_list_empty(&current->bio_list[0]) ||
> -				      =
!bio_list_empty(&current->bio_list[1]))),
> +				     bio_list &&
> +				     (!bio_list_empty(&bio_list[0]) ||
> +				      !bio_list_empty(&bio_list[1]))) ||
> +				     /* move on if recovery thread is
> +				      * blocked by us
> +				      */
> +				     (conf->mddev->thread->tsk =3D=3D =
current &&
> +				      test_bit(MD_RECOVERY_RUNNING,
> +					       &conf->mddev->recovery) =
&&
> +				      conf->nr_queued > 0),
> 				    conf->resync_lock);
> 		conf->nr_waiting--;
> 		if (!conf->nr_waiting)
> =E2=80=94=20
> 1.8.3.1
>=20

Song, Have you had a chance to look at this patch?
We would like to have it pulled in to the kernel.

-Nigel
