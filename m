From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: raid 5 question
Date: Mon, 29 Apr 2002 04:13:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020429041335.A12337@unthought.net>
References: <20020426084705.GA22119@comet.tr.rdts.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020426084705.GA22119@comet.tr.rdts.de>; from schommer@rdts.de on Fri, Apr 26, 2002 at 10:47:05AM +0200
To: Marcus Schommer <schommer@rdts.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 26, 2002 at 10:47:05AM +0200, Marcus Schommer wrote:
> hello,
> is an existing raid5 array expandable in the way lvm is,
> so that i can add a disk, repartition and expand the file system on i=
t?

Well, yes and no.

raidreconf (http://unthought.net/raidreconf) will do what you are askin=
g,
so that makes it a "yes".  But the conversion can take considerable tim=
e
(a full day or more is not unheard of) - since you should take a full
backup of your system anyway, maybe the fastest solution would be to
simply get the backup done, re-create the array, and restore.

If your system has a lot of memory, it is possible that raidreconf is
faster.

In any case, I would be interested in hearing your experiences if you
decide to try out raidreconf.


--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
