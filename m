From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 20:26:27 +0200
Message-ID: <20080702182627.GA12614@rap.rap.dk>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com> <20080702175117.GC12081@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FDB5@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A20315AE59B5C34585629E258D76A97CF1FDB5@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 01:08:04PM -0500, David Lethe wrote:
> 
> 
> And also the disk controllers, could these be bottlenecks? They typically
> operate at 300 MB/s nominally, per disk channel, and presumably they
> then have a connection to the southbridge that is capable of handling
> this speed. So for a 4-disk SATA-II controller this would be at least
> 1200 MB/s or about 10 gigabit. 
> 
> best regards
> keld
> -------------------
> It is much more complicated than just saying what the transfer rates are, especially in the world of blocking, arbitration, and unbalanced I/O.  

Yes, that is understood, but I am only listing some potential
bottlenecs, of cause there may be more.

> Everything is a potential bottleneck.  As I am under NDA with most of the controller vendors, then I can not provide specifics, but suffice to say that certain cards with certain chipsets will max out at well under published speeds.  Heck, you could attach solid-state disks with random I/O access time in the nanosecond range and still only get 150MB/sec out of certain controllers, even on a PCIe X 16 bus. 
> 
> BTW, there isn't a SATA-II controller in the planet that will deliver 1200 MB/sec with 4 disk drives. 

Yes, but I think this is normally due to that the max transfer speed per
disk is in the ballpark of 80-120 MB/s - which is less than half the
SATA-II max speed. And I think much of this slowdown comes from head movement,
track-to-track, disk latency etc. I was of the impression, that when the
transfer between the disk and the controller is going on, then the
transfer speed would be not far from the 300 MB/s max speed, eg for
90 MB/s 1 TB disks that I bougth recently, or the faster 15000 RPM
disks, which give something like 120 MB/s.

best regards
keld
