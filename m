From: Dave Chinner <david@fromorbit.com>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Tue, 25 Jan 2011 19:36:43 +1100
Message-ID: <20110125083643.GE28803@dastard>
References: <20110118210112.D13A236C@gemini.denx.de>
 <4D361F26.3060507@stud.tu-ilmenau.de>
 <20110119192104.1FA92D30267@gemini.denx.de>
 <AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
 <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
 <20110124215713.82D75B187@gemini.denx.de>
 <20110124230314.GA11040@dastard>
 <20110125083900.4dd65bf2@galadriel2.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110125083900.4dd65bf2@galadriel2.home>
Sender: linux-raid-owner@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com
List-Id: linux-raid.ids

[ As a small note - if you are going to comment on the results table
from a previous message, please don't cut it from your response.
Context is important. I pasted the relevant part back in so i can
refer back to it in my response. ]

On Tue, Jan 25, 2011 at 08:39:00AM +0100, Emmanuel Florac wrote:
> Le Tue, 25 Jan 2011 10:03:14 +1100 vous =E9criviez:
> > > Version  1.96       ------Sequential Create------ --------Random =
Create--------
> > > A1                  -Create-- --Read--- -Delete-- -Create-- --Rea=
d--- -Delete--
> > >               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec=
 %CP  /sec %CP
> > >                  16   104   0 +++++ +++   115   0    89   0 +++++=
 +++   111   0
> >=20
> > Only 16 files?
>=20
> IIRC this is 16 thousands of files. Though this is not enough, I
> generally use 80 to 160 for tests.

Yes, you're right, the bonnie++ man page states that it is in units
of 1024 files. Be nice if there was a "k" to signify that so people
who aren't intimately familiar with it's output format can see
exactly what was tested....

As it is, a create rate of 104 files/s (note the consistency of
units between 2 adjacent numbers!) indicates something else is
screwed, because my local test VM on RAID0 gets numbers like this:

Version  1.96       ------Sequential Create------ --------Random Create=
--------
test-4              -Create-- --Read--- -Delete-- -Create-- --Read--- -=
Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  =
/sec %CP
                 16 25507  90 +++++ +++ 30472  97 25281  93 +++++ +++ 2=
9077  97
Latency             23864us     204us   21092us   18855us      82us    =
 121us

IOWs, create rates of 25k/s and unlink of 30k/s and it is clearly
CPU bound.

Therein lies the difference: the original numbers have 0% CPU usage,
which indicates that the test is blocking.  Something is causing the
reported test system to be blocked almost all the time.

/me looks closer.

Oh, despite $subject being "RAID0" the filesystems being tested are
on RAID5 and RAID6 with very small chunk sizes on slow SATA drives.
This is smelling like a case of barrier IOs on software raid on
cheap storage....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
