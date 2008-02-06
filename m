From: Marcin Krol <admin@domeny.pl>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 6 Feb 2008 11:32:44 +0100
Message-ID: <200802061132.44462.admin@domeny.pl>
References: <200802051142.19625.admin@domeny.pl> <200802061055.03979.admin@domeny.pl> <47A987E7.9000902@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A987E7.9000902@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wednesday 06 February 2008 11:11:51 Peter Rabbitson napisa=C5=82(a):
> > lsof /dev/sdf1 gives ZERO results.
> >=20
>=20
> What does this say:
>=20
> 	dmsetup table


% dmsetup table
vg-home: 0 614400000 linear 9:2 384

Regards,
Marcin Krol
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
