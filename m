From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Wed, 27 Mar 2013 17:01:34 +0100 (CET)
Message-ID: <16639206.20.1364400094382.JavaMail.root@zimbra>
References: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46rom the manual

       -c, --chunk=3D
              Specify  chunk size of kibibytes.  The default when creat=
ing an array is 512KB.  To ensure compatibility with ear=E2=80=90
              lier versions, the default when Building and array with n=
o persistent metadata is 64KB.  This is  only  meaningful
              for RAID0, RAID4, RAID5, RAID6, and RAID10.

meaning - chunk size isn't relevant to a mirror

----- Opprinnelig melding -----
> Greetings,
>=20
> I have a RAID-1, two disk volume that was created with a strange chun=
k
> size. For reasons I won't go into here removing the data and
> redefining a new RAID-1 volume with a different chunk size is
> presently not a viable option.
>=20
> Since this is a two disk mirror I should, /*theoretically*/ be able t=
o
> redefine the chunk size without impacting existing data. I have never
> attempted such a thing and am not sure how best to go about it. I kno=
w
> in a striped data level like RAID-5 or RAID-6 this would absolutely
> not be possible.
>=20
> I know I would have to set a different chunk size in the superblock.
> Google and wiki research do not show a clear method to do this.
>=20
> Any suggestions are appreciated.
>=20
> --Jeff
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
>=20
> 4170 Morena Boulevard, Suite D - San Diego, CA 92117
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

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
