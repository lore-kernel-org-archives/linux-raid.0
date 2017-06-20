From: NeilBrown <neilb@suse.com>
Subject: RE: mismatch_cnt > 0 during initial sync?
Date: Tue, 20 Jun 2017 14:14:59 +1000
Message-ID: <87lgon2t30.fsf@notabene.neil.brown.name>
References: <9A8A3C34-EED0-42FF-B631-7AD1D6EAF9A2@stanford.edu> <D974501A-3A8C-438B-A043-8E44DE6D18C7@stanford.edu> <87shix3rpi.fsf@notabene.neil.brown.name> <009901d2e946$a3eff400$ebcfdc00$@wnsdev.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <009901d2e946$a3eff400$ebcfdc00$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, 'Stephane Thiell' <sthiell@stanford.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 19 2017, Peter Sangas wrote:

>> From: NeilBrown [mailto:neilb@suse.com]
>> Sent: Sunday, June 18, 2017 2:35 PM
>> Subject: Re: mismatch_cnt > 0 during initial sync?
>>=20
>>=20
>> From the perspective of md, the initial sync is no different from any
> other sync.  It
>> will count the number of mismatches that it finds and fixes.
>>=20
>
> Should a sync always fix a mismatch it encounters?   I have a RAID1 with 3
> disks.  Sometimes I need to replace one disk and after adding a replaceme=
nt
> disk syslog indicates  "RebuildFinished event detected on md device
> /dev/md/2, component device  mismatches found: 256 (on raid level 1)" but
> says nothing about fixing it.

No, it wouldn't say anything about fixing things.  That is assumed.

>
> cat /sys/block/md2/md/last_sync_action
> recovery

This is a recovery, not a resync.  They are different.

Recovery is when you add a device to an array, and the data that should
be there is recovered from elsewhere.

Resync is when the redundancy in the array might be compromised, so it
is repaired, possibly by read-check-maybe_write.  Possibly by
read-write.

For raid1, recovery and resync and require similar.  For raid5 they are
very different.

The mismatch count is only reset when a resync starts, not when a
recovery (or reshape) starts.  So mdadm shouldn't really report the
mismatches when the recovery finishes.  The number is left over from the
most recent resync.

raid1 only counts when a resync is requested, either by writing "check"
or "repair" to the sync_action file in sysfs.  An automatic resync after
and unclean shutdown (or when array is started) just copies blocks
without checking, so it has nothing to count.
"repair" repairs any inconsistencies found, "check" doesn't.  Both count
inconsistencies.

raid5/raid6 counts for resync, check, and repair (but not for recover or
reshape).
By default, when the array is created, raid5 performs a recovery,
nominating one of the devices to be the "spare" with the others assumed
to have "correct" data.  This is faster than assuming they are all
"correct", and performing a resync.
RAID6 (the array used in the original question) does resync, rather than
recovery, on initial creation - because 2-drive recovery is/was thought
to have performance issues.

So: mdadm should be modified to not report "mismatches found" is
"last_sync_action" is recovery or reshape.

Thanks,
NeilBrown


>
> mdadm -V
> mdadm - v3.3 - 3rd September 2013
>
>
> Thank you,
> Pete

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllIoUUACgkQOeye3VZi
gbkYqA//UjkiJJ2b36XiOI8XDd2wirKu0t0D6PrmjWumpsdRM8g/ZKk1TesgpN51
JmgPoo5oPZmG3ABct5L4lEiGvS5fCt71/5tqrIhcueXMQxRWmNAHeVvkceP19AyG
ChnGDZphbRglEYjsq9IQr86v2vjjunhAwcS5JrCsDNWWhG9/8ateSZ5mlUwmmmkt
dKi+9w43K1yyt7v4RC6ECDf5XdAN08/rBK87iKIt9LezfcYg5ykfkUfYkNs3ZKI/
Rjs2TTCWtmoE3jnRpvtxLH313yOhwet3htgqjqSAyXsLUI+jThu55MVoC/wLkK+a
2DEx32kuCKXz7F1gX2eUdAfOGkak+3p6vyNPPZWvOXUVQHe8189RB7mK1eUEUzs+
/m8b8lk0jNB7w18rbosH+T0qwcJvDDiv0AYzlpIityLocp7SXnChjrCtBYKcj/rR
e+oSl2h5Z9s3Bn81eW1pMRJ82yMBBmecuG2SPmhiD6RZiicD8xvwLT/RMfF2JAxN
KqbZKlXQObj1y97iBHKrVG9p2RSMDZLos2owdUaX0QOMlVL4PL9rFwlFZM53Awo6
TE70L1je59WoAZxF3aepWEpjsNRcnGW/5DP/Aw0dvk3UzMD1bJgq11NiuUNco0RE
jP7DOsWjxKIzFdZDtHqEvv5owbiOVyCQ7I6RXt0WZNIN7U+cxHE=
=KJoW
-----END PGP SIGNATURE-----
--=-=-=--
