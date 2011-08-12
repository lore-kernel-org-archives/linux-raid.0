From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: single cpu thread performance limit?
Date: Fri, 12 Aug 2011 15:51:30 -0500
Message-ID: <4E459252.7060700@hardwarefreak.com>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>	<4E44265D.3050809@hardwarefreak.com> <CAACGR8v87iw9qmtfsQTiUP8QWQEZPyryBc_zZwuD_DyUxgzN8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAACGR8v87iw9qmtfsQTiUP8QWQEZPyryBc_zZwuD_DyUxgzN8Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 8/12/2011 8:23 AM, mark delfman wrote:

> Quick update with the XFS tests suggested (although a FS is still
> probably not a real option at teh moment for me)
>=20
> This rig only has 4 x Flash (2 MLC and 2 SLC).....  125K IOPS each fo=
r
> MLC - 165K each for SLC.
>=20
> Create linear RAID and XFS with ag=3D4
>=20
> Mount as suggested and create 4 test folders.....
>=20
> If i test individually - we get 99.9% of the IOPS (ie. 125 for first =
2
> AG's and 165 for last 2).  which is great news and means that the AG
> does what it should.

Now you know why XFS has the high performance reputation it does.

> But if a run the test over all 4, then we see it peak at aroudn 320K
> IOPS.  Interstingly each AG =3D 80K IOPS and as we can see above this=
 is
> need not be the case, as the CPU load is not having any issues - i am
> presuming that this could be a simple XFS limit maybe.

Ok, now this is interesting, because the 320K IOPS you mentioned as a
limit here is very close to the ~350K IOPS you mentioned in your first
post, when 4 cores were pegged with the md processes.  In this case you=
r
CPUs are not pegged, but you're hitting nearly the same ceiling, 320K I=
OPS.

I'm pretty sure you're not hitting an XFS limit here.  To confirm,
create 4 subdirectories in each of the current 4 directories, and
generate 16 concurrent writers against the 16 dirs.

On 8/11/2011 10:58 AM, mark delfman wrote:
> If I use say 4 x RAID1 / 10=92s and a RAID0 on top =96 I see not much
> greater results. (although the theory seems to say I should and there
> are now 4 CPU threads running, it still seems to hit 4 x 100% at mayb=
e
> 350K).

So it's beginning to look like your scalability issue may not
necessarily be with mdraid, but possibly a hardware bottleneck, or a
bottleneck somewhere else in the kernel.  As Bernd mentioned previously=
,
you should probably run perf top or some other tool to see where the
kernel is busy.

Also, you never answered my question regarding which block device
driver(s) you're using for these PCIe SSDs.

> More testing with many R1's and R0's on top seem to suggest that R0 i=
s
> losing around 20-25% of the IOPS.  (R1 around 5%).  I have tried with
> LVM strip and much the same.

Are you hitting the same ~320K-350K IOPS aggregate limit with all test
configurations?

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
