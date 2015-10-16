From: Neil Brown <nfbrown@novell.com>
Subject: Re: kernel: BUG: soft lockup - CPU#1 stuck for 60s! [md0_raid5:1614]
Date: Fri, 16 Oct 2015 12:15:59 +1100
Message-ID: <87si5bvcj4.fsf@notabene.neil.brown.name>
References: <1092031595.20151015153830@oudeis.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1092031595.20151015153830@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer =?utf-8?Q?F=C3=BCgenstein?= <rfu@oudeis.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rainer F=C3=BCgenstein <rfu@oudeis.org> writes:

> Hi,
>
> my  NAS-like  server with 5*3TB SATA drives in RAID5 configuration was
> running  without  problems  for  what seems an eternity; since about 3
> weeks it keeps freezing every other day with the following error:
>
> # grep soft /var/log/messages
> Oct 15 11:26:49 alfred kernel: BUG: soft lockup - CPU#1 stuck for 60s! [m=
d0_raid5:1614]
> Oct 15 11:26:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x=
28
> Oct 15 11:26:49 alfred kernel:  [<ffffffff80012583>] __do_softirq+0x51/0x=
133
> Oct 15 11:26:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x=
28
> Oct 15 11:26:49 alfred kernel:  [<ffffffff8006d63a>] do_softirq+0x2c/0x7d
> Oct 15 11:27:49 alfred kernel: BUG: soft lockup - CPU#1 stuck for 60s! [m=
d0_raid5:1614]
> Oct 15 11:27:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x=
28
> Oct 15 11:27:49 alfred kernel:  [<ffffffff80012583>] __do_softirq+0x51/0x=
133
> Oct 15 11:27:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x=
28
> Oct 15 11:27:49 alfred kernel:  [<ffffffff8006d63a>] do_softirq+0x2c/0x7d
> Oct 15 11:28:49 alfred kernel: BUG: soft lockup - CPU#1 stuck for 60s! [m=
d0_raid5:1614]
> Oct 15 11:28:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x=
28
> Oct 15 11:28:49 alfred kernel:  [<ffffffff80012583>] __do_softirq+0x51/0x=
133
> Oct 15 11:28:49 alfred kernel:  [<ffffffff8005e298>] call_softirq+0x1c/0x=
28
> Oct 15 11:28:49 alfred kernel:  [<ffffffff8006d63a>] do_softirq+0x2c/0x7d
> [...]
> this  is  only  part  of  the story, check the end of this message for
> a detailed log.
>
> sometimes the server recovers after 60+ seconds, sometimes it requires
> a hard reset (causing mdraid to re-sync the whole array).

I strongly recommend adding a write-intend bitmap
  mdadm --grow /dev/md0 --bitmap=3Dinternal

that will speed up the resync enormously.

>
> IIRC,  it  started  when  a  drive  in  the  array  failed  with "SATA
> connection  timeouts" (kind of). this drive has been replaced by a new
> one, but yet the  CPU lockups keep coming.
>
> I  suspect  that  aging  hardware  slowly starts to fail, but not sure
> which part (drives? SATA controller? cables? NIC? CPU? ...)
>
> here's some info that might be useful:
> # uname -a
> Linux alfred 2.6.18-406.el5 #1 SMP Tue Jun 2 17:25:57 EDT 2015 x86_64 x86=
_64 x86_64 GNU/Linux

This is a rather ancient kernel.
The "el" suffix probably suggests Redhat?  If you have a Redhat support
contract you should ask them.  If you don't, you should probably try a
newer kernel (or buy a support contract).

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWIE/PAAoJEDnsnt1WYoG5nkcQAJzdbd0MbVvw0YSgImqxgGtf
oda1cah4ytUWGYo+x6ux7PQipnpl8KTQEwy3uj1pTOJhesuWn2JxnyXfK6HOvR+O
IaXdQKMw5XTxcmeF934jqaxt/5BhHakZz1HvpiV7vgQzEWLDjdHYsA8ja7b16C4X
LC4Xr7nyGUUktnlAS1fWFhs/tolrC+W7Aax3JPCXkpxViKU2onHlSrXJF6rpliwY
d9b+JUMn8qCBmBPtzzx2OouYxHekxl7xfs5O0c/MCtufvARBuPNywt0ulcZduYBW
CioyCVXUFP2Enq8pIInOULD6GyPjyTaw/BG1oz5yhcy9ZRZsklwL+ApkQMpL8kw1
X0zqrenjrRlOIv6ddSErvxe0t1urHgRi6+91aWvJG6l5qMUYTQfMI9tt5tCEm5Gm
hjKgjwHIarBlJkx4Cvq3j992CEH0wwG5ySm+C2l0RxcJm1h2sDibuEhO9kvz3wZF
MK7fsFOIjRjO94gbGvk4R6XhKCSEDrM0L4Lstdk/Sa8iM8PNZ0ju4KHQg7dbsux/
zTd3UYvrq1HS4kOcLkhnL4xcIaYAUIUBrzzYuyQDkUedpJ2CADULGCtl231QeVWp
1uFntX9F4IibM8pGdlXjGeUZsDsxjDpRV+efXS+ZP2nY09P6rF50l21QdjV/8WUM
4hJs2hwWZrs/wp4vn27P
=PVR8
-----END PGP SIGNATURE-----
--=-=-=--
