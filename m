From: Jens Benecke <jens-dated-1092049816.9085e9@spamfreemail.de>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian "woody",
	homebrew 2.4.25 kernel
Date: Wed, 4 Aug 2004 13:10:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408041310.12982.jens@spamfreemail.de>
References: <Pine.LNX.4.44.0408041058470.7382-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0408041058470.7382-100000@uplift.swm.pp.se>
Content-Disposition: inline
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Mittwoch, 4. August 2004 11:00 schrieb Mikael Abrahamsson:

> On Wed, 4 Aug 2004, Jens Benecke wrote:
> > The goal is to have as "stress free" a system as possible - i.e. wi=
th
> > as little manual configuration, and in event of emergencies, as lit=
tle
> > work to do, as possible.
>
> You probably should go for hardware RAID1 instead, this will present =
the
> drive as a single drive to the OS and will handle all failure scenari=
os,
> you will not be hindered by fixing LILO to boot etc. Yes, it'll cost =
a
> bit more but if your goal is simplicity and carefree running, this is
> probably the best way.

Hi Mikael,

thanks for your answer. What hardware RAID1 options would I have here t=
hat=20
are somewhat affordable? I see 3ware 2-drive RAID controllers for =A412=
0.-=20
here, and Promise UDMA for =A460.-

I hear Promise only offers binary drivers and is only "software RAID", =
is=20
the 3ware solution worth the extra =A460 (less hassle and more=20
compatbility)?


Thanks!

--=20
Dipl.-Ing. Jens Benecke
http://www.hitchhikers.de - Europas kostenlose Mitfahrzentrale seit 199=
8
http://www.rb-hosting.de - Webhosting mit Extras - PHP ab =A49 - SSH ab=
 =A419
http://www.spamfreemail.de - 100% saubere Postf=E4cher, garantiert!
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
