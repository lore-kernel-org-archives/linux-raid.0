From: Doug Ledford <dledford@redhat.com>
Subject: Re: [mdadm GIT PULL] rebuild checkpoints, incremental assembly, volume
 delete/rename, and fixes
Date: Tue, 06 Jul 2010 17:43:37 -0400
Message-ID: <4C33A389.7000607@redhat.com>
References: <1274921452.17973.253.camel@dwillia2-linux>	<20100531113710.29e12d97@notabene.brown>	<AANLkTimgVuEIkB2s9rra5QS11YMUSpvSkBOcbzza44LX@mail.gmail.com>	<20100616163343.2c57de59@notabene.brown>	<1278032211.2179.24.camel@dwillia2-linux> <20100706145043.107f7f76@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFFBE477CD2F4102C2BBAB47D"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100706145043.107f7f76@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFFBE477CD2F4102C2BBAB47D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/06/2010 12:50 AM, Neil Brown wrote:
> On Thu, 01 Jul 2010 17:56:51 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>=20
>> On Tue, 2010-06-15 at 23:33 -0700, Neil Brown wrote:
>>> On Thu, 10 Jun 2010 23:42:16 -0700
>>> Dan Williams <dan.j.williams@intel.com> wrote:
>>>
>>>>> I've merged and pushed out the other bits which all seem OK. =20
>>>>
>>>> Ok, there was one more you didn't comment on and didn't cherry-pick =
[2]
>>>>
>>>> Dave Jiang (1):
>>>>       create: Check with OROM limit before setting default chunk siz=
e
>>>>
>>>> Thanks,
>>>> Dan
>>>
>>> I don't remember seeing that before - sorry.
>>> It looks OK.  It might be nice to combine it with the ->default_layou=
t
>>> setting somehow, but that isn't necessary in the first instance.
>>>
>>> Include it in the next pull request and I'll take it.
>>>
>>
>> Here is the updated pull request:
>>
>> The following changes since commit b3b4e8a7a229cccca915421329a5319f996=
b0842:
>>   NeilBrown (1):
>>         Avoid skipping devices where removing all faulty/detached devi=
ces.
>>
>> are available in the git repository at:
>>
>>   git://github.com/djbw/mdadm.git master
>>
>> Dan Williams (10):
>>       mdmon: periodically checkpoint recovery
>>       Kill subarray v2
>>       imsm: dump each disk's view of the slot state
>>       mdmon: record sync_completed directly to the metadata
>>       Remove 'checkpointing' side effect of --wait-clean
>>       Always assume SKIP_GONE_DEVS behaviour and kill the flag
>>       Rename subarray v2
>>       mdmon: prevent allocations due to late binding
>>       Merge branch 'subarray' into for-neil
>>       Merge branch 'fixes' into for-neil
>>
>> Dave Jiang (1):
>>       create: Check with OROM limit before setting default chunk size
>=20
> Thanks.  They all look credible.
> I have pulled and pushed so you can find them in=20
>    git://neil.brown.name/mdadm master
>=20
>=20
> I'm fairly seriously considering cutting a 3.1.3 shortly (Thursday?) so=
 that
> I have a clean slate to build the policy frame work and aim it for 3.2.=
0.
>=20
> If you have anything that you would like to see included in (or address=
ed
> for) 3.1.3, please let me know.
>=20
> Thanks,
> NeilBrown

Hey Neil, I'm just back on the job.  I'd appreciate a few days to go
through all my bugs and see what items not related to the policy
framework might need fixed from my perspective for a 3.1.3 release.
Thanks ;-)

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigFFBE477CD2F4102C2BBAB47D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkwzo4kACgkQg6WylM+/8ZTUzACgmX8mmJDa4r/5je6jjq8D+YHK
+r0An2H/XGOkclQUimD5kHTx33A2g3jj
=cT+F
-----END PGP SIGNATURE-----

--------------enigFFBE477CD2F4102C2BBAB47D--
