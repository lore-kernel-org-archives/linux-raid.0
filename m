From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 14:49:35 -0400
Message-ID: <87f94c370910131149o140cfe76nf9768045426481e8@mail.gmail.com>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 12, 2009 at 12:58 PM, mark delfman
<markdelfman@googlemail.com> wrote:
> Hi... in recent tests we are seeing a 50% drop in performance from
> XFS>MD on a 2.6.30 kernel (compared to a 2.6.28 kernel)
>
> In short: =A0Performance to MD0 direct =3D circa 1.7GBsec (see below)=
, via
> xfs circa 850MBsec. =A0On previous system (2.6.28) there was no drop =
in
> performance (in fact often an increase).
>
> I am hopefully that this is simply a matter of barriers etc on the
> newer kernel and MD, but we have tried many options and nothing seems
> to change this so would very much appreciate advice.
>
>
> Below is the configuration / test results
>
> Hardware: =A0Decent performance quad core with LSI SAS controller: =A0=
10 x
> 15K SAS drives
> (note we have tried this on various hardware and various amounts of d=
rives).
>
> Newer kernel setup =A0(performance drop)
> Kernel 2.6.30.8 =A0(open SUSE userspace)
> mdadm - v3.0 - 2nd June 2009
> Library version: =A0 1.02.31 (2009-03-03)
> Driver version: =A0 =A04.14.0
>
> RAID0 created: mdadm -C /dev/md0 -l0 -n10 /dev/sd[b-k]
> RAID0 Performance:
> dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M count=3D20000
> 20000+0 records in
> 20000+0 records out
> 20971520000 bytes (21 GB) copied, 12.6685 s, 1.7 GB/s
>
>
> XFS Created: =A0(can see from output it is self aligning - but tried
> various alignments)
>
> # mkfs.xfs -f /dev/md0
> meta-data=3D/dev/md0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 isize=3D256 =A0 =A0a=
gcount=3D32, agsize=3D22888176 blks
> =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D512 =A0 attr=3D2
> data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D=
4096 =A0 blocks=3D732421600, imaxpct=3D5
> =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sunit=
=3D16 =A0 =A0 swidth=3D160 blks
> naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0 a=
scii-ci=3D0
> log =A0 =A0 =A0=3Dinternal log =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 b=
locks=3D32768, version=3D2
> =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sects=
z=3D512 =A0 sunit=3D16 blks, lazy-count=3D0
> realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extsz=3D655360 b=
locks=3D0, rtextents=3D0
>
>
> Mounted: =A0mount -o nobarrier /dev/md0 /mnt/md0
> /dev/md0 on /mnt/md0 type xfs (rw,nobarrier)
> (tried with barriers / async)
>
> Performance:
>
> linux-poly:~ # dd if=3D/dev/zero of=3D/mnt/md0/test bs=3D1M count=3D2=
0000
> 20000+0 records in
> 20000+0 records out
> 20971520000 bytes (21 GB) copied, 23.631 s, 887 MB/s
>
>
>
> Note:
>
> Older kernel setup (no performance drop)
> Newer kernel setup
> Kernel 2.6.28.4
> mdadm =A02.6.8
> Library version: =A0 1.02.27 (2008-06-25)
> Driver version: =A0 =A04.14.0

It doesn't look like you are using device mapper, but I just saw this p=
osted:

=3D=3D=3D=3D=3D=3D=3D=3D
We used to issue EOPNOTSUPP in response to barriers (so flushing ceased=
 to be
supported when it became barrier-based). 'Basic' barrier support was ad=
ded
first (2.6.30-rc2), as Mike says, by waiting for relevant I/O to comple=
te.
Then this was extended (2.6.31-rc1) to send barriers to the underlying =
devices
for most dm types of dm targets.

To see which dm targets in a particular source tree forward barriers ru=
n:
(set to a non-zero value).
 grep 'ti->num_flush_requests =3D' drivers/md/dm*c
=3D=3D=3D=3D=3D=3D=3D=3D=3D

So barriers went through a implementation change in 2.6.30.  Thought
it might give you one more thing to chase down

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
