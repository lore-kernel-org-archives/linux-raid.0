From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 16:20:56 -0500
Message-ID: <4D66CBB8.5010804@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>	<20110215044434.GA9186@septictank.raw-sewage.fake>	<4D5A98BF.3030704@gmail.com> <AANLkTin+BWOn+45Y8op7k6cFymmv1VgLrh9Ro9sU7nPJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin+BWOn+45Y8op7k6cFymmv1VgLrh9Ro9sU7nPJ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Doug Dumitru <doug@easyco.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/24/2011 03:58 PM, Matt Garman wrote:

> These are definitely large files; maybe "huge" is a better word.  All
> are over 100 MB in size, some are upwards of 5 GB, most are probably a
> few hundred megs in size.

Heh ... the "huge" storage I alluded to above is also quite ... er ... 
context sensitive.

>
> The word "streaming" may be accurate, but to me it is misleading. I

Actually not at all.  We have quite a few customers that consume files 
by slurping them into ram before processing.  So the file system streams 
(e.g. sends data as fast as the remote process can consume it, modulo 
network and other inefficiencies).

> associate streaming with media, i.e. it is generally consumed much
> more slowly than it can be sent (e.g. even high-def 1080p video won't
> saturate a 100 mbps link).  But in our case, these files are basically
> read into memory, and then computations are done from there.

Same use case.  dd is an example of a "trivial" streaming app, though we 
prefer to generate load with fio.

>
> So, for an upper bounds on the notion of "fast", I'll illustrate the
> worst-case scenario: there are 50 analysis machines, each of which can
> run up to 10 processes, making 500 total processes.  Every single
> process requests a different file at the exact same time, and every
> requested file is over 100 MB in size.  Ideally, each process would be
> able to access the file as though it were local, and was the only
> process on the machine.  In reality, it's "good enough" if each of the
> 50 machines' gigabit network connections are saturated.  So from the
> network perspective, that's 50 gbps.

Ok, so if we divide these 50 Gbps across say ... 10 storage nodes ... 
then we need only sustain, on average, 5 Gbps/storage node.  This makes 
a number of assumptions, some of which are valid (e.g. file distribution 
across nodes is effectively random, and can be accomplished via parallel 
file system). 5 Gbps/storage node sounds like a node with 6x GbE ports, 
or 1x 10GbE port.  Run one of the parallel file systems across it and 
make sure the interior RAID can handle this sort of bandwidth (you'd 
need at least 700 MB/s on the interior RAID, which eliminates many/most 
of the units on the market, and you'd need pretty high efficiencies in 
the stack, which also have a tendency to reduce your choices ... better 
to build the interior RAIDs as fast as possible, deal with the network 
efficiency losses and call it a day)

All this said, its better to express your IO bandwidth needs in MB/s, 
preferably in terms of sustained bandwidth needs, as this is language 
that you'd be talking to vendors in.  So on 50 machines, assume each 
machine can saturate its 1GbE port (these aren't Broadcom NICs, right?), 
that gets you 50x 117 MB/s or about 5.9 GB/s sustained bandwidth for 
your IO.  10 machines running at a sustainable 600 MB/s delivered over 
the network, and a parallel file system atop this, solves this problem.

Single centralized resources (FC heads, filers, etc.) won't scale to 
this.  Then again, this isn't their use case.

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
