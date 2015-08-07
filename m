From: <stockhausen@collogia.de>
Subject: [Patch v1 1/4] md/raid5: MAX_DISKS define
Date: Fri, 7 Aug 2015 20:21:00 +0000
Message-ID: <efe32f66-e566-43c8-acd6-79cf27ed9a5b@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-2c09d235-f6e1-4cbf-ba96-38bae53114f0"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-2c09d235-f6e1-4cbf-ba96-38bae53114f0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

md/raid5: MAX_DISKS define=0A=
=0A=
The maximum number of disks raid5 can handle is not clearly defined.=0A=
To avoid arbitrary values at several places introduce a new constant.=0A=
=0A=
Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>=0A=
=0A=
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0A=
index 643d217..817d125 100644=0A=
--- a/drivers/md/raid5.c=0A=
+++ b/drivers/md/raid5.c=0A=
@@ -7722,7 +7722,7 @@ static void *raid6_takeover(struct mddev *mddev)=0A=
 		return ERR_PTR(-EINVAL);=0A=
 	if (mddev->degraded > 1)=0A=
 		return ERR_PTR(-EINVAL);=0A=
-	if (mddev->raid_disks > 253)=0A=
+	if (mddev->raid_disks >=3D MAX_DISKS)=0A=
 		return ERR_PTR(-EINVAL);=0A=
 	if (mddev->raid_disks < 3)=0A=
 		return ERR_PTR(-EINVAL);=0A=
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h=0A=
index d051442..112545b 100644=0A=
--- a/drivers/md/raid5.h=0A=
+++ b/drivers/md/raid5.h=0A=
@@ -542,6 +542,11 @@ struct r5conf {=0A=
 	int			worker_cnt_per_group;=0A=
 };=0A=
 =0A=
+/*=0A=
+ * Number of disks a raid456 device can support. Regarding physical constr=
aints=0A=
+ * this is only a theoretical value. Nevertheless it improves readability=
=0A=
+ */=0A=
+#define MAX_DISKS 254=0A=
 =0A=
 /*=0A=
  * Our supported algorithms=0A=



------=_NextPartTM-000-2c09d235-f6e1-4cbf-ba96-38bae53114f0
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

------=_NextPartTM-000-2c09d235-f6e1-4cbf-ba96-38bae53114f0--
