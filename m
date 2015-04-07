From: NeilBrown <neilb@suse.de>
Subject: Re: multi-threaded raid5
Date: Tue, 7 Apr 2015 11:11:57 +1000
Message-ID: <20150407111157.2200fb0b@notabene.brown>
References: <551AD6AE.4030607@cra.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Tkk35ITO9.Xng9CzxItSrlV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <551AD6AE.4030607@cra.cz>
Sender: linux-raid-owner@vger.kernel.org
To: stkoupr <p.kouril@cra.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Tkk35ITO9.Xng9CzxItSrlV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Mar 2015 19:17:34 +0200 stkoupr <p.kouril@cra.cz> wrote:

> Hi,
>=20
> We are testing write performance of md raid5 with SSD array and we are=20
> hitting limit which I understand is caused by writes being handled in=20
> single thread (md0_raid5 process is eating 100% of 1 CPU core when the=20
> test is running). I understood that there is some work in progress which=
=20
> should make write handling multi-threaded. I'd like to ask about the=20
> status of this work, is it still in progress or planned?
>=20
> Regards,
> Prema
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

See /sys/block/mdXXX/md/group_thread_cnt

Set it to a bigger number, get more threads.

Requires 3.12 or later.

NeilBrown

--Sig_/Tkk35ITO9.Xng9CzxItSrlV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSMu3Tnsnt1WYoG5AQKYFBAAlAvd2FQgvlmDlFT9fdoA41BlnHKVx/pK
K++GthsZmcxcJdaGZ2725KHexgGeoTNnmVnMYLGsed/P+6oTEGkHLqLv/pToR3W7
gBVhPMT1QwbaWSlXi8H/wM8bd1NygS2IdlGqH87ccae1zUq139c9N/v64cndGL8R
PqHsdqNNTwJDt0k8G6MsYrYlxblt+4CQAx5/ocxJ5V02p/w1tblAYcZTkL4l+pRD
+a0oR3LR37L9o3tBYzTKJNK+zLLgHbdu1mZmusFAT0MGunFmebeHnp1U6fD26Ke1
n9lOqpWgUW/i+QgtXS6Z3KOEdg4y7hoO0z9HN+YWA8/BBxWVmOs+/Kkjw+tFqGwc
6ZTmrk6XDxMk6ZYpCt/vjKW+0vdH7xtuZGosM6W8HhvBGEvdS4e5cpOZlZqeH+2O
LlfFWKFSbO6oCmy6Q9v25Al8K4DcZri9LoZgWRe39cHyxwnYks6ASci6xhbwvjH9
N4TJs0Sy4+85HuK+UlEH2hi7GyzSibNXPLimqyIKu/0LCZ3AtUIURCp6TADOOfvr
Jmzoq2G5+KLsES8swyxcHcXqxpNu0KTSAVO1CwTZ/BRRMXD7KXEM9mANBRzunlJ4
5oX9vA9niFXbZytaz6dwvbfop1InegCH+9FhU/PiUbOXh4wCpeao53Fy1ZS31jTL
FZ6QkdxiXnc=
=gZ7z
-----END PGP SIGNATURE-----

--Sig_/Tkk35ITO9.Xng9CzxItSrlV--
