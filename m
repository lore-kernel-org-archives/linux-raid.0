From: David Greaves <david@dgreaves.com>
Subject: Re: Looking for the cause of poor I/O performance
Date: Fri, 03 Dec 2004 16:32:43 +0000
Message-ID: <41B0952B.1000302@dgreaves.com>
References: <200412030630.51004.systemloc@earthlink.net> <20041203114635.GB21302@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041203114635.GB21302@harddisk-recovery.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: TJ <systemloc@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
h. The=20
>>NICs are Intel 82540EM's. I got them for around $55 per. I didn't thi=
nk that=20
>>was too bad for gigabit. Of course, these controllers may be complete=
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
