From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 data corruption during resync
Date: Tue, 9 Sep 2014 11:08:13 +1000
Message-ID: <20140909110813.3c6a15b2@notabene.brown>
References: <D4FE2D75-4208-48C9-A4D0-432F092E5AE9@redhat.com>
	<CEEAB94E-18F3-4087-A866-B412582F7B8D@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/eHyqtyRSTm4pJic3Qb9Cs6x"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CEEAB94E-18F3-4087-A866-B412582F7B8D@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/eHyqtyRSTm4pJic3Qb9Cs6x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Sep 2014 10:52:49 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
>=20
> Begin forwarded message:
>=20
> > From: Brassow Jonathan <jbrassow@redhat.com>
> > Date: September 4, 2014 9:01:58 AM CDT
> > To: NeilBrown <neilb@suse.de>
> > Cc: Eivind Sarto <eivindsarto@gmail.com>, "linux-raid@vger.kernel.org R=
aid" <linux-raid@vger.kernel.org>
> > Subject: Re: raid1 data corruption during resync
> >=20
> >=20
> > On Sep 4, 2014, at 12:28 AM, NeilBrown wrote:
> >=20
> >>=20
> >> Neither of these explain the hang you are seeing.
> >> I note that the "md0-resync" thread isn't listed.  I don't suppose you=
 know
> >> what it was doing (stack trace)??
> >> Also, had  "md: md0: sync done" appeared in syslog yet?
> >=20
> > The sync has not yet completed (no message).  I'm not sure why the resy=
nc thread didn't automatically report, but I've grabbed the entire trace fr=
om the machine ('echo t > /proc/sysrq-trigger') and it appears there.  The =
traces are attached.  (Would you rather have something so large posted in-l=
ine?)
>=20
> I didn't see this message come through yet.  I am resending it with only =
the trace you requested from the mdX_resync thread.  If you need the entire=
 list of traces, I can try resending that.
>=20
>  brassow
>=20
> Sep  4 08:52:00 bp-01 kernel: mdX_resync      D 0000000000000008     0 12=
374      2 0x00000080
> Sep  4 08:52:00 bp-01 kernel: ffff880207a5bb38 0000000000000046 000000000=
0000296 ffff88021727efc0
> Sep  4 08:52:00 bp-01 kernel: ffff880207a58010 0000000000012bc0 000000000=
0012bc0 ffff880214de0f40
> Sep  4 08:52:00 bp-01 kernel: ffff880207a5bb60 ffff88040171e178 ffff88040=
171e100 ffff880207a5bb58
> Sep  4 08:52:00 bp-01 kernel: Call Trace:
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff81580549>] schedule+0x29/0x70
> Sep  4 08:52:00 bp-01 kernel: [<ffffffffa038a122>] raise_barrier+0xe2/0x1=
60 [raid1]
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0=
xe0
> Sep  4 08:52:00 bp-01 kernel: [<ffffffffa038b701>] sync_request+0x161/0x9=
e0 [raid1]
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff8108ee13>] ? __wake_up+0x53/0x70
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff81460009>] md_do_sync+0x849/0xd40
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff8108847f>] ? put_prev_entity+0x2f=
/0x400
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff81460816>] md_thread+0x116/0x150
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff8158006e>] ? __schedule+0x34e/0x6=
e0
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff81460700>] ? md_rdev_init+0x110/0=
x110
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff8107083e>] kthread+0xce/0xf0
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_sh=
ould_stop+0x70/0x70
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff8158412c>] ret_from_fork+0x7c/0xb0
> Sep  4 08:52:00 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_sh=
ould_stop+0x70/0x70
>=20

I did get the original thanks, I guess it just didn't make it to the list as
well.  Probably there is a limit on attachment sizes which isn't entirely
unreasonable.

No brilliant ideas yet...
That fact that there are no kernel messages: no "sync done" or "redirecting
sector" or "unrecoverable I/O" is a little surprising...

It appears that conf->barrier is elevated, implying that there is a resync
request that is still in-flight.  However there I cannot think were it would
be.
It might help  if I could see the disassemble of raise_barrier() so I could
confirm that "raise_barrier+0xe2/0x160" is in the first or the second
"wait_event_lock_irq" call.  I assume it is in the first, and is waiting for
the request that kcopyd wants to submit, to complete.
It it were the second then it would be waiting for ->start_next_window
to increase.  That happens when allow_barrier() is called.  If that were
the blockage, it means that some normal write is in-flight, rather than
an sync request.  But I don't know where it could be either.

So - still mystified.

NeilBrown

--Sig_/eHyqtyRSTm4pJic3Qb9Cs6x
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA5S/Tnsnt1WYoG5AQJgvg/+JrkXOL8KQUHzAc0RZbZJfh6lJdWAd2qd
dnq+OuXt5npgXoErTVAUHgMFW6bwhyjL9LXNVH3abDF4pLPejC4YcONaPUkNOJr7
QJTpdd0Pc5ZjVgLDwWPSIdHIm3j0dzsM3aJQCA/1HsAA5SH1JImlnhDMo3ZYGFQD
UhX3fmMxJj+NDeOK/rdbGdigQvmdh6f8olJguVcWBMUGFXFTdyC8AOZVQ2TNcUWO
pVyjs8kz/txukopin4VFspGAi1rvO3W5qFIoc/ohenTzY3nWqr8WGFBxCsd6F9g3
dpznD6Qks2eH1rpOpMZHNJmJctwagiWYFro4ZG5+SVzWV7CeHttqUZIKANcHd0aV
eGrLhU2aoCHCoiVTB1uc/LrZJMxGzjiJQxt0E0oy05ysUVpkxBjxgitrmMCQ5LHc
UWt7UAISo+GbjrL5JHzg//MKBpKsHvpx7pWx9x8KqFHWDkx1st25YM08vlTR2gT0
IaJSi+76NEqvw7r05PsONqOYDZZTT67tMZWQ1AQy/BBQCvZsq/+DHShGyWYY0PLc
oyP1glJyAg12HGSPUZqzS7VT+cQ6QiczXW3cYDt12mXrk4BWJ4sWKIwTmyUqEer1
oXvJZ9i9btzuLTZ+GkU8Zks+GJ0zc/FIttvCz0bWSgaF2TgpeuEDTPiRf9w0VUhg
LRrbntfIsyQ=
=wNt6
-----END PGP SIGNATURE-----

--Sig_/eHyqtyRSTm4pJic3Qb9Cs6x--
