From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: performance problems with raid10,f2
Date: Sat, 5 Apr 2008 18:31:00 +0100
Message-ID: <18423.46932.567093.734946@tree.ty.sabi.co.uk>
References: <20080314231151.GA14568@rap.rap.dk>
	<20080320172817.GA27070@rap.rap.dk>
	<18408.35320.92714.891870@notabene.brown>
	<20080325103656.GA4911@rap.rap.dk>
	<18408.64635.201923.65782@tree.ty.sabi.co.uk>
	<20080402211315.GA7899@rap.rap.dk>
	<18421.15381.649822.295786@tree.ty.sabi.co.uk>
	<20080404080359.GA5264@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080404080359.GA5264@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Fri, 4 Apr 2008 10:03:59 +0200, Keld J=F8rn Simonsen
>>> <keld@dkuug.dk> said:

[ ...  slow software RAID in sequential access ... ]

> I did experiment and I noted that a 16 MiB readahead was
> sufficient.

That still sounds a bit high.

> And then I was wondering if this had negative consequences, eg
> on random reads.

It surely has large negative consequences, but not necessarily on
random reads. After all that depends when an operations completes,
and I suspect that read-ahead is at least partially asynchronous,
that is the read of a block completes when it gets to memory, not
when the whole read-ahead is done. The problem is more likely to be
increased memory contention when the system is busy, and even
worse, increased disks arm contention.

Read ahead not only loads memory with not-yet-needed blocks, it
keeps the disk busier reading those not-yet-needed blocks.

> I then had a test with reading 1000 files concurrently, and
> Some strange things happened. Each drive was doing about 2000
> transactions per second (tps). Why? I thought a drive could
> only do about 150 tps, given t5hat it is a 7200 rpm drive.

RPM is not that related to transactions/s, however defined, perhaps
arm movement time and locality of access are.

> What is tps measuring?

That's pretty mysterious to me. It could mean anything, and anyhow
I I have become even more disillusioned about the whole Liux IO
subsystem, which I now think to be as poorly misdesigned as the
Linux VM subsystem.

Just the idea of putting "plugging" at the block device level
demonstrates the level of its developers (amazingly some recent
tests I have done seem to show that at least in some cases it has
no influence on performance either way).

But then I was recently reading these wise words from a great
old man of OS design:

  http://CSG.CSAIL.MIT.edu/Users/dennis/essay.htm

   "During the 1980s things changed. Computer Science Departments
    had proliferated throughout the universities to meet the
    demand, primarily for programmers and software engineers, and
    the faculty assembled to teach the subjects was expected to do
    meaningful research.

    To manage the burgeoning flood of conference papers, program
    committees adopted a new strategy for papers in computer
    architecture: No more wild ideas; papers had to present
    quantitative results. The effect was to create a style of
    graduate research in computer architecture that remains the
    "conventional wisdom" of the community to the present day: Make
    a small, innovative, change to a commercially accepted design
    and evaluate it using standard benchmark programs.

    This style has stifled the exploration and publication of
    interesting architectural ideas that require more than a
    modicum of change from current practice.

    The practice of basing evaluations on standard benchmark codes
    neglects the potential benefits of architectural concepts that
    need a change in programming methodology to demonstrate their
    full benefit."

and around the same time I had a very depressing IRC conversation
with a well known kernel developer about what I think to be some
rather stupid aspects of the Linux VM susbsystem and he was quite
unrepentant, saying that in some tests they were of benefit...

> Why is the fs not reading the chunk size for every IO operation?

Why should it? The goal is to keep the disk busy in the cheapest
way. Keep the queue as long as you need to keep the disk busy
(back-to-back operations) and no more.

However if you are really asking why the MD subsystem needs
read-ahead values hundreds or thousands of times larger than the
underlying devices, counterproductively, that's something that I am
trying to figure out in my not so abundant spare time. If anybody
knows please let the rest of us know.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
