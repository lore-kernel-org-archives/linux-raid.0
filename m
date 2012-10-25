From: NeilBrown <neilb@suse.de>
Subject: Subject:  ANNOUNCE: mdadm 3.2.6 - A tool for managing Soft RAID
 under Linux
Date: Thu, 25 Oct 2012 17:26:56 +1100
Message-ID: <20121025172656.171d9ce0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eFpSyp1pJyM/+2Ab7drJreQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/eFpSyp1pJyM/+2Ab7drJreQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


I am pleased to announce the availability of
   mdadm version 3.2.6

It is available at the usual places, now including github:
   countrycode=3Dxx.
   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://github.com/neilbrown/mdadm
   git://neil.brown.name/mdadm
   http://neil.brown.name/git/mdadm

This is a stablity release which adds a number of bugfixes to 3.2.5.
There are no real stand-out fixes, just lots of little bits and pieces.

Below is the "git log --oneline --reverse" list of changes since
3.2.5.

NeilBrown 25th October 2012

b7e05d2 udev-rules: prevent systemd from mount devices before they are read=
y.
0d478e2 mdadm: Fix Segmentation fault.
42f0ca1 imsm: fix: correct checking volume's degradation
fcf2195 Monitor: fix inconsistencies in values for ->percent
5f862fb Monitor: Report NewArray when an array the disappeared, reappears.
6f51b1c Monitor: fix reporting for Fail vs FailSpare etc.
68ad53b mdmon: fix arg parsing.
517f135 Assemble: don't leak memory with fdlist.
090900c udev-rules: prevent systemd from mount devices before they are read=
y.
446e000 sha1.h: remove ansidecl.h header inclusion
ec894f5 Manage: zero metadata before adding to 'external' array.
3a84db5 ddf: allow a non-spare to be used to recovery a missing device.
c5d61ca ddf: hack to fix container recognition.
23084aa mdmon: fix arg processing for -a
c4e96a3 mdmon: allow --takeover when original was started with --offroot
80841df find_free_devnum: avoid auto-using names in /etc/mdadm.conf
c5c56d6 mapfile: fix mapfile rebuild for containers
aec89f6 fix segfaults in Detail()
2117ad1 Fix 'enough' function for RAID10.
0bc300d Use --offroot flag when assembling md arrays via --incrmental
ac78f24 Grow: make warning about old metadata more explicit.
14026ab Replace sha1.h with slightly older version.
6f6809f Add zlib license to crc32.c
5267ba0 Handles spaces in array names better.
c51f288 imsm: allow --assume-clean to work.
acf7076 Grow: allow --grow --continue to work for native metadata.
335d2a6 Grow: fix a couple of typos with --assume-clean usage
9ff1427 Fix open_container
3713633 mdadm: super0: do not override uuid with homehost
31bff58 Trivial bugfix and spelling fixes.
e1e539f Detail: don't report a faulty device as 'spare' or 'rebuilding'.
22a6461 super0: allow creation of array on 2TB+ devices.
a5d47a2 Create new md devices consistently
eb48676 Monitor: don't complain about non-monitorable arrays in mdadm.conf
ecdf2d7 Query: don't be confused by partition tables.
f7b75c1 Query: allow member of non-0.90 arrays to be better reported.

--Sig_/eFpSyp1pJyM/+2Ab7drJreQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIjbsDnsnt1WYoG5AQLklQ/9FTG9UFFR22cnBfrJY5Xr+xEZYMGiivHc
osNLH+1+CZdkH534A6x2E+Cv/q8828jJ7+lS5EYdi/ukDuoCma3hAQxIkN0DYmJP
oulnpXBSH625H2qH2qYLbeY8WYOUgzucujQ6H1JPcb8pk4yny6xSoigsg0UArSLT
/A0H23/16cXwNwodBCV6NZTuKPbqo+65vZUNs11jGnfTPrIGs4tCG+bEZm8J52w/
Osc8YCeTzJlko/R1qYDy4NunMoqV/sUNhZitqKq9ODIcgKYFb4zwq6epziV5RYT1
CWkAdyiWmP79yp7DM02dW3qXsk5RUn3/GGijQA5qM/yIErt7plQEOXrmXJm0M6iZ
r9UTCSvctuHQzznefvQP/Z+3FgWAJMG8Wn9qFxr5Vlg6aGdTQK24Segt8cPYZI9q
enM0LVxow85LnXeeiwUPPKRqsaOpL+bGEIcVxRpDKh3XkmnHKNeDc3JWNRxGBr/M
/2YJ4Ihpyuc6RDe/RZYN2hDbKGqg8vo5IOOz34ZYjaMiVFFkCpURgN2WGL42PlA9
mmLVX+6rPSaSE8iKD5l9QmFSV1Q/zzF0NiAfXLfHpOuTx+7a8RFnTqp4mqasL6zE
JD9gsgT0Hv9woy3zvNS3HAGkeY0QVXLVrNan8QDkKcOxdDmiuVuuUKaZBrvqi6Bf
lRZkV/XGADs=
=GRAJ
-----END PGP SIGNATURE-----

--Sig_/eFpSyp1pJyM/+2Ab7drJreQ--
