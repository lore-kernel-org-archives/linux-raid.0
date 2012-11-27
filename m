From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 14:56:34 +0100 (CET)
Message-ID: <25425956.18.1354024591879.JavaMail.root@zimbra>
References: <50B4BE27.1050101@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B4BE27.1050101@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>
List-Id: linux-raid.ids

> > If this system is running RAID-6, recovery should be possible to
> > check both parity chunks, right?
>=20
> Yes, of course. (And if anyone ever needs it, it is possible to exten=
d
> raid6 to 3 parity chunks. I've done the maths, but it is not
> implemented - there doesn't seem to be a big need for it.) But - agai=
n
> referring back to Neil's blog - if the low-level raid spots a
> consistency error, it still cannot correct it reliably even with 2
> parity chunks, and should pass on a read error to the higher level
> raid.
> Using raid6 at the low level would let you do a good consistency chec=
k
> even in the case of a failed drive (or a known read error on a drive)
> -
> or two simultaneous undetected read errors. And raid6 on the higher
> level raid would let you correct such errors, even when there are
> other
> errors around. You'd soon reach the point where it is more likely for
> your disks to spontaneously turn into a bowl of petunias than for rea=
d
> errors to be undetected or unrecoverable.

That would be nice. So what should be done here in the first place, is =
to change the code to allow parity data to be read and calculated also =
on reads?

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
