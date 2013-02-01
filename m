From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Raid 5 to 6 migration
Date: Fri, 1 Feb 2013 15:38:22 -0700
Message-ID: <B0CBBAD8-16B1-4ABC-A5F0-0B8F7E580AA0@colorremedies.com>
References: <BLU0-SMTP433B0BCF64D448CC81098D2C91C0@phx.gbl> <510C0075.9010908@turmel.org> <20130202001625.2b7d6514@natsu> <510C072B.1030108@turmel.org> <065BDBBE-7DB8-40CC-B1BC-8DCEE327F7C4@colorremedies.com> <510C3BED.2030408@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510C3BED.2030408@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 1, 2013, at 3:04 PM, Phil Turmel <philip@turmel.org> wrote:

> On 02/01/2013 01:49 PM, Chris Murphy wrote:
>>=20
>>=20
>> Does this option mean, in effect, the 7th disk is just a parity disk=
? So, sorta like a hybrid RAID 5/RAID4.
>=20
> Yes, with just the Q left on the 7th disk.  The remainder of the arra=
y
> is the normal raid5 stripe.  See the manpage for the layout
> "left-symmetric-6".

Just when I thought I had some lanterns illuminating most of the rabbit=
 hole=85

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
