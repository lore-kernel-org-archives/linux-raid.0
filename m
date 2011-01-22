From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA
 questions for HW owners/users
Date: Fri, 21 Jan 2011 21:50:55 -0800
Message-ID: <AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com> <4D39D8B5.1090901@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D39D8B5.1090901@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jan 21, 2011 at 11:04 AM, Stan Hoeppner <stan@hardwarefreak.com=
> wrote:
> Michael Evans put forth on 1/21/2011 10:00 AM:
>> The SUPERMICRO AOC-SASLP-MV8 PCI Express x4 Low Profile SAS SAS RAID
>> Controller seems to fit my needs and budget except for one glaring
>> omission on Supermicro's product page, and every other site that
>> blindly copies it.
>>
>> Has anyone tested this hardware with a 48-bit LBA required drive (EG
>> one of the 3TB drives that still exposes 512k sectors)?
>
> NewEgg has an excellent return policy:
> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816101358
>
> But, BTW, if you can afford over $1000 of 3TB drives, why are you dem=
anding to
> go so cheap with the HBA? =A0There are plenty of much better LSI base=
d dual
> SFF8087 HBAs available with no LBA or driver issues. =A0For instance:
> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816117157
>
> $155 Quality/compatible LSI SAS1068E chip+driver vs
> $109 Marvell 88SE6480 less than quality chip+driver
>
> If you can afford 5+ 3TB drives you can certainly afford an extra ~$5=
0 for a
> decent quality known to work SAS/SATA HBA. =A0I say 5+ because you're=
 obviously
> starting out with 5 or you'd be looking at cards with a single SFF808=
7, or
> simply 4 individual SATA connectors.
>
> I can't imagine an easier decision to make: =A0$50 for guaranteed pie=
ce of mind,
> performance, compatibility.
>
> --
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I wouldn't mind spending an extra $50 on the controller IF I knew it
supported 48 or 64 bit LBA, however neither the documentation on Intel
and NewEgg specifies what is supported.  In fact I have to assume
PCI-E 1.0 since it doesn't specify (not that it's an issue, 8 lane 1x
vs 4 lane 2x is more or less the same thing; though 4x is more future
proof since there is likely to be a slot that big on future
motherboards at /least/ for physics GPU support).

Are you suggesting the LSI based Intel card because you know it to
properly support >32 bit LBA?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
