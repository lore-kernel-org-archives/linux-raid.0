From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Resync raid array problem
Date: Mon, 20 May 2013 15:45:17 +0200 (CEST)
Message-ID: <32232973.14.1369057517437.JavaMail.root@zimbra>
References: <51999C89.6090001@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51999C89.6090001@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 20/05/13 10:53, Keith Keller wrote:
> > On 2013-05-20, Tarak <tarakramgopal@gmail.com> wrote:
> >> We sucessfully created a Raid array of 8 harddisks.
> >> On power failure situation,
> >
> > You should probably have some sort of redundant power for such an
> > array--either a UPS or backup power provided by a building
> > generator.
> >
>=20
> Can't agree with this strongly enough. Grab the best UPS you can
> afford
> (and often that means getting a 10 year old one second hand and
> replacing the batteries). Best investment I _ever_ made was a 2000
> vintage APC SmartUPS 2200 and it cost all of about $200 second hand,
> plus another $100 for new batteries.
>=20
> Also, look at adding a bitmap to your array. Then it will only resync
> what it suspects might be dirty.

oh - and if this is a raid-5 array, better get a new disk and change to=
 raid-6. 8 drives in raid-5 is rather a lot=E2=80=A6

Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
