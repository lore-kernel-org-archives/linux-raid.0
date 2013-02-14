From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Best practice for large storage?
Date: Thu, 14 Feb 2013 18:39:31 +0100 (CET)
Message-ID: <9702021.20.1360863570996.JavaMail.root@zimbra>
References: <511D1FF9.1020502@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511D1FF9.1020502@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I don't feel like using the fuse version, but is zfsonlinux really stab=
le yet?=20

----- Opprinnelig melding -----
> Roy,
>=20
> Why not use ZFS on Linux? (http://www.zfsonlinux.org)
>=20
> ZFS on Linux is being merged into the upcoming Lustre 2.4 parallel
> filesystem release.
>=20
> --Jeff
>=20
> On 2/14/13 9:28 AM, Roy Sigurd Karlsbakk wrote:
> > Hi all
> >
> > It seems we may need some storage for video soon. This is a 20k
> > studen college in Norway, with rather a few on media related
> > studies. Since these students produce rather large amounts of raw
> > material, typically to be stored during the semester, we may need
> > some 50-100TiB, perhaps more. I have setup systems with these
> > amounts of storage earlier on ZFS, but may be using Linux MD for
> > this project. I'm aware of the lack of checksumming, snapshots etc
> > with Linux, but may be using it because of more Linux knowledge
> > amongst the sysadmins here. In such a setup, I guess nearline SAS
> > drives on a SAS expander will be used, and with the amount of
> > storage needed, I won't be using a single RAID-6 (too insecure) or
> > RAID-10 (too expensive) for the lot. In ZFS-land I used smallish
> > VDEVs (~10 drives each) in a large pool.
> >
> >   - Would using LVM on top of RAID-6 give me something similar?
> >   - If so, should I stripe the RAID sets, and again, if striping
> >   them, will it be as easy to add new RAID sets as we run out of
> >   space?
> >
> > Thanks, and best regards
> >
> > roy
> > --
> > Roy Sigurd Karlsbakk
> > (+47) 98013356
> > roy@karlsbakk.net
> > http://blogg.karlsbakk.net/
> > GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> > --
> > I all pedagogikk er det essensielt at pensum presenteres
> > intelligibelt. Det er et element=C3=A6rt imperativ for alle pedagog=
er =C3=A5
> > unng=C3=A5 eksessiv anvendelse av idiomer med xenotyp etymologi. I =
de
> > fleste tilfeller eksisterer adekvate og relevante synonymer p=C3=A5
> > norsk.
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
>=20
>=20
> --
> ------------------------------
> Jeff Johnson
> Co-Founder
> Aeon Computing
>=20
> jeff.johnson@aeoncomputing.com
> www.aeoncomputing.com
> t: 858-412-3810 x101 f: 858-412-3845
> m: 619-204-9061
>=20
> /* New Address */
> 4170 Morena Boulevard, Suite D - San Diego, CA 92117

--=20
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
