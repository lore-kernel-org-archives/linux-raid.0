From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 14:09:30 +0100 (CET)
Message-ID: <2920513.16.1354021770710.JavaMail.root@zimbra>
References: <50B4B40B.3000807@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B4B40B.3000807@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>
List-Id: linux-raid.ids

> One way to handle this at md block level would be to have an option
> for
> raid arrays to always do a full stripe read and consistency check
> whenever a block is read. If the consistency check fails (without any
> errors being indicated from the drives), the array should simply
> return
> a read error - it should /not/ attempt to recover the data (since it
> can't tell which parts are the real problem). If arrays with this
> option are used as first-level arrays, with a "normal" md raid array
> (raid1, raid5, etc.) on top, then the normal raid recovery process
> will
> replace the bad data and initiate a new write to correct the
> undetected
> read error. I think this would perhaps give you the level of
> reliability you are looking for, and be suitable for big arrays
> (indeed,
> it would be unsuitable for small arrays as you need at least two
> levels).

If this system is running RAID-6, recovery should be possible to check =
both parity chunks, right?

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
