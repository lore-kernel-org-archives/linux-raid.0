From: NeilBrown <neilb@suse.de>
Subject: Subject:  ANNOUNCE: mdadm 3.2.3 - A tool for managing Soft RAID
 under Linux
Date: Fri, 23 Dec 2011 14:36:04 +1100
Message-ID: <20111223143604.4e537831@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mYE1WZdDLe=akdGbkT1PA41"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/mYE1WZdDLe=akdGbkT1PA41
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


I am pleased to announce the availability of
   mdadm version 3.2.3

It is available at the usual places:
   countrycode=3Dxx.
   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
and via git at
   git://neil.brown.name/mdadm
   http://neil.brown.name/git/mdadm

This release is largely a bugfix release for the 3.2 series with many
minor fixes with little or no impact.

The largest single area of change is support for reshape of Intel
IMSM arrays (OnLine Capacity Explansion and Level Migtration).
Among other fixes, this now has a better chance of surviving if a
device fails during reshape.

Upgrading is recommended - particularly if you use mdadm for IMSM
arrays - but not essential.

NeilBrown 23rd December 2011

--Sig_/mYE1WZdDLe=akdGbkT1PA41
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvP3JDnsnt1WYoG5AQLLdhAAny7RFQptO6tIflnbg8P1GgAuIfPdOvY4
rn/WOq7kkFlk1Kw7Y84uhtgeRsUY7xKTZc+L0y8MzwrtX/7PEgP4k0LLxSaO49Dk
zXOwf/1B+2eVLcAl4cYK4EJBg6Qov4tsCwJynb2HxSo0LL3FtG/Jp/cSRln7a2UB
JkxGVOTY2f21n8wWM5zmecxGJounmCJvb5FLeH2cFSlot3Zutck5KaZ6cAx0lkfw
Y2uJqlhOvQS4e7qAuh7ZjBkn2z9okRD6rjfqe0TbTzCd1IzjiXWoTz6uPebi2xKz
jMLZlaCw3rrb4tgi+o0vecrpzBlHMrTf0h4gwYXuIxPjj+CopG1dAZErya86dDVP
irOHVlw0SckZQZgTDWTF/dbu/mgK0TFhFzy8ZVm2sZnY/49Ssu+EUkTAwbsQoapF
nalq36XHrtV7VvsloQOb2DbvFZYL98Ky1HM9w9udkwIM6oXLBAIWkTxUoGPq6yRC
wzzN6cpZtSLdY9dpsb0JZSiNXGmH0hTCBpaZ7GlwFbmPYx/Ra29fNp7nWN9g1WOg
AU23Qh7v2/e6hFq1+wEado45HDOG1wOzehP+58rVt+5ODBRqmQNUzgbKf/+F3dhk
/tVCcrZU/9kRRhjNXJkdp8itN9bmtf0FNSZLOUjAOKznGWqtDrQbvxUY3huX8Fqd
EE3XS8CSYS4=
=+U3y
-----END PGP SIGNATURE-----

--Sig_/mYE1WZdDLe=akdGbkT1PA41--
