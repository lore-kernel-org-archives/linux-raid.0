From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Wed, 23 Mar 2011 03:53:45 -0500
Message-ID: <4D89B519.3020907@hardwarefreak.com>
References: <4D837DAF.6060107@hardwarefreak.com> <20110319090101.1786cc2a@notabene.brown> <4D8559A2.6080209@hardwarefreak.com> <20110320144147.29141f04@notabene.brown> <AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com> <4D868C36.5050304@hardwarefreak.com> <20110321024452.GA23100@www2.open-std.org> <4D875E51.50807@hardwarefreak.com> <20110321221304.GA900@www2.open-std.org> <20110322094658.GA21078@cthulhu.home.robinhill.me.uk> <20110322101403.GA9329@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110322101403.GA9329@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Mdadm <linux-raid@vger.kernel.org>, Roberto Spadim <roberto@spadim.com.br>, NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen put forth on 3/22/2011 5:14 AM:

> Of course the IO will be randomized, if there is more users, but the
> read IO will tend to be quite sequential, if the reading of each proc=
ess
> is sequential. So if a user reads a big file sequentially, and the
> system is lightly loaded, IO schedulers will tend to order all IO
> for the process so that it is served in one series of operations,
> given that the big file is laid out consequently on the file system.

With the way I've architected this hypothetical system, the read load o=
n
each allocation group (each 12 spindle array) should be relatively low,
about 3 streams on 14 AGs, 4 streams on the remaining two AGs,
_assuming_ the files being read are spread out evenly across at least 1=
6
directories.  As you all read in the docs for which I provided links,
XFS AG parallelism functions at the directory and file level.  For
example, if we create 32 directories on a virgin XFS filesystem of 16
allocation groups, the following layout would result:

AG1:  /general requirements	AG1:  /alabama
AG2:  /site construction	AG2:  /alaska
AG3:  /concrete			AG3:  /arizona
=2E.
=2E.
AG14: /conveying systems	AG14: /indiana
AG15: /mechanical		AG15: /iowa
AG16: /electrical		AG16: /kansas

AIUI, the first 16 directories get created in consecutive AGs until we
hit the last AG.  The 17th directory is then created in the first AG an=
d
we start the cycle over.  This is how XFS allocation group parallelism
works.  It doesn't provide linear IO scaling for all workloads, and it'=
s
not magic, but it works especially well for multiuser fileservers, and
typically better than multi nested stripe levels or extremely wide arra=
ys.

Imagine you have a 5000 seat company.  You'd mount this XFS filesytem i=
n
/home.  Each user home directory created would fall in a consecutive AG=
,
resulting in about 312 user dirs per AG.  In this type of environment
XFS AG parallelism will work marvelously as you'll achieve fairly
balanced IO across all AGs and thus all 16 arrays.

In the case where you have many clients reading files from only one
directory, hence the same AG, IO parallelism is limited to the 12
spindles of that one array.  When this happens, we end up with a highly
random workload at the disk head, resulting in high seek rates and low
throughput.  This is one of the reasons I built some "excess" capacity
into the disk subsystem.  Using XFS AGs for parallelism doesn't
guarantee even distribution of IO across all the 192 spindles of the 16
arrays.  It gives good parallelism if clients are accessing different
files in different directories concurrently, but not in the opposite ca=
se.

> The block allocation is only done when writing. The system at hand wa=
s
> specified as a mostly reading system, where such a bottleneck of bloc=
k
> allocating is not so dominant.

This system would excel at massive parallel writes as well, again, as
long as we have many writers into multiple directories concurrently,
which spreads the write load across all AGs, and thus all arrays.

XFS is legendary for multiple large file parallel write throughput,
thanks to delayed allocation, and some other tricks.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
