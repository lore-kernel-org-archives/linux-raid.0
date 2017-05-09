From: NeilBrown <neilb@suse.com>
Subject: Re: RAID creation resync behaviors
Date: Wed, 10 May 2017 06:30:57 +1000
Message-ID: <87o9v1n56m.fsf@notabene.neil.brown.name>
References: <20170503202748.7r243wj5h4polt6y@kernel.org> <87inlhpgzu.fsf@notabene.neil.brown.name> <20170504020452.kcmjgxnk7zsx7kdx@kernel.org> <1fca5ff4-358a-e0cf-d1a4-fc33ecdcbd62@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1fca5ff4-358a-e0cf-d1a4-fc33ecdcbd62@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, May 09 2017, Jes Sorensen wrote:

> On 05/03/2017 10:04 PM, Shaohua Li wrote:
>> On Thu, May 04, 2017 at 11:07:01AM +1000, Neil Brown wrote:
>>> On Wed, May 03 2017, Shaohua Li wrote:
>>>
>>>> Hi,
>>>>
>>>> Currently we have different resync behaviors in array creation.
>>>>
>>>> - raid1: copy data from disk 0 to disk 1 (overwrite)
>>>> - raid10: read both disks, compare and write if there is difference (c=
ompare-write)
>>>> - raid4/5: read first n-1 disks, calculate parity and then write parit=
y to the last disk (overwrite)
>>>> - raid6: read all disks, calculate parity and compare, and write if th=
ere is difference (compare-write)
>>>
>>> The approach taken for raid1 and raid4/5 provides the fastest sync for
>>> an array built on uninitialised spinning devices.
>>> RAID6 could use the same approach but would involve more CPU and so
>>> the original author of the RAID6 code (hpa) chose to go for the low-CPU
>>> cost option.  I don't know if tests were done, or if they would still be
>>> valid on new hardware.
>>> The raid10 approach comes from "it is too hard to optimize in general
>>> because different RAID10 layouts have different trade-offs, so just
>>> take the easy way out."
>>=20
>> ok, thanks for the explanation!
>>>>
>>>> Write whole disk is very unfriendly for SSD, because it reduces lifeti=
me. And
>>>> if user already does a trim before creation, the unncessary write coul=
d make
>>>> SSD slower in the future. Could we prefer compare-write to overwrite i=
f mdadm
>>>> detects the disks are SSD? Surely sometimes compare-write is slower th=
an
>>>> overwrite, so maybe add new option in mdadm. An option to let mdadm tr=
im SSD
>>>> before creation sounds reasonable too.
>>>
>>> An option to ask mdadm to trim the data space and then --assume-clean
>>> certainly sounds reasonable.
>>=20
>> This doesn't work well. read returns 0 for trimmed data space in some SS=
Ds, but
>> not all. If not, we will have trouble.
>
> /sys/block/<device>/queue/discard_zeroes_data
>
> We could use this as an indicator for what to do.
>
According to

Documentation/ABI/testing/sysfs-block

Description:
                Will always return 0.  Don't rely on any specific behavior
                for discards, and don't read this file.

See also
 Commit: 48920ff2a5a9 ("block: remove the discard_zeroes_data flag")

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkSJwEACgkQOeye3VZi
gbmruw//dOiDLW6+GGZODohAUdwymcelg/q5241iovhQtMmIzqvsYx4Q0f/8yNXI
j2VIAmVJXP7ShcBFKuAFuf0kGOiGbV0tgGYbnD2RZaqCS7o64yN+rNXWpIT4xjd1
IRpJ8DMcOy9CTZogxjq9m/2SopS/tb6eswZqW0XnQu4k2VmcXGCJG41aVahrAhOS
P1Sttisk7LLLJxFgwKSBHE/ZMPxOn3O8pxJSGbdate9wMijJF9TnqS9PHfBDbrX0
BrqwbZAu22zXtvVGnciUjygrtdHs7JQi7W8no57iB/BgjFgTW21QNLkH3JKoLV4v
Zsl9cHgMBMp7T8mt7tRk4Q57j5hNxphTgEmxoV48wCmLqErxW4LZzo6HLiEgIP5U
qz0D7IP68PU9avB4cdU3TZV9B0SYxy/i9VoIstawphrl3Y1DOL3UN3TA/hPT8Cxw
Cu59P73jrBuocKfiHCJ0K5zt7kH53BXhOjNaO3VmC7VD8t+Hw/o/mVVlEX8trRip
o8Mju4zoP0DnXhh8pRTrcCFPGZtEci9+A4htsg4qG3ba6+HBVOVEVqQmYCTDe91R
79bu30sy1Jz8Dq96D/0FNZvcBkS7rsOHOEOh4r8KOtbYnYA7GuI74mUkHudeFIF+
GN/3IPscZGhO98p+l7YF1DGtplOlCKtXnFfUvKhaHH8gYjyiKjE=
=fRpE
-----END PGP SIGNATURE-----
--=-=-=--
