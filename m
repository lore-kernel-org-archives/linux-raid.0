From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Checksumming RAID?
Date: Wed, 28 Nov 2012 11:58:01 +0100 (CET)
Message-ID: <32402494.9.1354100281894.JavaMail.root@zimbra>
References: <50B52740.5000201@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B52740.5000201@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux Raid <linux-raid@vger.kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>, David Brown <david.brown@hesbynett.no>
List-Id: linux-raid.ids

> > To do checksumming (and in particular, recovery), requires higher
> > level
> > knowledge of the data. The filesystem can track when it writes a
> > file,
> > and update metadata (including, if desired, a data checksum) once i=
t
> > knows the file is correctly stored. But I don't think it can
> > sensibly
> > be done at the block device level - the recovery procedure doesn't
> > know
> > what is old data, what is new data, or which bit is important to th=
e
> > filesystem.
> >
> > So I think it can make sense to use a filesystem like ZFS or BTRFS
> > that
> > can do checksumming - that is a reasonable level to add the
> > checksum.
>=20
> You'll see CRC in XFS in the future as well. Some of the foundation i=
s
> already laid to allow it, but IIRC it requires an on disk format
> change
> for full implementation. On disk format changes are a big deal and ar=
e
> taken with great care. IIRC XFS has only seen one or two in 18 years.

I'm afraid that won't help much either, since it'll only allow for *det=
ecting* the errors, and not *fixing* them (as with ZFS and Btrfs). Or p=
erhaps if XFS can integrate with MD somehow?

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
