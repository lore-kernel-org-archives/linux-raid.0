From: NeilBrown <nfbrown@novell.com>
Subject: Re: Unable to convert raid1 to raid5
Date: Fri, 12 Aug 2016 11:32:39 +1000
Message-ID: <87a8gilqko.fsf@notabene.neil.brown.name>
References: <57A4F436.9080402@youngman.org.uk> <57A679C9.3060204@youngman.org.uk> <CAN7jt2060xqsQB+nAnWO4LmqdUySkU_AWpq=UdFte=Ht0zuoPw@mail.gmail.com> <57A68815.40601@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57A68815.40601@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Glenn Enright <glenn.enright@gmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 07 2016, Wols Lists wrote:

> On 07/08/16 01:32, Glenn Enright wrote:
>> On 7/08/2016 12:01 pm, "Wols Lists" <antlists@youngman.org.uk
>> <mailto:antlists@youngman.org.uk>> wrote:
>>>
>>> On 05/08/16 21:16, Wols Lists wrote:
>>> > In my testing of xosview, I've been mucking about with a vm and raid.
>>> > xosview is looking quite promising (I've got a few comments about it,
>>> > but never mind).
>>> >
>>> > BUT. In mucking about with raid 1, I increased my raid devices to thr=
ee.
>>> > I now just can NOT convert the array to raid 5! I've been mucking aro=
und
>>> > with all sorts of things trying to get it to work, but finally two er=
ror
>>> > messages make things clear.
>>> >
>>> Following up to myself - suddenly thought "I know what's wrong". So I
>>> stopped the array, and of course couldn't access it, it was no longer
>>> there. So I assembled but didn't run it, and it worked fine.
>>>
>>> Simples, once you realise what's wrong - you can ADD devices to a
>>> running array, but you can't REMOVE them.
>>>
>>> Cheers,
>>> Wol
>>>
>
>>=20
>> You can remove em if you mark em as failed first. Eg
>>=20
>> Mdadm /dev/mdx --fail /dev/sdc1 --remove /dev/sdc1
>>=20
>> Best, Glenn
>>=20
> Except - if you read my original post - I was trying to TOTALLY remove
> the device!
>
> mdadm --grow -raid-devices=3D2
>
> THAT was the problem - I had a 3-device mirror, and you can't convert
> that to raid5! Even if you've --fail --remove'd the third device!
>
> In other words, "--grow --raid-devices=3Dmore" will work on a running
> device, "--grow --raid-devices=3Dless" will only work on an array that is
> built but not running.

I don't believe this is correct, and I could reproduce your results in
quick tests.

If the array is not running, then you cannot reshape it at all.

You can reduce the number of devices in a RAID1 at any time as long as
the number of active devices is not greater than the number of devices
requested.

/dev/md0 has 3 working devices:

# mdadm -G /dev/md0 -n2
mdadm: failed to set raid disks
# mdadm /dev/md0 -f /dev/loop0
mdadm: set /dev/loop0 faulty in /dev/md0
# mdadm -G /dev/md0 -n2
raid_disks for /dev/md0 set to 2


>
> I now have the problem that my "--grow --level=3D5" has fallen foul of the
> "reshape stuck at zero" problem, and I can now neither run the array,
> nor get the reshape working ... :-(

We really need to fix this ... if only I knew how to reproduce it.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXrSc3AAoJEDnsnt1WYoG5+nUP/Rk1NfWMs4eg9+v6YKHWAUBR
3sOoo2r8k6nEWsO3p1y16vnMJIi0nySwpheTeKziIDKt4ClV0h8uipgMNL17Nyj5
Uk/7a4pJI2mQUdVNpAGy+wR3uJQEZdYh92TMWG4n8gKI7og468/nZ+oE4qTCla2r
G2aVU1rglZ78kp3CspRQ2AFdKmFMbf37eEHvmyIcOgkUEU5z3hBz0cuv/fi4rosY
xDJlTUCCj+4Z1s3Stg0n//HMPHS3UugpR1Dl2HsHoTUhaLd4G6VnokdVZY1E1E97
LGj9xxoJF3m3qshHxjprmh6rReLTrG8xnsJEaZ7Kk0DK1xUpEIKju8gF+aPsBFTy
cIt3nM3B8KOkPRkD7WaYHRWfCWVBtOSaN9ZcdGU8L8Hoz/1tX+Fvmfqoj/uwcDKY
qnjE5KEBRAGnJP6Dg+y2Keh/8MKdfD/cKXg7JlYA0pu5OdX8hcaFRVC86baTMzRK
AiFSi+DeSbGfEaoYiCNsJ4BOhQn9rs6EpcOsRkfqqmDfNJ2wiHZDy+s6DD5CVnb/
m9P1iqwHeIvyWXDpRaAlIWFRYO5RCHsyCk9vWPF7rDA/cr7bhwwqJq8DT3//r0z5
MNJTFUW6jXoL0Atj4Vhqj1LNz6kQ1rpmwGjKFzrS1/S4mz7JCVBKRqjdAHJqKQs5
aA1GZf5mPw9A3oFYkHz0
=pEPZ
-----END PGP SIGNATURE-----
--=-=-=--
