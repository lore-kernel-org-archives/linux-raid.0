From: "bo" <bo@sosnetwork.net>
Subject: Re: raid 5 question
Date: Mon, 29 Apr 2002 08:43:34 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <072d01c1ef94$9f31bdc0$6501a8c0@bomoon>
References: <20020426084705.GA22119@comet.tr.rdts.de> <20020429041335.A12337@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>, Marcus Schommer <schommer@rdts.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is this URL right?

 " http://unthought.net/raidreconf)"

I could nto access it???

Bo

----- Original Message -----
=46rom: "Jakob =D8stergaard" <jakob@unthought.net>
To: "Marcus Schommer" <schommer@rdts.de>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, April 28, 2002 7:13 PM
Subject: Re: raid 5 question


> On Fri, Apr 26, 2002 at 10:47:05AM +0200, Marcus Schommer wrote:
> > hello,
> > is an existing raid5 array expandable in the way lvm is,
> > so that i can add a disk, repartition and expand the file system on=
 it?
>
> Well, yes and no.
>
> raidreconf (http://unthought.net/raidreconf) will do what you are ask=
ing,
> so that makes it a "yes".  But the conversion can take considerable t=
ime
> (a full day or more is not unheard of) - since you should take a full
> backup of your system anyway, maybe the fastest solution would be to
> simply get the backup done, re-create the array, and restore.
>
> If your system has a lot of memory, it is possible that raidreconf is
> faster.
>
> In any case, I would be interested in hearing your experiences if you
> decide to try out raidreconf.
>
>
> --
> ................................................................
> :   jakob@unthought.net   : And I see the elder races,         :
> :.........................: putrid forms of man                :
> :   Jakob =D8stergaard      : See him rise and claim the earth,  :
> :        OZ9ABN           : his downfall is at hand.           :
> :.........................:............{Konkhra}...............:
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
