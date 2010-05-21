From: Doug Ledford <dledford@redhat.com>
Subject: Re: raid 5 mismatch_cnt errors
Date: Thu, 20 May 2010 22:16:07 -0400
Message-ID: <4BF5ECE7.7020907@redhat.com>
References: <4BF56B1F.9080205@locallinux.com>	<20100521071645.497cdcad@notabene.brown>	<4BF5B7D1.3070808@locallinux.com> <20100521083819.54680dfb@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigECF8913BF2A73773A9DED69E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100521083819.54680dfb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Trey Scarborough <treys@locallinux.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigECF8913BF2A73773A9DED69E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/20/2010 06:38 PM, Neil Brown wrote:
> On Thu, 20 May 2010 17:29:37 -0500
> Trey Scarborough <treys@locallinux.com> wrote:
>=20
>> Neil Brown wrote:
>>> On Thu, 20 May 2010 12:02:23 -0500
>>> Trey Scarborough <treys@locallinux.com> wrote:
>>>
>>>  =20
>>>> I have a raid 5 array with 9 disks and I have a mismatch_cnt that ke=
eps=20
>>>> growing. This is causing file corruption on the underlaying file sys=
tems=20
>>>> as well.  I can copy a group of 100 100mb files and then do a md5sum=
 on=20
>>>> them and 1-3 will be corrupt. If this is a drive that is bad is ther=
e=20
>>>> anyway to run a report on the count per drive that these mismatches =

>>>> occur. I have run smarttools test and do not see one drive that stan=
ds=20
>>>> out to be causing errors. Could something else be causing these erro=
rs?
>>>>    =20

While a bad drive is certainly a possibility here, this is precisely the
type of failure scenario that would make me suspect bad RAM,
motherboard, or CPU.  So I wouldn't rule those out as possibilities eithe=
r.

>>>
>>> When RAID5 detects an inconsistency there is no way to know which dev=
ice was
>>> wrong.
>>> SMART only detects some errors, not all.
>>> I have had hard drives before which appears to have a single-bit erro=
r in
>>> their internal buffer.  No error would be reported, but data you read=
 would
>>> sometimes be wrong.
>>> RAID5 cannot help you with this sort of error.
>>>
>>> I would suggest backing up all your data (if it isn't already to late=
),
>>> breaking the array, and testing each device individually.
>>> e.g. create a filesystem on the device and try copying data on and re=
ading it
>>> off.
>>>
>>> NeilBrown
>>>  =20
>> Thats what I was afraid of. The problem I have is if I back it up=20
>> knowing what data is bad. Luckily it appears to be a write error becau=
se=20
>> once written and correct I can do sums on all the files and I do not s=
ee=20
>> anymore errors. I was thinking that there might be a way of do a resyn=
c=20
>> and turning up the debug somehow so that it would log the mismatches=20
>> with both the drives that it was reading from at the time. I could the=
n=20
>> take that information and considering there are 9 drives in the array =

>> the one that comes out having the most should be the culprit. I could =

>> then remove that drive from the array and test it leaving the rest in =
a=20
>> state that could be rebuilt and the data being consistant because the =

>> drive with the bad write errors would be removed. Is this something th=
at=20
>> might be possible?
>=20
> To detect a mismatch, raid5 reads from all drives in parallel, calculat=
es the
> parity across the data blocks and compares that to the parity block.
> So no: something like that is not possible.
>=20
> only thing I can suggest:
>=20
> - add a write-intent bitmap so you can remove/re-add devices fairly che=
aply
> - create a v.large file.
> - write random data to the file without truncating it. (use dd of=3Dfil=
e
>   conv=3Dnotrunc) then read it back and see if it matches.   If it does=
, then
>   this approach doesn't help.  If it doesn't:
>=20
>   1 by 1, fail/remove a drive from the array.  Write new random data to=
 the
>   same file and read it back and compare.  Then --readd the missing dev=
ice.
>   I'm hoping that you will get an error every time except when the 'bad=
'
>   device has been removed.
>=20
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigECF8913BF2A73773A9DED69E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv17OcACgkQg6WylM+/8ZSYkACfbE+/mgPj61PeT0qdncwYmvEm
S/EAn3hr3roIx4TeoZb1ejCXsgs8Lz3R
=43Mc
-----END PGP SIGNATURE-----

--------------enigECF8913BF2A73773A9DED69E--
