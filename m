From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: RAID-6 support in kernel?
Date: Wed, 5 Jun 2002 12:53:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020605125341.E31741@unthought.net>
References: <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <1023125615.1051.1283.camel@peecee> <20020604222053.C31741@unthought.net> <20020605075701.GD2541@colombina.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020605075701.GD2541@colombina.comedia.it>; from bluca@comedia.it on Wed, Jun 05, 2002 at 09:57:01AM +0200
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 05, 2002 at 09:57:01AM +0200, Luca Berra wrote:
> On Tue, Jun 04, 2002 at 10:20:53PM +0200, Jakob =D8stergaard wrote:
> > What often happens (in my experience) is, that a number of disks bu=
ild up bad
> > blocks.  One day, you hit one of those bad blocks, and that one dis=
k is kicked
> > from the array.
> >=20
> > When you re-sync, you *will* hit the remaining bad blocks on the ot=
her disks,
> > causing the array to fail completely.
> >=20
> > Using hot-spares will "automate" this failure - meaning that an adm=
inistrator
> > may not be anywhere near the system when this total failure happens=
=2E
> >=20
> > Not using hot-spares is less "automatic" in the lucky case where ev=
erything
> > works, but it also assures that an administrator actually is near t=
he system
> > when the total failure is likely to occur.
> well, what we could do to prevent this. if you don't have or trust S.=
M.A.R.T.

I have and use SMART, and because of my experiences with it I do not tr=
ust it  :)

> is having a 'consistency check' function in md, that would read from =
all disks
> and even compare data or calculate parity for raid5, it could be sche=
duled
> to run periodically with a very very low priority.

This definitely belongs in user-space.  But you are right, and I've dis=
cussed
it with colleagues before as well - it would be a good thing to have su=
ch a
tool.

In root's crontab you could easily just put a 'dd if=3D/dev/hda of=3D/d=
ev/null' and
so on for all your drives.   No need for kernel extensions here...

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
