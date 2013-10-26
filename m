From: Steven Haigh <netwiz@crc.id.au>
Subject: aac_write: aac_fib_send failed with status: -12
Date: Sat, 26 Oct 2013 17:55:22 +1100
Message-ID: <526B675A.2020102@crc.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="X0IqJdxanN19C2rbuXacRs0pHFDkAvfJb"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X0IqJdxanN19C2rbuXacRs0pHFDkAvfJb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

Not 100% sure if this is the correct list - or if there is a seperate
hwraid list.

I seem to be getting some random filesystem corruption on an IBM server
that I use as a Xen Dom0.

*** Specs ***
Vendor: IBM
Version: -[GGE149AUS-1.19]-
Product Name: IBM System x3650 -[7979CBM]-
AAC0: kernel 5.2-0[17003] Jul 25 2011
AAC0: monitor 5.2-0[17003]
AAC0: bios 5.2-0[17003]
AAC0: serial 5AB49E0
scsi0 : ServeRAID
scsi 0:0:0:0: Direct-Access     ServeRA  Dom0_RAID6       V1.0 PQ: 0 ANSI=
: 2
scsi 0:1:0:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI=
: 5
scsi 0:1:1:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI=
: 5
scsi 0:1:2:0: Direct-Access     IBM-ESXS MBC2073RC        SC06 PQ: 0 ANSI=
: 5
scsi 0:1:3:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:1:4:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:1:5:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:1:6:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:1:7:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:3:0:0: Enclosure         IBM-ESXS VSC7160          1.07 PQ: 0 ANSI=
: 3

I'm currently running kernel 3.11.4 and before the filesystem corruption
seems to happen, I get a load of these:
aac_write: aac_fib_send failed with status: -12

While this is going on, random things seem to fail. Eventually, I'll
reboot the system and lots of tools will segfault - tracing it back
leads to libraries that seem to have been corrupted.

I can boot the system from rescue media, reinstall all the corrupted
libraries / binaries and the system runs fine again for another few
months before it happens again.

arcconf shows:
# arcconf getconfig 1
Controllers found: 1
----------------------------------------------------------------------
Controller information
----------------------------------------------------------------------
   Controller Status                        : Okay
   Channel description                      : SAS/SATA
   Controller Model                         : IBM ServeRAID 8k
   Controller Serial Number                 : 5AB49E0
   Physical Slot                            : 0
   Installed memory                         : 256 MB
   Copyback                                 : Disabled
   Data scrubbing                           : Enabled
   Defunct disk drive count                 : 0
   Logical drives/Offline/Critical          : 1/0/0
   --------------------------------------------------------
   Controller Version Information
   --------------------------------------------------------
   BIOS                                     : 5.2-0 (17003)
   Firmware                                 : 5.2-0 (17003)
   Driver                                   : 1.2-0 (30200)
   Boot Flash                               : 5.1-0 (17002)
   --------------------------------------------------------
   Controller Battery Information
   --------------------------------------------------------
   Status                                   : Okay
   Over temperature                         : No
   Capacity remaining                       : 100 percent
   Time remaining (at current draw)         : 3 days, 20 hours, 56 minute=
s
   --------------------------------------------------------
   Controller Vital Product Data
   --------------------------------------------------------
   VPD Assigned#                            : 39R8875
   EC Version#                              : J85096
   Controller FRU#                          : 25R8076
   Battery FRU#                             : 25R8088

----------------------------------------------------------------------
Logical drive information
----------------------------------------------------------------------
Logical drive number 1
   Logical drive name                       : Dom0_RAID6
   RAID level                               : 6
   Status of logical drive                  : Okay
   Size                                     : 419400 MB
   Read-cache mode                          : Enabled
   Write-cache mode                         : Enabled (write-back)
   Write-cache setting                      : Enabled (write-back)
   Partitioned                              : Yes
   Number of segments                       : 8
   Stripe-unit size                         : 256 KB
   Stripe order (Channel,Device)            : 0,0 0,1 0,2 0,3 0,4 0,5
0,6 0,7
   Defunct segments                         : No
   Defunct stripes                          : No

Does anyone have any thoughts on this?

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299




--X0IqJdxanN19C2rbuXacRs0pHFDkAvfJb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (MingW32)

iQIcBAEBAgAGBQJSa2diAAoJEEGvNdV6fTHcXgcP/RzDUmBHBkMZW6y9RJRJ7au3
3RohGa3HlCwthr4eQmDSVtnPu7I2+C4huujXDHZ8DuO8OiNK2QwQEesaUMzyoYER
vFUQOxgvwf4rbNKmuelVmkuS2DAR1Q5TN8IYQknsMOQJBzLcKHfHsS7P0FbrDRC7
EV19XJganBr0QtekqoYiuNiq1ONhSUL+LlmFnri6DLoo4DUiTdfR1Ac+JwCdkvld
oqjOib7QTDlu7eaTcHB8Ez6oLzKriqQBdJawptbd/IO3k6zx0ieKxh19rFcspacw
Ox0HFWiTkjjVBuc1xEivQ3h4gbOaSo+IS20Z1ehxchuRK3S7Jtdk+buLJeNgLWoO
zYaFSuebML16q2SklD4YOi/9pOdpVvxclDPV1z25oPBLktIpJj9cN3pLFoyg7+d/
mcLNosslZulzWKJdo4i4W2AJb+DHrMLmQPEOore5obNZNgy2TQB4NT4mT7Pjbw/H
e1nSpCgqVdOC9j+jveFmh8+oixYAwwIUOJpR7f1GLN9HHHrXhDJSI7UMwPyntm0G
lt1+1NPw2tWL8kdY0z/rFbY69d4uZEdykEDDEK4aU0HzxIvCA6tqd0Id+eFtfq6K
UHBVn9sQvPh69QYGpRtqNgtfV3ulQl2d0sDX///vB5ALrSS3hejt7WJ28fL0J6tY
0gbpsLJcWLtDYKmi3O8f
=i+bF
-----END PGP SIGNATURE-----

--X0IqJdxanN19C2rbuXacRs0pHFDkAvfJb--
