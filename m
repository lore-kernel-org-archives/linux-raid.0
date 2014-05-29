From: NeilBrown <neilb@suse.de>
Subject: Re: Understanding raid array status: Active vs Clean
Date: Thu, 29 May 2014 16:06:23 +1000
Message-ID: <20140529160623.5b9e37e5@notabene.brown>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
	<20140529151658.3bfc97e5@notabene.brown>
	<1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6bU0QKe/ojBhQrzS=o/I788"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: forumscollective@gmail.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/6bU0QKe/ojBhQrzS=o/I788
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 May 2014 07:52:02 +0200 forumscollective@gmail.com wrote:

> > I doubt there is a difference between Ubuntu and Arch here.
> >=20
> > The array should show "active" in "mdadm --detail" output for 200ms aft=
er the
> > last write, and then switch to 'clean'.
> > So if you are writing every 100ms, it will always say "active".
> >=20
> > NeilBrown
>=20
> For some reason this array has never shown Clean status, only Active.
>=20
> It isn't written to other than when NFS mounted for adding new content.
>=20
> Any idea what would cause constant writing - I presume from what I see th=
at the initial array sync completed?--

Hmmm...
Do the numbers in /proc/diskstats change?

  watch -d 'grep md0 /proc/diskstats'

What is in /sys/block/md0/md/safe_mode_delay?
What if you change that to a different number (it is in seconds and can be
fractional)?

What  kernel version (uname -a)?

NeilBrown

--Sig_/6bU0QKe/ojBhQrzS=o/I788
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4bOXznsnt1WYoG5AQLWWRAAt1QA3koccB1sBwE2gZt3Qom4JigXLMYy
J9mQQ4r7eL2XoeSxKfrv4TLpei1Y7UT5LWz1zkIFXvRCBio+BbEqfKQU77hdfIJW
18fvjAJZ8dhsY8nDs6Ynslddcq0LCc7WNno9cWtTWaAXqZbDpplCBAVt00Ayv3b+
zFL5NfbPaNyMd3JMeLRBJAIrYNUsnvUPCxpA6TsR6Kp/MkmH6eVHvpu1IVS2l9Sg
kRFqL7odoGb4SCR/dRHmT3tkm1ciI2H+Nvx6a0PmXT/EmqoU28WpXOTJdUfY+ve4
ajgN9ILiRB2BxZgzwSrZuQQluI5b2rCAGmUPM6sSkTLUHKaPhXoO+LUBWYsCyIZI
difP6V0VQP6IbPXd+PyyhWgO+AZHzn+1CRhYUK6H2Kvxh/TbEAe7F1+PpCDjzsLS
oaT+0SIyFdQsmd9rNBEVu2PnYUYVjq2KmFaAYJnhbRVQDLWE0E2sPHiWZzE3Gkv1
BYwSTUBpBeX8abrdo6g3oFoXDB4PcpwNtdG91KuS+lhk4veqrTyEwuJmYBYu5Y6F
P3mSA2GC8ucdsn+cTkh2EdVV/j9PRbaGj7SHOjNfQkqbHVr0Cos8EVo5QzbpZvBA
q/KLRDGnes+kFDg7UzxBJ/+xOLYzjH2juckqhEFM/tYTiXQkKCJHPqGE0QLAo3FG
2V/2MZ8nTDc=
=8Wl0
-----END PGP SIGNATURE-----

--Sig_/6bU0QKe/ojBhQrzS=o/I788--
