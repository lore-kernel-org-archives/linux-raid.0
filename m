From: "Ionut Nistor" <ionut@modulo.ro>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Thu, 19 Jun 2003 18:25:34 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <028401c33677$07904790$0cc7e7c1@EEL>
References: <02d201c33023$13fd45a0$3351960a@EEL> <3EE7585E.45D851CE@SteelEye.com> <20030612100423.GA14106@marowsky-bree.de> <007c01c330d0$86dda7b0$0cc7e7c1@EEL> <3EE893A4.E0518632@SteelEye.com> <00e801c33183$8072cd70$0cc7e7c1@EEL> <20030618102157.GD27378@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Lars Marowsky-Bree <lmb@suse.de>, Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Lars,

I'll try this and see how it goes.
I've seen that you also included a mdadm patch (probably to support the
other ioctls clean, active, inactive).

Have a nice day,
Ionut

----- Original Message -----=20
=46rom: "Lars Marowsky-Bree" <lmb@suse.de>
To: "Ionut Nistor" <ionut@modulo.ro>; "Paul Clements"
<Paul.Clements@SteelEye.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, June 18, 2003 1:21 PM
Subject: Re: Multipath problem in a SAN enviromnent


> On 2003-06-13T11:12:15,
>    Ionut Nistor <ionut@modulo.ro> said:
>
> > Agreed, but Lars mentioned 'the patch in 2.4 went even further' -  =
hence
I
> > assume what's at the link you posted is obsolete - am I correct?
> > While I'm patching it, I want to make sure it's the latest one.
>
> I've pulled out the latest patch set against our kernel and made it
> available at ftp://ftp.suse.com/pub/people/lmb/md-mp/; however, it
> probably will not apply cleanly against 2.4.21 yet.
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
