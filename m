From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID halting
Date: Mon, 6 Apr 2009 18:16:50 -0400
Message-ID: <87f94c370904061516t51b74f26g9d2b02c09f27283f@mail.gmail.com>
References: <87f94c370904051300x531acb1fqb55319536333c01f@mail.gmail.com>
	 <20090405220311.YMPW19140.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405220311.YMPW19140.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Lot of reported problems turn out to be power supplies not designed =
to
>> carry a Sata load. =A0Apparently sata drives are very demanding and =
many
>> "good" power supplies don't cut the mustard.
>
> Well, the server itself only has a single PATA drive as its boot driv=
e, and
> the only peripheral card is the SATA controller. =A0It's a new chassi=
s (6
> months) with a 550 Watt supply, so it's unlikely to be the culprit, e=
ven
> though the CPU is 125 Watts. =A0The RAID chassis is a 12 slot system =
with a
> 400 Watt supply and 11 drives. =A0I suppose I could try changing the =
RAID
> supply to a 600 or 700 watt model, but really 400W should be enough f=
or 11
> drives and 3 port multipliers. =A0According to the spec sheets, the m=
ost power
> hungry drives in the mix (Hitachi E7K1000) require an absolute maximu=
m of 26
> watts. =A0If all the drives were the same, that would be 286 watts.
> Especially given the Western Digital drives and the one Seagate (not =
part of
> the array) drives are specified to have somewhat lower power consumpt=
ion,
> 400W should be fine.

It may or may not be as simple as you describe.

A lot of modern PSUs have multiple rails.  Each rail is independent
and provides some number of watts.

So if your CPU / graphic rail(s) are getting 300 watts out of your
550, then that only leave 250.  And that can be split among 2 or 3
rails as well.

It definitely gets complicated.

Or you may have a simple design where all the 5v lines are tied
together, same for +12v,-12v.

OTOH, if your having issues with power you should be seeing sata
transmission errors reported in the kernel log.  I don't recall your
saying, but I assume you've been watching that and nothing is showing
up during these events?

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
