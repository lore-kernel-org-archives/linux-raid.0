From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Tue, 9 Feb 2010 02:22:37 -0800 (PST)
Message-ID: <507150.35529.qm@web51303.mail.re2.yahoo.com>
References: <adf93d751002081645o2906c43fnc8468c81747fdd3c@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002081645o2906c43fnc8468c81747fdd3c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>, Dawning Sky <the.dawning.sky@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Tue, 9/2/10, Dawning Sky <the.dawning.sky@gmail.com> wrote:

> From: Dawning Sky <the.dawning.sky@gmail.com>
> Subject: Re: Disk I/O error while rebuilding an md raid-5 array
> To: "Greg Freemyer" <greg.freemyer@gmail.com>
> Cc: linux-raid@vger.kernel.org
> Date: Tuesday, 9 February, 2010, 0:45
> On Mon, Feb 8, 2010 at 4:04 PM, Greg
> Freemyer <greg.freemyer@gmail.com>
> wrote:
> >>
> >> PS, if in the end I have to build a new array,
> I'll probably go with a
> >> raid 6 instead.
> >
> > Agreed, someone recently posted that for a raid-5
> composed of 1TB
> > drives the odds of a rebuild failure are 1 in 67 even
> if the remaining
> > drives are within spec. =A0(ie. the unrecoverable bit
> error rate is
> > slowing succumbing to the ever increasing size of
> drives.)
>=20
> Has anyone done similar calculation for raid-6?
>=20
> >
> > Greg

I am not sure of the math, but i was under the impression the odds were=
 calculated PER DRIVE, not combining the array size. I HAD a 6 drive ar=
ray comprised of 4x500GB and 2x750 (with some wasted space) as I wanted=
 to push the new drives into 1~+ TB drives to make use of this lost spa=
ce I decided to go RAID6 so i now have a 7 drive array.. 4x500GB 2x750 =
1x1TB. Now i am happy it is ok (see lots of earlier posts about mismatc=
hes) I am gearing up to replace 2 of the 500GB's with 1TB drives, and i=
n 6 months I will repeat.

Bottom line, my 'gut' says if your drives are going to stray over 1TB g=
o to RAID6 also, I have staggered DAILY smart reads (i think each drive=
 gets 1 day a week 'off' and the rest are either long or short but neve=
r all doing 1 type) i also do a weekly 'scrub' of my array (this is so =
amazingly important).

My only downside is due to FSB speed issues i dont get more than 30m/s =
when accessing all 7 drives simultaneously but that is enough for RAID.


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
