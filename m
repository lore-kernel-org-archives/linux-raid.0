From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Chances of silent errors?
Date: Tue, 22 Jan 2013 09:28:55 -0700
Message-ID: <83E6A21C-E6EF-4437-A265-67839431EA4E@colorremedies.com>
References: <24463267.2.1358852138003.JavaMail.root@zimbra>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24463267.2.1358852138003.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 22, 2013, at 3:55 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> w=
rote:

>> Coming from the zfs world, I've heard a few talk about the chances o=
f
>> "silent errors", meaning the checksum on the drives match, but the
>> data being bad because of matching checksum (aka collisions). Does
>> anyone in here know the relative chance of something like that
>> happening with the checksums of current harddisks? Is the 1:10^14 or
>> 1:10^15 chances for a URE in regard to this, or is that when the dri=
ve
>> reports an error, or those two combined?
>=20
> A follow-up here. I see drive manufacturers report the chance of an U=
RE is 1:10^14 for desktop drives, 1:10^15 for 7k2RPM enterprise drives =
and 1:10^16 for 10k and 15k enterprise drives (or most do). I was under=
 the impression that "nearline"  / 7k2 enterprise drives were the same =
thing as desktop drives, only with a slightly different firmware (TLER =
and friends =3D> don't do anything as stupid as going into "deep recove=
ry mode" like some desktop drives do).
>=20
> Any idea if there's a real difference between the hardware on enterpr=
ise and desktop 7k2 drives? Is this 10-fold difference between error ra=
tes real, or is it just marketing?

SNIA has said there are differences in ECC between consumer SATA, nearl=
ine SATA, and enterprise SAS for some time. They also distinguish quite=
 a few other differences that aren't ECC related, but they don't discus=
s error rates directly. And this is old information=85

http://www.snia.org/sites/default/education/tutorials/2007/spring/stora=
ge/Desktop_Nearline_Deltas_by_Design.pdf

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
