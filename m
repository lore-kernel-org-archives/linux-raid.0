From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Tue, 25 Jan 2011 13:51:23 +0100
Message-ID: <20110125135123.0342f116@harpe.intellique.com>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
	<alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
	<20110124215713.82D75B187@gemini.denx.de>
	<20110124230314.GA11040@dastard>
	<20110125083900.4dd65bf2@galadriel2.home>
	<20110125083643.GE28803@dastard>
	<20110125124509.D76D6BB0B9@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110125124509.D76D6BB0B9@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-raid@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com
List-Id: linux-raid.ids

Le Tue, 25 Jan 2011 13:45:09 +0100
Wolfgang Denk <wd@denx.de> =E9crivait:

> > This is smelling like a case of barrier IOs on software raid on
> > cheap storage.... =20
>=20
> Right. [Any way to avoid these, btw?]=20

Easy enough, use the "nobarrier" mount option.=20

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
