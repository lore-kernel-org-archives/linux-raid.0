From: NeilBrown <nfbrown@novell.com>
Subject: Re: Start reshape failed
Date: Mon, 21 Dec 2015 12:09:26 +1100
Message-ID: <87fuyw620p.fsf@notabene.neil.brown.name>
References: <CAN4XXPD2bmrJKRBMm+3Rz4_pegBK4Qp37cn2O-TvEZZ8ww1bFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAN4XXPD2bmrJKRBMm+3Rz4_pegBK4Qp37cn2O-TvEZZ8ww1bFw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kev Dorman <kdorman036@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Dec 16 2015, Kev Dorman wrote:

> Hi,
>
> Xiao Ni posted back in September about a problem where mdadm --grow fails with:
>
> mdadm: Failed to initiate reshape!
>
> I'm seeing the same problem, with mdadm 3.3.4, Kernel 4.3.0.  I can
> reproduce this reliably
> when adding a device to a 2-device raid0 array.  Instead of switching
> to raid4 for the
> reshape, then switching back to raid0 when done, it ends up in raid4
> in recovery mode.
>
> I tried the suggested change of adding a call to md_check_recovery()
> in action_store(),
> and that does seem to help most of the time.
>
> I was curious if there is a better solution, and/or if this or another
> change will show up in
> 4.3.x soon.

I have a patch queued in my for-next branch which I'll send to Linus
before Christmas.  It should then get into 4.3.x in early January (at a
guess).

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd1FGAAoJEDnsnt1WYoG59fEQALiq++FMen8R1DSicTL5urTG
z253+JOQBoYwNFQVvilFsYJtPtRiecrlj/6lOJHmWl7ABIfseCt9Lx8rIEKKJjqN
iNB6Hy/IXZoRJR1jpcssPPEwgMjazzCuPokjDY0nF9c34rVh1rm+gHdQcqDqdN/g
kZVEzz3HzyH0E46GZPM8L5xiOWgvt0BZl9z+hPihl2xa7wtG9R/Is5sb0ssX4p0E
p3ZDw5RyuL48SRcEmoqjSev7/ukEfBWaRJeTCXNkKt8WTh6Lr7BJKtemyVnmWrZv
1gyW7obE38gvxKnWqcIG+Tbzp/ORC06OivnMPLB8Y1HgG0hsYlCBRAa1Z+hcVydc
h2HnUw2ehCMMdIB/g5TyZwy/Tjapr8vViU591NeTNkTAO0hU6OkDgunt5AV3Dpsb
+hCw7jvCr4qIU9qnq/WBkgj/TsKPpEAMG0iT5bzaHVO0O2k8AXr92GHEicC6ijN2
9k5WDKGlw60yNwKHZH+CyiJp6243hK5UYQV7OmZl3DwqxOjFyRISPVG49B6XQW0I
y3XxNxioV9W30BwVspRiZBBjiU9rYi7ufwDk4vKL8g6mBOI12oUpNMDLztUfAlIR
Zf6vAGFN76AFHVUYV4sG+yXSPriXDE3+iwsDh3yut8LJoeuJrDZnFFnnWyy3mtde
4JdM1a24FnqUXvtrzoqN
=Uers
-----END PGP SIGNATURE-----
--=-=-=--
