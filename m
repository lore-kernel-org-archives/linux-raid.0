From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] md/raid1: Refactor raid1_make_request
Date: Fri, 02 Dec 2016 11:36:35 +1100
Message-ID: <87eg1r6ub0.fsf@notabene.neil.brown.name>
References: <20161130212020.15762-1-robert@leblancnet.us> <20161130212020.15762-2-robert@leblancnet.us>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161130212020.15762-2-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 01 2016, Robert LeBlanc wrote:

> Refactor raid1_make_request to make read and write code in their own
> functions to clean up the code.

There is a change in here that is more than just a refactoring.

You have moved the wait_barrier() call from after the checks on
->suspend_{lo,hi} to before.
If a write was sent to a suspended region, this will block any pending
resync until the suspended region is moved.
The previous code won't block resync in this case.

I cannot see that this would actually have any practical significance,
as I don't think the suspend_hi/lo settings are used at all for raid1.
I'm less certain about the ->area_resyncing() test, though that probably
isn't a problem.

But it should at least be noted in the change-log that there is
potentially a functional change here.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhAwhMACgkQOeye3VZi
gblPHA//WmtQE2Ofh827N2WvLqE8pnpNrquuJSgdToYShCNf6xj03uc/MQssVvu9
PBzooo+u+Is/ybaZw+D7f+36TjVeSA7e5jKLZJ+F3JzJPPlecCQZIUbeah2a1KUx
DxqGjaZHAkx4s5mmh9e40FiGjhkrirN/v1FwhFQIP2nIPiu/di7m3svmlt0vex9h
wsIbwzI2GYGgwGa7JLjjE4dhXzzXc6YV/G2+uTsJAey4k/iWOho+9cwlFCUIZnre
1v4UgOyQUkxNk162i0vRogNn4psluurjVOmpLtj62cqd1oONuJhK4hbYi7ae7Xuk
3BYlhmpmxZMih8zYDoojaDVXEG5aslUTJkd7Rkt01XK1n7JfMdvnaViJXYEdUJ5o
C6YxE6S75UaW6KgfXb51BpHyvvpTdMIuwtrAofhIBYG8x/T88NWM78pOtcpJF/z/
Gf1t9yiOGj16qXG9vsoMxIKCq0e2jW7fZev6tTJhtvOFiZG3ViEbwz6jrbxwor+U
xiqa7hSEdlb9RtqpqHUj1TicqZYzDI9FTX5Wj5EpipWWQ99x/5resxdTYgLsXaOI
qB4ng2XFU1OOHjoNNUkgt4BF0Fu9WcgISS852LhsiEDyAA61Y9FfL3AskJYEyqJZ
/ayfjqX/icA/w7P3aRejWk21bTfctS0bLbtLqJN99paHAxloS1g=
=kLdt
-----END PGP SIGNATURE-----
--=-=-=--
