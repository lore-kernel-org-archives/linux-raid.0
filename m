From: "Francois Billard" <francois.billard@alyseo.com>
Subject: RE: Managing mdam
Date: Wed, 11 Sep 2013 09:40:23 +0200
Message-ID: <026e01ceaec2$2ced7110$86c85330$@alyseo.com>
References: <CAPoh-nY8wwu-2yYRbKycPX2gEUofQu6y29TOYhOm83C2au6ZQQ@mail.gmail.com>	<20130910153347.5fafb58b@notabene.brown>	<CAPoh-nYLbSL81V4zmLQ579+XMa2rsNFG-Drf6mVQQuCh6SYOKg@mail.gmail.com>	<6693fa95e533a6027b7346f1b9b8af7e@alyseo.com> <20130911094848.00289146@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130911094848.00289146@notabene.brown>
Content-Language: fr
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We want to embed raid management in our application. But we want a bett=
er
solution if it exists rather than parsing the output of mdadm which is =
error
prone.
Is there a solution or should i write kilometer of regexp ? :)

-----Message d'origine-----
De=A0: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] De la part de NeilBrown
Envoy=E9=A0: mercredi 11 septembre 2013 01:49
=C0=A0: Francois Billard
Cc=A0: linux-raid@vger.kernel.org
Objet=A0: Re: Managing mdam

On Tue, 10 Sep 2013 10:03:23 +0200 Francois Billard
<francois.billard@alyseo.com> wrote:

> Hi,
>=20
> Is it possible to manage mdadm from an external point of view ? with =
a=20
> library with bindings in some language (Python) for example ?
> Thanks in advance
>=20
> Regards,
> Francois

Only by running mdadm in a separate process and passing appropriate
arguments.

Is there something particular that you wanted to do?

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
