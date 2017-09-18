From: NeilBrown <neilb@suse.com>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Mon, 18 Sep 2017 10:56:32 +0200
Message-ID: <874ls0s7un.fsf@notabene.neil.brown.name>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org> <871sn78pzt.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 18 2017, Mikael Abrahamsson wrote:

> On Sat, 16 Sep 2017, NeilBrown wrote:
>
>> "Hiding" is a very vague term.  Should we get Harry Potter's
>> invisibility cloak and wrap it around the hardware?
>> Do we need to:
>>  - remove from /proc/partitions - possible and possibly sane
>>  - remove from from /dev - easy, given clear justification
>>  - remove from /sys/block - I don't think this is justifiable
>>  - make open() impossible - it already is if you use O_EXCL
>> ??
>>
>> Possibly something sensible could be done, but we do need a clear
>> statement of, and justification for, the customer requirement.
>
> This is interesting.
>
> On the IRC channel #linux-raid on freenode, we have frequent visitors who=
=20
> "oh, I happened to overwrite an active component drive with dd" or "I=20
> zero:ed the superblock on the active component by mistake" etc. So there=
=20
> is something to it to remove the "/dev/sd*" when they're part of an activ=
e=20
> md device.
>
> However, this would cause problems when people are using for instance=20
> "smartctl" and equivalent ways to pull data from the devices. Same with=20
> mdadm -E.
>
> Just thinking out loud, perhaps it would make sense to create some kind o=
f=20
> hierarchy along the lines of "/proc/mapper/md0/" and put the components=20
> there for monitoring. However, I think it would be quite confusing for=20
> users if /dev/sd[b-f] disappeared as soon as it was put into an array.=20
> There is also the question about how to refer to these devices when=20
> manipulating with mdadm.
>
> I don't have good answers, but I can say that there is user pain out ther=
e=20
> when they shoot themselves in the foot. If we can come up with a clever=20
> way to help them (without too many downsides), it'd be good.
>
> If we could disable writing to the drives/partitions from regular=20
> userspace when they're handled by md, that could be some kind of middle=20
> ground. I guess most tools don't use O_EXCL.

This is awkward.  There are times when userspace needs to write to a
device which is in used by me.  One example is when using DDF or Intel
metadata and userspace manages the metadata.  Another is using
raid6check to correct inconsistencies.

I don't object at all to making it hard for regular commands to write to
the devices, but it is hard to come up with a good way to do it.

Maybe just removing the /dev/XXX entry would be best.  That doesn't stop
a determined program, but it does make it harder for an inexperienced
user. As you say, that might cause confusion though.

It would be nice if we could simple remove write permission, but
that is ignored when root opens things.

We could add an ioctl that needs to be called on an fd before writes are
allowed.  This would effect a per-fd write access that applies even to
root.  If feels a but ugly, but might be possible.

Anyway, thanks for the example of a real problem related to this.  It
does make it easier to think about.

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlm/ikAACgkQOeye3VZi
gblkTg/8DDUM3Y94PtTZcFDy06oO+oxoV2RS/okNBIaqtbYesVscCI3MK/ciCz47
GYNLHCBu/kh4Dw3CPjBj40YYpD425OYN1nhNhT60W3sOV+AHEErlruUFRZNAgQtk
zJiFiUdo4ykOP2oyLMg+M/rlKyiyYirVX4Di+86dBT8QZAznEYMDHFXiwCtVBe2r
T9lQfHZP7bvniauhcBdTjKAK7cczOyO6mn3e31iupCkB6O2gCH6+DURWn598K9rd
7+b3lN/6OpIVpeEo8dFOpIQEDWK0dOl6GSo3UN7N7eMFNHnNZ1x9VZSfVlmXN8vA
bYc7+3fWc00cOHmDAD0Rnf0wBvfR2RDlL3Z7NomorzXFXWHbztrSVr0tEMK8slSs
UYuMbombsjflDUZ2F53kIzMO9NgACY4Q5Nb1HdDJ/G3JA9RXCC14odsqy9azuOTo
J0FkxwyE6QEmS1Yg2wVHfzOMPd8bTaEhDVATqyS6i16IP5yOYOM+kmFMRwLfLZyd
XSsbZsCXQwbDf++H0i0bE1vug8Rp2QifCFmSZpzcqQtof8PmK24PgRKO7nukyvsA
xJYBZvEH716jzJZ1KFdTtCNo/zVhsDZtJv47xleeIDU0cM6v6T8B2cDUw8iXVUCW
ANn8Fq+2nTJUBgQC450Vfikk26psIvsOjMl80UpJyChlVVixQ7Q=
=EU6e
-----END PGP SIGNATURE-----
--=-=-=--
