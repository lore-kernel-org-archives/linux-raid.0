From: Gavin McCullagh <gmccullagh@gmail.com>
Subject: Re: LINEAR RAID, little help
Date: Sat, 7 Apr 2007 18:33:52 +0100
Message-ID: <20070407173352.GA23645@gmail.com>
References: <46177DD8.9080707@pcfusion.co.uk>
Reply-To: Gavin McCullagh <gmccullagh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46177DD8.9080707@pcfusion.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Rich <rich@pcfusion.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

The main reason I'm posting (given others can answer these questions
better) is to ask a further question:=20

Why would anyone use RAID-linear?  If RAID-0 gives better performance f=
or
the same (reduced) reliability, what's the point of using Linear?  Do y=
ou
get slightly more space out of it?  I presume it's for stuff where you
don't place much value no your data.

On Sat, 07 Apr 2007, Rich wrote:

> I currently have a linear RAID setup via mdadm with is made up of 3=20
> drives. I just have a few questions that I can't seem to find searchi=
ng=20
> around on Google, etc.

I must admit I've never used linear raid.  May I ask what made you choo=
se
it over say raid-0?

> First question, what happens if one drive fails (I know I will loose =
the=20
> data on that drive) but how, if at all can I recover the data on the=20
> other drives can I plug them in (on their own) as though they were in=
=20
> fact an individual drives? Do I need to execute a rebuild command in=20
> mdadm at all to rebuild the array?

http://tldp.org/LDP/EVMSUG/html/characraidlvls.html

I'm sure someone else will give you a better answer but it would appear
from these docs that your situation is similar to that of a person usin=
g
RAID-0 who has a drive failure.  Basically, you end up with a big porti=
on
of your filesystem data missing so you may lose everything.  I guess yo=
u
might be able to recover some data using some filesystem recovery tools=
 but
it's likely to be a pretty unreliable process and likely to vary from o=
ne
filesystem to the next.  It's probably a little more reliable than RAID=
-0
in that what's left is probably contiguous but I would certainly not wa=
nt
to rely on such a process for my data.

The faq says similar "RAID-linear is a simple concatenation of partitio=
ns
to create a larger virtual partition. It is handy if you have a number
small drives, and wish to create a single, large partition. This
concatenation offers no redundancy, and in fact decreases the overall
reliability: if any one disk fails, the combined partition will fail."

http://tldp.org/HOWTO/Software-RAID-0.4x-HOWTO-2.html

> Second question, how can I go about adding a drive to my linear RAID,=
 I
> wish to add two new 500GB drives but I'm unsure how. I have found how=
to's
> for RAID 5 but I just wanted to check it was a similar process for
> Linear? Also this won't effect any data currently on the drive will i=
t?

You don't say what you're doing on this array, but before modifying it,=
 I'd
be seriously inclined to question whether RAID-linear is really the rig=
ht
thing to be using at all.  Anyway, the mdadm manpage says=20

"Currently the only support available is to
 =B7 change the "size" attribute for RAID1, RAID5 and RAID6.
 =B7 increase the "raid-disks" attribute of RAID1 and RAID5.
 =B7 add a write-intent bitmap to any array which support these bitmaps=
, or
   remove  a  write-intent bitmap from such an array."

which suggests you can't.  That might be wrong though as it sounds (to =
me
anyway) like linear would be one of the easier ones to implement grow f=
or.
I'm not sure.

Gavin

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
