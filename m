From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Best practice for large storage?
Date: Sat, 16 Feb 2013 13:48:20 +0100 (CET)
Message-ID: <10665743.0.1361018900938.JavaMail.root@zimbra>
References: <511E051A.9080004@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511E051A.9080004@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Jeff Johnson <jeff.johnson@aeoncomputing.com>
List-Id: linux-raid.ids

> On 14.02.2013 18:48, Jeff Johnson wrote:
> > Stable enough where it is being used at Lawrence Livermore Nat'l
> > Labs on
> > a 55PB Lustre resource.
> >
> > I've been using it on a pre-release Lustre 2.4 and I have not had
> > any
> > issues.
>=20
> ZFS completely fragments if you've got massive parallel write IO -
> especially with Solaris 11. You'll get only 2..3 MiB/s after some tim=
e
> as everything is stored completely random then. So if you don't reall=
y
> need these snapshots you shouldn't use ZFS. NILFS is also good for
> snapshots.

This won't be massive parallel I/O, just a fileserver with a limited am=
ount of users. Also, can you document this claim?

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
