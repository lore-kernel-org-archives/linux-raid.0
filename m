From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Sat, 26 Nov 2005 18:34:20 +0100
Message-ID: <01f901c5f2af$a4312550$0400a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at> <17282.22120.327672.720044@cse.unsw.edu.au> <20051122220531.GU26862@skl-net.de> <015c01c5f292$57e0e270$0400a8c0@dcccs> <5d96567b0511260756t3989df8ep8c98326fc394ca18@mail.gmail.com> <01ca01c5f2a3$ab6ebf00$0400a8c0@dcccs> <Pine.LNX.4.58.0511261810350.1482@lajli.gau.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lajber Zoltan <lajbi@lajli.gau.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, Zolt=E1n!

----- Original Message -----=20
=46rom: "Lajber Zoltan" <lajbi@lajli.gau.hu>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Saturday, November 26, 2005 6:11 PM
Subject: Re: RAID0 performance question


> On Sat, 26 Nov 2005, JaniD++ wrote:
>
> > Hello, Raz,
> >
> > Think this is not cpu usage problem. :-)
> > The system is divided to 4 cpuset, and each cpuset uses only one
disknode.
> > (CPU0->nb0, CPU1->nb1, ...)
>
> Seams to be CPU problem. Which kind of NIC do you have?

Intel xeon motherboard, intel e1000 x2. (64bit)
But i already write that, if i cut out the raid, and starts the 4 cat a=
t one
time the traffic is rise to 780-800 Mbit! :-)

This is not hardware related problem.
Only tune, or missconfiguration problem.  - I think...

>
> > CPU2 states:   2.0% user  74.0% system    0.0% nice   3.0% iowait  =
18.0%
> > idle
> > CPU3 states:  10.0% user  57.0% system    0.0% nice   5.0% iowait  =
26.0%
>
> Do you have 4 cpu, or 2 HT cpu?

2x HT :-)

But in the previous top, it was an used system!

Thanks,

Janos

>
> Bye,
> -=3DLajbi=3D---------------------------------------------------------=
-------
>  LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivat=
al
>  Most of the time, if you think you are in trouble, crank that thrott=
le!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
