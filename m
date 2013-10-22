From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 repair does not repair errors?
Date: Tue, 22 Oct 2013 12:11:13 +1100
Message-ID: <20131022121113.48958a0b@notabene.brown>
References: <526541CD.8000003@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qtYji4x4jUcIQUaFCBeQ1mn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526541CD.8000003@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qtYji4x4jUcIQUaFCBeQ1mn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Oct 2013 19:01:33 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> Hello.
>=20
> I've a raid1 array (composed of 4 drives, so it is a 4-fold
> copy of data), and one of the drives has an unreadable (bad)
> sector in the partition belonging to this array.
>=20
> When I run md 'repair' action, it hits the error place, the
> kernel clearly returns an error, but md does not do anything
> with it.  For example:
>=20
> Oct 21 18:43:55 mother kernel: [190018.073098] md: requested-resync of RA=
ID array md1
> Oct 21 18:43:55 mother kernel: [190018.093910] md: minimum _guaranteed_  =
speed: 1000 KB/sec/disk.
> Oct 21 18:43:55 mother kernel: [190018.114765] md: using maximum availabl=
e idle IO bandwidth (but not more than 200000 KB/sec) for requested-resync.
> Oct 21 18:43:55 mother kernel: [190018.136459] md: using 128k window, ove=
r a total of 2096064k.
> Oct 21 18:45:11 mother kernel: [190094.091974] ata6.00: exception Emask 0=
x0 SAct 0xf SErr 0x0 action 0x0
> Oct 21 18:45:11 mother kernel: [190094.114093] ata6.00: irq_stat 0x400000=
08
> Oct 21 18:45:11 mother kernel: [190094.135906] ata6.00: failed command: R=
EAD FPDMA QUEUED
> Oct 21 18:45:11 mother kernel: [190094.157710] ata6.00: cmd 60/00:00:00:3=
b:3e/04:00:00:00:00/40 tag 0 ncq 524288 in
> Oct 21 18:45:11 mother kernel: [190094.157710]          res 41/40:00:29:3=
e:3e/00:00:00:00:00/40 Emask 0x409 (media error) <F>
> Oct 21 18:45:11 mother kernel: [190094.202315] ata6.00: status: { DRDY ER=
R }
> Oct 21 18:45:11 mother kernel: [190094.224517] ata6.00: error: { UNC }
> Oct 21 18:45:11 mother kernel: [190094.248920] ata6.00: configured for UD=
MA/133
> Oct 21 18:45:11 mother kernel: [190094.271003] sd 5:0:0:0: [sdc] Unhandle=
d sense code
> Oct 21 18:45:11 mother kernel: [190094.293044] sd 5:0:0:0: [sdc]
> Oct 21 18:45:11 mother kernel: [190094.314654] Result: hostbyte=3DDID_OK =
driverbyte=3DDRIVER_SENSE
> Oct 21 18:45:11 mother kernel: [190094.336483] sd 5:0:0:0: [sdc]
> Oct 21 18:45:11 mother kernel: [190094.357966] Sense Key : Medium Error [=
current] [descriptor]
> Oct 21 18:45:11 mother kernel: [190094.379808] Descriptor sense data with=
 sense descriptors (in hex):
> Oct 21 18:45:11 mother kernel: [190094.402024]         72 03 11 04 00 00 =
00 0c 00 0a 80 00 00 00 00 00
> Oct 21 18:45:11 mother kernel: [190094.424502]         00 3e 3e 29
> Oct 21 18:45:11 mother kernel: [190094.446338] sd 5:0:0:0: [sdc]
> Oct 21 18:45:11 mother kernel: [190094.467995] Add. Sense: Unrecovered re=
ad error - auto reallocate failed
> Oct 21 18:45:11 mother kernel: [190094.490075] sd 5:0:0:0: [sdc] CDB:
> Oct 21 18:45:11 mother kernel: [190094.511870] Read(10): 28 00 00 3e 3b 0=
0 00 04 00 00
> Oct 21 18:45:11 mother kernel: [190094.533829] end_request: I/O error, de=
v sdc, sector 4079145
> Oct 21 18:45:11 mother kernel: [190094.555800] ata6: EH complete
> Oct 21 18:45:22 mother kernel: [190105.602687] md: md1: requested-resync =
done.
>=20
> There's no indication that raid code tried to re-write the bad spot,
> and the bad block remains bad in the drive, so next read (direct from
> the drive) return the same I/O error with the same kernel messages.
>=20
> Shouldn't `repair' action re-write the problem place?

Yes it should.
When end_sync_read() notices that BIO_UPTODATE isn't set it refuses to set
R1BIO_Uptodate.
When sync_request_write() notices that isn't set it calls
fix_sync_read_error().

fix_sync_read_error then calls sync_page_io() for each page in the region a=
nd
if that fails (as you would expect, it goes on to the next disk and the next
until a working one is found.  Then that block is written back to all those
that failed.
fix_sync_read_error doesn't report any success, but as it re-read the faili=
ng
device you should see the SCSI read error reported a second time at least.

Are you able to add some tracing and recompile the kernel and see if you can
find out what is happening?
e.g.
  if end_sync_read doesn't see BIO_UPTODATE, print something.
  if sync_request_write doesn't see R1BIO_Uptodate, print something
  when fix_sync_read_error calls sync_page_io, print something.

??

Thanks,
NeilBrown



>=20
> This is kernel 3.10.15.
>=20
> Thank you!
>=20
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/qtYji4x4jUcIQUaFCBeQ1mn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmXQsTnsnt1WYoG5AQI+xw//ba5RTq/CFzkVUkzNQsJPQHDCdq86hpqN
tNhP8P/pAVyUaACD0YhXDqMsoWvmC70Y+tv4DbxZ/uADDs62OzaTe4ivXiy9g8/2
vwV3dMJrYz/I5MI67VkOJyvIjMJpD/EUaOSyF6Y8y1f582aYTooI50PEg8XqaBZF
ecizXmAZNsmlkASSDbHzjKbheTuR19ScxOey6EUtDgkxRwTCtJka52Xw5zvo/CwL
yfFRgV5CrvCBZryGwtdpGpdSFyAhwiVLohAeaSQtzv/H0eZKS+cwH4mthz6pSm/z
gBknJZuMNI2P5A/shh+9T4IL2CWQUHWH3sO6ByuC+tz4qk7mPgwchUjd4DQkbX9z
AdO/dBmbTLRaN/HsD7VgDxU3rjA7p5fuXYVGiz69VWqRFJemta8IeQX8kWWM1v84
rNOn6wEdJDX4Pw8nnSZm1P1TVLdmTbSTHpu9JJWNPanJTiqYPoqEDXr0vROzAgQC
jfUlNzmyXJ6BPlnj6Zf+Iq05CNdAaj7LrS8FlBB/bowp79ZroKrHwgBvtXwmOUdl
RfCEy7Ti5DBOvmXHhQvDKzWVOrhpnJdTUB2hFtOFBkBMJSYkYm9CVQbWHp5Ith0K
DOpKyKccjxKeMGA4scTKoOmt1dKZeXHN77TWlHYrQ7NhdExHocgZxBWChus/eWl7
0AuivtFofbo=
=n8JS
-----END PGP SIGNATURE-----

--Sig_/qtYji4x4jUcIQUaFCBeQ1mn--
