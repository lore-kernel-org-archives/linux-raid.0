From: NeilBrown <neilb@suse.de>
Subject: Re: md device io request split
Date: Wed, 23 Nov 2011 13:31:24 +1100
Message-ID: <20111123133124.2042c1f4@notabene.brown>
References: <20111122093634.105520@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p_+oU2Wvnwl.KymSz+S6KUC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111122093634.105520@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon =?ISO-8859-1?B?U2No9m5ib3Ju?= <RSchoenborn@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/p_+oU2Wvnwl.KymSz+S6KUC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 10:36:34 +0100 "Ramon Sch=F6nborn" <RSchoenborn@gmx.net>
wrote:

> Hi,
>=20
> could someone help me understand why md splits io requests in 4k blocks?
> iostat says:
> Device:	rrqm/s	wrqm/s	r/s	w/s	rMB/s	wMB/s	avgrq-sz	avgqu-sz	await	svctm	%=
util			=09
> ...
> dm-71	4.00	5895.00	31.00	7538.00	0.14	52.54	14.25	94.69	16041	0.13	96.00
> dm-96	2.00	5883.00	18.00	7670.00	0.07	52.95	14.13	104.84	13.69	0.12	96.00
> md17	0.00	0.00	48.00	13234.00	0.19	51.70	8.00	0.00	0.00	0.00	0.00
>=20
> md17 is a raid1 with members "dm-71" and "dm-96". IO was generated with s=
omething like "dd if=3D/dev/zero bs=3D100k of=3D/dev/md17".
> According to "avgrq-sz", the average size of the requests is 8 times 512b=
, i.e. 4k.
> I used kernel 3.0.7 and verified the results with a raid5 and older kerne=
l version (2.6.32) too.
> Why do i bother about this at all?
> The io requests in my case come from a virtual machine, where the request=
s have been merged in a virtual device. Afterwards the requests are split a=
t md-level (vm host) and later merged again (at dm-71/dm-96). This seems to=
 be an avoidable overhead, isn't it?

Reads to a RAID5 device should be as large as the chunk size.

Writes will always be 4K as they go through the stripe cache which uses 4K
blocks.
These 4K requests should be combined into large requests by the
elevator/scheduler at a lower level so the device should see largish writes.

Writing to a RAID5 is always going to be costly due to the need to compute
and write parity, so it isn't clear to me that this is a place were
optimisation is appropriate.


RAID1 will only limit requests to 4K if the device beneath it is
non-contiguous - e.g. a striped array or LVM arrangement were consecutive
blocks might be on different devices.
Because of the way request splitting is managed in the block layer, RAID1 is
only allowed to send down a request that will be sure to fit on a single
device.  As different devices in the RAID1 could have different alignments =
it
would be very complex to track exactly how each request must be split at the
top of the stack so as to fit all the way down, and I think it is impossible
to do it in a race-free way.
So if this might be the case, RAID1 insists on only receiving 1-page reques=
ts
because it knows they are always allowed to be passed down.

NeilBrown

--Sig_/p_+oU2Wvnwl.KymSz+S6KUC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsxa/Dnsnt1WYoG5AQJNPg/+OMI8ngTjWRWxWeGlBxiaADXZpqOYOFvb
8odFqD+kDts0ozczEq93MbpE+EHqDCaQpLNgQs6jTjZEfWXyGwXAFBmrHYF/z5Q/
af8S1td8qfkFVROGN0fej0yu7jocnBsudyOtizuC9jI/GTp9FRmz4PytwT85Ucin
XVo7L7QVZnmVzUSiuY5UhRDWHBWHDQnEuVXjucC3Fa7XBz4858KyX0oH/rqnjS3I
zBgno4UGQpmE+huA/snK/fqMcOw6x5V+iIfLwuElw3irOxRGxGMyEQkMeNu/jVQX
hPWq30elW0hHMGnwZn55+T20TN0PH6+BoNpHD16cZy7N+XwF6YAKgCWu3PjTgQ40
10bduxkkqt8U6d14nOOCp9kstuGJUq2PW9QIcM/p0wahybLImcZbq+2cckUlFJSY
Qkh1opqSllbtfk0rZFD9U6CxG1XKrLCCPu4mqx8VWQPogVDNLP4SM/UBiZ2BqCwJ
qi5274/QituuwaVIhnshX+Ppomo4SITHQcKGXAFUm5P4ZU/8QX6LilvqfPmMnqJD
hSvtHpMpH0+bVyneseeFxxJd/j0kAzS9M9KinRxpCt7bcR1QN1FkxfF6zMaFjGpD
UH6DhcNxXrr7xwGc8JY1tZyDwdl15WCpukIGbTf2qCyvH1U+HI7Kk/393It0Yc4Z
7hA6X5JVduE=
=Gl1B
-----END PGP SIGNATURE-----

--Sig_/p_+oU2Wvnwl.KymSz+S6KUC--
