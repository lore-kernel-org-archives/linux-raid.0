From: Harry Mangalam <hjm@tacgi.com>
Subject: Re: 3ware + RAID5 + xfs performance
Date: Mon, 25 Jul 2005 21:34:13 -0700
Message-ID: <200507252134.13869.hjm@tacgi.com>
References: <Pine.SOL.4.58.0507252110320.2683@titan.cfa.harvard.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.SOL.4.58.0507252110320.2683@titan.cfa.harvard.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: gbakos@cfa.harvard.edu
Cc: linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

I went thru the same hardware config gymnastics (confounded by bad disk=
s, a=20
bad controller, bad hotswap cages, and some SW config issues - see:
http://maillists.uci.edu/mailman/public/uci-linux/2005-June/001067.html=
).


The 3ware info is partially reported here:
http://maillists.uci.edu/mailman/public/uci-linux/2005-June/001134.html

and I believe I also sent a similar report to this list, but google doe=
sn't=20
show it.


Here's the results of my bonnie tests on a similar system:
8x250GB WD SD series disks on a 3ware 9500S-8, on an IWILL 2x Opteron m=
obo,=20
4GB RAM, with XFS.

The XFS parameters are with a 64K stripe to match the RAID card; other =
params=20
more or less vanilla.

Below are some bonnie timing results with differing filesystems (1 run =
with=20
ext3, 3 with XFS with differnt file sizes - unwrap in an editor to comp=
are in=20
columns:

 XFS sand,=20
7000M,52315,99,104402,22,32242,8,32018,60,127998,20,435.5,0,80,1724,15,=
+++++,
+++, 3248, 16,1718,15,+++++,+++,750, 4
ext3 sand, 7000M,40682,91, 47732,23,25432,9,38027,72,179352,27,311.1,0,=
80,=20
416,99,+++++,+++,53250,100, 423,99,+++++,+++,560,58
 XFS sand,=20
7000M,50040,98,106324,24,33046,8,31269,59,112240,17,416.0,0,80,1930,17,=
+++++,
+++, 3753, 17,1913,17,+++++,+++,449, 2
 XFS sand,=20
15000M,51065,99,101659,24,26884,7,35344,69,141223,23,263.0,0,80,1666,14=
,
+++++,+++, 4565, 22,1700,16,+++++,+++,793, 4

=46rom my reading (see URL above for resourcelist), XFS is quite bad fo=
r tiny=20
files - we use it for very large files (>GB size); using XFS for this w=
ould=20
generally be a bad thing.  We do NOT get tremendous performance out of =
it;=20
but the performance is much better than with ext3 and the CPU usage is =
lower,=20
sometimes dramtically so.  Real life experience with some benchmarks co=
nfirms=20
this - we get approximately ~ the same real life thruput as we do on a =
IBM=20
SP2 8way module with a direct attach disk.

We are now considering adding a local PVFS2 system to a small cluster f=
or very=20
fast IO under MPI




On Monday 25 July 2005 18:11, Gaspar Bakos wrote:
> Dear all,
>
> The purpose of this email is twofold:
> - to share the results of the many tests I performed with
> =A0 a 3ware RAID card + RAID-5 + XFS, pushing for better file I/O,
> - and to initiate some brainstorming on what parameters can be tuned =
for
> =A0 getting a good performance out of this hardware under 2.6.* kerne=
ls.
>
> I started all these tests because the performance was quite poor, mea=
ning
> that the write speed was slow, the read speed was barely acceptable, =
and
> the system load went very high (10.0) during bonnie++ tests.
> My questions are marked below with "Q".

<clipped>
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
