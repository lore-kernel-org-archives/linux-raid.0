From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10 vs raid5 - strange performance
Date: Sun, 30 Mar 2008 11:34:20 +0200
Message-ID: <20080330093420.GB21050@rap.rap.dk>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com> <20080325233649.GA632@rap.rap.dk> <bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com> <20080326072416.GA8674@rap.rap.dk> <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com> <20080326192935.GB18621@rap.rap.dk> <47EAACAB.7070203@tmr.com> <bb145bd20803261902g44e88f64p982607b88d864678@mail.gmail.com> <47EEA5BB.5080106@tmr.com> <20080330085528.GC17756@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080330085528.GC17756@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Christian Pernegger <pernegger@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 30, 2008 at 10:55:28AM +0200, Keld J=F8rn Simonsen wrote:
> On Sat, Mar 29, 2008 at 04:25:31PM -0400, Bill Davidsen wrote:
> > Christian Pernegger wrote:
> >=20
> > The md raid10,f2 generally has modest write performance, if U is a=20
> > single drive speed, write might range between 1.5U to (N-1)/2*U=20
> > depending on tuning. Read speed is almost always (N-1)*U, which is =
great=20
> > for many applications. Playing with chunk size, chunk buffers, etc,=
 can=20
> > make a large difference in write performance.
>=20
> Hmm, I have other formulae for this. raid10,f2 write speed would rath=
er
> be U*N/2, and read speed be U*N - possibly enhanced by also having
> bigger chunks than on a regular non-raid disk, and enhanced by lower
> access times. The formulae are both for sequential and random reads.

And also faster transfer rates due to using the outer tracks of the
disk. This factor could amount to up to a factor of 2 when reading from
the high end of the array vs reading from the high end of the bare disk=
=2E

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
