From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: raid 5 question
Date: Tue, 30 Apr 2002 22:19:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020430221936.E15847@unthought.net>
References: <20020429041335.A12337@unthought.net> <Pine.GSO.4.21.0204290956010.8825-100000@gecko.roadtoad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.21.0204290956010.8825-100000@gecko.roadtoad.net>; from derek@cynicism.com on Mon, Apr 29, 2002 at 10:05:12AM -0700
To: Derek Vadala <derek@cynicism.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 29, 2002 at 10:05:12AM -0700, Derek Vadala wrote:
> On Mon, 29 Apr 2002, [iso-8859-1] Jakob =D8stergaard wrote:
>=20
> > raidreconf (http://unthought.net/raidreconf) will do what you are a=
sking,
>=20
> Is that the official site and are you and/or Danny Cox still working =
on
> the code?=20

1) It is the official site
2) We're not working on the code  ;)

>I noticed that the raidreconf bundled with the raidtools-1.0 in
> skipjack is 0.1.2 and the one at unthought.net is 0.1.1-- but maybe t=
hat's
> because someone else worked on it and didn't put their name in.

That is interesting - too bad RedHat didn't care to ask me about the kn=
own
problems with the tool... Some of the known problems are easily fixable=
=2E

I guess their customers will tell them what happens when raidreconf enc=
ounters
a bad block  ;)    (trivial fix by the way)

>=20
> > In any case, I would be interested in hearing your experiences if y=
ou
> > decide to try out raidreconf.
>=20
> I've still got a bunch of comparison tests to run, but I'll post the
> results here when I' m done.

Great !  Thanks,

Oh, and just to let everyone know:  I'm hoping that someone is going to=
 take
raidreconf and integrate it into LVM or EVMS - this is clearly the way =
that
things *should* be going, and it would be needed for hot-reconfiguratio=
n
anyway.  I can't do this myself, because I simply don't have the time.

As I see it - while raidreconf might be useful as it is today (I wrote =
it
because I needed it, and it has helped me a few times), the concept of =
having
to dismount, raidstop, reconfigure (for 20+ hours!), raidstart, ext2res=
ize, and
remount, is dead.  It is simply not acceptable.  RAID reconfiguration *=
MUST* be
on-line, and it must be something that's just running in the background=
 while
the server is ticking away doing whatever it is it is doing.

Knowing that I can't integrate it in the kernel as it should be (becaus=
e of my
own time constraints), and knowing that the way the tool works today
(userspace, non on-line) is not acceptable, doesn't give me much of an
incentive to keep "working" on it.

Now I will try to push this to someone else, rather than feeling bad ab=
out not
doing anything about a potentially really useful tool myself.

Cheers,   :)

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
