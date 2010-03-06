From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: What RAID type and why?
Date: Sat, 6 Mar 2010 15:56:15 -0800
Message-ID: <4877c76c1003061556s60de651bqd5217ed06be42d51@mail.gmail.com>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
	 <87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com>
	 <9089562724D84B3C858E337F202FF550@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9089562724D84B3C858E337F202FF550@m5>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 6, 2010 at 3:17 PM, Guy Watkins <linux-raid@watkins-home.co=
m> wrote:
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Greg Freemyer
> } Sent: Saturday, March 06, 2010 5:33 PM
> } To: Mark Knecht
> } Cc: Linux-RAID
> } Subject: Re: What RAID type and why?
> }
> } On Sat, Mar 6, 2010 at 5:02 PM, Mark Knecht <markknecht@gmail.com> =
wrote:
> } > First post. I've never used RAID but am thinking about it and loo=
king
> } > for newbie-level info. Thanks in advance.
> } >
> } > I'm thinking about building a machine for long term number crunch=
ing
> } > of stock market data. Highest end processor I can get, 16GB and a=
t
> } > least reasonably fast drives. I've not done RAID before and don't=
 know
> } > how to choose one RAID type over another for this sort of workloa=
d.
> } > All I know is I want the machine to run 24/7 computing 100% of th=
e
> } > time and be reliable at least in the sense of not losing data if =
1
> } > drive or possibly 2 go down.
> } >
> } > If a drive does go down I'm not overly worried about down time. I=
'll
> } > stock a couple of spares when I build the machine and power the b=
ox
> } > back up within an hour or two.
> } >
> } > What RAID type do I choose and why?
> } >
> } > Do I need a 5 physical drive RAID array to meet these requirement=
s?
> } > Assume 1TB+ drives all around.
> } >
> } > How critical is it going forward with Linux RAID solutions to be =
able
> } > to get exactly the same drives in the future? 1TB today is 4TB a =
year
> } > from now, etc.
> } >
> } > With an 8 core processor (high-end Intel Core i7 probably) do I n=
eed
> } > to worry much about CPU usage doing RAID? I suspect not and I don=
't
> } > really want to get into hardware RAID controllers unless critical=
ly
> } > necessary which I suspect it isn't.
> } >
> } > Anyway, if there's a document around somewhere that helps a newbi=
e
> } > like me I'd sure appreciate finding out about it.
> } >
> } > Thanks,
> } > Mark
> }
> } I'm not sure about a newbie doc, but here's some basics:
> }
> } You haven't said what kind of i/o rates you expect, nor how much
> } storage you need.
> }
> } At a minimum I would build a 3-disk raid 6. =A0raid 6 does a lot of=
 i/o
> } which may be a problem.
>
> If he only needs 3 drives I would recommend RAID1. =A0Can still loose=
 2 drives
> and you don't have the RAID6 I/O overhead.
>
> Also, you said your data is important. =A0If so, you need a backup so=
lution!
> 2 copies with 1 off-site. =A0Maybe alternate between the 2 each day o=
r week.
>
> How much data per day? =A0How much data during the next 3 years?
>
> Guy
>
> }
> } Raid-5 is out of favor for me due to issues people are seeing with
> } discrete bad sectors with the remaining drives after you have a dri=
ve
> } failure. =A0raid-6 tolerates those much better. =A0Even raid 10 is =
not as
> } robust as raid 6 and with the current generation drives robustness =
in
> } the raid solution is more important than ever.
> }
> } But raid 6 uses 2 parity drives, so you'll only get 1TB of useable
> } space from a 3-disk raid 6 made from 1TB drives.
> }
> } mdraid just requires replacement disks be bigger than the old disk
> } you're replacing.
> }
> } You might consider layering LVM on top of mdraid to help you manage
> } the array as it grows.
> }
> } Greg
> } --
> } Greg Freemyer
> } Head of EDD Tape Extraction and Processing team
> } Litigation Triage Solutions Specialist
> } http://www.linkedin.com/in/gregfreemyer
> } Preservation and Forensic processing of Exchange Repositories White=
 Paper
> } -
> } <http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.=
html>
> }
> } The Norcross Group
> } The Intersection of Evidence & Technology
> } http://www.norcrossgroup.com
> } --
> } To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> } the body of a message to majordomo@vger.kernel.org
> } More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

More importantly, it sounds like his workload will be mostly /database/=
 driven.

As far as I'm aware, databases tend to produce many small operations;
which unfortunately pushes favor to the simple mirroring operations.
If two drives going bad is a concern then using 2 backup copies per
raid 1 mirror set would work.  Most modern consumer systems come with
6 SATA ports or more, so it should be possible to get 6 hard drives
installed and shared among two raid 1 sets of 3 drives each.  LVM with
striping could be used over the raid 1 sets.

On the other hand, he says that the system will have 16 GB of memory;
I'm not sure what size his working set is, but it sounds entirely
plausible that a well constructed database could live entirely within
the ram.  If that's the case it doesn't really matter what the precise
performance of the storage solution is.  Raid 6 would offer more
efficient drive use at similar rates of error tolerance at a cost
savings of 2 drives in the six drive case.

Update for new email: Just go with the raid 1 version; it sounds like
you aren't trying to store terabytes of data so the raid 1 solution
with even just 3 drives should be sufficient.  Put the saved resources
in to more, faster, or better memory.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
