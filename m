From: =?ISO-8859-1?Q?Ra=FAl_G=F3mez?= Cabrera <raulgomezc@acm.org>
Subject: Re: Removing a RAID 1 setting without loosing data
Date: Sat, 13 May 2006 11:04:07 -0400
Message-ID: <1147532647.6198.16.camel@nachus.raulgomez.net>
References: <1147531525.6198.8.camel@nachus.raulgomez.net>
	 <Pine.LNX.4.56.0605131548450.19433@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0605131548450.19433@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Gordon, thanks for your quick response.

Well my client does not want to spend more money on this particular
server, I think maybe that is because they are planning to replace it..=
=2E

As for the RAID settings you are rigth!!!, I'm going to leave it
untouched!

Thanks again!

Raul.

El s=C3=A1b, 13-05-2006 a las 15:50 +0100, Gordon Henderson escribi=C3=B3=
:

> I'd just halt the server and remove the failed disk and would leave a=
ll
> the RAID stuff in-place as theres no need to remove it, really. It so=
unds
> like your client thinks there might be issues, but there really shoul=
dn't
> be any. (nor performance issues either)
>=20
> Why can't you find a replacement disk? You can always put in a bigger=
 one
> if neccessary...
>=20
> Gordon
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
