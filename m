From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: mdadm mail option configuration
Date: Fri, 31 May 2002 16:09:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020531160937.A22230@unthought.net>
References: <15604.45423.781175.499314@notabene.cse.unsw.edu.au> <Pine.LNX.4.30.0205291602130.23219-100000@duplo.agenda.si> <15605.24561.501893.319158@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15605.24561.501893.319158@notabene.cse.unsw.edu.au>; from neilb@cse.unsw.edu.au on Thu, May 30, 2002 at 09:10:41AM +1000
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Danilo Godec <danci@agenda.si>, Jeff Hill <jhill@hronline.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 30, 2002 at 09:10:41AM +1000, Neil Brown wrote:
> On Wednesday May 29, danci@agenda.si wrote:
> > On Wed, 29 May 2002, Neil Brown wrote:
> >=20
> > > > Then, I just have an init script that runs:
> > > >
> > > > 	/sbin/mdadm -Fs --delay=3D600 &
> > >
> > > Why 600 (10 minutes)?? I would suggest 60seconds for normal opera=
tion
> > > and 1 second for testing.
> >=20
> > I've tried this and maybe I'm missing something. I've set a 5 secon=
d
> > interval for checking and I only got one mail - notifiyng me about
> > a failure.
>=20
> Yes, that's right.  One failure, one email.  I'm not in the business
> of spam.

What we do with SysOrb (blatant plug: http://sysorb.com) is to send out=
 an
e-mail immediately when the RAID degrades, and then a new mail every N =
seconds.
The RAID may be checked every 10 seconds, and the user may configure N =
to be,
say, 1800 seconds.  So the failure is detected almost immediately, whil=
e the
alert will only be sent every half hour for example.

We've found that this repetition is useful as a reminder.   It also mot=
ivates
people to either fix the problem, or schedule downtime for the check sa=
ying
that it will be down for another 24 hours for example.

Once you are administering more than a few machines, one alert can get =
lost in
the occational heap.

=2E..
> It has occurred to me that it could be useful to send mail at startup
> if there appear to be any abnormalities, but I think I would prefer
> that sort of functionality to be external.  A sysdamin might want tha=
t
> mail are reboot, or every night, or every week, or never.  A simple:
>   grep -s > /dev/nu $magic_pattern /proc/mdstat &&=20
>        mail -s "Raid problem on `hostname`" root << END
> 	    Possible RAID problem, please check.
> 	    `hostname`
> 	    `cat /proc/mdstat
> 	    END
>=20
> is all that is needed.

In general, I think that these small scripts are really nice and all, i=
f that
is "good enough" for you.   Once they are no longer good enough, start =
looking
into real monitoring systems.

NetSaint could be hacked into supporting RAID I'm sure.   And if you wa=
nt to
save the hackery and can accept a commercial solution, well, then I plu=
gged one
just above  ;)

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
