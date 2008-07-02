From: Keld J?rn Simonsen <keld@dkuug.dk>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 22:05:33 +0200
Message-ID: <20080702200533.GA13464@rap.rap.dk>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com> <20080702175117.GC12081@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FDB5@34093-C3-EVS3.exchange.rackspace.com> <20080702194546.GB2311@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080702194546.GB2311@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 02:45:46PM -0500, Matt Garman wrote:
> On Wed, Jul 02, 2008 at 01:08:04PM -0500, David Lethe wrote:
> > Everything is a potential bottleneck.  As I am under NDA with most
> > of the controller vendors, then I can not provide specifics, but
> > suffice to say that certain cards with certain chipsets will max
> > out at well under published speeds.  Heck, you could attach
> > solid-state disks with random I/O access time in the nanosecond
> > range and still only get 150MB/sec out of certain controllers,
> > even on a PCIe X 16 bus. 
> 
> Short of signing an NDA, how would one go about determining which
> chipsets are least likely to be a bottleneck?  I'm interested in
> building an NFS server with a Linux software RAID-5 data store.  To
> me, that means my I/O subsystem should be as fast and capable as
> possible.
> 
> For example, looking at the block diagram [1] of Intel's P45/ICH10
> chipset [2], it appears that the link between the north and south
> bridges is only 2 GB/s.  I would think that any raid level that
> requires the CPU (e.g. parity calculations) would clog that link
> fairly quickly, at least if large block transfers are taking place.
> And then I wonder what impact that has on the performance of the
> NIC(s) (I don't know how much a NIC has to talk to the CPU).

2 GB/s seems adequate. Not many raids are in this class. Theoretically
you would need something like more than 20 disks to get this bandwidth,
and normally you only have 4 to 8 disks attachable to IO controllers on
the mobo. 

Parity calculations are done by the cpu on the ram, and should not touch
the northbridge - southbridge internal bus in vanilla motherboards.

best regards
keld
