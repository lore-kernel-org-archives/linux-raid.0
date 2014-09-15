From: NeilBrown <neilb@suse.de>
Subject: Re: frequent disk activity with mdadm-3.3
Date: Mon, 15 Sep 2014 10:18:30 +1000
Message-ID: <20140915101830.3c85d423@notabene.brown>
References: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com>
	<20140912082403.549fc298@notabene.brown>
	<164CD08B-99CA-4007-855A-7B0561B4EC76@gmail.com>
	<BDDC2624-8578-4720-A526-56EFDFBE26C4@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NW1RUvwM7D//c8NTDJSG/iD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BDDC2624-8578-4720-A526-56EFDFBE26C4@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marco Schindler <marco.schindler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NW1RUvwM7D//c8NTDJSG/iD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Sep 2014 14:15:35 +0200 Marco Schindler
<marco.schindler@gmail.com> wrote:

> ok, that=E2=80=99s interesting.
> the process id is _not_ mdadm daemon and it looks like the spindown itsel=
f is triggering the process.
>=20
> ps ax | grep mdadm
> 28956 ?        Ss     0:00 mdadm --monitor --scan --daemonise --pid-file =
/var/run/mdadm.pid --syslog
>=20
> grep sda /var/log/messages
> Sep 12 13:55:04 alina spindown: sda is now inactive.
> Sep 12 13:55:09 alina kernel: mdadm(29737): READ block 3907028992 on sda =
(8 sectors)
> Sep 12 13:55:17 alina kernel: mdadm(29737): READ block 3907029152 on sda =
(8 sectors)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 0 on sda (8 sector=
s)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sector=
s)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sector=
s)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 3907029167 on sda =
(1 sectors)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 3907029166 on sda =
(1 sectors)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 0 on sda (1 sector=
s)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 0 on sda (1 sector=
s)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 3907029152 on sda =
(8 sectors)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 0 on sda (8 sector=
s)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sector=
s)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sector=
s)
> Sep 12 13:55:26 alina kernel: mdadm(29737): READ block 8 on sda (8 sector=
s)
> Sep 12 13:56:12 alina spindown: sda is now active.

It would help to get "udevadm monitor" info to correlate with this.
Presumably some uevent is generated when the spindown happens.  udev might
respond to this by reading from the device, which defeats the purpose...


>=20
> here=E2=80=99s the output of blktrace -d /dev/sda during that time.
> https://dl.dropboxusercontent.com/u/3464720/blktrace.tar.bz2

That suggest that something is reading the metadata from the device almost
constantly.  Mostly a 'kworker' thread.  I don't know what would cause that.

Let's look at the 'udevadm monitor' trace first and see what that shows.

NeilBrown

--Sig_/NW1RUvwM7D//c8NTDJSG/iD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBYwVjnsnt1WYoG5AQItjxAAh7WtecPxaD0j0r3RVNvPL/4FttJz1Ml7
PdATKOr6ESBr27oG74KRbHEawv9ZOHM7lhgYSDBYUYVWlCTDK8JxeFwvDCvHYtFN
M1St5I+CqmbMvreKkRP5pPV5PNvBIZ3/ehYDcJF6+41ob54tS/BeFlYMo42RBEKU
1W8TGutERgsqwPB+ixMyMkVPzSIFjLGyhgRZlOs6tqF+7++l5gH39ef9Ju7uDsLK
VMEdsak8kR3KJqZUrHC7NZ6+KhpChFiyM9SrG4vMmSNQnf1eqbLyG2uCyhqmnrul
4bYcJOjPo511DFj6qjoQ5FxnchIblKRb+GWTUXNhEpr12sRNtcyc3MXImY5G/p5p
WHT8+1jvj2BM6p/sI3A5KDQHl2hc+gKh0erkD3+518ByRKa5FpKCEh4pTGVIJiub
hGsN+rsJaqYY6GSWdTmmGYHsClUpYJ3L7hnjuxrNTXcfs3DtxoDM7nWd+Aunt0j/
d5pBi4TmFQZHgZLuaogpJB1jNOh+r8wk1nrvjMlyKdHWdiZI/fM1Dxmx3Z5EKZHe
MYMxoSUAtMHTbQc0R8XU60HSTQwVWr7RdrqCqcBk4Xwa1s5yefcWiz8QznhsxCjX
cwdF7x0Q+w1Lbtld2BVXBRpy6LiTJpt1lxkVMywsPEn34LyUke2ODdiABIbmsn5N
0Aq48uz0fpU=
=GTlQ
-----END PGP SIGNATURE-----

--Sig_/NW1RUvwM7D//c8NTDJSG/iD--
