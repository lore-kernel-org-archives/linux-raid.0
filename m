From: NeilBrown <neilb@suse.com>
Subject: Re: query re: resync not persisting over reboot in rescue mode
Date: Fri, 28 Oct 2016 16:36:38 +1100
Message-ID: <87zilprq55.fsf@notabene.neil.brown.name>
References: <1477266640.7137.13.camel@adelaide.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477266640.7137.13.camel@adelaide.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Kortschak <dan.kortschak@adelaide.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Oct 24 2016, Dan Kortschak wrote:

> First, I'll start with an apology - I have little (~nothing) in the way
> of hard data to back up this question, but it is now just a matter of
> personal interest as the problem appears to be fixed.
>
>
> Background:
>
> Last week I tried to upgrade a kernel (ubuntu distro 16.04) but that
> failed due to out of space (the system was originally built when
> kernels were much smaller and I have now got to the point where it is
> not possible to have two kernels on the /boot partitian).
>
> On reboot the boot failed with a great deal of disk noise which
> persisted. Booting into recovery worked, and the noise was now knowable

Disk noise shouldn't cause the boot to fail....


> to be coming from a RAID resync of /dev/md0 (RAID10) after I dropped
> into a root shell. I allowed this to complete and then went back to
> resume the normal boot. This failed as before.
>
> Repeating the process above, I found that the RAID was again unsynced
> an doing a resync.
>
> This has now resolved - I again allowed the resync to complete and then
> did a /sbin/reboot from the CLI rather than going back to the recovery
> menu and continuing the boot from the menu.
>
>
> Question:
>
> What is a/are likely cause(s) for a resync to not persist over a
> reboot?

If /sbin/reboot works and the menu-thing doesn't then the menu-thing
much be doing something very seriously wrong.
You might be able to get the resync status to be forgotten if you
write something to the array and then quickly run "reboot -f -n", or
maybe "echo b > /proc/sysrq-trigger".

Given that /sbin/reboot works, I suggest you report this to ubuntu as a
bug.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYEuPmAAoJEDnsnt1WYoG5IYUQALp+o5mi5VqF3kUi1XAZ80oC
CAJ2Uz3LrHaLVnHKi3n6m1piow8kKBG7Hl1gMkucnkui3ta1iZ8BR/3r+Vgk0KyD
+gpxT76YMTK2WesiynHiqJnIuxL6vuWVBt1FeHmvgvvC8TmbLqzIDk6pMy784dWT
niLG7RsD1i4PKl5gRVZyIQuoQgzAoxqxFRo1ZmatOPixlogDFL/kgTer/FvHP7CJ
YkcgZe4ZMBET5gLXkXWiNw3aEmYIRsZ/HMZCvG8FyJVqJLXs/vujO0iR8Ea9bMvz
60yc8JYEPZ2ORV2Y749TeEZSbiLSVgbsLTGbfblGv6FuQQomQCoYjEgSUWIS09SS
nrBNrxCOweQxU31JoFMmjV1sDrdMDs5SNt7Jue3ocU/fyDZ4YM30aXLgW+tRJu13
7hcxyJ7bn+qyiRt8yIReOHt681DByEw0hYYA2c0L7DK31cVI6G+d5+gwqxsNkB7E
BoWunnJb9AbmVhkRIERkOTTEn5rwRvrtuaJq3vGK8MJqxOVIYatrh9xfMtqBYKSc
B6KdtMvPitgQrHMTvZc8ylhLeQTBlaXbNiuIghPLhc0941MF/AyPEO1Xb/UfzjM1
wBaAwDVwegOvScstCC0aFORAr1mwyXPHaGNgGNNE5NeHsZlGbKiktFUSB/NZ3VM8
dLBcRzmh2/Ec3ZfbzI4a
=6v1D
-----END PGP SIGNATURE-----
--=-=-=--
