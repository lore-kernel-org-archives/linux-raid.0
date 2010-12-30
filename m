From: Doug Dumitru <doug@easyco.com>
Subject: Re: Raid/5 optimization for linear writes
Date: Thu, 30 Dec 2010 10:47:31 -0800
Message-ID: <AANLkTin=TUv0ebNLxhDtrQZbaNyCy0BdDRGxWtyPtZjS@mail.gmail.com>
References: <AANLkTinEuKzKxWTOY7Mpj207Y2t_mzjy9_8D5O5dP+Qe@mail.gmail.com>
	<AANLkTikKpFARod23akheM3-P_CUh7DtNTEtw72hVbYAZ@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikKpFARod23akheM3-P_CUh7DtNTEtw72hVbYAZ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What I have been working on does not change the raid algorithm.  The
issue is scheduling.

When raid/456 gets a write, it needs to write not only the new blocks,
but also the parity blocks that are associated.  In order to calculate
the parity blocks, it needs data from other blocks in the same stripe
set.  The issue is, a) should the raid code issue read requests for
the needed blocks, or b) should the raid code wait for more write
requests hoping that these requests will contain data for the needed
blocks.  Both of these approaches are wrong some of the time.  To make
things worse, with some drives, guessing wrong just a fraction of a
percent of the time can hurt performance dramatically.

In my case, if the raid code can get an entire stripe in a single
write request, then it can bypass most of the raid logic and just
"compute and go".  Unfortunately, such big requests break a lot of
conventions about how big requests can be, especially for large drive
count arrays.

Doug Dumitru
EasyCo LLC

On Thu, Dec 30, 2010 at 6:36 AM, Roberto Spadim <roberto@spadim.com.br>=
 wrote:
>
> could we make a
> write algorithm
> read algorithm
>
> for each raid type? we don=B4t need to change default md algorithm, j=
ust
> put a option to select algorithm, it=B4s good since new developers co=
uld
> "plugin" news read/write algorithm
> thanks
>
> 2010/12/29 Doug Dumitru <doug@easyco.com>:
> > Hello all,
> >
> > I have been using an in-house mod to the raid5.c driver to optimize
> > for linear writes.=A0 The optimization is probably too specific for
> > general kernel inclusion, but I wanted to throw out what I have bee=
n
> > doing in case anyone is interested.
> >
> > The application involves a kernel module that can produce precisely
> > aligned, long, linear writes. =A0In the case of raid-5, the obvious=
 plan
> > is to issue writes that are complete raid stripes of
> > 'optimal_io_length'.
> >
> > Unfortunately, optimal_io_length is often less than the advertised =
max
> > io_buf size value and sometime less than the system max io_buf size
> > value. =A0Thus just pumping up the max value inside of raid5 is dub=
ious.
> > =A0Even though dubious, just punching up the
> > mddev->queue->limits.max_hw_sectors does seem to work, not break
> > anything obvious, and does help performance out a little.
> >
> > In looking at long linear writes with the stock raid5 driver, I am
> > seeing a small amount of reads to individual devices. =A0The test
> > application code calling the raid layer has > 100MB of locked kerne=
l
> > buffer slamming the raid5 driver, so exactly why raid5 needs to
> > back-fill some reads is not very clear to me. =A0Looking at the rai=
d5
> > code, it does not look like there is a real "scheduler" for decidin=
g
> > when to back-fill the stripe cache, but instead it just relies on
> > thread round trips. =A0In my case, I am testing on server-class sys=
tems
> > with 8 or 16 3GHz threads, so availability of CPU cycles for the ra=
id5
> > code is very high.
> >
> > My patch ended up special casing a single inbound bio that containe=
d a
> > write for a single full raid stripe. =A0So for 8 drives raid-5, thi=
s is
> > 7 * 64K or an IO 448KB long. =A0With 4K pages this is a bi_io_vec a=
rray
> > of 112 pages. =A0Big for kernel memory generally, but easily handle=
d by
> > server systems. =A0With more drives, you can be talking well over 1=
MB in
> > a single bio call.
> >
> > The patch takes this special case write, makes sure it is raid-5 an=
d
> > layout 2, is not degraded and is not migrating. =A0If all of these =
are
> > true, the code allocates a new bi_io_vec and pages for the parity
> > stripe, new bios for each drive, computes parity "in thread", and t=
hen
> > issues simultanious IOs to all of the devices. =A0A single bio comp=
lete
> > function catches any errors and completes the IO.
> >
> > My testing is all done using SSDs. =A0I have tests for 8 drives and=
 for
> > 32 partition on the 8 drives. =A0The drives themselves do about
> > 100MB/sec per drive. =A0With the stock code I tend to get 550 MB/se=
c
> > with 8 drives and 375 MB/sec with 32 partitions on 8 drives. =A0Wit=
h the
> > patch, both 8 and 32 yield about 670 MB/sec which is within 5% of
> > theoretical bandwidth.
> >
> > My "fix" for linear writes is probably way to "miopic" for general
> > kernel use, but it does show that properly fed, really big raid/456
> > arrays should be able to crank linear bandwidth far beyond the curr=
ent
> > code base.
> >
> > What is really needed is some general technique to give the raid
> > driver a "hint" that an IO stream is linear writes so that it will =
not
> > try to back-fill too eagerly. =A0Exactly how this can make it back =
up
> > the bio stack is the real trick.
> >
> > I am happy to discuss this on-list or privately.
> >
> > --
> > Doug Dumitru
> > EasyCo LLC
> >
> > ps: =A0I am also working on patches to propagate "discard" requests
> > through the raid stack, but don't have any operational code yet.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial



--
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
