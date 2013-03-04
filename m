From: NeilBrown <neilb@suse.de>
Subject: Re: Periodically scanning RAID arrays for inconsistencies
Date: Mon, 4 Mar 2013 16:42:21 +1100
Message-ID: <20130304164221.70d51311@notabene.brown>
References: <81526C3C-7F95-4A17-B91B-8FD45BED55DE@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tvhiup_EkbQLbPS9x2VfS8M"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <81526C3C-7F95-4A17-B91B-8FD45BED55DE@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/tvhiup_EkbQLbPS9x2VfS8M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Mar 2013 15:50:05 -0600 Brassow Jonathan <jbrassow@redhat.com>
wrote:

> Is there a way to periodically scan a RAID array to report any discrepanc=
ies?  This would be something like the initial synchronization, but would d=
o nothing but report anomalies.  For example, it is possible for tracks to =
be altered when adjacent tracks are repeatedly written.  It might happen ra=
rely, but without a periodic scan, you would never know about it.  Leaving =
aside the question of /what/ to do when an anomaly is found, I haven't seen=
 any code or indication in the man page for 'mdadm' that would suggest this=
 is currently possible.  Am I wrong?  Is there a way to do this?
>=20
>  brassow

echo check > /sys/block/mdX/md/sync_action

look for results in /sys/block/mdX/md/mismatch_cnt

See "SCRUBBING AND MISMATCHES" in "man 4 md".

Yes it would be nice if mdadm provided a nicer interface to this.  Patches
welcome:-)

NeilBrown

--Sig_/tvhiup_EkbQLbPS9x2VfS8M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTQ0PTnsnt1WYoG5AQLOsQ/6AnPNNMjmsiyMPsxvl0t4krYcZhdEWEVj
tJx+ZYXMPAru0BtPNhINOC50I3GGqiH9vqUjrQ9fskdx/CGCPiEaOo1I3lP1fmdk
C+FKJ4HRG5UBkYPuFzRfZ7O+Ov4QrZ+xVpKQvBkbg4I8+SJO8RwHwrfkq/NuhS6x
yPk9tV3xWPXnyK7rxRE2NXggqRknMK0Qb8BE6QpEpDEHdvcBc/9RlUIZl9SJqNmo
mnK35qApB2Xm5VdDHgbwSPL3MySo6AZTd/WvvwY9+ONbvi6cZYVVpthdH1yOnRA2
RooFcSxjTqOCScJD9IlYfkUOn6v1VhhgTa72iBAyus22Ty8reF1O1o4eFA+R1MuS
YQVehfIrckQ51qhmq0jzSxcP88AWFW3Erb8PtV9SNtMtBFxdRdECn01+aBNspVwz
49BsCII7uvo98AqTanOUtfmNEz4LuNU2+ZoICSTRVfX6agnZTewTOVY6T6WNYgOF
kvuuRQdx6MBcX966AVJb/v6utsOIWOOXWu8LztvH5uyIRNqczbMoOJm5TdbzGjIP
fgdgopSGjixzBPWgAKvECHuB3yv+nijEVQN4fLifRs/tZ6i+JtBbfbp3jyfvKDCj
Y1LH9+emc9savGf/ubHP5cdchfcKiywtAaR1HuMdJ8pM+u5d8/MzrYz3ichHsHY9
Jl+ztlyESEc=
=bMur
-----END PGP SIGNATURE-----

--Sig_/tvhiup_EkbQLbPS9x2VfS8M--
