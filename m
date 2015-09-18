From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Recommendations for RAID setup needed
Date: Fri, 18 Sep 2015 14:25:37 +0300
Message-ID: <55FBF4B1.6060501@msgid.tls.msk.ru>
References: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>	<55F85E9F.1070100@youngman.org.uk>	<CAB1R3sj3fA3rJA+hQRJcTvL6HmNium+T2RRfdvF9YhpLA=q2Vg@mail.gmail.com>	<55F8D01C.5040106@websitemanagers.com.au> <CAB1R3siXjNdihbJhzSWL7bbLGuj0SD7a9iA2wKs-C2dKAO6u0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3siXjNdihbJhzSWL7bbLGuj0SD7a9iA2wKs-C2dKAO6u0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>, Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

16.09.2015 18:53, Alex wrote:
[]
>>> All four are WD30EFRX-68EUZN0. They're not the cheapest WD disks, b=
ut
>>> they're also not the ones with the 5yr warranty. The last array I
>>> built using disks with 5yr warranty exceeded their capacity before =
the
>>> warranty expired.
>>
>> Umm, 1st google result showed this:
>> http://community.wd.com/t5/Desktop-Mobile-Drives/New-WD30EFRX-Red-Dr=
ive-Idle3-Timer-Set-to-8-Seconds-High-LCC-in/td-p/648821/page/5
>=20
> I was really just looking for general input on RAID5 vs RAID6, but
> that is good information. I knew the drives weren't basic desktop
> drives and would be generally suitable for building a software RAID
> array.
>=20
> Are you familiar with the idle3 time? It appears the idle3-tools can
> be used to disable the idle3 timer entirely, which would disable
> parking the head at all, correct?

An addition.  From hdparm(8) manpage:

       -J     Get/set the Western Digital (WD) Green Drive's  "idle3"  =
timeout
              value.   This  timeout  controls  how  often the drive pa=
rks its
              heads and enters a low power  consumption  state.   The  =
factory
              default  is  eight  (8) seconds, which is a very poor cho=
ice for
              use with Linux.  Leaving it at the default will result  i=
n  hun=E2=80=90
              dreds  of  thousands  of head load/unload cycles in a ver=
y short
              period of time.  The drive mechanism is only rated  for  =
300,000
              to  1,000,000  cycles, so leaving it at the default could=
 result
              in premature failure, not to mention the performance  imp=
act  of
              the drive often having to wake-up before doing routine I/=
O.

              WD  supply  a WDIDLE3.EXE DOS utility for tweaking this s=
etting,
              and you should use that program instead of hdparm if at a=
ll pos=E2=80=90
              sible.   The  reverse-engineered implementation in hdparm=
 is not
              as complete as the original official  program,  even  tho=
ugh  it
              does  seem  to  work  on  at a least a few drives.  A ful=
l power
              cycle is required for any change  in  setting  to  take  =
effect,
              regardless of which program is used to tweak things.

              A setting of 30 seconds is recommended for Linux use.  Pe=
rmitted
              values are from 8 to 12 seconds, and from 30 to 300  seco=
nds  in
              30-second  increments.   Specify  a value of zero (0) to =
disable
              the WD idle3 timer completely (NOT RECOMMENDED!).

Thanks,

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
