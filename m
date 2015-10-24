From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/2] raid1/10: Handle write errors correctly in narrow_write_error()
Date: Sat, 24 Oct 2015 16:31:11 +1100
Message-ID: <87k2qcygrk.fsf@notabene.neil.brown.name>
References: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com> <87pp092sid.fsf@notabene.neil.brown.name> <wrfjpp06lws6.fsf@redhat.com> <87r3kmziux.fsf@notabene.neil.brown.name> <56296510.4030702@stratus.com> <87d1w6zbrv.fsf@notabene.neil.brown.name> <562A4475.1000904@stratus.com> <wrfjoafpcvjs.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjoafpcvjs.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Nate Dailey <nate.dailey@stratus.com>
Cc: linux-raid@vger.kernel.org, William.Kuzeja@stratus.com, xni@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Nate Dailey <nate.dailey@stratus.com> writes:
>> Thank you!
>>
>> I confirmed that this patch prevents the bug.
>>
>> Nate
>
> Awesome, thanks Nate!
>
> Neil once you commit the final version of this patch, please let me
> know.
>
> Cheers,
> Jes
>
>>
>>
>>
>> On 10/22/2015 08:09 PM, Neil Brown wrote:
>>> Nate Dailey <nate.dailey@stratus.com> writes:
>>>
>>>> The problem is that we aren't getting true write (medium) errors.
>>>>
>>>> In this case we're testing device removals. The write errors happen
>>>> because the
>>>> disk goes away. Narrow_write_error returns 1, the bitmap bit is cleared, and
>>>> then when the device is re-added the resync might not include the sectors in
>>>> that chunk (there's some luck involved; if other writes to that chunk happen
>>>> while the disk is removed, we're okay--bug is easier to hit with
>>>> smaller bitmap
>>>> chunks because of this).
>>>>
>>>>
>>> OK, that makes sense.
>>>
>>> The device removal will be noticed when the bad block log is written
>>> out.
>>> When a bad-block is recorded we make sure to write that out promptly
>>> before bio_endio() gets called.  But not before close_write() has called
>>> bitmap_end_write().
>>>
>>> So I guess we need to delay the close_write() call until the
>>> bad-block-log has been written.
>>>
>>> I think this patch should do it.  Can you test?
>>>
>>> Thanks,
>>> NeilBrown
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index c1ad0b075807..1a1c5160c930 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -2269,8 +2269,6 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>>>   			rdev_dec_pending(conf->mirrors[m].rdev,
>>>   					 conf->mddev);
>>>   		}
>>> -	if (test_bit(R1BIO_WriteError, &r1_bio->state))
>>> -		close_write(r1_bio);
>>>   	if (fail) {
>>>   		spin_lock_irq(&conf->device_lock);
>>>   		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
>>> @@ -2396,6 +2394,9 @@ static void raid1d(struct md_thread *thread)
>>>   			r1_bio = list_first_entry(&tmp, struct r1bio,
>>>   						  retry_list);
>>>   			list_del(&r1_bio->retry_list);
>>> +			if (mddev->degraded)
>>> +				set_bit(R1BIO_Degraded, &r1_bio->state);
>>> +			close_write(r1_bio);
>>>   			raid_end_bio_io(r1_bio);
>>>   		}
>>>   	}

I've just pushed out a version (for raid10 as well) in my 'for-linus'
branch.  I'll submit to Linus later today after zero-day comes back with
no errors.

This version contains some extra code which is not needed, but makes the
change more obviously correct.

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKxefAAoJEDnsnt1WYoG59ksQAJ5uojENqgUoFrsGmnuKwOA+
7cbW8xeXpcSSV7fPfkBOVKf0EIa/MqY0FE6fnHD60zFeILOqVKP4u9TTx32290cu
8f7akQ+aFWavCBaSkflMEL2dkrV35auYJS0mQ0fTC2qV36vFdbnw2vbLOdKVg/dy
sPaOXmBnGm3WV0i/NTD5oLdSLyxdwIfCtcilaoRxbDTS30VtRRs9d3IWgeh3sYj0
ZrkMeVqM3yHxkyeyKpRND8d9Wm4i4srzuuA4Ax7f8BuuWCKnG0kEGkxtCrwGyypZ
sPziVYTvQAQqpmw4KopIHIcK5EDrqbVRTpDXr9OEON+i0H3pEB1kfTi3FWOFKgyg
UrCiP1F/T92HjXuK5OxyLWXnlZFae2GBrIQdZx0P0EsWDpmtwMRPjjRhQbdDPH42
vVFlOksPpNNB9oxvkamE7baNnsfJ+p3ms8PwTYA/24kKuJzze4S7hgWpYpawf5xa
JVSD9GlHG7xwWutCtYXfgXkjdYCGJwCAQU4UWsdVDZ5zUuPDmDYQDnWCs+T3GK/k
5ptrMliFNvsS+6PWWN6J0tktIefAZgmmLeR5YZyVZ5Pq5t69ColGBR92g0etjAQb
tGGoYnT3E7CK/kO4tYheCHoeVQWtcEe/rmCvbx6HHcINx/RVk6dutC4qDjxZF41s
UWryi67Wbztau5ZLtC6J
=oyG3
-----END PGP SIGNATURE-----
--=-=-=--
