From: <stockhausen@collogia.de>
Subject: [Patch v1 4/4] md/raid5: Fix rmw/rcw parametrization check
Date: Fri, 7 Aug 2015 20:21:04 +0000
Message-ID: <6fb0d15a-95da-494c-8bf8-9722933108be@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-38a83d3d-d255-42de-a1e8-aaf9be5d2be8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-38a83d3d-d255-42de-a1e8-aaf9be5d2be8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

md/raid5: Fix rmw/rcw parametrization check=0A=
=0A=
Commit 584acdd49cd2472ca0f5a06adbe979db82d0b4af (activate rmw feature) and=
=0A=
commit d06f191f8ecaef4d524e765fdb455f96392fbd42 (rmw_level) allow to set th=
e=0A=
desired rmw/rcw handling for a raid456 device. For the corner case that IO =
=0A=
costs of rmw and rcw are equal setting PARITY_PREFER_RMW should favour rmw =
=0A=
over rcw. The implementation is slightly messed. Instead the default settin=
g=0A=
PARITY_ENABLE_RMW already favours rmw. Fix that.=0A=
=0A=
Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>=0A=
=0A=
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0A=
index f8630c1..f94c389 100644=0A=
--- a/drivers/md/raid5.c=0A=
+++ b/drivers/md/raid5.c=0A=
@@ -3564,7 +3564,7 @@ static void handle_stripe_dirtying(struct r5conf *con=
f,=0A=
 		/* Calculate the real rcw later - for now make it=0A=
 		 * look like rcw is cheaper=0A=
 		 */=0A=
-		rcw =3D 1; rmw =3D 2;=0A=
+		rcw =3D 1; rmw =3D 3;=0A=
 		pr_debug("force RCW rmw_level=3D%u, recovery_cp=3D%llu sh->sector=3D%llu=
\n",=0A=
 			 conf->rmw_level, (unsigned long long)recovery_cp,=0A=
 			 (unsigned long long)sh->sector);=0A=
@@ -3584,7 +3584,9 @@ static void handle_stripe_dirtying(struct r5conf *con=
f,=0A=
 	}=0A=
 	pr_debug("for sector %llu, rmw=3D%d rcw=3D%d\n",=0A=
 		(unsigned long long)sh->sector, rmw, rcw);=0A=
-	if ((rmw < rcw || (rmw =3D=3D rcw && conf->rmw_level =3D=3D PARITY_ENABLE=
_RMW)) && rmw > 0) {=0A=
+	if (rcw && conf->rmw_level =3D=3D PARITY_PREFER_RMW)=0A=
+		rcw++;=0A=
+	if (rmw && rmw < rcw) {=0A=
 		/* prefer read-modify-write, but need to get some data */=0A=
 		if (conf->mddev->queue)=0A=
 			blk_add_trace_msg(conf->mddev->queue,=0A=
@@ -3611,7 +3613,7 @@ static void handle_stripe_dirtying(struct r5conf *con=
f,=0A=
 			}=0A=
 		}=0A=
 	}=0A=
-	if ((rcw < rmw || (rcw =3D=3D rmw && conf->rmw_level !=3D PARITY_ENABLE_R=
MW)) && rcw > 0) {=0A=
+	if (rcw && rcw <=3D rmw) {=0A=
 		/* want reconstruct write, but need to get some data */=0A=
 		int qread =3D0;=0A=
 		rcw =3D 0;=0A=



------=_NextPartTM-000-38a83d3d-d255-42de-a1e8-aaf9be5d2be8
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-38a83d3d-d255-42de-a1e8-aaf9be5d2be8--
