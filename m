From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Looking for the cause of poor I/O performance
Date: Fri, 3 Dec 2004 11:50:16 -0500
Message-ID: <200412031650.iB3GoL916280@www.watkins-home.com>
References: <41B0952B.1000302@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41B0952B.1000302@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Greaves' <david@dgreaves.com>, 'Erik Mouw' <erik@harddisk-recovery.com>
Cc: 'TJ' <systemloc@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now I have network envy!  I am feeling inadequate.  :)

I guess I have some more XMAS ideas!  :)

I have about 7+ computers in my house and 2 network printers.
I currently have a 24 port 10/100BaseT switch.  A 5 port 100/1000BaseT
switch would be enough to make me happy.  I would connect up to 4 compu=
ters
to Gigabit, and connect the Gigabit switch to the 100BaseT switch.  Swe=
et!
I guess I better get a full time job!

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Greaves
Sent: Friday, December 03, 2004 11:33 AM
To: Erik Mouw
Cc: TJ; linux-raid@vger.kernel.org
Subject: Re: Looking for the cause of poor I/O performance

I paid about =A350 for a 5port gig switch
I have 3 e1000 cards (about =A330 each) - they're relegated to doorstop=
s=20
I'm afraid :(
Despite months of trying they just won't work with my consumer VIA/AMD=20
systems (and Ganesh and gang have tried)
I'm now using even cheaper Marvell based SMC EZ1000s (=A320ish) - I dou=
bt=20
I'll get close to the throughput the e1000s could achieve - but I get 3=
=20
times more then fast ethernet (and about 10 times more than e1000s)=20
which is worthwhile.

David

Erik Mouw wrote:

>On Fri, Dec 03, 2004 at 06:30:51AM -0500, TJ wrote:
> =20
>
>>I'm cheap. I use a crossover so I didn't have to spring for the switc=
h.
The=20
>>NICs are Intel 82540EM's. I got them for around $55 per. I didn't thi=
nk
that=20
>>was too bad for gigabit. Of course, these controllers may be complete
trash,=20
>>I dunno.=20
>>   =20
>>
>
>You won't do any better than fast ethernet when you're using a
>crossover cable. Gigabit ethernet doesn't need crossover cables for
>direct connections, it uses all four wire pairs in cat5 cable and will
>automatically figure out if there's a direct connection and do the
>right thing (all mandatory by the gigE standard, so every NIC will
>support it). If you use a fast ethernet cross cable, the NICs will
>autonegotiate to 100 MB/s full-duplex.
>
>The Intel gigE NICs are very good: good hardware, good driver, good
>support. Gigabit ethernet switches are becoming rather cheap: 200 EUR
>buys you an 8 port switch.
>
>
>Erik
>
> =20
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
