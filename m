From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?  GPFS w/ 10GB/s throughput to
 the rescue
Date: Sat, 26 Feb 2011 17:54:54 -0600
Message-ID: <4D6992CE.60803@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>	<20110215044434.GA9186@septictank.raw-sewage.fake>	<4D5A98BF.3030704@gmail.com> <AANLkTin+BWOn+45Y8op7k6cFymmv1VgLrh9Ro9sU7nPJ@mail.gmail.com> <4D66CBB8.5010804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D66CBB8.5010804@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Matt Garman <matthew.garman@gmail.com>, Doug Dumitru <doug@easyco.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Joe Landman put forth on 2/24/2011 3:20 PM:

> All this said, its better to express your IO bandwidth needs in MB/s,
> preferably in terms of sustained bandwidth needs, as this is language
> that you'd be talking to vendors in.  

Heartily agree.

> that gets you 50x 117 MB/s or about 5.9 GB/s sustained bandwidth for
> your IO.  10 machines running at a sustainable 600 MB/s delivered over
> the network, and a parallel file system atop this, solves this problem.

That's 1 file server for each 5 compute nodes Joe.  That is excessive.
Your business is selling these storage servers, so I can understand this
recommendation.  What cost is Matt looking at for these 10 storage
servers?  $8-15k apiece?  $80-150K total, not including installation,
maintenance, service contract, or administration training?  And these
require a cluster file system.  I'm guessing that's in the territory of
quotes he's already received from NetApp et al.

In that case it makes more sense to simply use direct attached storage
in each compute node at marginal additional cost, and a truly scalable
parallel filesystem across the compute nodes, IBM's GPFS.  This will
give better aggregate performance at substantially lower cost, and
likely with much easier filesystem administration.

Matt, if a parallel cluster file system is in your cards, and it very
well may be, the very best way to achieve your storage bandwidth goal
would be leveraging direct attached disks in each compute node, your
existing GbE network, and using IBM GPFS as your parallel cluster
filesystem.  I'd recommend using IBM 1U servers with 4 disk bays of
146GB 10k SAS drives in hardware RAID 10 (it's built in--free).  With 50
compute nodes, this will give you over 10GB/s aggregate disk bandwidth,
over 200MB/s per node.  Using these 146GB 2.5" drives you'd have ~14TB
of GPFS storage and can push/pull over 5GB/s of GPFS throughput over
TCP/IP.  Throughput will be likely be limited by the network, not the disks.

Each 1U server has dual GbE ports, allowing each node's application to
read 100MB/s from the GPFS while the node is simultaneously serving
100MB/s to all the other nodes, with full network redundancy in the
event a single NIC or switch should fail in one of your redundant
ethernet segments.  Or, you could bond the NICs, without fail over, for
over 200MB/s full duplex, giving you aggregate GPFS throughput of
between 6-10GB/s depending on actual workload access patterns.

Your only additional cost here over the base compute node is 4 drives at
~$1000, the GPFS licensing, and consulting fees to IBM Global Services
for setup and training, and maybe another GbE switch or two.  This
system is completely scalable.  Each time you add a compute node you add
another 100-200MB/s+ of GPFS bandwidth to the cluster, at minimal cost.
 I have no idea what IBM GPFS licensing costs are.  My wild ass guess
would be a couple hundred dollars per node, which is pretty reasonable
considering the capability it gives you, and the cost savings over other
solutions.

You should make an appointment with IBM Global Services to visit your
site, go over your needs and budget, and make a recommendation or two.
Request they send a GPFS educated engineer along on the call.  Express
that you're looking at the architecture I've described.  They may have a
better solution given your workload and cost criteria.  The key thing is
that you need to get as much information as possible at this point so
have the best options going forward.

Here's an appropriate IBM compute cluster node:
http://www-304.ibm.com/shop/americas/webapp/wcs/stores/servlet/default/ProductDisplay?productId=4611686018425930325&storeId=1&langId=-1&categoryId=4611686018425272306&dualCurrId=73&catalogId=-840

1U rack chassis
Xeon X3430 - 2.4 GHz, 4 core, 8MB cache
8GB DDR3
dual 10/100/1000 Ethernet
4 x 146GB 10k rpm SAS hot swap, RADI10

IBM web price per single unit:  ~$3,100
If buying volume in one PO:     ~$2,500 or less through a wholesaler

Hope this information is helpful Matt.

-- 
Stan

