From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH 0/4] Add AVX512 optimized gen_syndrome and recovery
 functions
Date: Wed, 3 Aug 2016 05:44:03 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1739B81A7C6@EXCHANGE.collogia.de>
References: <1470180539-7417-1-git-send-email-gayatri.kammela@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-d6a014cc-44f2-4c77-9a96-022029440d98"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470180539-7417-1-git-send-email-gayatri.kammela@intel.com>
Content-Language: de-DE
Sender: linux-kernel-owner@vger.kernel.org
To: Gayatri Kammela <gayatri.kammela@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "shli@kernel.org" <shli@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "james.t.kukunas@linux.intel.com" <james.t.kukunas@linux.intel.com>, "fenghua.yu@intel.com" <fenghua.yu@intel.com>, "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>, "ravi.v.shankar@intel.com" <ravi.v.shankar@intel.com>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-d6a014cc-44f2-4c77-9a96-022029440d98
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org]&=
quot; im Auftrag von &quot;Gayatri Kammela [gayatri.kammela@intel.com]=0A=
> Gesendet: Mittwoch, 3. August 2016 01:28=0A=
> An: linux-raid@vger.kernel.org=0A=
> Cc: shli@kernel.org; linux-kernel@vger.kernel.org; hpa@zytor.com; james.t=
.kukunas@linux.intel.com; fenghua.yu@intel.com; megha.dey@linux.intel.com; =
ravi.v.shankar@intel.com; Gayatri Kammela=0A=
> Betreff: [PATCH 0/4] Add AVX512 optimized gen_syndrome and recovery funct=
ions=0A=
> =0A=
> This is the patch set for adding AVX512 optimized gen_syndrome=0A=
> and recovery functions.=0A=
> =0A=
> Optimization of RAID6 using AVX512 instructions should improve the=0A=
> RAID6 performance.These patches are tested and observed the improvement=
=0A=
> in performance.=0A=
=0A=
Hi Gayatri,=0A=
=0A=
as you already implemented the gen_syndrome() functions it should be a piec=
e=0A=
of cake to add the xor_syndrome() ones. Only if these are implemented we ca=
n=0A=
make use of Read-Modify-Write operations if the kernel chooses an processor=
 =0A=
optimized algorithm. They are already in the SSE2 path but are still missin=
g from =0A=
the current AVX2 implementation.=0A=
=0A=
More infos here:=0A=
=0A=
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=3Dfe5cbc6e06c7d8b3a86f6f5491d74766bb5c2827=0A=
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=3Da582564b24bec0443b5c5ff43ee6d1258f8bd658=0A=
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=3D0e833e697bcf4c2f3f7fb9fce39d08cd4439e5d7=0A=
=0A=
It would give the final touch to the patches.=0A=
=0A=
Best regards.=0A=
=0A=
Markus=0A=
=0A=
------=_NextPartTM-000-d6a014cc-44f2-4c77-9a96-022029440d98
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

------=_NextPartTM-000-d6a014cc-44f2-4c77-9a96-022029440d98--
