From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Tiobench results LOWER with more threads
Date: Fri, 18 Oct 2002 13:19:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021018111918.GC7875@unthought.net>
References: <3DABCFE7.9070701@webmail.co.za> <20021017215014.GA7875@unthought.net> <20021018023137.GC18294@peeps.cable.rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021018023137.GC18294@peeps.cable.rcn.com>
To: Gregory Leblanc <gleblanc@linuxweasel.com>
Cc: Vladimir Milovanovic <vlad@webmail.co.za>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Oct 17, 2002 at 07:31:37PM -0700, Gregory Leblanc wrote:
> On Thu, Oct 17, 2002 at 11:50:14PM +0200, Jakob Oestergaard wrote:
> > On Tue, Oct 15, 2002 at 10:20:55AM +0200, Vladimir Milovanovic wrot=
e:
> > > OK, just joined the list and rad the faq, and something caught my=
 eye.=20
> > > Tiobench results are apparently supposed to INCREASE when there a=
re more=20
> > > threads.
> >=20
> > No, what gave you that idea?
> >=20
> > It is so much easier for the kernel to handle one sequential stream=
 of
> > I/O, instead of many streams.
> >=20
> > If you have more than one stream, you need to seek. Seeking is bad.=
 One
> > sequential I/O is almost always (with the notable exception of RAID=
-1
> > reads) faster in total sustained throughput, and always (as in real=
ly
> > always) faster in per-thread sustained throughput.
>=20
> Err, so are you saying that a single sequential I/O is slower on RAID
> 1 when compared with a single disk?  That doesn't make a lot of
> sense.  There -are- instances where parallel I/O is required.  In
> these cases, any RAID-1 should be much faster than a single disk, as
> should RAID 10.  I'm not sure that RAID 5 should give a similar
> benefit, but given the cost of disks, I don't care about RAID 5.

The exception I made was:

"One sequential I/O is almost always (with the notable exception of
RAID-1 reads) faster in total sustained throughput,..."

What I wanted to say was: One sequential reader is usually faster than =
N
readers are in total.  Except on an N-disk RAID-1, where up to N reader=
s
will be faster in total than one reader.

An N-disk RAID-1 will scale with up to N readers.

There's some fuzz on these measurements, because a sequential read on a
filesystem is not a sequential read on the disk (because of fs
metadata), so therefore often a single threaded read on an N-disk RAID-=
1
will be faster than on a single disk - and maybe RAID-1 will not scale
up to N readers, but only N-1, but that all depends on the fs - and
let's not go too deep into that for now  :)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
