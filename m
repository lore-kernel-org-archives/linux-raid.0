From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Question about resync in RAID5
Date: Tue, 16 Apr 2013 17:46:07 +0200 (CEST)
Message-ID: <4915289.2.1366127167165.JavaMail.root@zimbra>
References: <20130416102452.GC25795@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130416102452.GC25795@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org, Robin Dong <robin.k.dong@gmail.com>
List-Id: linux-raid.ids

> > Is there any method to just resync WRITTEN data to new-added-disk ?
> > Or any developing plan to add this feature?
>=20
> No, because md is a block device it has no knowledge of what data has
> actually been written to the disk or where it is stored. This means i=
t
> has to rebuild the entire disk.
>=20
> There are plans to improve this by keeping track of which stripes hav=
e
> been written to, which should help (and will also mean no need for an
> initial RAID sync). I don't know whether this has progressed beyond
> the idea stage yet though.

Interesting - do you have any docs about this? I haven't seen any talk =
on this list about it...

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
