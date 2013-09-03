From: NeilBrown <neilb@suse.de>
Subject: Subject: ANNOUNCE: mdadm 3.3 - A tools for managing md Soft RAID
 under Linux
Date: Tue, 3 Sep 2013 14:57:36 +1000
Message-ID: <20130903145736.39e11aa0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/A9eZef=6/w8BSUfyjTUVHyv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/A9eZef=6/w8BSUfyjTUVHyv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


I am pleased to announce the availability of
   mdadm version 3.3

It is available at the usual places:
   http://www.kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://github.com/neilbrown/mdadm
   git://neil.brown.name/mdadm
   http://git.neil.brown.name/git/mdadm

This is a major new release so don't be too surprised if there are a
few issues.  If I hear about them they will be fixed in 3.3.1.
git log reports nearly 500 changes since 3.2.6 so I won't list them
all.

Some highlights are:

- Some array reshapes can proceed without needing backup file.
  This is done by changing the 'data_offset' so we never need to write
  any data back over where it was before.  If there is no "head space"
  or "tail space" to allow data_offset to change, the old mechanism
  with a backup file can still be used.
- RAID10 arrays can be reshaped to change the number of devices,
  change the chunk size, or change the layout between 'near'
  and 'offset'.
  This will always change data_offset, and will fail if there is no
  room for data_offset to be moved.
- "--assemble --update=3Dmetadata" can convert a 0.90 array to a 1.0 array.
- bad-block-logs are supported (but not heavily tested yet)
- "--assemble --update=3Drevert-reshape" can be used to undo a reshape
  that has just been started but isn't really wanted.  This is very
  new and while it passes basic tests it cannot be guaranteed.
- improved locking between --incremental and --assemble
- uses systemd to run "mdmon" if systemd is configured to do that.
- kernel names of md devices can be non-numeric. e.g. "md_home" rather than
  "md0".  This will probably confuse lots of other tools, so you need to
       echo CREATE names=3Dyes >> /etc/mdadm.conf
  or the feature will not be used.  (you also need a reasonably new kernel).
- "--stop" can be given a kernel name instead of a device name. i.e
     mdadm --stop md4
  will work even if /dev/md4 doesn't exist.
- "--detail --export" has some information about the devices in the array
- --dump and --restore can be used to backup and restore the metadata on an
   array.
- Hot-replace is supported with
     mdadm /dev/mdX --replace /dev/foo
  and
     mdadm /dev/mdX --replace /dev/foo --with /dev/bar
- Config file can be a directory in which case all "*.conf" files are
  read in lexical order.
  Default is to read /etc/mdadm.conf and then /etc/mdadm.conf.d
  Thus
      echo CREATE name=3Dyes > /etc/mdadm.conf.d/names.conf
  will also enable the use of named md devices.

- Lots of improvements to DDF support including adding support for
  RAID10 (thanks Martin Wilck).

and lots of bugfixes and other little changes.

NeilBrown 3rd September 2013

--Sig_/A9eZef=6/w8BSUfyjTUVHyv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUiVsQDnsnt1WYoG5AQKEfQ//RwE9zyBYENfcCweFi/qqrQRNsks7Nmlg
oZF3fqTH+IS5jQ303D+p+qW06MS7H9cxmV8FJaLzIW6ev3g8aempY13wrHLP1rff
g3U3y5ymljMrOcZDamiik08/0FOjK3BlVACK8IIrLuObBLN3MXK8xOUmFsvpeDXB
hufM1bdBDiVlyscVmULO4UHEQ0IrV/QC3Pf5iH41tAuMKAFQqgFX7RXcMJU0f96I
qAg1tHpNHa0UUxoZT5fHl+l7QDgeA4iIBgpI9MYiiCc9+vNc6ltE2qHmV+lit8c4
qV7BwUIGhMxagw33Lhjhux/XhatSveadNaetCdSXuR3ojWl/vwRh8Dj3gcrxVL8k
pMaGBMxyYn603mWrRHDdSKcTb3GKfBiDkrxBtv1OY7sPL2eOIMDXDeHtIO+3Hexh
GWs7X1W8ARqk8alrVGBmCFKtXGz0uAH5ORrP9LbdDZrBZwYnJ6UqNH7Pof66kWAJ
oeH0Sr5yOeIrXC4TPWzlqlZhf4ryRet5PZrlDRCcrZRhdvOIp3lbWRspGnmYiUAi
X8CbdNjykyXR9py0VBubBgvUxxmvRbn0IuEOUYBojyFoNrSBZ4/UuyGviEDkD0Lq
jlEf/B7niX4/WIm5HqZihVaWAd7kMr0Pqb/l03V/ye4hcPkYZfC1sp9a5wqPdJU4
WgvzzT1Dubs=
=MB6c
-----END PGP SIGNATURE-----

--Sig_/A9eZef=6/w8BSUfyjTUVHyv--
