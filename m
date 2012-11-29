From: NeilBrown <neilb@suse.de>
Subject: Re: [Bug 45351] General protection fault in raid5, load_balance
Date: Thu, 29 Nov 2012 12:24:48 +1100
Message-ID: <20121129122448.485d2cce@notabene.brown>
References: <bug-45351-6135@https.bugzilla.kernel.org/>
	<20121128103306.23F2011FB83@bugzilla.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hFEOf2JSLpiybzbXm7gjEjc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121128103306.23F2011FB83@bugzilla.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org, Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hFEOf2JSLpiybzbXm7gjEjc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Nov 2012 10:33:06 +0000 (UTC) bugzilla-daemon@bugzilla.kernel.org
wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=3D45351
>=20
>=20
> Cyril B. <cbay@excellency.fr> changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>      Kernel Version|3.5.0                       |3.5.0, 3.6.8
>=20
>=20
>=20
>=20
> --- Comment #1 from Cyril B. <cbay@excellency.fr>  2012-11-28 10:33:05 ---
> I've just tested 3.6.8, I still get the same bug/trace.
>=20

Hi Jim,
 could you look at this bug please?

https://bugzilla.kernel.org/show_bug.cgi?id=3D45351

It seems to be crashing in xor_avx_4:

[48595.135046] general protection fault: 0000 [#1] SMP
[48595.135093] CPU 0
[48595.135098] Modules linked in: nf_conntrack_ipv6 nf_defrag_ipv6
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_multiport coretemp
hwmon i2c_i801 shpchp pci_hotplug ehci_hcd usbcore usb_common netconsole e1=
000e
[last unloaded: scsi_wait_scan]
[48595.135211]
[48595.135224] Pid: 2429, comm: md4_raid5 Not tainted 3.5.0 #2             =
   =20
/DH67BL
[48595.135263] RIP: 0010:[<ffffffff813512d8>]  [<ffffffff813512d8>] xor_avx=
_4+0x48/0x350
[48595.135303] RSP: 0018:ffff880213a259d0  EFLAGS: 00010282
[48595.135323] RAX: 000000008005003b RBX: 0000000000000008 RCX: ffff8802130=
b5000
[48595.135346] RDX: ffff880212c9f000 RSI: ffff880212c9e000 RDI: 00000000000=
01000
[48595.135368] RBP: ffff880213a25ac0 R08: ffff8802130b4000 R09: ffff880212c=
9e000
[48595.135391] R10: ffff880212c9e000 R11: 0000000000000000 R12: 00000000800=
5003b
[48595.135413] R13: 0000000000000003 R14: ffff880213a25cd0 R15: 00000000000=
01000
[48595.135436] FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlGS:=
0000000000000000
[48595.135471] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[48595.135492] CR2: 000000000235f570 CR3: 0000000001c0b000 CR4: 00000000000=
407f0
[48595.135514] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[48595.135537] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
....

[48595.136063] Code: b5 30 ff ff ff 48 89 95 28 ff ff ff 48 89 8d 20 ff ff =
ff 4c 89 85 18 ff ff ff e8 c4 04 ce ff 66 90 49 89 c4 0f 06 66 66 90 66 90 =
<c5> fc 29 85 50 ff ff ff c5 fc 29 8d 70 ff ff ff c5 fc 29 55 90


Thanks,
NeilBrown

--Sig_/hFEOf2JSLpiybzbXm7gjEjc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULa5YDnsnt1WYoG5AQJ+QxAAjlJSWf5cO2kT5Ra9d2CcVHlZOMiHgDV9
Y9rSdPNyMb8+CODliM5mJPkbkvnBCprPB6BfsWIsGjgrk5Phd7N9572BtNEVFdR9
C7GXCugA9mYHtwfsPAYDiqlc2prcqnhqnsiuDshpyoc069N9hmudRFLuSbZu7+1v
aZ+wV/w+P3IUky4ghzl2hJicrZQVWAA/ooUeoqOm/4caw5dgWY/vGOeblthdYmG7
o448BlfQ0H4QrufipNj5ditVoRhfQqYAL57HBEeUibammToKWQeNPgv9DU1RN3HY
8dX5JOuBC2jphXY3zcqA2/X0f6ldOeRGyoPc38dqHCA5Zp3GXYhbpVyYAIaROBYb
qq/sppK0k5q+sgBXqJwHlsVtUGYvwQU8o6JA0yqCgNSeWC9NnHb0FPhOysCIfATM
By6uxSLy0UofzXrA7lcNnTBwPtS2bT6iu7uZCCQ4lC6hDgw+LkZQcgwkxct0WJQm
NC49mFkmQs3nNqyPrbIb0OP+0IUPf553b+A5d/9ZTlvJdZhVhEqqt30OCFtMvZ9z
weXg5OTjusHAxeMlDa6whMiF0eu99NnBgM3G/bcsP/yMujw2nl3gypuk0nk7MQ/X
bPzJkTDAp4dxuLyqo27fa4SDv40wRDWOS4ovgzaNMAWSazIkawtyO7nIwO0rwo9j
DWLsMh9949s=
=tRNt
-----END PGP SIGNATURE-----

--Sig_/hFEOf2JSLpiybzbXm7gjEjc--
