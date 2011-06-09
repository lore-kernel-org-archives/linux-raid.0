From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Backup Server RAID Array Event Notification
Date: Fri, 10 Jun 2011 00:46:55 +0600
Message-ID: <20110610004655.66e259ad@natsu>
References: <9C.33.00666.09211FD4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ugec6Vek.oHQYuVOibUhqr1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9C.33.00666.09211FD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ugec6Vek.oHQYuVOibUhqr1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Jun 2011 13:35:59 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

>=20
> 	After I created a pair of two member RAID1 arrays and then added
> them as members to a RAID6 array, I am now getting messages similar to the
> following, complaining of "Wrong-level" issues.  When I check the RAID6
> array, however, it is clean and both RAID1 members are still there.  When=
 I
> check both RAID1 arrays, they show clean with no events.  I am running a
> compare between all the data on this machine and its mirror (this is a
> backup machine).  So far everything looks good.  What does this imply?  Is
> there something about which I should be worried?

You said RAID1 twice, and your mdadm --detail doesn't agree with you and sa=
ys
"raid0" twice. Maybe you mistakenly used RAID1 instead of RAID0 somewhere
else as well, and the WrongLevel message is trying to tell you that?

--=20
With respect,
Roman

--Sig_/ugec6Vek.oHQYuVOibUhqr1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3xFR8ACgkQTLKSvz+PZwie1ACghrLaAAdbaprJc/01gGv0Vu0f
LrwAn19/eu9X2f3wCWkVqmZZtzXAkkFd
=Q1JN
-----END PGP SIGNATURE-----

--Sig_/ugec6Vek.oHQYuVOibUhqr1--
