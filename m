From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: parity check for read?
Date: Wed, 4 Apr 2007 08:57:39 -0700
Message-ID: <e9c3a7c20704040857p70a4c2ceh976768610f16dfcc@mail.gmail.com>
References: <461254DF.3050503@web.de> <17938.49705.840745.66635@notabene.brown>
	 <46138C06.5020903@web.de> <4613A9A4.1060800@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4613A9A4.1060800@emc.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: ric@emc.com
Cc: Mirko Benz <mirko.benz@web.de>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/4/07, Ric Wheeler <ric@emc.com> wrote:
>
>
> Mirko Benz wrote:
> > Neil,
> >
> > Exactly what I had in mind.
> >
> > Some vendors claim they do parity checking for reads. Technically i=
t
> > should be possible for Linux RAID as well but is not implemented =96=
 correct?
> >
> > Reliability data for unrecoverable read errors:
> > - enterprise SAS drive (ST3300655SS): 1 in 10^16 bits transfered, ~=
 1
> > error in 1,1 PB
> > - enterprise SATA drive (ST3500630NS): 1 in 10^14 bits transfered, =
~ 1
> > error in 11 TB
> >
> > For a single SATA drive @ 50 MB/s it take on average 2,7 days to
> > encounter an error.
> > For a large RAID with several drives this becomes much lower or am =
I
> > viewing this wrong?
> >
> > Regards,
> > Mirko
>
> One note is that if the drive itself notices the unrecoverable read e=
rror, MD
> will see this as an IO error and rebuild the stripe.
>
> What you need the parity check on read for is to validate errors not =
at the disk
> sector level, but rather ones that sneak in from DRAM, HBA errors or =
wire level
> uncorrected errors.
>
=46or the raid5 case the corruption can be detected, but not corrected.
Is the expectation that the administrator will be notified to restore
from backup?

Are there any raid6 solutions that take advantage of what hpa has prove=
d?
http://marc.info/?l=3Dlinux-raid&m=3D117333726129771&w=3D2

I am prototyping a writeback caching policy for MD, it seems plugging
in different read policies would be a straightforward extension.

> ric

Dan
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
