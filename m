From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?  GPFS w/ 10GB/s throughput to
 the rescue
Date: Sat, 26 Feb 2011 19:56:52 -0500
Message-ID: <4D69A154.3030403@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>	<20110215044434.GA9186@septictank.raw-sewage.fake>	<4D5A98BF.3030704@gmail.com> <AANLkTin+BWOn+45Y8op7k6cFymmv1VgLrh9Ro9sU7nPJ@mail.gmail.com> <4D66CBB8.5010804@gmail.com> <4D6992CE.60803@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6992CE.60803@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/26/2011 06:54 PM, Stan Hoeppner wrote:
> Joe Landman put forth on 2/24/2011 3:20 PM:

[...]

>> that gets you 50x 117 MB/s or about 5.9 GB/s sustained bandwidth for
>> your IO.  10 machines running at a sustainable 600 MB/s delivered over
>> the network, and a parallel file system atop this, solves this problem.
>
> That's 1 file server for each 5 compute nodes Joe.  That is excessive.

No Stan, it isn't.  As I said, this is our market, we know it pretty 
well.  Matt stated his needs pretty clearly.

He needs 5.9GB/s sustained bandwidth.  Local drives (as you suggested 
later on) will deliver 75-100 MB/s of bandwidth, and he'd need 2 for 
RAID1, as well as a RAID0 (e.g. RAID10) for local bandwidth (150+ MB/s). 
  4 drives per unit, 50 units.  200 drives.

Any admin want to admin 200+ drives in 50 chassis?  Admin 50 different 
file systems?

Oh, and what is the impact if some of those nodes went away?  Would they 
take down the file system?  In the cloud of microdisk model Stan 
suggested, yes they would.  Which is why you might not want to give that 
advice serious consideration.  Unless you built in replication.  Now we 
are at 400 disks in 50 chassis.

Again, this design keeps getting worse.

> Your business is selling these storage servers, so I can understand this
> recommendation.  What cost is Matt looking at for these 10 storage

Now this is sad, very sad.

Stan started out selling the Nexsan version of things (and why was he 
doing it on the MD RAID list I wonder?), which would have run into the 
same costs Stan noted later.  Now Stan is selling (actually mis-selling) 
GPFS (again, on an MD RAID list, seemingly having picked it off of a 
website), without having a clue as to the pricing, implementation, 
issues, etc.

> servers?  $8-15k apiece?  $80-150K total, not including installation,
> maintenance, service contract, or administration training?  And these
> require a cluster file system.  I'm guessing that's in the territory of
> quotes he's already received from NetApp et al.

I did suggest using GlusterFS as it will help with a number of aspects, 
has an open source version.  I did also suggest (since he seems to wish 
to build it himself) that he pursue a reasonable design to start with, 
and avoid the filer based designs Stan suggested (two Nexsan's and some 
sort of filer head to handle them), or a SAN switch of some sort. 
Neither design works well in his scenario, or for that matter, in the 
vast majority of HPC situations.

I did make a full disclosure of my interests up front, and people are 
free to take my words with a grain of salt.  Insinuating based upon my 
disclosure?  Sad.


> In that case it makes more sense to simply use direct attached storage
> in each compute node at marginal additional cost, and a truly scalable
> parallel filesystem across the compute nodes, IBM's GPFS.  This will
> give better aggregate performance at substantially lower cost, and
> likely with much easier filesystem administration.

See GlusterFS.  Open source at zero cost.  However, and this is a large 
however, this design, using local storage for a pooled "cloud" of disks, 
has some often problematic issues (resiliency, performance, hotspots). 
A truly hobby design would use this.  Local disk is fine for scratch 
space, for a few other things.  Managing the disk spread out among 50 
nodes?  Yeah, its harder.

I'm gonna go out on a limb here and suggest Matt speak with HPC cluster 
and storage people.  He can implement things ranging from effectively 
zero cost through things which can be quite expensive.  If you are 
talking to Netapp about HPC storage, well, probably move onto a real HPC 
storage shop.  His problem is squarely in the HPC arena.

However, I would strongly advise against designs such as a single 
centralized unit, or a cloud of micro disks.  The first design is 
decidedly non-scalable, which is in part why the HPC community abandoned 
it years ago.  The second design is very hard to manage and guarantee 
any sort of resiliency.  You get all the benefits of a RAID0 in what 
Stan proposed.

Start out talking with and working with experts, and its pretty likely 
you'll come out with a good solution.   The inverse is also true.

MD RAID, which Stan dismissed as a "hobby RAID" at first can work well 
for Matt.  GlusterFS can help with the parallel file system atop this. 
Starting with a realistic design, an MD RAID based system (self built or 
otherwise) could easily provide everything Matt needs, at the data rates 
he needs it, using entirely open source technologies.  And good designs.

You really won't get good performance out of a bad design.  The folks 
doing HPC work who've responded have largely helped frame good design 
patterns.  The folks who aren't sure what HPC really is, haven't.

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
