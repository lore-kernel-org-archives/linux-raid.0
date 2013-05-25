From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Moving RAID1 disks between systems
Date: Sat, 25 May 2013 21:44:36 +0200 (CEST)
Message-ID: <10904484.6.1369511076742.JavaMail.root@zimbra>
References: <CAGPLN=ut9sacwkYuaVbDP3u3dhm-WTZQw2gnAoVjMWFBEbqTCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGPLN=ut9sacwkYuaVbDP3u3dhm-WTZQw2gnAoVjMWFBEbqTCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Santos <iluvgadgets@gmail.com>
Cc: linux-raid@vger.kernel.org, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

----- Opprinnelig melding -----
> On Fri, May 24, 2013 at 2:30 PM, Drew <drew.kay@gmail.com> wrote:
> >
> > Hi Jim,
> >
> > You should have no troubles reassembling the array on a new machine=
=2E
> > From what I understand, md raid doesn't depend on device names for
> > assembling arrays, it has some internal UUID's to distinguish which
> > array a member disk belongs to.
> >
> > mdadm --assemble --scan is pretty much all you need (and won't brea=
k
> > anything in the process)
> >
> >
> Is there a way to rename md devices? It would be useful in general an=
d
> maybe necessary if assembling the arrays from the other system causes
> md device name collisions

if you mean device name, it's configured in /etc/mdadm/mdadm.conf or si=
milar (varies a bit between distros). that should hold the device name =
and its UUID

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
