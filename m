From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 0/0] raid5: fix init_stripe() inconsistencies
Date: Wed, 13 Aug 2014 09:37:31 +0000
Message-ID: <fb820ed5-44e5-4596-b8d4-956027be204a@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-bb6aa2bd-1727-4314-9308-4302ebe1f5c0"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-bb6aa2bd-1727-4314-9308-4302ebe1f5c0
Content-Type: text/plain

commit 639a347254c4b8daa22ce09c281259dce7f6ba71
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Sun Aug 10 09:25:55 2014 +0000

    raid5: fix init_stripe() inconsistencies 

    1) remove_hash() is not necessary. We will only be called right after
    get_free_stripe(). There we have already a call to remove_hash().

    2) Tracing prints out the sector of the freed stripe and not the sector
    that we want to initialize.

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7f66741..c4cd245 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -527,9 +527,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
 	BUG_ON(stripe_operations_active(sh));
 
 	pr_debug("init_stripe called, stripe %llu\n",
-		(unsigned long long)sh->sector);
-
-	remove_hash(sh);
+		(unsigned long long)sector);
 retry:
 	seq = read_seqcount_begin(&conf->gen_lock);
 	sh->generation = conf->generation - previous;

------=_NextPartTM-000-bb6aa2bd-1727-4314-9308-4302ebe1f5c0
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

------=_NextPartTM-000-bb6aa2bd-1727-4314-9308-4302ebe1f5c0--
