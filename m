From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH 1/2] md/raid6: use faster multiplication for ARM NEON
 delta syndrome
Date: Thu, 13 Jul 2017 17:51:19 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173010E029C61@EXCHANGE.collogia.de>
References: <20170713171601.25440-1-ard.biesheuvel@linaro.org>,
 <20170713171601.25440-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----=_NextPartTM-000-82adbd26-40ef-4c6b-95c9-17094597a03e"
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170713171601.25440-2-ard.biesheuvel@linaro.org>
Content-Language: de-DE
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "will.deacon@arm.com" <will.deacon@arm.com>, "shli@kernel.org" <shli@kernel.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-82adbd26-40ef-4c6b-95c9-17094597a03e
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: Ard Biesheuvel [ard.biesheuvel@linaro.org]=0A=
> Gesendet: Donnerstag, 13. Juli 2017 19:16=0A=
> An: linux-arm-kernel@lists.infradead.org; linux-raid@vger.kernel.org=0A=
> Cc: shli@kernel.org; Markus Stockhausen; linux@armlinux.org.uk; will.deac=
on@arm.com; catalin.marinas@arm.com; Ard Biesheuvel=0A=
> Betreff: [PATCH 1/2] md/raid6: use faster multiplication for ARM NEON del=
ta syndrome=0A=
> =0A=
> The P/Q left side optimization in the delta syndrome simply involves=0A=
> repeatedly multiplying a value by polynomial 'x' in GF(2^8). Given=0A=
> that 'x * x * x * x' equals 'x^4' even in the polynomial world, we=0A=
> can accelerate this substantially by performing up to 4 such operations=
=0A=
> at once, using the NEON instructions for polynomial multiplication.=0A=
> =0A=
> Results on a Cortex-A57 running in 64-bit mode:=0A=
> =0A=
>   Before:=0A=
>   -------=0A=
>   raid6: neonx1   xor()  1680 MB/s=0A=
>   raid6: neonx2   xor()  2286 MB/s=0A=
>   raid6: neonx4   xor()  3162 MB/s=0A=
>   raid6: neonx8   xor()  3389 MB/s=0A=
> =0A=
>   After:=0A=
>   ------=0A=
>   raid6: neonx1   xor()  2281 MB/s=0A=
>   raid6: neonx2   xor()  3362 MB/s=0A=
>   raid6: neonx4   xor()  3787 MB/s=0A=
>   raid6: neonx8   xor()  4239 MB/s=0A=
=0A=
Nice optimiziation. Nevertheless the test algorithm favours this implementa=
tion. See:=0A=
=0A=
int start =3D (disks>>1)-1, stop =3D disks-3; /* work on the second half of=
 the disks */=0A=
=0A=
What gives the before/after test if you work on the middle data disks and n=
ot on =0A=
the right ones? In the 4K page size this should be  start =3D 3, stop =3D 1=
1 instead of=0A=
start =3D 7, stop =3D 13. Given the large gain you see the impact should be=
 lower but =0A=
at least in the >10% range. =0A=
=0A=
Markus=0A=
 =0A=
> While we're at it, simplify MASK() by using a signed shift rather than=0A=
> a vector compare involving a temp register.=0A=
> =0A=
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>=0A=
> ...=
------=_NextPartTM-000-82adbd26-40ef-4c6b-95c9-17094597a03e
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

------=_NextPartTM-000-82adbd26-40ef-4c6b-95c9-17094597a03e
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

------=_NextPartTM-000-82adbd26-40ef-4c6b-95c9-17094597a03e--
