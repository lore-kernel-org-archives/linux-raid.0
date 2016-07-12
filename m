From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH RFC] md/raid1: fix deadlock between freeze_array() and wait_barrier().
Date: Wed, 13 Jul 2016 08:14:01 +1000
Message-ID: <87d1miec7q.fsf@notabene.neil.brown.name>
References: <CAGRgLy6RcG0_DYbd89LK0fWSJkMgqmDYn8ug7pYn+4uRqDRGqg@mail.gmail.com> <87poqpf23c.fsf@notabene.neil.brown.name> <CAGRgLy4UgT_gGHL=Lx_By1fqmE4Q4pwvbhBTh0J+u=9gxuQOYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4UgT_gGHL=Lx_By1fqmE4Q4pwvbhBTh0J+u=9gxuQOYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: =?utf-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@redhat.com>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12 2016, Alexander Lyakas wrote:

> Hello Neil,
>
> Thank you for your response. I read an email about you retiring from
> MD/mdadm maintenance and delegating mdadm maintenance to Jes Sorensen.
> But I was wondering who will be responsible for MD maintenance, and
> was about to send an email asking that.

Yes, I no longer have maintainership responsibilities, though I'm still
involved to some extent.  Jes Sorensen is looking after mdadm and
Shaohua Li is looking after the kernel driver (as listed in MAINTAINERS).


>
> On Fri, Jul 8, 2016 at 2:41 AM, NeilBrown <neilb@suse.com> wrote:
>> On Mon, Jun 27 2016, Alexander Lyakas wrote:
>>
>>> When we call wait_barrier, we might have some bios waiting
>>> in current->bio_list, which prevents the array_freeze call to
>>> complete. Those can only be internal READs, which have already
>>> passed the wait_barrier call (thus incrementing nr_pending), but
>>> still were not submitted to the lower level, due to generic_make_request
>>> logic to avoid recursive calls. In such case, we have a deadlock:
>>> - array_frozen is already set to 1, so wait_barrier unconditionally wai=
ts, so
>>> - internal READ bios will not be submitted, thus freeze_array will
>>> never completes
>>>
>>> This problem was originally fixed in commit:
>>> d6b42dc md/raid1,raid10: avoid deadlock during resync/recovery.
>>>
>>> But then it was broken in commit:
>>> b364e3d raid1: Add a field array_frozen to indicate whether raid in
>>> freeze state.
>>
>> Thanks for the great analysis.
>> I think this primarily a problem in generic_make_request().  It queues
>> requests in the *wrong* order.
>>
>> Please try the patch from
>>   https://lkml.org/lkml/2016/7/7/428
>>
>> and see if it helps.  If two requests for a raid1 are in the
>> generic_make_request queue, this patch causes the sub-requests created
>> by the first to be handled before the second is attempted.
> I have read this discussion and more or less (probably less than more)
> understood that the second patch by Lars is supposed to address our
> issue. However, we cannot easily apply that patch:
> - The patch is based on structures added by earlier patch "[RFC]
> block: fix blk_queue_split() resource exhaustion".
> - Both patches are not in the mainline tree yet.
> - Both patches are in block core, which requires to recompile the whole k=
ernel.
> - Not sure if these patches are applicable for our production kernel
> 3.18 (long term)
>
> I am sure you understand that for production with our current kernel
> 3.18 (long term) we cannot go with these two patches.

This patch takes the basic concept of those two and applies it just to
raid1 and raid10.  I think it should be sufficient.  Can you test?  The
patch is against 3.18

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 40b35be34f8d..99208aa2c1c8 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1229,7 +1229,7 @@ read_again:
 				sectors_handled;
 			goto read_again;
 		} else
=2D			generic_make_request(read_bio);
+			bio_list_add_head(current->bio_list, read_bio);
 		return;
 	}
=20
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 32e282f4c83c..c528102b80b6 100644
=2D-- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1288,7 +1288,7 @@ read_again:
 				sectors_handled;
 			goto read_again;
 		} else
=2D			generic_make_request(read_bio);
+			bio_list_add_head(&current->bio_list, read_bio);
 		return;
 	}
=20

>
> Since this issue is a real deadlock we are hitting in a long-term 3.18
> kernel, is there any chance for cc-stable fix? Currently we applied
> the rudimentary fix  I posted. It basically switches context for
> problematic RAID1 READs, and runs them from a different context. With
> this fix we don't see the deadlock anymore.
>
> Also, can you please comment on another concern I expressed:
> freeze_array() is now not reentrant. Meaning that if two threads call
> it in parallel (and it could happen for the same MD), the first thread
> calling unfreeze_array will mess up things for the second thread.

Yes, that is a regression.  This should be enough to fix it.  Do you
agree?

Thanks,
NeilBrown


diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 40b35be34f8d..5ad25c7d7453 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -984,7 +984,7 @@ static void freeze_array(struct r1conf *conf, int extra)
 	 * we continue.
 	 */
 	spin_lock_irq(&conf->resync_lock);
=2D	conf->array_frozen =3D 1;
+	conf->array_frozen +=3D 1;
 	wait_event_lock_irq_cmd(conf->wait_barrier,
 				conf->nr_pending =3D=3D conf->nr_queued+extra,
 				conf->resync_lock,
@@ -995,7 +995,7 @@ static void unfreeze_array(struct r1conf *conf)
 {
 	/* reverse the effect of the freeze */
 	spin_lock_irq(&conf->resync_lock);
=2D	conf->array_frozen =3D 0;
+	conf->array_frozen -=3D 1;
 	wake_up(&conf->wait_barrier);
 	spin_unlock_irq(&conf->resync_lock);
 }

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXhWuqAAoJEDnsnt1WYoG5YA0P/R16myQS/GTirFKyryY2TVHM
eZlLE5zOEWA65LDi4G5+qxokfciftzBRLTMJl74d8SzgbbLo7xQ13wmnQj3+aoAi
sAgINQwBD8Sbd+bWc6dN2hVhMV79Rm56er2Y9YyVPiFrUdew6aBJivGfjnUrs9PM
90DL4ZSrpmbPrafyZvDgXsbzK89dT+4/gKkia9EMbP6Pi01s+D9vFnuxhqHH0Ogd
VDu2KrVjemayrZWaDoximM+A+N+iyRMjHazrnMzQiDIJnrtg9+9SYZJ7fJs5ny4M
VzENlF1wbqWCIVCopzJidADZfXtX3U2bdjFOXwpQL1lOdccTowjPABX1GBoKzBTl
KlpIQTj8UPcawrJ/QtS0t+Iifbv8/JNoHLJgMm2T0k0EIG9laenMi9JyQECqC107
kyi/vNadr4aM9YrYlF+jEF/+CJ18QRSjKpYGqws9SfH/k81JOPkcrWdHYzqTKPtF
gQifyM+76P6NwWN0iVkWnjPTmhO+Qmt2zn2PMV2kf7HoytgGZvyXBu2ai+STyj2V
GIooooTj49Mq0Daeim8eXx/plEwfTlSDPz2i48UNJ1Nj6AXIcic03gYwiWJT2uP5
515yNH4x3b8txOYntsTbH2LUovCD5DJr7/jkvEJdnLcIHVYi5S2ymoLHNGWCQmRT
IIVDaNILjr9kmbTmjdfy
=6Hik
-----END PGP SIGNATURE-----
--=-=-=--
