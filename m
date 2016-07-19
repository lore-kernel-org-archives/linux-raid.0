From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH RFC] md/raid1: fix deadlock between freeze_array() and wait_barrier().
Date: Wed, 20 Jul 2016 08:19:11 +1000
Message-ID: <87bn1t9sps.fsf@notabene.neil.brown.name>
References: <CAGRgLy6RcG0_DYbd89LK0fWSJkMgqmDYn8ug7pYn+4uRqDRGqg@mail.gmail.com> <87poqpf23c.fsf@notabene.neil.brown.name> <CAGRgLy4UgT_gGHL=Lx_By1fqmE4Q4pwvbhBTh0J+u=9gxuQOYQ@mail.gmail.com> <87d1miec7q.fsf@notabene.neil.brown.name> <CAGRgLy47B1QJrHgGP6L1VFpBwF+g8Uk2QED9MJ1oZr0KNv6kQw@mail.gmail.com> <87lh13dd1a.fsf@notabene.neil.brown.name> <CAGRgLy6QhpWr5f07w3jT04oX4aA-aKTAr44JOih-DkK+dn5ABQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6QhpWr5f07w3jT04oX4aA-aKTAr44JOih-DkK+dn5ABQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: =?utf-8?B?6ams5bu65pyL?= <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@redhat.com>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Jul 19 2016, Alexander Lyakas wrote:

> Hello Neil,
> Thank you for your response.
>
> On Fri, Jul 15, 2016 at 2:18 AM, NeilBrown <neilb@suse.com> wrote:
>> On Thu, Jul 14 2016, Alexander Lyakas wrote:
>>
>>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>>> index 32e282f4c83c..c528102b80b6 100644
>>>> --- a/drivers/md/raid10.c
>>>> +++ b/drivers/md/raid10.c
>>>> @@ -1288,7 +1288,7 @@ read_again:
>>>>                                 sectors_handled;
>>>>                         goto read_again;
>>>>                 } else
>>>> -                       generic_make_request(read_bio);
>>>> +                       bio_list_add_head(&current->bio_list, read_bio);
>>>>                 return;
>>>>         }
>>>
>>> Unfortunately, this patch doesn't work. It is super elegant, and seems
>>> like it really should work. But the problem is that the "rdev", to
>>> which we want to send the READ bio, might also be a remapping device
>>> (dm-linear, for example). This device will create its own remapped-bio
>>> and will call generic_make_request(), which will stick the bio onto
>>> current->bio_list TAIL:(:(:( So we are back at square one. This patch
>>> would work if *all* the remapping drivers in the stack were doing
>>> bio_list_add_head() instead of generic_make_request()  :(:(:(
>>>
>>> It seems the real fix should be that generic_make_request() would use
>>> bio_list_add_head(), but as pointed in
>>> http://www.spinics.net/lists/raid/msg52756.html, there are some
>>> concerns about changing the order of remapped bios.
>>>
>>
>> While those concerns are valid, they are about hypothetical performance
>> issues rather than observed deadlock issues.  So I wouldn't be too
>> worried about them.
> I am thinking of a hypothetical driver that splits say a 12Kb WRITE
> into 3x4kb WRITEs, and submits them in a proper order, hoping they
> will get to the disk in the same order, and the disk will work
> sequentially. But now we are deliberately hindering this. But I see
> that people much smarter than me are in this discussion, so I will
> leave it to them:)

Sure, that is the concern and ideally we would keep things in order.
But the elevator should re-order things in most cases so it shouldn't
matter too much.
For upstream, we obviously aim for best possible.  For stable backports,
we sometimes accept non-ideal code when the change is less intrusive.

If we do backport something to -stable, I would do it "properly" using
something very similar to the upstream version.  You don't seem to want
that for your code so I'm suggesting options that, while not 100% ideal,
should suit your needs - and obviously you will test your use cases.

>
>> However I think you said that you didn't want to touch core code at all
>> (maybe I misunderstood) so that wouldn't help you anyway.
> Yes, this is correct. Recompiling the kernel is a bit of a pain for
> us. We were smart enough to configure the md_mod as loadable module,
> so at least now I can patch MD code easily:)
>
>>
>> One option would be to punt the request requests to raidXd:
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 40b35be34f8d..f795e27b2124 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1229,7 +1229,7 @@ read_again:
>>                                 sectors_handled;
>>                         goto read_again;
>>                 } else
>> -                       generic_make_request(read_bio);
>> +                       reschedule_retry(r1_bio);
>>                 return;
>>         }
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 32e282f4c83c..eec38443075b 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1288,7 +1288,7 @@ read_again:
>>                                 sectors_handled;
>>                         goto read_again;
>>                 } else
>> -                       generic_make_request(read_bio);
>> +                       reschedule_retry(r10_bio);
>>                 return;
>>         }
> This is more or less what my rudimentary patch is doing, except it is
> doing it only when we really need to wait for the barrier.
>
>>
>>
>> That might hurt performance, you would need to measure.
>> The other approach would be to revert the patch that caused the problem.
>> e.g.
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 40b35be34f8d..062bb86e5fd8 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -884,7 +884,8 @@ static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
>>                         wait = false;
>>                 else
>>                         wait = true;
>> -       }
>> +       } else if (conf->barrier)
>> +               wait = true;
>>
>>         return wait;
>>  }
>>
>>
> I am not sure how this patch helps. You added another condition, and
> now READs will also wait in some cases. But still if array_frozen is
> set, everybody will wait unconditionally, which is the root cause for
> the deadlock I think.

Maybe you're right.  I was thinking that array_frozen only causes
problems if there are read requests in the generic_make_request queue,
and this change would keep them out.  But I might have dropped a ball
somewhere.


>
> I see that there will be no magic solution for this problem:(
>

Not really.


NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXjqdfAAoJEDnsnt1WYoG5gn0P/RrhO2KrkxfW93qBcXRtUbAV
e2pwijML2gR9Ejg/1ml1iFHBZdPQvFYJSwgrmCsd0D/7PAnSgViE5EU7YX+MoL+g
G7UZHV2+CLcrcegB2v7CsZ9LNrusXTnFr4jV312l4zxsD5rNQpIAMReM97TwN7It
D69y8Jis+XS6ky3hekZjOjbEO6rgOvh1pMbpU76E2GaAYXemoMAlhtAwNNYcCsov
ae6AdsovjgL9mEHQCQVMLLUmrd1nSyViRQZzAuNVoHWKL/4+gH7Ql5G8ustDMoXc
BXvYmh5A6UrjHBZtVskc5lCPX63ei8KkHxr8Mws0zi9rH5sQtF0XuMEQeLnfuC4R
OwfU1tUSHPE1XZC3+BZIAo4q7yloC/1WbJHOqCT7Uq+zWYUsKtvPF/CuSrCjYQ+z
YpIN+sC/pVe4WPSmoiHk2Mq9fkeloj6UrJ2UrKV3hembAwJU1vqNVlepjGMjIN9L
sTEVXlNb2swz1FOYaFoa0v8sNE0zkH5tr0rRiXGdAcPcxIpCNwYZh3QkBWdvKvi0
POiz1GN15NpviLYSHFdycqRkb9/uIqr2TiNxvuEYevc8sIg+Yv5qP9D3cJHjEASo
+nKiYG90jDMuublGRgFiX9eZsK7V1L0RvW+l94kEgr89JZMp4BrOU0tlkpTHjnl3
Jn5CaHyB+Gk3rtfeVoqB
=hQvo
-----END PGP SIGNATURE-----
--=-=-=--
