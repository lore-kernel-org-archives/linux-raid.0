From: <stockhausen@collogia.de>
Subject: [Patch v1 3/4] md/raid5: STIPE_HANDLE bit in handle_strype_dirtying()
Date: Fri, 7 Aug 2015 20:21:03 +0000
Message-ID: <10d76233-f0d2-43cc-8e15-02015d960d32@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-14f34451-d570-49ee-a97f-55c3a55fc1fb"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-14f34451-d570-49ee-a97f-55c3a55fc1fb
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

md/raid5: STIPE_HANDLE bit in handle_strype_dirtying() =0A=
=0A=
Set STRIPE_HANDLE flag only if it is required.=0A=
=0A=
Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>=0A=
=0A=
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0A=
index 6a7e638..f8630c1 100644=0A=
--- a/drivers/md/raid5.c=0A=
+++ b/drivers/md/raid5.c=0A=
@@ -3584,7 +3584,6 @@ static void handle_stripe_dirtying(struct r5conf *con=
f,=0A=
 	}=0A=
 	pr_debug("for sector %llu, rmw=3D%d rcw=3D%d\n",=0A=
 		(unsigned long long)sh->sector, rmw, rcw);=0A=
-	set_bit(STRIPE_HANDLE, &sh->state);=0A=
 	if ((rmw < rcw || (rmw =3D=3D rcw && conf->rmw_level =3D=3D PARITY_ENABLE=
_RMW)) && rmw > 0) {=0A=
 		/* prefer read-modify-write, but need to get some data */=0A=
 		if (conf->mddev->queue)=0A=
@@ -3646,8 +3645,10 @@ static void handle_stripe_dirtying(struct r5conf *co=
nf,=0A=
 	}=0A=
 =0A=
 	if (rcw > disks && rmw > disks &&=0A=
-	    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))=0A=
+	    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {=0A=
 		set_bit(STRIPE_DELAYED, &sh->state);=0A=
+		set_bit(STRIPE_HANDLE, &sh->state);=0A=
+	}=0A=
 =0A=
 	/* now if nothing is locked, and if we have enough data,=0A=
 	 * we can start a write request=0A=



------=_NextPartTM-000-14f34451-d570-49ee-a97f-55c3a55fc1fb
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

------=_NextPartTM-000-14f34451-d570-49ee-a97f-55c3a55fc1fb--
