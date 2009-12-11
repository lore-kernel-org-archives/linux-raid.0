From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Date: Thu, 10 Dec 2009 21:20:08 -0600
Message-ID: <4B21BA68.4060205@sandeen.net>
References: <4B204334.1000605@shiftmail.org> <4B207620.3060605@sandeen.net> <4B21A34C.9090100@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B21A34C.9090100@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>
List-Id: linux-raid.ids

Asdo wrote:
> Eric Sandeen wrote:
> Gabor Gombas wrote:
> Kristleifur Da=F0ason wrote:
> [CUT]
>=20
> Thank you guys for your help
>=20
> I have done further investigation.
>=20
> I still have not checked how performances are with very small files a=
nd
> multiple simultaneous rsyncs.
>=20
> I have checked the other problem I had which I was mentioning, that I
> couldn't go more than 150MB/sec even with large files and multiple
> simultaneous transfers.
> I confirm this one and I have narrowed the problem: two XFS defaults
> (optimizations) actually damage the performances.
>=20
> The first and most important is the aligned writes: cat /proc/mounts
> lists this (autodetected) stripe size: "sunit=3D2048,swidth=3D28672" =
=2E My
> chunks are is 1MB and I have 16 disks in raid-6 so 14 data disks. Do =
you
> think it's correct? xfs_info lists blocks as 4k and sunit and swidth =
are
> in 4k blocks and have a very different value. Please do not use the s=
ame
> name "sunit"/"swidth" to mean 2 different things in 2 different place=
s,
> it can confuse the user (me!)

granted, this is confusing.

the /proc/mounts units are in 512-byte sectors.  So 2048 is 1M; 28672/2=
048
is 14, so that all looks right.

> Anyway that's not the problem: I have tried to specify other values i=
n
> my mount (in particular I tried the values sunit and swidth should ha=
ve
> had if blocks were 4k), but ANY xfs aligned mount kills the performan=
ces
> for me.=20

certainly any wrong alignment would ;)

> I have to specify "noalign" in my mount to go fast. (Also note
> this option cannot be changed on mount -o remount. I have to unmount.=
)

so noalign is faster than the defaults?  hm.

> The other default feature that kills performances for me is the
> rotorstep. I have to max it out at 255 in order to have good
> performances. Actually it is reasonable that a higher rotorstep shoul=
d
> be faster... why is 1 the default? Why it even exists? With low value=
s
> the await (iostat -x 1) increases, I guess because of the seeks, and
> stripe_cache_active stays higher, because there are less filled strip=
es.

this is related to the inode64 mount option I mentioned, which I guess =
you
haven't tested?   rotorstep affects how often new AGs are chosen in
the 32-bit inode mode.  I'm not sure why 1 is the default, perhaps
this should be changed.

> If I use noalign and rotorstep at 255 I am able to go at 325 MB/sec o=
n
> average (16 parallel transfers of 7MB files) while with defaults I go=
 at
> about 90 MB/sec.

It might be nice to do some blktracing to see what's actually
hitting the disk.

Are you running on the entire md device, or is it partitioned?
If you have partitioned your device with something so that the partitio=
ns
are not stripe-aligned, maybe that throws everything off.

Maybe you can post your partition info if any, as well as the actual
raid geometry as reported by md.

> Also with noalign and rotorstep at 255 the stripe_cache_size stays
> usually in the lower half (below 16000 out of 32000) while with defau=
lts
> it's stuck for most of the time at the maximum and processes are stuc=
k
> sleeping in MD locks for this reason.
>=20
> Do you have any knowledge of sunit/swidth alignment mechanism being
> broken on 2.6.31 or more specifically 2.6.31 ubuntu generic-14 ?

nope, don't use ubuntu, and AFAIK stripe alignment is just fine upstrea=
m.

> (Kristleifur thank you I have seen your mention of the Ubuntu vs vani=
lla
> kernel, I will try a vanilla one but right now I can't. However now I
> have narrowed the problem so XFS people might want to watch at the
> alignment problem more specifically)
>=20
> Regarding my previous post I still would like to know what are those
> stack traces I posted in my previous post: what are the functions
> xlog_state_get_iclog_space+0xed/0x2d0 [xfs]  and
> xfs_buf_lock+0x1e/0x60 [xfs]
> and what are they waiting for...
> these are still the place where processes get stuck, even after havin=
g
> worked around the alignment/rotorstep problem...
>=20
> And then a few questions on inode64:
> - if I start using inode64, do I have to remember to use inode64 on
> every subsequent mount for the life for that filesystem? Or does it
> write it in some filesystem info region that the option has been used
> once, so it applies the inode64 by itself on subsequent mounts?

Unfortunately it's not a superblock features, though IMHO it should
be; so yes, you need to mount with it always.  Leaving it out won't
harm your filesystem, it'll just put you back in 32-bit-inode mode.
Just put it in your fstab.

> - if I use a 64bit linux distro, will ALL userland programs
> automatically support 64bit inodes or do I have to continuously pay
> attention and risk to damage my data?

all 64-bit applications should be just fine.

-Eric

> Thanks for your help
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
