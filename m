Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D519C433DF
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 02:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D64E21775
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 02:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgJNCM5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Oct 2020 22:12:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:56962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgJNCM5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 13 Oct 2020 22:12:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 144ECAFD5;
        Wed, 14 Oct 2020 02:12:56 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Date:   Wed, 14 Oct 2020 13:12:48 +1100
Subject: [PATCH mdadm] Super1: allow RAID0 layout setting to be removed.
cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
Message-ID: <871ri1h7xb.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Once the RAID0 layout has been set, the RAID0 array cannot be assembled
on an older kernel which doesn't understand layouts.
This is an intentional safety feature, but sometimes people need the
ability to roll-back to a previously working configuration.

So add "--update=3Dlayout-unspecified" to remove RAID0 layout information
from the superblock.
Running "--assemble --update=3Dlayout-unspecified" will cause the assembly
the fail when run on a newer kernel, but will allow it to work on
an older kernel.

Signed-off-by: NeilBrown <neilb@suse.de>
=2D--
 md.4       | 13 +++++++++++++
 mdadm.8.in | 15 +++++++++++++--
 mdadm.c    |  5 +++--
 super1.c   |  6 +++++-
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/md.4 b/md.4
index aecff38a1d02..60fdd274cc50 100644
=2D-- a/md.4
+++ b/md.4
@@ -215,6 +215,19 @@ option or the
 .B "--update=3Dlayout-alternate"
 option.
=20
+Once you have updated the layout you will not be able to mount the array
+on an older kernel.  If you need to revert to an older kernel, the
+layout information can be erased with the
+.B "--update=3Dlayout-unspecificed"
+option.  If you use this option to=20
+.B --assemble
+while running a newer kernel, the array will NOT assemble, but the
+metadata will be update so that it can be assembled on an older kernel.
+
+No that setting the layout to "unspecified" removes protections against
+this bug, and you must be sure that the kernel you use matches the
+layout of the array.
+
 .SS RAID1
=20
 A RAID1 array is also known as a mirrored set (though mirrors tend to
diff --git a/mdadm.8.in b/mdadm.8.in
index ab832e858bca..34a93a8fb3cf 100644
=2D-- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1213,6 +1213,7 @@ argument given to this flag can be one of
 .BR no\-ppl ,
 .BR layout\-original ,
 .BR layout\-alternate ,
+.BR layout\-unspecified ,
 .BR metadata ,
 or
 .BR super\-minor .
@@ -1368,8 +1369,9 @@ The
 .B layout\-original
 and
 .B layout\-alternate
=2Doptions are for RAID0 arrays in use before Linux 5.4.  If the array was =
being
=2Dused with Linux 3.13 or earlier, then to assemble the array on a new ker=
nel,
+options are for RAID0 arrays with non-uniform devices size that were in
+use before Linux 5.4.  If the array was being used with Linux 3.13 or
+earlier, then to assemble the array on a new kernel,=20
 .B \-\-update=3Dlayout\-original
 must be given.  If the array was created and used with a kernel from Linux=
 3.14 to
 Linux 5.3, then
@@ -1379,6 +1381,15 @@ will happen normally.
 For more information, see
 .IR md (4).
=20
+The
+.B layout\-unspecified
+option reverts the effect of
+.B layout\-orignal
+or
+.B layout\-alternate
+and allows the array to be again used on a kernel prior to Linux 5.3.
+This option should be used with great caution.
+
 .TP
 .BR \-\-freeze\-reshape
 Option is intended to be used in start-up scripts during initrd boot phase.
diff --git a/mdadm.c b/mdadm.c
index 1b3467fd4779..493d70e4d4ac 100644
=2D-- a/mdadm.c
+++ b/mdadm.c
@@ -796,7 +796,8 @@ int main(int argc, char *argv[])
 			if (strcmp(c.update, "revert-reshape") =3D=3D 0)
 				continue;
 			if (strcmp(c.update, "layout-original") =3D=3D 0 ||
=2D			    strcmp(c.update, "layout-alternate") =3D=3D 0)
+			    strcmp(c.update, "layout-alternate") =3D=3D 0 ||
+			    strcmp(c.update, "layout-unspecified") =3D=3D 0)
 				continue;
 			if (strcmp(c.update, "byteorder") =3D=3D 0) {
 				if (ss) {
@@ -828,7 +829,7 @@ int main(int argc, char *argv[])
 		"     'summaries', 'homehost', 'home-cluster', 'byteorder', 'devicesize'=
,\n"
 		"     'no-bitmap', 'metadata', 'revert-reshape'\n"
 		"     'bbl', 'no-bbl', 'force-no-bbl', 'ppl', 'no-ppl'\n"
=2D		"     'layout-original', 'layout-alternate'\n"
+		"     'layout-original', 'layout-alternate', 'layout-unspecified'\n"
 				);
 			exit(outf =3D=3D stdout ? 0 : 2);
=20
diff --git a/super1.c b/super1.c
index 76648835bf8f..8b0d6ff3d8bc 100644
=2D-- a/super1.c
+++ b/super1.c
@@ -1551,11 +1551,15 @@ static int update_super1(struct supertype *st, stru=
ct mdinfo *info,
 	else if (strcmp(update, "nofailfast") =3D=3D 0)
 		sb->devflags &=3D ~FailFast1;
 	else if (strcmp(update, "layout-original") =3D=3D 0 ||
=2D		 strcmp(update, "layout-alternate") =3D=3D 0) {
+		 strcmp(update, "layout-alternate") =3D=3D 0 ||
+		 strcmp(update, "layout-unspecified") =3D=3D 0) {
 		if (__le32_to_cpu(sb->level) !=3D 0) {
 			pr_err("%s: %s only supported for RAID0\n",
 			       devname?:"", update);
 			rv =3D -1;
+		} else if (strcmp(update, "layout-unspecified") =3D=3D 0) {
+			sb->feature_map &=3D ~__cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
+			sb->layout =3D 0;
 		} else {
 			sb->feature_map |=3D __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
 			sb->layout =3D __cpu_to_le32(update[7] =3D=3D 'o' ? 1 : 2);
=2D-=20
2.28.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJCBAEBCAAsFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl+GXqEOHG5laWxiQHN1
c2UuZGUACgkQOeye3VZigbkBKQ/9G668cAv+Gf0IqRs/X0HORWLFxv6xKhuRRxH3
JX41ztcONwUm0nLQARdz1BJ5g7UoxmrVUHcIyk9bXVwjtWkr4Em5g5tzBWeJjsbf
wtINv1yAhK2Fd8HpFqHqQ6aybsFfBOfdJFYpe3XNi6bwD42vDq8x3z0ftPVFf1GN
NXO4txy/UySbn99Bif+QZv+viwlB/t3cswl69HnMiedeujCra3uX9QbJiIW/teN1
ZvXedSo485NqPDQH9UVn/i1r0qlibhjs4t7j21qWIlFyuOKwTGw+9fistyTwfPvl
BbByczITsU4nQfehY6AMYneWZgIeH+SbYTrauZSLIm4rrP7R1jOsEbDBaI+wL9DF
wpGwDTACtFQGe5ZgKV7hHBBo9WtRGB2U4RZCz4XRfY0/tHCWJ5fFopzIs0Tw3opS
VMImcaZGJATQDked4T+p3HbWbCFprSJiptr2NzgNNteFg5WfbsdfhLNJ6kK5j3DX
xK7dl1+NxwFeds7rs3xlMDLGCod+mirXcZ9nlmlc+Sj0SAVa4bLmEks6TrKUlf2w
IHnidQXD/5zAt53GakcXKwAtjcxOyGmLtlqd9agLr5m4alpNubEzFrP5qKadJQD3
D3s8hTNhD1m8KjJo+4F6X4w1S3U8v4U/wVlk2IqCMTO7Cel1CCmaz2kP9O/sh+11
PbJZx9w=
=o2kk
-----END PGP SIGNATURE-----
--=-=-=--
