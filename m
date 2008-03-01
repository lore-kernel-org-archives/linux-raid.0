From: Nat Makarevitch <nat@makarevitch.org>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Sat, 1 Mar 2008 22:05:06 +0000 (UTC)
Message-ID: <loom.20080301T213935-669@post.gmane.org>
References: <1204195554.16924.16.camel@franck-gusty> <loom.20080228T223023-79@post.gmane.org> <20080301204020.GC10278@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen <keld <at> dkuug.dk> writes:

> I believe that a full chunk is read for each read access.

I've read various definitions for "chunk". Is a "stripe" a 'cluster' (i=
n the
"group of disk sectors" meaning) on a single physical drive (device, le=
t's say
"spindle"), and a 'chunk' a set of stripes made with a single stripe of=
 each
spindle? For what I understand this is the definition used in the 'md' =
world
(see 'man mdadm'), therefore I will use it thereafter.

Yes, AFAIK a full chunk is concerned by each access.

> Most random database reads are much smaller than 256 kiB.
> So the probability that one random read can be done with just one=20
> seek + read operation is very high, as far as I understand it.

Indeed. In fact I proposed to define the chunk size with respect to the=
 (known)
average size of read/written data blocks. Most database servers are abl=
e to show
this (you let your application run normally for hours/day, then obtain =
the
information), one can also use some instrumentation (blktrace...)

> This would lead to that it is not important whether to use=20
> two arrays of 6 disks each, or 3 arrays of 4 disks each.=20
> Or for that sake 1 array of 12 disks.

I beg to disagree. Creating more than one array may be OK when you very
precisely know your load profile per table, but in most cases this is n=
ot true,
or this profile will vary, therefore your best bet is "to maintain, for=
 each
request, as much disk heads available as possible", carpet-bomb the arr=
ay with
all requests and let the elevator(s) optimize. Another way to see it, i=
n some
reciprocal way, is to say that you don't want to have any head sleeping=
 when
there is a request to serve.=20

> Some other factors may be more important: such as the ability to surv=
ive
> disk crashes

That's very true, however one may not neglect logistics. If I'm pretty =
sure that
I can change a spindle in less than 2 hours after a failure I will pref=
er using
all disks less one on a single array and letting the last one as a conn=
ected
(but powered off) spare. The alarm trips, some automatic or manual proc=
edure
powers the spare and mounts it in the array, while the procedure aiming=
 at
physically extracting the failed device and replacing it (it will becom=
e the new
spare) rolls. With more latency-prone logistics one may reserve more di=
sks as
spares.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
