From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: high throughput storage server?
Date: Wed, 23 Mar 2011 12:57:43 -0300
Message-ID: <AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com>
References: <4D837DAF.6060107@hardwarefreak.com>
	<20110319090101.1786cc2a@notabene.brown>
	<4D8559A2.6080209@hardwarefreak.com>
	<20110320144147.29141f04@notabene.brown>
	<AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>
	<4D868C36.5050304@hardwarefreak.com>
	<20110321024452.GA23100@www2.open-std.org>
	<4D875E51.50807@hardwarefreak.com>
	<20110321221304.GA900@www2.open-std.org>
	<20110322094658.GA21078@cthulhu.home.robinhill.me.uk>
	<20110322101403.GA9329@www2.open-std.org>
	<4D89B519.3020907@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D89B519.3020907@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Mdadm <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

it's something like 'partitioning'? i don't know xfs very well, but ...
if you use 99% ag16 and 1% ag1-15
you should use a raid0 with stripe (for better write/read rate),
linear wouldn't help like stripe, i'm right?

a question... this example was with directories, how files (metadata)
are saved? and how file content are saved? and jornaling?

i see a filesystem something like: read/write
jornaling(metadata/files), read/write metadata, read/write file
content, check/repair filesystem, features (backup, snapshot, garbage
collection, raid1, increase/decrease fs size, others)

speed of write and read will be a function of how you designed it to
use device layer (it's something like a virtual memory utilization, a
big memory, and many programs trying to use small parts and when need
use a big part)


2011/3/23 Stan Hoeppner <stan@hardwarefreak.com>:
> Keld J=F8rn Simonsen put forth on 3/22/2011 5:14 AM:
>
>> Of course the IO will be randomized, if there is more users, but the
>> read IO will tend to be quite sequential, if the reading of each pro=
cess
>> is sequential. So if a user reads a big file sequentially, and the
>> system is lightly loaded, IO schedulers will tend to order all IO
>> for the process so that it is served in one series of operations,
>> given that the big file is laid out consequently on the file system.
>
> With the way I've architected this hypothetical system, the read load=
 on
> each allocation group (each 12 spindle array) should be relatively lo=
w,
> about 3 streams on 14 AGs, 4 streams on the remaining two AGs,
> _assuming_ the files being read are spread out evenly across at least=
 16
> directories. =A0As you all read in the docs for which I provided link=
s,
> XFS AG parallelism functions at the directory and file level. =A0For
> example, if we create 32 directories on a virgin XFS filesystem of 16
> allocation groups, the following layout would result:
>
> AG1: =A0/general requirements =A0 =A0 AG1: =A0/alabama
> AG2: =A0/site construction =A0 =A0 =A0 =A0AG2: =A0/alaska
> AG3: =A0/concrete =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 AG3: =A0/arizona
> ..
> ..
> AG14: /conveying systems =A0 =A0 =A0 =A0AG14: /indiana
> AG15: /mechanical =A0 =A0 =A0 =A0 =A0 =A0 =A0 AG15: /iowa
> AG16: /electrical =A0 =A0 =A0 =A0 =A0 =A0 =A0 AG16: /kansas
>
> AIUI, the first 16 directories get created in consecutive AGs until w=
e
> hit the last AG. =A0The 17th directory is then created in the first A=
G and
> we start the cycle over. =A0This is how XFS allocation group parallel=
ism
> works. =A0It doesn't provide linear IO scaling for all workloads, and=
 it's
> not magic, but it works especially well for multiuser fileservers, an=
d
> typically better than multi nested stripe levels or extremely wide ar=
rays.
>
> Imagine you have a 5000 seat company. =A0You'd mount this XFS filesyt=
em in
> /home. =A0Each user home directory created would fall in a consecutiv=
e AG,
> resulting in about 312 user dirs per AG. =A0In this type of environme=
nt
> XFS AG parallelism will work marvelously as you'll achieve fairly
> balanced IO across all AGs and thus all 16 arrays.
>
> In the case where you have many clients reading files from only one
> directory, hence the same AG, IO parallelism is limited to the 12
> spindles of that one array. =A0When this happens, we end up with a hi=
ghly
> random workload at the disk head, resulting in high seek rates and lo=
w
> throughput. =A0This is one of the reasons I built some "excess" capac=
ity
> into the disk subsystem. =A0Using XFS AGs for parallelism doesn't
> guarantee even distribution of IO across all the 192 spindles of the =
16
> arrays. =A0It gives good parallelism if clients are accessing differe=
nt
> files in different directories concurrently, but not in the opposite =
case.
>
>> The block allocation is only done when writing. The system at hand w=
as
>> specified as a mostly reading system, where such a bottleneck of blo=
ck
>> allocating is not so dominant.
>
> This system would excel at massive parallel writes as well, again, as
> long as we have many writers into multiple directories concurrently,
> which spreads the write load across all AGs, and thus all arrays.
>
> XFS is legendary for multiple large file parallel write throughput,
> thanks to delayed allocation, and some other tricks.
>
> --
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
