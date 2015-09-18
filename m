From: Alex <mysqlstudent@gmail.com>
Subject: Re: Recommendations for RAID setup needed
Date: Fri, 18 Sep 2015 08:55:59 -0400
Message-ID: <CAB1R3sjFN4KgA=NK2dE3apzN9j5-PdQSpnk8drmMML=UR5PFQw@mail.gmail.com>
References: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>
	<55F85E9F.1070100@youngman.org.uk>
	<CAB1R3sj3fA3rJA+hQRJcTvL6HmNium+T2RRfdvF9YhpLA=q2Vg@mail.gmail.com>
	<55F8D01C.5040106@websitemanagers.com.au>
	<CAB1R3siXjNdihbJhzSWL7bbLGuj0SD7a9iA2wKs-C2dKAO6u0Q@mail.gmail.com>
	<55FBF4B1.6060501@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55FBF4B1.6060501@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Wols Lists <antlists@youngman.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

> An addition.  From hdparm(8) manpage:
>
>        -J     Get/set the Western Digital (WD) Green Drive's  "idle3"=
  timeout
>               value.   This  timeout  controls  how  often the drive =
parks its
>               heads and enters a low power  consumption  state.   The=
  factory
>               default  is  eight  (8) seconds, which is a very poor c=
hoice for
>               use with Linux.  Leaving it at the default will result =
 in  hun=E2=80=90
>               dreds  of  thousands  of head load/unload cycles in a v=
ery short
>               period of time.  The drive mechanism is only rated  for=
  300,000
>               to  1,000,000  cycles, so leaving it at the default cou=
ld result
>               in premature failure, not to mention the performance  i=
mpact  of
>               the drive often having to wake-up before doing routine =
I/O.
>
>               WD  supply  a WDIDLE3.EXE DOS utility for tweaking this=
 setting,
>               and you should use that program instead of hdparm if at=
 all pos=E2=80=90
>               sible.   The  reverse-engineered implementation in hdpa=
rm is not
>               as complete as the original official  program,  even  t=
hough  it
>               does  seem  to  work  on  at a least a few drives.  A f=
ull power
>               cycle is required for any change  in  setting  to  take=
  effect,
>               regardless of which program is used to tweak things.
>
>               A setting of 30 seconds is recommended for Linux use.  =
Permitted
>               values are from 8 to 12 seconds, and from 30 to 300  se=
conds  in
>               30-second  increments.   Specify  a value of zero (0) t=
o disable
>               the WD idle3 timer completely (NOT RECOMMENDED!).

Thanks very much for the info. I posted to the WD community forum and
didn't receive any responses, so this is much appreciated. I'd like to
understand why disabling it isn't recommended (that's what I was going
to do), but I'll have to just accept this for now and move on.

In addition to hdparm, there's also the idle3-tools package and the
idle3ctl binary.

Thanks,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
