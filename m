From: Tanguy Herrmann <dolanor@gmail.com>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Fri, 22 Jul 2011 01:08:34 +0000 (UTC)
Message-ID: <loom.20110722T025156-876@post.gmane.org>
References: <4CE00206.4000301@geograph.co.za> <20101114195036.GA23982@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra <bluca <at> comedia.it> writes:

> 
> On Sun, Nov 14, 2010 at 05:36:38PM +0200, Zoltan Szecsei wrote:
> > *If I have to reformat the drives and redo mdadm --create, other than mdadm 
> > stop, how can I get rid of all the /dev/md* etc etc so that when I restart 
> > this exercise, the original bad RAID does not interfere with this new 
> > attempt?
> 
> mdadm -Ss
> mdadm --zero-superblock on each partition
> >
> >
> > *Partition alignment?
> > Is this relevant for modern HDs (I'm using 5900rpm Seagate 2TB drives)
> for modern hdds with 4k sectors it is
> new fdisk and/or parted should already know how to align
> in any case, since you want to use the whole space for raid, why create
> partitions at all, md works nicely without

Hello,
first thank you for the interesting topic (because it fits my questions ^^) and 
for all the participation of this community to this topic !
 
I've read somewhere (sorry I can't remind it) that the raid still could be 
unaligned by using the whole disk, and so we had to create a partition aligned 
(by using fdisk -u, then creating a partition beginning at LBA 64 at least, and 
that would span on a length multiple of 8.

Was it totally wrong ?

Tanguy




