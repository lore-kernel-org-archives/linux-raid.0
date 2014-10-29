From: NeilBrown <neilb@suse.de>
Subject: Re: Raid1 element stuck in (S) state
Date: Thu, 30 Oct 2014 09:47:34 +1100
Message-ID: <20141030094734.2451cc24@notabene.brown>
References: <87k33lwq7s.fsf@muck.riseup.net>
	<20141029084224.6d92d8be@notabene.brown>
	<8761f3q8gr.fsf@muck.riseup.net>
	<20141030071019.1a5c57e7@notabene.brown>
	<87zjcepnno.fsf@muck.riseup.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=W1sGg=HFQv/l_JX0M.pRW0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zjcepnno.fsf@muck.riseup.net>
Sender: linux-raid-owner@vger.kernel.org
To: micah <micah@riseup.net>
Cc: micah anderson <micah@debian.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=W1sGg=HFQv/l_JX0M.pRW0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Oct 2014 17:32:43 -0400 micah <micah@riseup.net> wrote:

> NeilBrown <neilb@suse.de> writes:
>=20
> > On Wed, 29 Oct 2014 10:03:16 -0400 micah <micah@riseup.net> wrote:
> >
> >> NeilBrown <neilb@suse.de> writes:
> >>=20
> >> > On Mon, 27 Oct 2014 10:18:47 -0400 micah anderson <micah@debian.org>=
 wrote:
> >> >
> >> >>=20
> >> >> Hi,
> >> >>=20
> >> >> i've got a raid1 setup, where one drive died, it was replaced with =
a new
> >> >> one, but its stuck in a (S) state and I can't seem to get it added =
into
> >> >> the array, /proc/mdstat looks like this:
> >> >>=20
> >> >> md3 : active raid1 sdc1[2](S) sdd1[1]
> >> >>       976759672 blocks super 1.2 [2/1] [_U]
> >> >>=20
> >> >> where sdc1 is the replaced drive.
> >> >>=20
> >> >> What is the right way to get this added back?
> >> >>
> >> >
> >> > I've a feeling this bug might have been fixed.
> >> > What versions of mdadm and Linux are you using?
> >>=20
> >> I'm using squeeze here, and had 3.1.4-1+8efb9d1+squeeze1 installed, I
> >> just installed the backport, which is 3.2.5-3~bpo60+1.
> >
> > Is assume that is the version of mdadm.  You didn't say what version of=
 Linux.
>=20
> Yes, that is the version of mdadm. I am running squeeze, which is a
> 2.6.32-5 version of the kernel, and it is an amd64 machine.

Wow.... a 5 year old kernel.

I suspect this is a kernel bug you are hitting.  I vaguely remember somethi=
ng
like that - spares not becoming properly activated after recovery.
I don't remember the details and a quick look at commit logs doesn't show
anything obvious.
And maybe Debian has backported something which broke something.

Can you try a newer kernel at all?


NeilBrown


>=20
> >> > Are there any errors in the kernel logs when you --add the device?
> >
> > You didn't answer this question either.  Are there any messages in the
> > kernel log: /var/log/kern.log on debian.
> > Or in the output of "dmesg".
>=20
> The only thing I see in the log is:
>=20
> [307932.328420] mdadm: sending ioctl 1261 to a partition!
> [307932.328425] mdadm: sending ioctl 1261 to a partition!
> [307932.346642] mdadm: sending ioctl 1261 to a partition!
> [307932.346648] mdadm: sending ioctl 1261 to a partition!
> [307932.352466] mdadm: sending ioctl 1261 to a partition!
> [307932.352468] mdadm: sending ioctl 1261 to a partition!
> [307932.376821] mdadm: sending ioctl 1261 to a partition!
> [307932.376824] mdadm: sending ioctl 1261 to a partition!
> [307932.377623] mdadm: sending ioctl 1261 to a partition!
> [307932.377630] mdadm: sending ioctl 1261 to a partition!
> [307932.467292] md: bind<sdc1>
> [307932.588154] RAID1 conf printout:
> [307932.588159]  --- wd:1 rd:2
> [307932.588164]  disk 0, wo:1, o:1, dev:sdc1
> [307932.588167]  disk 1, wo:0, o:1, dev:sdd1
> [307932.588248] md: recovery of RAID array md3
> [307932.588251] md: minimum _guaranteed_  speed: 50000 KB/sec/disk.
> [307932.588254] md: using maximum available idle IO bandwidth (but not mo=
re than 2000000 KB/sec) for recovery.
> [307932.588260] md: using 128k window, over a total of 976759672 blocks.
>=20
> but this is just when the device is added, after that it appears that
> logrotation failed and I have a zero byte kern.log, and firewall spew
> has filled up my dmesg ring.
>=20
> >> Can I just zero the superblock of that device and re-add it in order to
> >> resolve this?
> >
> >
> > If it resyncs and the is still spare, there was almost certainly some s=
ort of
> > failure.  There really must be something in the kernel logs at that tim=
e.
>=20
> It did resync, and is still a spare.... Now that I've fixed the logs,
> I'm going to try it again to see if there is any error that happens
> after the sync finishes.
>=20
> micah


--Sig_/=W1sGg=HFQv/l_JX0M.pRW0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFFuhjnsnt1WYoG5AQKAzw//Vcy9v3mO3VpKyL+LJBgA7uPGcFpHXmPu
9KdnXwzMAFcxyTLNYuvzEdmNLnBG1iSyv/Vkx8nbJs7jxf4blUnwkGSfNifmOC6t
gB1lrX4hV5/+PbeIZmSXAMOsp6jM5itotUFL5ECs8IlMMW82fc7Ji1pfRIphczkU
LY3c+29E24uVXbfEClgQLXe1ZGpKweGgPzMvl/EOtMgB5XdoKCIQbuEqbQUX+G6S
zD6fschTWugzsF3+w2aduGkhAXk5mqBv7NKtMuwzgq+lMKymKePBwcTEB2/4+tSD
T8v4ZKwolhucT15lhKlgfGpj/bdZl9PkJYO/XbODd74fXDX9JiYwKIQ87eGlJMup
mjrwBabnQCZ1YkKFQxNw1jd9axG6jxKdNz/mbUxfftthaQt9dc+0qA3sKp0p9GGQ
Jzv0zTUfY7WQvPBC62h0SNhLGl2/aO26AuYflyqZ3nlXcsqogdcdJZhMjyM/MaGK
/jGgn7Ee08Tx8IpdtV1TmFX5K1YDIr72wcbBTMXVbCCOjsvJ3IE1eTjKVdapAVaZ
lfYUC1jdIAKRoxG7XS3ricMbR8woTISveb3bhd7lfHFwpnbJn5jQPEnI1GJDqrxW
Q9Gc3+2gR/y3OXrmYYN9RjLsh57A0oJpAojV9evRUwjJBfY7Kwj0MAGZg8QgvBnj
s7H87oyFUck=
=XrdJ
-----END PGP SIGNATURE-----

--Sig_/=W1sGg=HFQv/l_JX0M.pRW0--
