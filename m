From: Neil Brown <neilb@suse.de>
Subject: Re: LINEAR RAID, little help
Date: Wed, 11 Apr 2007 09:12:12 +1000
Message-ID: <17948.6604.619118.556382@notabene.brown>
References: <46177DD8.9080707@pcfusion.co.uk>
	<20070407173352.GA23645@gmail.com>
	<4617E5E2.2090609@pcfusion.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rich on Saturday April 7
Sender: linux-raid-owner@vger.kernel.org
To: Rich <rich@pcfusion.co.uk>
Cc: Gavin McCullagh <gmccullagh@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 7, rich@pcfusion.co.uk wrote:
> Gavin McCullagh wrote:
> >
> > I must admit I've never used linear raid.  May I ask what made you =
choose
> > it over say raid-0?
> >  =20
> Er, I went with Linear as reading around people seemed to recommend t=
his=20
> for odd sized drives (my old drives are 80's, 120 and 320's) also a r=
ead=20
> somewhere that data on the other drives is more recoverable that most=
 of=20
> the other RAID's.

Linux raid0 works with varying sized drives without problem.

> >  =20
> >> First question, what happens if one drive fails (I know I will loo=
se the=20
> >> data on that drive) but how, if at all can I recover the data on t=
he=20
> >> other drives can I plug them in (on their own) as though they were=
 in=20
> >> fact an individual drives? Do I need to execute a rebuild command =
in=20
> >> mdadm at all to rebuild the array?

If you lose one drive, you should consider that you have lost the
whole array.  You might be able to recover some data, if you are lucky
and spend a lot of time hunting for it.  But it is quite unlikely that
you will get much that is useful.

> >  =20
> >> Second question, how can I go about adding a drive to my linear RA=
ID, I
> >> wish to add two new 500GB drives but I'm unsure how. I have found =
howto's
> >> for RAID 5 but I just wanted to check it was a similar process for
> >> Linear? Also this won't effect any data currently on the drive wil=
l it?
> >>    =20
> >
> > You don't say what you're doing on this array, but before modifying=
 it, I'd
> > be seriously inclined to question whether RAID-linear is really the=
 right
> > thing to be using at all.  Anyway, the mdadm manpage says=20
> >  =20
> > "Currently the only support available is to
> >  =B7 change the "size" attribute for RAID1, RAID5 and RAID6.
> >  =B7 increase the "raid-disks" attribute of RAID1 and RAID5.
> >  =B7 add a write-intent bitmap to any array which support these bit=
maps, or
> >    remove  a  write-intent bitmap from such an array."
> >
> > which suggests you can't.  That might be wrong though as it sounds =
(to me
> > anyway) like linear would be one of the easier ones to implement gr=
ow for.
> > I'm not sure.

The man page is out of date.  With reasonably recent kernel/mdadm you
can
  mdadm --grow /dev/mdX --add /dev/sdY

To add a drive to a linear array.  You then need to grow the
filesystem of course.

But yes:  A big linear array is good for scratch space, but I wouldn't
want to store data that I couldn't afford to lose.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
