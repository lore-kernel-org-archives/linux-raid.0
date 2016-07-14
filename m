From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH RFC] md/raid1: fix deadlock between freeze_array() and wait_barrier().
Date: Fri, 15 Jul 2016 09:18:25 +1000
Message-ID: <87lh13dd1a.fsf@notabene.neil.brown.name>
References: <CAGRgLy6RcG0_DYbd89LK0fWSJkMgqmDYn8ug7pYn+4uRqDRGqg@mail.gmail.com> <87poqpf23c.fsf@notabene.neil.brown.name> <CAGRgLy4UgT_gGHL=Lx_By1fqmE4Q4pwvbhBTh0J+u=9gxuQOYQ@mail.gmail.com> <87d1miec7q.fsf@notabene.neil.brown.name> <CAGRgLy47B1QJrHgGP6L1VFpBwF+g8Uk2QED9MJ1oZr0KNv6kQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy47B1QJrHgGP6L1VFpBwF+g8Uk2QED9MJ1oZr0KNv6kQw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: =?utf-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@redhat.com>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 14 2016, Alexander Lyakas wrote:

>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 32e282f4c83c..c528102b80b6 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1288,7 +1288,7 @@ read_again:
>>                                 sectors_handled;
>>                         goto read_again;
>>                 } else
>> -                       generic_make_request(read_bio);
>> +                       bio_list_add_head(&current->bio_list, read_bio);
>>                 return;
>>         }
>
> Unfortunately, this patch doesn't work. It is super elegant, and seems
> like it really should work. But the problem is that the "rdev", to
> which we want to send the READ bio, might also be a remapping device
> (dm-linear, for example). This device will create its own remapped-bio
> and will call generic_make_request(), which will stick the bio onto
> current->bio_list TAIL:(:(:( So we are back at square one. This patch
> would work if *all* the remapping drivers in the stack were doing
> bio_list_add_head() instead of generic_make_request()  :(:(:(
>
> It seems the real fix should be that generic_make_request() would use
> bio_list_add_head(), but as pointed in
> http://www.spinics.net/lists/raid/msg52756.html, there are some
> concerns about changing the order of remapped bios.
>

While those concerns are valid, they are about hypothetical performance
issues rather than observed deadlock issues.  So I wouldn't be too
worried about them.
However I think you said that you didn't want to touch core code at all
(maybe I misunderstood) so that wouldn't help you anyway.

One option would be to punt the request requests to raidXd:

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 40b35be34f8d..f795e27b2124 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1229,7 +1229,7 @@ read_again:
 				sectors_handled;
 			goto read_again;
 		} else
=2D			generic_make_request(read_bio);
+			reschedule_retry(r1_bio);
 		return;
 	}
=20
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 32e282f4c83c..eec38443075b 100644
=2D-- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1288,7 +1288,7 @@ read_again:
 				sectors_handled;
 			goto read_again;
 		} else
=2D			generic_make_request(read_bio);
+			reschedule_retry(r10_bio);
 		return;
 	}
=20

That might hurt performance, you would need to measure.
The other approach would be to revert the patch that caused the problem.
e.g.
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 40b35be34f8d..062bb86e5fd8 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -884,7 +884,8 @@ static bool need_to_wait_for_sync(struct r1conf *conf, =
struct bio *bio)
 			wait =3D false;
 		else
 			wait =3D true;
=2D	}
+	} else if (conf->barrier)
+		wait =3D true;
=20
 	return wait;
 }



>
>>
>>
>>>
>>> Since this issue is a real deadlock we are hitting in a long-term 3.18
>>> kernel, is there any chance for cc-stable fix? Currently we applied
>>> the rudimentary fix  I posted. It basically switches context for
>>> problematic RAID1 READs, and runs them from a different context. With
>>> this fix we don't see the deadlock anymore.
>>>
>>> Also, can you please comment on another concern I expressed:
>>> freeze_array() is now not reentrant. Meaning that if two threads call
>>> it in parallel (and it could happen for the same MD), the first thread
>>> calling unfreeze_array will mess up things for the second thread.
>>
>> Yes, that is a regression.  This should be enough to fix it.  Do you
>> agree?
>>
>> Thanks,
>> NeilBrown
>>
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 40b35be34f8d..5ad25c7d7453 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -984,7 +984,7 @@ static void freeze_array(struct r1conf *conf, int ex=
tra)
>>          * we continue.
>>          */
>>         spin_lock_irq(&conf->resync_lock);
>> -       conf->array_frozen =3D 1;
>> +       conf->array_frozen +=3D 1;
>>         wait_event_lock_irq_cmd(conf->wait_barrier,
>>                                 conf->nr_pending =3D=3D conf->nr_queued+=
extra,
>>                                 conf->resync_lock,
>> @@ -995,7 +995,7 @@ static void unfreeze_array(struct r1conf *conf)
>>  {
>>         /* reverse the effect of the freeze */
>>         spin_lock_irq(&conf->resync_lock);
>> -       conf->array_frozen =3D 0;
>> +       conf->array_frozen -=3D 1;
>>         wake_up(&conf->wait_barrier);
>>         spin_unlock_irq(&conf->resync_lock);
>>  }
> I partially agree. The fix that you suggest makes proper accounting of
> whether the array is considered frozen or not.
> But the problem is that even with this fix, both threads will think
> that they "own" the array. And both will do things, like writing data
> or so, which might interfere. The proper fix would ensure that only
> one thread "owns" the array, and the second thread waits until the
> first calls unfreeze_array(), and then the second thread becomes
> "owner" of the array. And of course while there are threads that want
> to "freeze" the array, other threads that want to do raise_barrier
> etc, should wait.

Is that really a problem?
A call to "freeze_array()" doesn't mean "I want to own the array", but
rather "No regular IO should be happening now".

Most callers of freeze_array():
    raid1_add_disk(), raid1_remove_disk(), stop(), raid1_reshape()
are called with the "mddev_lock()" mutex held, so they cannot interfere
with each other.

handle_read_error() is called with one pending request, which will block
any call on freeze_array(mddev, 0); - handle_read_error() itself calls
freeze_array(mddev, 1) so it gets access.
So these are already locked against the first four (as lock that
=2D>array_frozen doesn't get corrupted).

That just leaves raid1_quiesce().
That is mostly called under mddev_lock() so it won't interfere with the
others.
The one exception is where md_do_sync() calls
			mddev->pers->quiesce(mddev, 1);
			mddev->pers->quiesce(mddev, 0);

As this doesn't "claim" the array, but just needs to ensure all pending
IO completes, I don't think there is a problem.

So it seems to me that your concerns are not actually a problem.
Did I miss something?

>
> I am sorry for giving two negative responses in one email:)

Better a negative response than no response :-)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXiB3CAAoJEDnsnt1WYoG57PIP/i59KA/zDtM8tEs2DhrHFauw
MGQ4WbUgai5HZ5uXqKxwHjb/VhXSBFR2VwyBtCh2P0lTGxl0fWATbR5kgaLfks4j
7OE/DIplNCH+nGdVfxgq+j8uTvkBu16r/8MlyM+1t3Ua2JF3GEF5xVUfwPivFHw6
zC+dlBirCvxrNm90tCBMxaP/vAPitqd7XHYmD4pVIuriP4VY+hPlqt3D+kSfQSwd
2WTF1PUrhiHAz1E0LHkuP+DHBh0mbwuImsiXnr9fo9OmZl8HHSblA+9DK+yGrwQS
s+lvHg6MyoC/Y1GJWMkxYqkHEh/9oMR63mtbIxAbSSRwCWICxaeTawPJcpJq5hkH
W3gRau87qDJbxDmqVVivh73uXia0d34ppV+KB3q7zlwX6By2TJ3cs6wUpuU+zly+
RfSo5c2duP8AC6ok3kdDOJH4RVVpTYGKj1//9OSw9jI28arzR+cVBejb8YMJC07F
JZ3q8T8Aqc1S/klUajSoMIVYik6I9vDonhlGZrmVt4SkZ0peNi/tMgYRPCru1Pvw
i7Sw0fsgpqSWN5oM+pjZINMXdzgB6Q3wlRiLKotCSXHc0Yjt3vRCUkg52cRtXjug
It9px5fGqs7D1xhoarzGFgR1tsfDbbrfA/NVldnK8q2Sk4a6T/X+4S0nkmXOecjK
U/7JFPmDexMJltIeRksU
=/fd8
-----END PGP SIGNATURE-----
--=-=-=--
