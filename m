From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: LVM on raid10,f2 performance issues
Date: Mon, 19 Jan 2009 14:59:38 +0100
Message-ID: <20090119135938.GA27466@rap.rap.dk>
References: <49332920.5010503@gmail.com> <20081201164244.GB23899@rap.rap.dk> <4935C4B3.2060404@gmail.com> <493654C7.2090909@ziu.info> <8CB47EBD70FE9E8-AC4-981@WEBMAIL-DG06.sim.aol.com> <20090119121724.GA23623@rap.rap.dk> <49747107.8020607@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49747107.8020607@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: thomas62186218@aol.com, soltys@ziu.info, mauermann@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 19, 2009 at 01:24:39PM +0100, Peter Rabbitson wrote:
> Keld J=F8rn Simonsen wrote:
> > Hmm,=20
> >=20
> > Why is the command
> >=20
> >  blockdev --setra 65536 /dev/md0
> >=20
> > really needed? I think the kernel should set a reasonable default h=
ere.
>=20
> The in-kernel default for a block device is 256 (128k) which is way t=
oo
> low. the MD subsystems tries to be a bit smarter and assigns the md
> device readahead according to the number of devices/raid level. For
> streaming (i.e. file sever) these values are also too low. LVs can ta=
ke
> a readahead specification at creation time and use that, but this is
> manual.

I would like to have something done automatically in the kernel, so tha=
t
you do not need to do it manually. People tend to not know that you nee=
d
to add the blockdev statement, eg in /etc/rc.local, to get decent
performance. And this is needed even for simpler arrays, such as a 4
drive raid10,f2 , which can be set up on many recent motherboards with=20
sata-II support directly off the mobo.

> It is arguable what the typical workload is, but I would lean towards
> big long linear reads (fileserver) vs short scattered ones (database)=
=2E

My understanding is that the readahead is only done when the kernel
thinks it is doing sequential reads. his prpbalu is not the case whan
doing database operations. So we are kind of safe here, IMHO.
>=20
> The real solution to the problem was proposed a long time ago, and it
> seems it got lost in the attic: http://lwn.net/Articles/155510/

Yes, interesting.

The patch may nt be ready for inclusion for some time due to complexity
and lack of testing.

So I am wondering if we could come up with a formula to set the readahe=
ad
for raid. It seems like a big readahead would not affect random reading=
=2E
It would then only be overkill for sequential reading of smallish files=
=2E

So how does the kernel detect that it is doing sequential reading?
Maybe it detects that the new block to read or a specific file
descriptor is the follower to the previous read on the same FD?

And then we normally read a full chunk for the raid, which is at least
something like 64 KiB? This would take care of most database
transactions.=20

I would think we then should find the smallest readahead value for a
given array, from chunk size and drive count, that gets the array to
perform as expected.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
