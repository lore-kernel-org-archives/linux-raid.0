From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 3/6] raid6 algorithms: xor_syndrome() for generic int
Date: Tue, 19 Aug 2014 16:36:38 +0000
Message-ID: <d8ea6d45-2b04-4084-b9cb-6e38ff142969@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-6ac6f4f9-8763-4345-9ed8-be1f100f7fbd"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-6ac6f4f9-8763-4345-9ed8-be1f100f7fbd
Content-Type: text/plain

commit 792ad6dd60e0e45f240d1a6e9cdad6bd45be6d46
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Tue Aug 19 16:00:57 2014 +0000

    raid6 algorithms: xor_syndrome() for generic int
    
    v2: xor_syndrome() with function header
    
    Start the algorithms with the very basic one. It is left and right
    optimized. That means we can avoid all calculations for unneeded pages
    above the right stop offset. For pages below the left start offset we
    still need the syndrome multiplication but without reading data pages.

diff --git a/lib/raid6/int.uc b/lib/raid6/int.uc
index 5ca60be..558aeac 100644
--- a/lib/raid6/int.uc
+++ b/lib/raid6/int.uc
@@ -107,9 +107,47 @@ static void raid6_int$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 }
 
+static void raid6_int$#_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	int d, z, z0;
+
+	unative_t wd$$, wq$$, wp$$, w1$$, w2$$;
+
+	z0 = stop;		/* P/Q right side optimization */
+	p = dptr[disks-2];	/* XOR parity */
+	q = dptr[disks-1];	/* RS syndrome */
+
+	for ( d = 0 ; d < bytes ; d += NSIZE*$# ) {
+		/* P/Q data pages */
+		wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE];
+		for ( z = z0-1 ; z >= start ; z-- ) {
+			wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
+			wp$$ ^= wd$$;
+			w2$$ = MASK(wq$$);
+			w1$$ = SHLBYTE(wq$$);
+			w2$$ &= NBYTES(0x1d);
+			w1$$ ^= w2$$;
+			wq$$ = w1$$ ^ wd$$;
+		}
+		/* P/Q left side optimization */
+		for ( z = start-1 ; z >= 0 ; z-- ) {
+			w2$$ = MASK(wq$$);
+			w1$$ = SHLBYTE(wq$$);
+			w2$$ &= NBYTES(0x1d);
+			wq$$ = w1$$ ^ w2$$;
+		}
+		*(unative_t *)&p[d+NSIZE*$$] ^= wp$$;
+		*(unative_t *)&q[d+NSIZE*$$] ^= wq$$;
+	}
+
+}
+
 const struct raid6_calls raid6_intx$# = {
 	raid6_int$#_gen_syndrome,
-	NULL,			/* XOR not yet implemented */
+	raid6_int$#_xor_syndrome,
 	NULL,			/* always valid */
 	"int" NSTRING "x$#",
 	0

------=_NextPartTM-000-6ac6f4f9-8763-4345-9ed8-be1f100f7fbd
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

------=_NextPartTM-000-6ac6f4f9-8763-4345-9ed8-be1f100f7fbd--
