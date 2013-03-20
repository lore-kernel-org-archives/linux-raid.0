From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Western Digital Green 3TB SATA3 experiences
Date: Wed, 20 Mar 2013 14:48:05 +0600
Message-ID: <20130320144805.15140c70@natsu>
References: <1363766982.51496ec6ea41f@mail.inbox.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AT0NWpmW6OXQMG5GkI7rDAS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363766982.51496ec6ea41f@mail.inbox.lv>
Sender: linux-raid-owner@vger.kernel.org
To: Andris Berzins <pkix@inbox.lv>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/AT0NWpmW6OXQMG5GkI7rDAS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Mar 2013 10:09:42 +0200
"Andris Berzins" <pkix@inbox.lv> wrote:

> I am running RAID5 array on 6x 3TB WD SATA disks.
> I have problems with all of these disks (including replaced one).
> Disks are being randomly kicked out from array and SMART shows
> pending sectors which usually can be fixed by read-write or write to that=
 sector.

Perhaps you have a problem with something other than the drives, e.g.:

- a bad or insufficient PSU, providing too low (or too high) voltage over 5V
  or 12V (this could manifest only under load, too);

- not enough cooling?=20

- inadequate case, resulting in overly high vibration or even resonance?


> Has anyone experienced something similar with WD green series?

If you see a sectors repeatedly appearing that become unreadable but are fi=
xed
after a write, it is usually a symptom of a drive that is partially defecti=
ve
and should be exchanged.=20

But since you have this symptom with all of them, maybe the cause is differ=
ent.


> Is this because of WD "green" series?

No.

--=20
With respect,
Roman

--Sig_/AT0NWpmW6OXQMG5GkI7rDAS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFJd8UACgkQTLKSvz+PZwhcewCeKXVmW/GhIMAVPd8CbaakGk1r
TF8AoIyRi3MssVVWNLDWtyOMjoBfbtZs
=Bikq
-----END PGP SIGNATURE-----

--Sig_/AT0NWpmW6OXQMG5GkI7rDAS--
