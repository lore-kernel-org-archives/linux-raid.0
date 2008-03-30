From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10 vs raid5 - strange performance
Date: Sun, 30 Mar 2008 16:21:07 +0200
Message-ID: <20080330142107.GF754@rap.rap.dk>
References: <20080325233649.GA632@rap.rap.dk> <bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com> <20080326072416.GA8674@rap.rap.dk> <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com> <20080326192935.GB18621@rap.rap.dk> <47EAACAB.7070203@tmr.com> <bb145bd20803261902g44e88f64p982607b88d864678@mail.gmail.com> <47EEA5BB.5080106@tmr.com> <20080330085528.GC17756@rap.rap.dk> <20080330093420.GB21050@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080330093420.GB21050@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Christian Pernegger <pernegger@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 30, 2008 at 11:34:20AM +0200, Keld J=F8rn Simonsen wrote:
> On Sun, Mar 30, 2008 at 10:55:28AM +0200, Keld J=F8rn Simonsen wrote:
> > On Sat, Mar 29, 2008 at 04:25:31PM -0400, Bill Davidsen wrote:
> > > Christian Pernegger wrote:
> > >=20
> > > The md raid10,f2 generally has modest write performance, if U is =
a=20
> > > single drive speed, write might range between 1.5U to (N-1)/2*U=20
> > > depending on tuning. Read speed is almost always (N-1)*U, which i=
s great=20
> > > for many applications. Playing with chunk size, chunk buffers, et=
c, can=20
> > > make a large difference in write performance.
> >=20
> > Hmm, I have other formulae for this. raid10,f2 write speed would ra=
ther
> > be U*N/2, and read speed be U*N - possibly enhanced by also having
> > bigger chunks than on a regular non-raid disk, and enhanced by lowe=
r
> > access times. The formulae are both for sequential and random reads=
=2E
>=20
> And also faster transfer rates due to using the outer tracks of the
> disk. This factor could amount to up to a factor of 2 when reading fr=
om
> the high end of the array vs reading from the high end of the bare di=
sk.

The faster transfer rates for reading would amount to an improvement,
both for sequential and random reading, in average of about 17 % for
raid10,f2 - given that it confines its reading to the outer faster trac=
ks
of the disks. For N>2 (f3, etc) this does not get much better.

The lover average seek times will also be geometrically determined (as
for the transfer rates as noted in another mail) and thus most likely
the speedup will be equal across disk sizes. The latency component woul=
d
for raid10,f2 improve slightly more than to the double (less than half =
the
average seek time). This will affect random reading.=20

I did some calculations on the geometry of a CD - Which has its inner
tracks at a radius of 15 mm, and its outer tracks at the radius of 59 m=
m
(approximately). Because there is more data in the outer tracks, you
need less tracks to make up for half the size of the disk, and the rang=
e
of the head movements are thus less than half of the original head span=
=2E
=46or a CD the head movements to cover half of the data on the outer pa=
rt
would only be 16 mm, compared to 44 mm to cover the whole CD size from
inner to outer tracks. This is a littele less than a third, which shoul=
d=20
amount to the same reduction in latency time. Given that there is less
data in the inner tracks, the improvement is somewhat offset by the
reduced probability that inner tracks will be read. I am sure that this
can be calculated on a strict geometric base, but I could not find the
formulae. Anyway something like a 2-3 times improvement in latency=20
would be expected. And then some disks do not follow the simple mapping
between logical sectors and physical layout.

Average access time will improve for N>2, eg raid10,f3 will have about
50 % improved latency compared to raid10,f2, and raid10,f4 will only
have around half the latency of raid10,f2.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
