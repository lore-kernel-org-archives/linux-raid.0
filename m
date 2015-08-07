From: <stockhausen@collogia.de>
Subject: [Patch v1 2/4] md/raid5: simplify handle_strype_dirtying()
Date: Fri, 7 Aug 2015 20:21:01 +0000
Message-ID: <f697f180-f2a7-41ec-8536-6d58feea8b69@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-5192f970-2ba4-4ea1-ba39-7d0fa0ccd36e"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-5192f970-2ba4-4ea1-ba39-7d0fa0ccd36e
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

md/raid5: simplify handle_strype_dirtying()=0A=
=0A=
Calculating rcw/rmw inside handle_stripe_dirtying() depends on =0A=
nearly doubled code. Consolidate parts of it.=0A=
=0A=
Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>=0A=
=0A=
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0A=
index 817d125..6a7e638 100644=0A=
--- a/drivers/md/raid5.c=0A=
+++ b/drivers/md/raid5.c=0A=
@@ -3548,7 +3548,7 @@ static void handle_stripe_dirtying(struct r5conf *con=
f,=0A=
 				   struct stripe_head_state *s,=0A=
 				   int disks)=0A=
 {=0A=
-	int rmw =3D 0, rcw =3D 0, i;=0A=
+	int rmw =3D 0, rcw =3D 0, i, cost;=0A=
 	sector_t recovery_cp =3D conf->mddev->recovery_cp;=0A=
 =0A=
 	/* Check whether resync is now happening or should start.=0A=
@@ -3569,27 +3569,17 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,=0A=
 			 conf->rmw_level, (unsigned long long)recovery_cp,=0A=
 			 (unsigned long long)sh->sector);=0A=
 	} else for (i =3D disks; i--; ) {=0A=
-		/* would I have to read this buffer for read_modify_write */=0A=
 		struct r5dev *dev =3D &sh->dev[i];=0A=
-		if ((dev->towrite || i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx) &&=0A=
-		    !test_bit(R5_LOCKED, &dev->flags) &&=0A=
+		if (!test_bit(R5_LOCKED, &dev->flags) &&=0A=
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||=0A=
 		      test_bit(R5_Wantcompute, &dev->flags))) {=0A=
-			if (test_bit(R5_Insync, &dev->flags))=0A=
-				rmw++;=0A=
-			else=0A=
-				rmw +=3D 2*disks;  /* cannot read it */=0A=
-		}=0A=
-		/* Would I have to read this buffer for reconstruct_write */=0A=
-		if (!test_bit(R5_OVERWRITE, &dev->flags) &&=0A=
-		    i !=3D sh->pd_idx && i !=3D sh->qd_idx &&=0A=
-		    !test_bit(R5_LOCKED, &dev->flags) &&=0A=
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||=0A=
-		    test_bit(R5_Wantcompute, &dev->flags))) {=0A=
-			if (test_bit(R5_Insync, &dev->flags))=0A=
-				rcw++;=0A=
-			else=0A=
-				rcw +=3D 2*disks;=0A=
+			/* IO cost for RMW/RCW depends on block readability */=0A=
+			cost =3D (test_bit(R5_Insync, &dev->flags)) ? 1 : 2*MAX_DISKS;=0A=
+			if (dev->towrite || i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx)=0A=
+				rmw +=3D cost;=0A=
+			if (!test_bit(R5_OVERWRITE, &dev->flags) &&=0A=
+			    i !=3D sh->pd_idx && i !=3D sh->qd_idx)=0A=
+				rcw +=3D cost;=0A=
 		}=0A=
 	}=0A=
 	pr_debug("for sector %llu, rmw=3D%d rcw=3D%d\n",=0A=



------=_NextPartTM-000-5192f970-2ba4-4ea1-ba39-7d0fa0ccd36e
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

------=_NextPartTM-000-5192f970-2ba4-4ea1-ba39-7d0fa0ccd36e--
