From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 12:39:34 +0100 (CET)
Message-ID: <22100889.14.1354016374529.JavaMail.root@zimbra>
References: <50B4A215.4000203@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B4A215.4000203@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>
List-Id: linux-raid.ids

> I can certainly sympathise with you, but I am not sure that data
> checksumming would help here. If your hardware raid sends out
> nonsense,
> then it is going to be very difficult to get anything trustworthy. Th=
e
> obvious answer here is to throw out the broken hardware raid and use =
a
> system that works - but it is equally obvious that that is easier sai=
d
> than done! But I would find it hard to believe that this is a common
> issue with hardware raid systems - it goes against the whole point of
> data storage.
>=20
> There is always a chance of undetected read errors - the question is
> if
> the chances of such read errors, and the consequences of them, justif=
y
> the costs of extra checking. And if they /do/ justify extra checking,
> are data checksums the right way?

The chance of a silent corruption is rather small with your average 3TB=
 home storage. On the other hand, if you had a petabyte or five, the ch=
ances would be very high indeed to get silent corruption (ref the CERN =
study done in 2007). In my last job, I worked with ZFS with ~350TiB sto=
rage, and there we saw errors happen rather frequently, but then, since=
 ZFS checksums data and uses it to deal with errors, we never saw any d=
ata loss. That is, except on an older machine, running ZFS on a hardwar=
e RAID controlled storage unit (NexSAN SATABeast). We had error corrupt=
ion on that one as well, after a disk failure, and had to resort to res=
toring from tape, since ZFS couldn't control the RAID.

> I agree with Neil's post that
> end-to-end checksums (such as CRCs in a gzip file, or GPG integrity
> checks) are the best check when they are possible, but they are not
> always possible because they are not transparent.

The problem with end-to-end-checksums at the application level, is it w=
ill only be able to detect the error, not fix it, similar to the issues=
 I mentioned above.

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
