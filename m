From: Tobias McNulty <tobias@caktusgroup.com>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 23:39:50 -0400
Message-ID: <BANLkTindNRCxRUpfpONnKPwoE8fg7SbgZw@mail.gmail.com>
References: <20110523021234.1BAEAF9C03C@mail.fulab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110523021234.1BAEAF9C03C@mail.fulab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <James.Schatzman@fulab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 22, 2011 at 10:11 PM, Jim Schatzman
<James.Schatzman@fulab.com> wrote:
> One more input re. using cheap drives.
>
> I have been running about 20 Western Digital "Green" and "Enterprise"=
 drives (half are 1.5 TB and half are 2 TB) for several years in Raid-5=
 and Raid-6 configurations (all linux md). They are up 24x7. When they =
first came on the market, about 30% of my new drives failed within 3 mo=
nths of operation (about equal fractions of Green and Enterprise). Over=
all, 50% of the drives eventually failed - 35% of the Green drives and =
100% of the Enterprise drives. In the past 18 months, one has failed (a=
n Enterprise drive). That drive was a warranty replacement for an earli=
er Enterprise drive failure.
>
> My impression is that Western was having some quality control issues =
with the 2GB drives - both Green and Enterprise. This was very annoying=
=2E It appears that quality has improved. I never lost any data nor eve=
r had to restore from backup because I was always able to replace the b=
ad drive and rebuild the raid without difficulty that I could not get s=
olved through this forum.
>
> My experience suggests that the WD Enterprise class drives were an un=
necessary expense, at least as far as reliability is concerned.
>
> Would I recommend cheap SATA drives for mission critical data? =A0Abs=
olutely not. I wouldn't recommend =A0any =A0SATA drives. Go with the mo=
st =A0expensive SAS drives available. For that matter, I have loads of =
SCSI drives that are still going fine after 5 to 10 years of 365x24x7 o=
peration.
>
> If you are going to build a RAID from cheap drives, expect that part =
of your hardware savings will be compensated for by labor costs. Run sm=
art checks often. Also, and I cannot emphasize this enough, make certai=
n that everything attached to the RAID is plugged into a high quality U=
PS. Otherwise, you are just asking for a power spike to take out multip=
le drives and/or the controller and to lose data.

One odd statistical fluke regarding quality control on the large Green
drives:  I ordered 3 of the drives on Amazon and 3 on Newegg, and all
3 of the Newegg drives failed very quickly (within a couple weeks),
while all 3 of the Amazon drives are still going strong (5 months old
and on 24/7).  I'm not sure if it was a packaging issue or an issue
with that particular set of drives that Newegg had in stock, but it
left me wondering.

Tobias
--=20
Tobias McNulty, Managing Member
Caktus Consulting Group, LLC
http://www.caktusgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
