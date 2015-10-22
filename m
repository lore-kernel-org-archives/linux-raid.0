From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/2] raid1/10: Handle write errors correctly in narrow_write_error()
Date: Fri, 23 Oct 2015 08:36:06 +1100
Message-ID: <87r3kmziux.fsf@notabene.neil.brown.name>
References: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com> <87pp092sid.fsf@notabene.neil.brown.name> <wrfjpp06lws6.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjpp06lws6.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, William.Kuzeja@stratus.com, xni@redhat.com, nate.dailey@stratus.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Neil Brown <neilb@suse.de> writes:
>> Jes.Sorensen@redhat.com writes:
>>
>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>
>>> Hi,
>>>
>>> Bill Kuzeja reported a problem to me about data corruption when
>>> repeatedly removing and re-adding devices in raid1 arrays. It showed
>>> up to be caused by the return value of submit_bio_wait() being handled
>>> incorrectly. Tracking this down is credit of Bill!
>>>
>>> Looks like commit 9e882242c6193ae6f416f2d8d8db0d9126bd996b changed the
>>> return of submit_bio_wait() to return != 0 on error, whereas before it
>>> returned 0 on error.
>>>
>>> This fix should be suitable for -stable as far back as 3.9
>>
>> 3.10?
>>
>> Thanks to both of you!
>>
>> I took the liberty of changing the patches a little so they are now:
>>
>> -               if (submit_bio_wait(WRITE, wbio) == 0)
>> +               if (submit_bio_wait(WRITE, wbio) < 0)
>>
>> because when there is no explicit test I tend to expect a Bool but these
>> values are not Bool.
>>
>> Patches are in my for-linus branch and will be forwarded sometime this
>> week.
>>
>> This bug only causes a problem when bad-block logs are active, so
>> hopefully it won't have caused too much corruption yet -- you would need
>> to be using a newish mdadm.
>
> Neil,
>
> An additional twist on this one - Nate ran more tests on this, but was
> still able to hit data corruption. He suggests the it is a mistake to
> set 'ok = rdev_set_badblocks()' and it should instead be set to 0 if
> submit_bio_wait() fails. Like this:
>
> --- raid1.c
> +++ raid1.c
> @@ -2234,11 +2234,12 @@
>  		bio_trim(wbio, sector - r1_bio->sector, sectors);
>  		wbio->bi_sector += rdev->data_offset;
>  		wbio->bi_bdev = rdev->bdev;
>  		if (submit_bio_wait(WRITE, wbio) < 0) {
>  			/* failure! */
> -			ok = rdev_set_badblocks(rdev, sector,
> -						sectors, 0)
> -				&& ok;
> +			ok = 0;
> +			rdev_set_badblocks(rdev, sector,
> +					   sectors, 0);
> +		}
>
> Question is whether this change has any negative impact in case of a
> real write failure?
>
> I have actual patches, I'll send as a reply to this one.
>

If we unconditionally set ok to 0 on a write error, then
narrow_write_error() will return 0 and handle_write finished() will call
md_error() to kick the device out of the array.

And given that we only call narrow_write_error()  when we got a write
error, we strongly expect at least one sector to give an error.

So it seems to me that the net result of this patch is to make
bad-block-lists completely ineffective.

What sort of tests are you running, and what sort of corruption do you
see?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKVbGAAoJEDnsnt1WYoG5EkYQAJ6pVEkFIj2TTEzGRlSvd6HN
3O9NT7DnLjLXVOVp2ScHfHtXohkqsYKR73LHVI2tiEwILJ8Dls1YD6f9R3Ta7zHE
m9TOUFbwXOjwICDlJwEiBBW2nbjT6meZlKVtHww6XTu7MD503OGnxSWPgTM9nsfJ
DEiDQ+yo2IevxH+xRWO6YdX7kauKM2uz4LulqMQP585gV+vX/gT4nHvSLYeDoF4J
OfIVp9sriawmFGAtTQYPbVP7KVzuWLdM3R26NhG6v4s8Gg4zs17w5mW5NUB6P514
UrRIKAePeojZW7qZmCUk77liWhclLwgP/0KTZCKVFnlKmId0V5N7NffFtzb7vyF4
Fo7luUCrB6LO/9gNkU6aIltRRBpzoEmnSZb33jKLGdZdkLZPzfWrKV+H4avFBQsZ
E19daS2Zd18qt/4mr79HcMqtd+7KxncrBkQzS77XzuHfitzpwyoIy357168NuF8k
sL5EmVmECijXCgDEvoDUa/DNQ2tytTrl/m3WNMp2jq/0vpsUMzpwA+m8B7ONChJa
CkW2xJVk33i3WpOwjcsa52k3Myrlu53rmUAw/Z7FEnBrH2aob+F4ksHtxeQ4TJ8J
HBw2h9r+uvCEm7GMK9JCNim2nX5QoRret7khpdY9GiyNkVhZZrTmLCxnxcZR7xJG
gcG9Tkyo+vF+0Os6NxIi
=Cioe
-----END PGP SIGNATURE-----
--=-=-=--
