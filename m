From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 device hangs in active state
Date: Wed, 29 Feb 2012 06:52:06 +1100
Message-ID: <20120229065206.60d1e2ea@notabene.brown>
References: <4F0A129E.5020706@nuclearwinter.com>
	<20120109112644.489e4a48@notabene.brown>
	<4F4D1B33.3010308@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2ModtQvoYiAwu6osxLEur6R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F4D1B33.3010308@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2ModtQvoYiAwu6osxLEur6R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Feb 2012 12:21:39 -0600 Larkin Lowrey <llowrey@nuclearwinter.com>
wrote:

> I did another sysrq dump and have attached the output.

Thanks.  Unfortunately it contains  nothing of value - too much has been
lost.  It seems that 'Show State' contains a lot more noise than it used to.

You will need to boot with=20
    log_buf_len=3D4M

or something like that.

>=20
> Again, 'iostat -dx 1' showed 100% utilization on the LVM which uses
> /dev/md0 as a pv and /sys/block/md0/md/stripe_cache_active was 29 and
> that value did not change. There were no error messages in
> /var/log/messages or 'dmesg'.

The '29' could simply mean that md/raid5 has sent 29 requests down to lower
levels which have not yet completed.
>=20
> My suspicions lie with md0 since the stripe_cache_active value remains
> at a fixed non-zero value even though all disks are (or appear to be)
> idle. Should I be looking elsewhere? This hardware did not exhibit this
> problem before "upgrading" from Fedora 15 to Fedora 16.

My guess is a problem with one of the drive controllers.  Your monthly 'syn=
c'
puts a much heavier load on them than normal IO does.  It is consistently
sending a bunch of requests to all devices at exactly the same time.  This
could trigger race conditions that normal IO does not.

But that is just a guess.  Unfortunately it is very hard to track exactly
what is going wrong in this sort of case.

I'd suggest shuffling devices so they are on different controllers, or maybe
replace a controller.  See if you can get the problem to move, and then see
which controller it stayed with.

NeilBrown


>=20
> Thank you,
>=20
> --Larkin
>=20
> On 1/8/2012 6:26 PM, NeilBrown wrote:
> > On Sun, 08 Jan 2012 16:03:10 -0600 Larkin Lowrey
> <llowrey@nuclearwinter.com>
> > wrote:
> >
> >> Suggestions?
> >
> > # echo t > /proc/sysrq-trigger
> >
> > and capture that messages that go to 'dmesg'. Post them.
> >
> > Hopefully your message ring buffer is big enough to collect the entire
> > output. If it isn't you might need to boot with
> > log_buf_len=3D1M
> > or similar.
> >
> > That should show what process is blocking on what.
> >
> > NeilBrown
>=20


--Sig_/2ModtQvoYiAwu6osxLEur6R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT00wZjnsnt1WYoG5AQJOWhAAmNcMeiCdQhgvRjmhevWeDAvwGYPAwZpN
SkwgWrbj5dLUrcEZHR4f0yqtTo/h/fRnegny+XAHiMurdEKhsUA28xIAhQd7VW/x
U3LVpXuxZyFyUKweG8YO/jx8g3CG1R7SOJp4QGirMJlNqy54aFytcYvus6PHgqv+
jbDPvg9sb+eewC5AnzB501QofxWHfsiGcv9JRiG/eQh0JhiHNB/F9fh2oh5amHRC
kjvurhbXj26dg7/exGSJkBQdyQeB47Vvl/yBFd3Tv1HyIV9Vk13SVZ9sffuTI4SF
28k4DHl41RkDy2z2r8wVYH0zItLomhWHt8/Vki23g+JHrq2ioE21pIJeMZSlUS6Q
eB+MxVmm1Q6dqGc9YAJqdxhj7Doymfs8WfDvDDzDNWLeBJ+pR50poIBBqhFHyUqn
HpSaOCvzZwt4MdNB7MAEfp80L5X5dwjKEtByel+VHBYPwbn3p7UZz32/vdqM+DWZ
hcnBnY5EENKo+22u2NWHvEXb6uEwHnEU6mUksmWrtV7UgOE6LrHiUiV/d8WGPau9
7A5erBbgwijWvhZhoIFv7EQu3BuUdTDSSJKaQU3HDxGWfquUrNLT9ANOro7USIFx
gWNB4R7CLdJcfL5gZfizKfSy0AE/SWLbobl0CMQc+Fkw+gCcuJkLggL7ilV1DHIY
fPxKV+uiFyw=
=zgWI
-----END PGP SIGNATURE-----

--Sig_/2ModtQvoYiAwu6osxLEur6R--
