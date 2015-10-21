From: Neil Brown <nfbrown@novell.com>
Subject: Re: How to recover after md crash during reshape?
Date: Thu, 22 Oct 2015 07:26:37 +1100
Message-ID: <87k2qg0xz6.fsf@notabene.neil.brown.name>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com> <874mhl2ed3.fsf@notabene.neil.brown.name> <56278284.5020306@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56278284.5020306@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, andras@tantosonline.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Phil Turmel <philip@turmel.org> writes:

> Good morning Neil,
>
> On 10/20/2015 09:35 PM, Neil Brown wrote:
>
>> Nothing dumb about that - you don't need a --backup option.
>> If you did, mdadm would have complained.
>>=20
>> You only need --backup when the size of the array is unchanged or
>> decreasing.
>
>> mdadm reads the first few stripes and stores them somewhere in each of
>> the spares.  md (in the kernel) then reads those stripes again and
>> writes them out in the new configuration.  It appears that one of the
>> writes failed, others might have succeeded.  This may not have corrupted
>> anything (the first few blocks are in the same position for both the old
>> and new layout) but it might have done.
>
>> If you do want to look for the backup, it is around about the middle of
>> the device and has some metadata which contains the string
>> "md_backup_data-1".  If you find that, you are close to getting the
>> backup data back.
>
> Hmmm.  This feature has advanced beyond my last look at the code.  I was
> under the impression the backup option was only optional when mdadm
> could move the data offset.  Does this new algorithm apply to v0.90
> metadata, a v3.2 kernel, and v3.2.5 mdadm?
>

It isn't a new algorithm, it is the original algorithm.

In mdadm-2.4-pre1 (march 2006), you couldn't specify a backup file, but
you could grow a raid5 to more devices.
That was changed by a patch with comment:

    Allow resize to backup to a file.
=20=20=20=20
    To support resizing an array without a spare, mdadm now understands
      --backup-file=3D
    which should point to a file for storing a backup of critical data.
    This can be given to --grow which will create the file, or
    --assemble which will restore from the file if needed.
=20=20=20=20
The backup-file was subsequently used to support in-place reshapes and
array shrinking.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWJ/T9AAoJEDnsnt1WYoG5qEwQAKuaHrsijDPtUWuhIcdUJ5mV
4KweZdpEg8EWhMOvCp3AYWTMgCmG0CMYaMVI1PFXcOtK6IGxSsITYE43j0F9/dI8
p+cxZJWx5/zuK9d0BN4O91Fy9yUFNVu9upEEDk9+1LmfnP9eKGTol7TfB4A/a3g4
aW/phGCTdhqtNn0NeqqQk3iOnou4S8kFaJF3lcLq3NHtC5btYiYXX9xcq9xrLMpE
Q7Mbwb/WALgt8AlHd0KZ4iADTC4FI45wdJco7CRU+ltmutUpbgQpjMFC9nmu6U40
7s0Q/UnJzHOdi20rtc1eBMV5BdWOg66IAEbBl9Y3+tCAULBFZ0ZweusGP0CS0LhH
DlaZi4eTCs48drxWT8+yE6jaLTZNQbW0aODuRtpNJY8/wWSAMoCKFFSQvm0PF2fN
FnyPG1MyW0Ls2JtHY6oL7C+mx/wyXTqNxcF3c2VR9wOPz+X6Kxuq7le5irMNrI4Y
Z2xxNzKZ6QFuILsJFaKsIh2GixNCq6n0M6Rvkvrktev8p0TQkL9Ep1t2ZNoZf4yK
RG6GvL6nrND1bU5ycvFh++xxgjHfqnexJb+EFb6YfZCrGEaqKlfaONMEbwy8jDpH
lEm18RrZnqNljXWmukRq9h7qpwcX3nsUvZQvRQ6z2ai8J7x6jOcNT5xCDBScpN0O
ntPNHTjG3vzsf6J/JP2R
=1ltU
-----END PGP SIGNATURE-----
--=-=-=--
