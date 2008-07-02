From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 14:45:46 -0500
Message-ID: <20080702194546.GB2311@sewage.raw-sewage.fake>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com> <20080702175117.GC12081@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FDB5@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A20315AE59B5C34585629E258D76A97CF1FDB5@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Keld J?rn Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 01:08:04PM -0500, David Lethe wrote:
> Everything is a potential bottleneck.  As I am under NDA with most
> of the controller vendors, then I can not provide specifics, but
> suffice to say that certain cards with certain chipsets will max
> out at well under published speeds.  Heck, you could attach
> solid-state disks with random I/O access time in the nanosecond
> range and still only get 150MB/sec out of certain controllers,
> even on a PCIe X 16 bus. 

Short of signing an NDA, how would one go about determining which
chipsets are least likely to be a bottleneck?  I'm interested in
building an NFS server with a Linux software RAID-5 data store.  To
me, that means my I/O subsystem should be as fast and capable as
possible.

For example, looking at the block diagram [1] of Intel's P45/ICH10
chipset [2], it appears that the link between the north and south
bridges is only 2 GB/s.  I would think that any raid level that
requires the CPU (e.g. parity calculations) would clog that link
fairly quickly, at least if large block transfers are taking place.
And then I wonder what impact that has on the performance of the
NIC(s) (I don't know how much a NIC has to talk to the CPU).

Then there are chips like nvidia's 8200 [3] that don't separate the
north and south bridges.  I can't find a block diagram on their
website, but I found a few via google "nvidia 8200 block diagram".
[4]  It looks like the 8200 MCP is connected via HT3 (don't know
exactly what that means/implies), but everything is connected to
this one chip (PCI, SATA, PCI-Express, NIC, etc).

Anyone have any suggestions on getting a motherboard with the most
I/O bandwidth?

[1] http://www.intel.com/products/chipsets/P45/pix/p45_blockdiagram.gif

[2] http://www.intel.com/products/chipsets/P45/index.htm

[3] http://www.nvidia.com/object/geforce_8200mgpu.html
    http://www.nvidia.com/object/mobo_gpu_tech_specs.html

[4] http://www.hardwarezone.com.sg/img/data/articles/2008/2453/GeForce_8200_Block_Diagram.jpg
    http://www.pcper.com/images/reviews/507/GeForce_8200_Block_Diagram.jpg
    http://media.arstechnica.com/news.media/GeForce8200.jpg
