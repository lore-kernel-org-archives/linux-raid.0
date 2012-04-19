From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on
 shutdown.
Date: Thu, 19 Apr 2012 19:57:40 +1000
Message-ID: <20120419195740.6e35ea02@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
	<20120419084833.39379a6f@notabene.brown>
	<CAGRgLy6LXB34JtmfZYQEdAK4GLCV-hn-V8cT1zCwo_=ERyK90A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Aor8G_f+8CX9VYcdxLmMIBK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6LXB34JtmfZYQEdAK4GLCV-hn-V8cT1zCwo_=ERyK90A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Aor8G_f+8CX9VYcdxLmMIBK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Apr 2012 12:11:43 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> Thanks for the clarification.
> However, from your commit message, it stems that during a normal
> reboot (without -f -n), writes can still arrive after your reboot
> notifier has cleaned the array. In such case, array might be dirty
> after reboot. Is that so? If yes, then that's kind of regression.

Why do you think that?=20

I don't think that is the case.

NeilBrown

--Sig_/Aor8G_f+8CX9VYcdxLmMIBK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4/hlDnsnt1WYoG5AQJdVQ/8COKduK7DwKHGt3ZBOnFD6LRyRsmnC94p
qnrYzUOlgAqP9azHU9EROLJR+dQHnztPT1g6pyD8tK9jV7elqvyJhLxUNsqxU1O4
kAyAJWDhN5dwVpkW8an61oTzzxJXpF9NZkNkHk2+wMsuWbBhBu53KTBdtJ9PKq4p
4XOdz2HKa8jeU5nI8vrFdTIX9V45LjzfvcWVa0p4KsK9SnspCYbRgxp/JJc9//bL
Si5wKl6eYpN1oT574DgQAJfpHD0H2OQorn+yPwhicr98he96Pm8KZ0NQbGiu2fFW
QgsJOcZyHPSzrUT7AwTCPIBL2tV4repi4HB9dmu7ChlQypgQoXzjH4K5cxTcOzWp
Fbr17KZKfR/VJa+oKHC/czZSMn1LW+dlgWAN7X8rh81ML3vlZyMaF5MsUJE2Q+mz
KhlG27kuSom0M57Mjg3Vm+03qMFwUMhG6g5xt705+pzRQc4FemVnGGplE15gRiFd
KZxH3Ze4xL6znQYl4dh3cVOgU094BQ3ZO4IjmDtPUxBG831PNe5rjZNvPfwsa9s3
Y3Zila3Q0y4MOv5CwrZLCiLVECStBaWB/F6qP93rUBxi3r0v030dnbgdadkqFw1Y
ILjnU99oBwushx1JQ01g2jGan9xKMxbldEOZjbrDIo4xlRgJ4LsCXUet6ZyJ6t+u
IX7qzhIqC9k=
=+86H
-----END PGP SIGNATURE-----

--Sig_/Aor8G_f+8CX9VYcdxLmMIBK--
