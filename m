From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: performance problems with raid10,f2
Date: Sat, 5 Apr 2008 20:46:16 +0200
Message-ID: <20080405184616.GA25112@rap.rap.dk>
References: <20080314231151.GA14568@rap.rap.dk> <20080320172817.GA27070@rap.rap.dk> <18408.35320.92714.891870@notabene.brown> <20080325103656.GA4911@rap.rap.dk> <18408.64635.201923.65782@tree.ty.sabi.co.uk> <20080402211315.GA7899@rap.rap.dk> <18421.15381.649822.295786@tree.ty.sabi.co.uk> <20080404080359.GA5264@rap.rap.dk> <18423.46932.567093.734946@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18423.46932.567093.734946@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Apr 05, 2008 at 06:31:00PM +0100, Peter Grandi wrote:
> >>> On Fri, 4 Apr 2008 10:03:59 +0200, Keld J=F8rn Simonsen
> >>> <keld@dkuug.dk> said:
>=20
> [ ...  slow software RAID in sequential access ... ]
>=20
> > I did experiment and I noted that a 16 MiB readahead was
> > sufficient.
>=20
> That still sounds a bit high.

Well.. it was ony 8 Mib...

> > And then I was wondering if this had negative consequences, eg
> > on random reads.
>=20
> It surely has large negative consequences, but not necessarily on
> random reads. After all that depends when an operations completes,
> and I suspect that read-ahead is at least partially asynchronous,
> that is the read of a block completes when it gets to memory, not
> when the whole read-ahead is done. The problem is more likely to be
> increased memory contention when the system is busy, and even
> worse, increased disks arm contention.

Well, it looks like the bigger the chunk size, the better for random
reading.. 1000 processes. I need to do some more tests.

> Read ahead not only loads memory with not-yet-needed blocks, it
> keeps the disk busier reading those not-yet-needed blocks.

But they will be needed, given that most processes read files
sequentially, which is my scenario.

The trick is to keep the data in memory till they are needed.


> > I then had a test with reading 1000 files concurrently, and
> > Some strange things happened. Each drive was doing about 2000
> > transactions per second (tps). Why? I thought a drive could
> > only do about 150 tps, given t5hat it is a 7200 rpm drive.

> RPM is not that related to transactions/s, however defined, perhaps
> arm movement time and locality of access are.

RPM is also related. Actually quite related.

> > What is tps measuring?
>=20
> That's pretty mysterious to me. It could mean anything, and anyhow
> I I have become even more disillusioned about the whole Liux IO
> subsystem, which I now think to be as poorly misdesigned as the
> Linux VM subsystem.

iostat -x actually gave a more plausible measurement.
It has two measures, actually aggregated IO requests to disk, and IO
requests made by programs.

> > Why is the fs not reading the chunk size for every IO operation?
>=20
> Why should it? The goal is to keep the disk busy in the cheapest
> way. Keep the queue as long as you need to keep the disk busy
> (back-to-back operations) and no more.

I would like the disk to produce as muce real data for processes as
possible. With about 150 requests per second that would for 256 kiB
chunks produce about 37 MB/s - but my system only gives me around 15
MB/s per disk. Some room for improvement.

> However if you are really asking why the MD subsystem needs
> read-ahead values hundreds or thousands of times larger than the
> underlying devices, counterproductively, that's something that I am
> trying to figure out in my not so abundant spare time. If anybody
> knows please let the rest of us know.

Yes, quite strange.

Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
