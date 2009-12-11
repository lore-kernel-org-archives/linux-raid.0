From: Asdo <asdo@shiftmail.org>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Date: Fri, 11 Dec 2009 02:41:32 +0100
Message-ID: <4B21A34C.9090100@shiftmail.org>
References: <4B204334.1000605@shiftmail.org> <4B207620.3060605@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B207620.3060605@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>
List-Id: linux-raid.ids

Eric Sandeen wrote:
Gabor Gombas wrote:
Kristleifur Da=F0ason wrote:
[CUT]

Thank you guys for your help

I have done further investigation.

I still have not checked how performances are with very small files and=
=20
multiple simultaneous rsyncs.

I have checked the other problem I had which I was mentioning, that I=20
couldn't go more than 150MB/sec even with large files and multiple=20
simultaneous transfers.
I confirm this one and I have narrowed the problem: two XFS defaults=20
(optimizations) actually damage the performances.

The first and most important is the aligned writes: cat /proc/mounts=20
lists this (autodetected) stripe size: "sunit=3D2048,swidth=3D28672" . =
My=20
chunks are is 1MB and I have 16 disks in raid-6 so 14 data disks. Do yo=
u=20
think it's correct? xfs_info lists blocks as 4k and sunit and swidth ar=
e=20
in 4k blocks and have a very different value. Please do not use the sam=
e=20
name "sunit"/"swidth" to mean 2 different things in 2 different places,=
=20
it can confuse the user (me!)

Anyway that's not the problem: I have tried to specify other values in=20
my mount (in particular I tried the values sunit and swidth should have=
=20
had if blocks were 4k), but ANY xfs aligned mount kills the performance=
s=20
for me. I have to specify "noalign" in my mount to go fast. (Also note=20
this option cannot be changed on mount -o remount. I have to unmount.)

The other default feature that kills performances for me is the=20
rotorstep. I have to max it out at 255 in order to have good=20
performances. Actually it is reasonable that a higher rotorstep should=20
be faster... why is 1 the default? Why it even exists? With low values=20
the await (iostat -x 1) increases, I guess because of the seeks, and=20
stripe_cache_active stays higher, because there are less filled stripes=
=2E

If I use noalign and rotorstep at 255 I am able to go at 325 MB/sec on=20
average (16 parallel transfers of 7MB files) while with defaults I go a=
t=20
about 90 MB/sec.

Also with noalign and rotorstep at 255 the stripe_cache_size stays=20
usually in the lower half (below 16000 out of 32000) while with default=
s=20
it's stuck for most of the time at the maximum and processes are stuck=20
sleeping in MD locks for this reason.

Do you have any knowledge of sunit/swidth alignment mechanism being=20
broken on 2.6.31 or more specifically 2.6.31 ubuntu generic-14 ?

(Kristleifur thank you I have seen your mention of the Ubuntu vs vanill=
a=20
kernel, I will try a vanilla one but right now I can't. However now I=20
have narrowed the problem so XFS people might want to watch at the=20
alignment problem more specifically)

Regarding my previous post I still would like to know what are those=20
stack traces I posted in my previous post: what are the functions
xlog_state_get_iclog_space+0xed/0x2d0 [xfs] =20
and
xfs_buf_lock+0x1e/0x60 [xfs]
and what are they waiting for...
these are still the place where processes get stuck, even after having=20
worked around the alignment/rotorstep problem...

And then a few questions on inode64:
- if I start using inode64, do I have to remember to use inode64 on=20
every subsequent mount for the life for that filesystem? Or does it=20
write it in some filesystem info region that the option has been used=20
once, so it applies the inode64 by itself on subsequent mounts?
- if I use a 64bit linux distro, will ALL userland programs=20
automatically support 64bit inodes or do I have to continuously pay=20
attention and risk to damage my data?

Thanks for your help
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
