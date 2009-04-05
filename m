From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID halting
Date: Sat, 4 Apr 2009 20:49:36 -0400
Message-ID: <87f94c370904041749j318b577dr663ef0bd3b4ad717@mail.gmail.com>
References: <49D7C19C.2050308@gmail.com>
	 <20090405000728.GGPW19140.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405000728.GGPW19140.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

<snip>
>=A0Also, it doesn't take a drive 40 seconds,
> let alone 2 minutes, to mark a sector bad.

Just for info, with Enterprise class sata drives, you're right.

=46or consumer grade sata, they have extended auto retry logic as an
effort not to fail a read from a bad sector.  It can easily take times
like your seeing.  I think the standard drive timeout is on the order
of 30 seconds and then libata sometimes has retry logic of its own.

Especially with PATA drives a 2 minute issue is not out of the
question, since the kernel will step down the i/o speed and retry each
speed as it goes.  And PATA (IDE) has a lot of speeds to try.

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
