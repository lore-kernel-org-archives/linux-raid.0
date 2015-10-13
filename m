From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/6] md: don't export log device
Date: Wed, 14 Oct 2015 07:41:58 +1100
Message-ID: <87eggyzejt.fsf@notabene.neil.brown.name>
References: <cover.1443973492.git.shli@fb.com> <7aecea0895b46e28c2b8a876a83da10d7f30d7f1.1443973492.git.shli@fb.com> <87pp0q6s1i.fsf@notabene.neil.brown.name> <20151008031644.GA3063621@devbig084.prn1.facebook.com> <87bnca6lli.fsf@notabene.neil.brown.name> <20151008043121.GA3189627@devbig084.prn1.facebook.com> <8737xl7v5l.fsf@notabene.neil.brown.name> <20151013120719.GA9734@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151013120719.GA9734@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Oct 08, 2015 at 05:04:54PM +1100, Neil Brown wrote:
>> Having two disks with ->raid_disk=3D=3D0 does seem a little weird, but w=
e do
>> already have that in some cases.
>> When you have a hot-replace going, both the original and the replacement
>> have the same ->raid_disk numbers.  They can be distinguished by the
>> Replacement flag.
>> I'm suggesting the same (sort of) for journals, and distinguish by the
>> Journal flag.
>>=20
>> I did quick audit and just found setup_conf, run() and md_update_sb().
>> If you could do an audit to that would be good.  I'd be surprised if you
>> find many more places where Journal needs to be tested with ->raid_disk.
>
> Overloading positive numbers for the journal disk sounds like a bad idea
> to me as it will cause a lot of confusion.  I'd rather assign specific
> negative values to special roles outside the actual rate.  This will
> require an initial audit, but give us nicely understandable rules later
> on.

The positive numbers are in different name-spaces:
 primary raid disks
 replacement raid disks
 journal disks

While confusion is always possible, I think keeping these separate is
not that hart.  For example ->raid_disk is primarily used to place the
rdev in an array after which it is the position in the array which is
primarily used.  The value of ->raid_disk is mostly tested only for
whether it is <0 or not.

I'm certainly happy to do our best to remove sources of confusion from
the user-space view of these numbers (e.g. put 'journal' or 'none' in
the 'slot' file, not '0' (and definitely not "-5")).  But internally to
the kernel it is important to remember that it isn't a primary key - and
once you do that there is not much chance of confusion.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWHWyWAAoJEDnsnt1WYoG5bCoQALyU/HkHRlebpa2JBdf4QGAC
O849WrV3u0lG1i9wmkh944x6lS79qO4sJ/MDLCGYYej/TA++Cl2rC450a35vXrpD
CLibqyBEukRaMxMtpq7WgoV3wC6pg+fxsjHkeQFZnfH8b6lg6nXgjZ09DSr1xPds
veEwDFhK72mHWJ16i1l91RUr3DIYWH0lkEZt+ZD+X7yQO3czmC7/ghB6C/euVTy5
oWfuvk82scNUbeIc9OU5F5aFMW96VNvahdbWWCat2VE7uGxFBkD5DzJR9Y1RRbav
a3jnAbyQEJO8BTvsuS2RjdCVl92qrPxvYspuHWevWA40uJEraunsmWciEw+cO7eu
iqlek8zuuWIiFrp1DKY3lynH+eCbHEOktax+fRUkO0R4zX2dDg8Qg838WwUl8Vxy
/YKXZkLIVEKMy0ajF7Q2y1F7Vuw9SiTtmSfQc+Qam1qp8XzG5DzDvmyfTmU+WR7e
MpeErlcEdXckX4gs5/DiVUtAN5bXOiqpy73ZgznMTP5uZmGYV5QrAmhJlwFKvX51
qBW9nBHO11bCU6xVweQdx1sXaujSWDvECFgrThKa0BcqM9vygMM+S04SnxZXBWUR
zr8qmzk5Kk+9lNxFvkK6CI2jlwTpaPNjjvN9xxUsUE2sv3T3A6fTUaQqV8eidmeo
me8vKtsjat+nhs+iRtLR
=HR4X
-----END PGP SIGNATURE-----
--=-=-=--
