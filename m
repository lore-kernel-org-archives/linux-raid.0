From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: raid-5 initiated as raid-4?
Date: Thu, 7 Feb 2013 18:56:12 +0100 (CET)
Message-ID: <23689346.18.1360259772196.JavaMail.root@zimbra>
References: <20130207175328.GA5391@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130207175328.GA5391@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > root@raidtest:~# cat /proc/mdstat
> > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5=
]
> > [raid4] [raid10]
> > md0 : active raid5 vdf[5](S) vde[4](S) vdd[3] vdc[1] vdb[0]
> >       4191232 blocks super 1.2 level 5, 512k chunk, algorithm 2
> >       [3/3] [UUU]
>=20
> Where did vde & vdf spring from? They weren't in your create command =
-
> did you add those as spares later?

Yes

>
> > Does this mean the raid-5 is actually initiated as a raid-4?
> >
> RAID-5 is always created with n-1 disks, with the final disk being
> recovered afterwards. It's quicker to do a linear read from the other
> disks and a linear write onto the final disk (creating parity or
> rebuilding the data as needed) than it is to intersperse reads &
> writes
> on all disks and just create the parity data (for RAID5 anyway -
> reconstructing the data on a RAID6 from P & Q parity is far more
> expensive, so it's quicker to just generate the parity there).

ok, so do I understand correctly that the initial raid-5 build only wri=
tes data/parity to a single drive (the 'replacement')? Doing some more =
testing now to see what I can find=E2=80=A6

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
