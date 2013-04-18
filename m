From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Odd --examine output
Date: Thu, 18 Apr 2013 13:33:42 +0200 (CEST)
Message-ID: <19242720.12.1366284822099.JavaMail.root@zimbra>
References: <20130416085857.GB25795@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130416085857.GB25795@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

> > Roy> I still don't understand why people use partitions for RAID
> > when
> > Roy> the whole drive is used anyway. Partitions were invented to
> > Roy> partition things up and are of no use if you want to spend the
> > Roy> whole drive's space for RAID use (or otherwise).
> >
> > Because if I take a 2tb disk a I put a partition on there which is =
a
> > bit smaller than the full disk, if I then add a new 2tb (or any
> > other
> > size) disk which says it's 2tb, but it's really a bit smaller, then
> > I'm not screwed. I've had it happen.
> >
> Recently? AFAIK, all modern drives (everything over 320G-ish IIRC) us=
e
> standardised sizes (i.e. any 2TB disk will present exactly the same
> number of sectors). I recall reading that all the manufacturers agree=
d
> to do this to prevent just this sort of issue, though I can't find a
> reference to it now.

Indeed - you have to go back to smaller drives than those in current pr=
oduction to find varying sizes for equally labelled drive sizes.

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
