From: =?iso-8859-1?Q?Jakob_=D8stergaard?= <jakob@unthought.net>
Subject: Re: Q: Priority of md_thread()
Date: Wed, 22 May 2002 22:45:03 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020522224503.E586@unthought.net>
References: <9CFB9DA5261CD611A29B00508B789048654302@ex-deu-munich02.force.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9CFB9DA5261CD611A29B00508B789048654302@ex-deu-munich02.force.de>; from Kay.Potthoff@force.de on Wed, May 22, 2002 at 01:59:57PM +0200
To: "Potthoff, Kay" <Kay.Potthoff@force.de>
Cc: "Linux RAID Mailing List (E-mail)" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, May 22, 2002 at 01:59:57PM +0200, Potthoff, Kay wrote:
> I have a question regarding the priority of the md_thread() function
> (defined in md.c).
>=20
> I have seen that the priority of this thread is set to -20 (parameter
> current->nice), which means that this thread takes the highest priori=
ty. The
> problem I have is that this thread blocks some other task that is ans=
wering
> keep alive network pings from another (sibling) node. Because the kee=
p alive
> answers are blocked the other node decides to take-over the RAID. Thi=
s
> situation leeds to the fact that two nodes try to start the RAID. MD =
don't
> like this. The RAID is considered to be faulty and both nodes try to =
repair
> it, that is a problem.

That system cannot be stable.

Remember the -20 is only for the CPU scheduler, and the md_thread is no=
t CPU
bound (unless you have ISA controllers, or *very* special disks).  What=
 I am
trying to say is, I doubt much would change if the nice level was chang=
ed to
20 instead...

I think your problem is that something (and probably as you state, md_t=
hread)
is causing fluctuations in the ping replies, causing your other nodes t=
o take
an action which they shouldn't take based on a ping fluctuation (that c=
ould
just as easily be caused by a packet loss or some other random event in=
 the
whole computer-network-computer system).

If you want multiple nodes mounting the same array, you need some consi=
stency
protocol to be able to *guarantee* that no two nodes will try to master=
 the
same array simultaneously. Ping fluctuations do not constitute a consis=
tency
protocol.


> I figuered out that the cause of this problem is the high priority of=
 the
> md_thread() function. I feel tempted to decrease this priority, but I=
 feel
> some upcoming ache in my belly because I don't know the exact reason =
why the
> priority had been set to -20. I hope that somebody can explain me why=
! The
> comments in the sources seem to regard to RAID-5 personality. If so t=
hat
> would be no problem, I intend only to use RAID-1.

Please let me know if I completely misunderstood the situation   :)

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
