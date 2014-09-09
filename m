From: NeilBrown <neilb@suse.de>
Subject: Re: RAID456 direct I/O write performance
Date: Tue, 9 Sep 2014 13:24:31 +1000
Message-ID: <20140909132431.24456db1@notabene.brown>
References: <12EF8D94C6F8734FB2FF37B9FBEDD17358642FF8@EXCHANGE.collogia.de>
	<12EF8D94C6F8734FB2FF37B9FBEDD17358643012@EXCHANGE.collogia.de>
	<5408D5CC.101@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//m.OM8fCq8W4gglo1zoj+Fg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5408D5CC.101@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//m.OM8fCq8W4gglo1zoj+Fg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 04 Sep 2014 23:12:44 +0200 Ethan Wilson <ethan.wilson@shiftmail.org>
wrote:

> OTOH I would like to ask kernel experts one thing if I may: does anybody=
=20
> know a way to get a stack trace for a process which is currently running=
=20
> in kernel mode and is running NOW on a CPU and it is not stopped waiting=
=20
> in a queue? I know about /proc/pid/stack but that one shows=20
> 0xffffffffffffffff for such a case. Being able to do that would help to=20
> answer the above question too...

The contents of the stack would change while it was being inspected, so it
would be impossible  to get a meaningful trace.

Maybe you could disable all but one CPU.  Then whenever you try to look at
the stack of another process it must have scheduled and so will have a
stable visible stack...

Or maybe you would use "perf record -g" to get some stack information, I'm
not sure.

NeilBrown

--Sig_//m.OM8fCq8W4gglo1zoj+Fg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA5y7znsnt1WYoG5AQKAAQ//c3Ag0bKH0E94ohnd8ABrw7wn4+NNEjyn
O9YOBrR/+1r7L+MY0mO3KiangjNBbyZBoyFHMp9kEW41f5G3iCnmx66QI2YoOAcH
KLMX79wVxl2Alc9CHGjaVHkmaMXZkUIDIqqIU3jEj5VlIR9GT+Z3eV4pTVauMAQ3
0Abpqs+eYwDN+mS6edLbHZRNXwLz9p2hz2V/fBz+fugksn1MZYN0K3mSxAV78kIC
iI7bhVtgPopdAOoPZTte08yME0zyd4ThJE5YCCpL74o9FTwuwtSRtLAKuLgmofCh
HgUBhSO0mejcd2m+/0ua1VnKM42b5q6vwBoNR644onlQn+eVLCfu+ToHVRIktq5k
ZXku9kGlGwTqc1WnstI94GAVDCWNcPkUpCcdGLzx8PNnUOe90gx7ffWRWFQ1mj3g
jeFTkAjVqSaWfunH8yUcb0/+1jD7Hi12ktf32N1gMX9GL+pA958I0n9Yq7zqXbXK
ZrZ3gpjnl95ClwjX9hs5xKEj8g4F7vAcZZejysPI/cyfO/uZQxpUkRSLeqUWE5jb
NdZHmP2AfZjc+xda1oifazqW0+/xNS0Ekq+vM4OoAJXKAtxdH0HPf2pCTZSNo/vP
jI1vtXa0X5frNSaj7NLWFvrL+29EqS0tsmfGBT9HPLkrEv8VVjHaBwyeKWGlyHHU
cyecp2L/svU=
=4FP7
-----END PGP SIGNATURE-----

--Sig_//m.OM8fCq8W4gglo1zoj+Fg--
