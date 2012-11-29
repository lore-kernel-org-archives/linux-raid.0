From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: Re: [Bug 45351] General protection fault in raid5, load_balance
Date: Thu, 29 Nov 2012 13:54:53 -0800
Message-ID: <20121129215453.GA1353@jtkukuna_gentoo_sb.jf.intel.com>
References: <bug-45351-6135@https.bugzilla.kernel.org/>
 <20121128103306.23F2011FB83@bugzilla.kernel.org>
 <20121129122448.485d2cce@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121129122448.485d2cce@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 12:24:48PM +1100, Neil Brown wrote:
> On Wed, 28 Nov 2012 10:33:06 +0000 (UTC) bugzilla-daemon@bugzilla.kernel.=
org
> wrote:
>=20
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D45351
> >=20
> >=20
> > Cyril B. <cbay@excellency.fr> changed:
> >=20
> >            What    |Removed                     |Added
> > -----------------------------------------------------------------------=
-----
> >      Kernel Version|3.5.0                       |3.5.0, 3.6.8
> >=20
> >=20
> >=20
> >=20
> > --- Comment #1 from Cyril B. <cbay@excellency.fr>  2012-11-28 10:33:05 =
---
> > I've just tested 3.6.8, I still get the same bug/trace.
> >=20
>=20
> Hi Jim,
>  could you look at this bug please?

Hi Neil,

Thank you for bringing this to my attention.

>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D45351
>=20
> It seems to be crashing in xor_avx_4:
>=20
> [48595.135046] general protection fault: 0000 [#1] SMP
> [48595.135093] CPU 0
> [48595.135098] Modules linked in: nf_conntrack_ipv6 nf_defrag_ipv6
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_multiport coret=
emp
> hwmon i2c_i801 shpchp pci_hotplug ehci_hcd usbcore usb_common netconsole =
e1000e
> [last unloaded: scsi_wait_scan]
> [48595.135211]
> [48595.135224] Pid: 2429, comm: md4_raid5 Not tainted 3.5.0 #2           =
     =20
> /DH67BL
> [48595.135263] RIP: 0010:[<ffffffff813512d8>]  [<ffffffff813512d8>] xor_a=
vx_4+0x48/0x350
> [48595.135303] RSP: 0018:ffff880213a259d0  EFLAGS: 00010282
> [48595.135323] RAX: 000000008005003b RBX: 0000000000000008 RCX: ffff88021=
30b5000
> [48595.135346] RDX: ffff880212c9f000 RSI: ffff880212c9e000 RDI: 000000000=
0001000
> [48595.135368] RBP: ffff880213a25ac0 R08: ffff8802130b4000 R09: ffff88021=
2c9e000
> [48595.135391] R10: ffff880212c9e000 R11: 0000000000000000 R12: 000000008=
005003b
> [48595.135413] R13: 0000000000000003 R14: ffff880213a25cd0 R15: 000000000=
0001000
> [48595.135436] FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlG=
S:0000000000000000
> [48595.135471] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [48595.135492] CR2: 000000000235f570 CR3: 0000000001c0b000 CR4: 000000000=
00407f0
> [48595.135514] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [48595.135537] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
> ....
>=20
> [48595.136063] Code: b5 30 ff ff ff 48 89 95 28 ff ff ff 48 89 8d 20 ff f=
f ff 4c 89 85 18 ff ff ff e8 c4 04 ce ff 66 90 49 89 c4 0f 06 66 66 90 66 9=
0 <c5> fc 29 85 50 ff ff ff c5 fc 29 8d 70 ff ff ff c5 fc 29 55 90

The code dump above is quiet revealing. The relevant instructions are:

	clts
	vmovaps	%ymm0,	-0xb0(%rbp)
	vmovaps %ymm1, 	-0x90(%rbp)
	vmovaps %ymm2,	-0x70(%rbp)

These instructions save the floating point state before we begin the
actual xor work. Looking at the register dump, -0xb0(%rbp) is not
properly aligned to 32 bytes, hence the #GP.

The question is whether the #GP still occurs after
841e3604d35aa70d399146abdc526d8c89a2c2f5.

Before that commit, we manually saved and restored the floating point state
to the stack with the YMMS_{SAVE,RESTORE} macros. After that commit, we
use the kernel_fpu_{begin,end} routines. In the former case, it would seem
GCC is ignoring our request to align the stack variable to 32-bytes and
841e3604d35aa70d399146abdc526d8c89a2c2f5 should resolve the problem. In the
later case, we will need to investigate further.

Thanks.

--=20
Jim Kukunas
Intel Open Source Technology Center

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQt9mtAAoJEJsd5ffp0QqMf04P/1sf9qVER/WSZlpGGlcKuh32
8sAqkI/1vqRBXj6p2w5vajyV3hvfF13QT6Tp9vFDoPvvN52Nj106PwnjbCgkQQZq
dsEa1a95JMWZuY2xjeKPrPttm0kJKkaB58Urpr0m17vS3zU5bo40N9YKILAmFFDQ
KMBZdJ88xUqPOXgQY9N5Ru4xiJ52CequEkUqlh9Z8hxE0bmELq/x1K0VQW1CJ5vY
y8qqXVTwV1ugppM1l29AS1TqHQ+5VZw1RXqZ84VfF7bDCsr3Ug9cAqkNfq/0k/IO
Zd1GslA1kgf9/mt029vdkmbIqB/edR4wpKtJoRoMa+rJlXgKZCjuqxA6ZXDmAy8/
d/IJvqjg21Qc1iVdIZeU/DvzASbx9ZVDvKlEmSAWJDnXZ35pyEtlK2zDa2L20Glg
M5hv2vIZo/2Fc9djm+8FyyHoCsPxJy9Qw3FFZkyrsv0LKWBxEY/m++jzZrL6mIdt
/sob8LDJ6SB1ytVSayyQrbp9I6dBETrwnHrYjFQBaPS1mOzRHgwBMNRS1LbDHUkF
zhlr0r/Hd65D5CyZSBd4K3MkC/stt51PZ71PFnz0CyEdzi2nUa12JtSmwIjlQmOz
rw3HBLHKXSao/6KeIjry01hFqY9dSwL32cHdy4EZ4UYjZDiu7IgYhvFT17ovyJUD
JlT+hJIq0GDDAYl/TSOW
=orne
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
