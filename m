From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Big Endian RAID discovery problem (metadata 1!)
Date: Wed, 28 Jun 2017 18:46:33 +0200
Message-ID: <3667530.kn15F7ggIU@daneel.sf-tec.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7208441.ttbm6MTBbd"; micalg="pgp-"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart7208441.ttbm6MTBbd
Content-Type: multipart/mixed; boundary="nextPart23791692.RIh9smj9x1"
Content-Transfer-Encoding: quoted-printable

This is a multi-part message in MIME format.

=2D-nextPart23791692.RIh9smj9x1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

I have an issue with a RAID1 array on my Sparc T5120. The superblocks of 3 
partitions are attached. The array was created as degraded RAID1 on sda2, then 
extended to sdb2 and sdc2, and then sda2 was removed from the array. I'm not 
entirely sure about the mdadm version used to extend the array, but it is 
likely 3.4 (current Gentoo stable).

From=20what I see the super_offset is written in big endian, which is consistent 
with the error message about super_offset being wrong when I run "mdadm -Asv". 
My luck is that the system on sda2 is still valid, so after reboot I ended up 
in an old copy of my data.

My plan is to change the GUID on sda2 and fix the super_offset on sd[bc]2, then 
reboot and hope the array(s) come up correctly.

Any thoughts on this, anything you want to test me, anything to make my life 
easier instead of poking with a hexeditor on the raw partitions?

Eike
=2D-nextPart23791692.RIh9smj9x1
Content-Disposition: attachment; filename="sda.dump"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="sda.dump"

/E4rqQEAAAAAAAAAAAAAAIl7+wBEXquogtrHH1RpEEljYXN0b3I6MAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAExVo1gAAAAAAQAAAAAAAAAAUDM6AAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAQAAAAAAD1RMzoAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcv6l
b1V39rRpfuAbH/0XagAAAAAAAAAADK46WQAAAABJ1AgAAAAAAP//////////8ar9MIAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/v/+//7//v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v8=

=2D-nextPart23791692.RIh9smj9x1
Content-Disposition: attachment; filename="sdb.dump"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="sdb.dump"

/E4rqQEAAAAAAAAAAAAAAIl7+wBEXquogtrHH1RpEEljYXN0b3I6MAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAExVo1gAAAAAAQAAAAAAAAD8H2t0AAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAQAAAAAAPwfa3QAAAAAAAAAAAAAAAgAAAAAAAAAAAIAAAAAAAAATLg0
bUBbJv9cB5JOvTEzrQAACABIAAAAGj8kWQAAAACj0wgAAAAAAP//////////rTXsaoAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP7//v8BAAAA/v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v8=

=2D-nextPart23791692.RIh9smj9x1
Content-Disposition: attachment; filename="sdc.dump"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="sdc.dump"

/E4rqQEAAAAAAAAAAAAAAIl7+wBEXquogtrHH1RpEEljYXN0b3I6MAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAExVo1gAAAAAAQAAAAAAAAD8H2t0AAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAQAAAAAAPwfa3QAAAAAAAAAAAAAAAgAAAAAAAAAAAMAAAAAAAAAXNSO
ZCX2AWhlEKuNODfLrQAACABIAAAAGj8kWQAAAACj0wgAAAAAAP//////////J/vSCoAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP7//v8BAAAA/v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v8=

=2D-nextPart23791692.RIh9smj9x1--
This is a multi-part message in MIME format.

--nextPart23791692.RIh9smj9x1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

I have an issue with a RAID1 array on my Sparc T5120. The superblocks of 3 
partitions are attached. The array was created as degraded RAID1 on sda2, then 
extended to sdb2 and sdc2, and then sda2 was removed from the array. I'm not 
entirely sure about the mdadm version used to extend the array, but it is 
likely 3.4 (current Gentoo stable).

From what I see the super_offset is written in big endian, which is consistent 
with the error message about super_offset being wrong when I run "mdadm -Asv". 
My luck is that the system on sda2 is still valid, so after reboot I ended up 
in an old copy of my data.

My plan is to change the GUID on sda2 and fix the super_offset on sd[bc]2, then 
reboot and hope the array(s) come up correctly.

Any thoughts on this, anything you want to test me, anything to make my life 
easier instead of poking with a hexeditor on the raw partitions?

Eike
--nextPart23791692.RIh9smj9x1
Content-Disposition: attachment; filename="sda.dump"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="sda.dump"

/E4rqQEAAAAAAAAAAAAAAIl7+wBEXquogtrHH1RpEEljYXN0b3I6MAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAExVo1gAAAAAAQAAAAAAAAAAUDM6AAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAQAAAAAAD1RMzoAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcv6l
b1V39rRpfuAbH/0XagAAAAAAAAAADK46WQAAAABJ1AgAAAAAAP//////////8ar9MIAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/v/+//7//v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v8=

--nextPart23791692.RIh9smj9x1
Content-Disposition: attachment; filename="sdb.dump"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="sdb.dump"

/E4rqQEAAAAAAAAAAAAAAIl7+wBEXquogtrHH1RpEEljYXN0b3I6MAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAExVo1gAAAAAAQAAAAAAAAD8H2t0AAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAQAAAAAAPwfa3QAAAAAAAAAAAAAAAgAAAAAAAAAAAIAAAAAAAAATLg0
bUBbJv9cB5JOvTEzrQAACABIAAAAGj8kWQAAAACj0wgAAAAAAP//////////rTXsaoAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP7//v8BAAAA/v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v8=

--nextPart23791692.RIh9smj9x1
Content-Disposition: attachment; filename="sdc.dump"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="sdc.dump"

/E4rqQEAAAAAAAAAAAAAAIl7+wBEXquogtrHH1RpEEljYXN0b3I6MAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAExVo1gAAAAAAQAAAAAAAAD8H2t0AAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAQAAAAAAPwfa3QAAAAAAAAAAAAAAAgAAAAAAAAAAAMAAAAAAAAAXNSO
ZCX2AWhlEKuNODfLrQAACABIAAAAGj8kWQAAAACj0wgAAAAAAP//////////J/vSCoAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP7//v8BAAAA/v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+
//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7/
/v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v8=

--nextPart23791692.RIh9smj9x1--

--nextPart7208441.ttbm6MTBbd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAllT3XYACgkQXKSJPmm5/E6+swCfbGooBjyDfokbpW2G9tC8ayb2
5pYAn2bsi//sMQ+9AFKvFI/M5Fo9Nc5C
=1md5
-----END PGP SIGNATURE-----

--nextPart7208441.ttbm6MTBbd--

