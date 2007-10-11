From: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Subject: AW: How do i limit the bandwidth-usage while resyncing on RAID 1?
Date: Thu, 11 Oct 2007 09:49:54 +0200
Message-ID: <735D322AED9CD711BE53000476917CD002972BB6@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 Hi Richard,

Seems to me, that you mussunderstood? There's no rsync in RAID afaik?
This is an internal driver...?

Kind regards, Florian

> -----Urspr=FCngliche Nachricht-----
> Von: Richard Scobie [mailto:richard@sauce.co.nz]=20
> Gesendet: Mittwoch, 10. Oktober 2007 21:46
> An: Linux RAID Mailing List
> Betreff: Re: How do i limit the bandwidth-usage while=20
> resyncing on RAID 1?
>=20
> Rustedt, Florian wrote:
>=20
> > How can i tune this? I want somthing like "nice -n 19 dm-mirror" ;)
>=20
> Have a look at man rsync - the --bwlimit=3DKBPS option.
>=20
> Regards,
>=20
> Richard
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-raid" in the body of a message to=20
> majordomo@vger.kernel.org More majordomo info at =20
> http://vger.kernel.org/majordomo-info.html
>=20
***********************************************************************=
***********************
IMPORTANT: The contents of this email and any attachments are confident=
ial. They are intended for the=20
named recipient(s) only.
If you have received this email in error, please notify the system mana=
ger or the sender immediately and do=20
not disclose the contents to anyone or make copies thereof.
*** eSafe scanned this email for viruses, vandals, and malicious conten=
t. ***
***********************************************************************=
***********************

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
