From: Eric BENARD / Free <ebenard@free.fr>
Subject: Re: MD drivers problems on 2.4.x
Date: Mon, 26 May 2003 08:17:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305260817.20409.ebenard@free.fr>
References: <200305231535.17808.ebenard@free.fr> <news2mail-barmsb$tl4$1@cartman.spoiled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <news2mail-barmsb$tl4$1@cartman.spoiled.org>
Content-Disposition: inline
To: Juri Haberland <juri@koschikode.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le Lundi 26 Mai 2003 02:24, Juri Haberland a =E9crit :
> Eric BENARD / Free <ebenard@free.fr> wrote:
> > Hi,
> >
> > I would like to know what is the md driver status on 2.4.19 and 2.4=
=2E20
> > kernels ?
> > I ve got many problems with RAID 0 (/tmp), 1 (/, /usr/var) and 5 (/=
home)
> > using these kernels and 4 IDE drives with ext3 partitions. In the e=
nd
> > each time I lose all the data :-(
> > After many tests (RAM is OK, HD don't have badblocks), I think the
> > problems comes from the md layer.
> >
> > May a switch to 2.4.21-rc3 solve my problems ?
> >
> > Did anyone here already meet this problem ?
> >
> > Many thanks and best regards
>
> Sorry, no problems here. /, /home, swap and the other stuff all on RA=
ID1
> and humming along.
> We need more data from you. What is failing in which way? Any error
> messages, kernel oopses?
>
in fact, I don't get to much error messages (or they were not reported =
to me=20
by the user of this PC).=20
I'm using a Promise PDC20277 IDE controler (with pseudo RAID functions =
but I'm=20
not using them).
4 Western Digital 120 GB with 8MB of cache are connected (Master/slave =
with=20
good cables) to it.
Power supply is sized large enough to support all the power consumption=
 of the=20
system.

I was using 2.4.20 with Alan Cox's patches in order to add new IDE laye=
r for=20
supporting this IDE controler.
Maybe the problem comes from IDE layer in these kernels with -ac patche=
s ?

After high data trasnfers on the disks, file system corruption occurs.
Last time, a php script reported this error : failed: Input/output erro=
r (5).
The server was rebooted and never started again as filesystems were too=
 much=20
corrupted.

Today, I'm going to setup it again with 2.4.21-rc3 and I'm going to do =
several=20
tests using Linux Test Project ( http://ltp.sourceforge.net/ ).
What are the tests you would advise me in order to stress as much as po=
ssible=20
the filesystems ?=20
I've noticed Cerberus could be a good test.

But if anyone already met this problem, I would be happy to hear any ad=
vice=20
;-)

Many thanks and best regards
Eric
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
