From: "Ionut Nistor" <ionut@modulo.ro>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Thu, 12 Jun 2003 13:51:06 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <007c01c330d0$86dda7b0$0cc7e7c1@EEL>
References: <02d201c33023$13fd45a0$3351960a@EEL> <3EE7585E.45D851CE@SteelEye.com> <20030612100423.GA14106@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Lars Marowsky-Bree <lmb@suse.de>, Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Lars,

Are these changes documented?
Is there a changelog?
In which official kernel has the patch been merged?
Is there a separate patch I can apply to 2.4.18 vanilla?

Thanks a lot,
Ionut

----- Original Message -----=20
=46rom: "Lars Marowsky-Bree" <lmb@suse.de>
To: "Paul Clements" <Paul.Clements@SteelEye.com>; "Ionut Nistor"
<ionut@modulo.ro>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, June 12, 2003 1:04 PM
Subject: Re: Multipath problem in a SAN enviromnent


> On 2003-06-11T12:27:10,
>    Paul Clements <Paul.Clements@SteelEye.com> said:
>
> > One way to get around this problem is to use non-persistent superbl=
ocks
> > for your arrays and just re-create them at bootup time by calling m=
kraid
> > (or mdadm) after you've correctly identified (using WWID or similar=
)
> > which devices belong to each particular raid set.
>
> The patches I did to multipath in 2.4 went even further: As the md
> superblock - this_disk etc - has little meaning for multipath, as the=
y
> are all identical, I made the assembly based entirely on the UUID,
> ignoring the device nodes completely.
>
>
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>
>
> --=20
> SuSE Labs - Research & Development, SuSE Linux AG
>
> "If anything can go wrong, it will." "Chance favors the prepared (min=
d)."
>   -- Capt. Edward A. Murphy            -- Louis Pasteur
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
