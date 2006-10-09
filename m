From: Neil Brown <neilb@suse.de>
Subject: Re: type-0.90.0 superblock and "md-1" superblocks
Date: Tue, 10 Oct 2006 08:09:14 +1000
Message-ID: <17706.51338.374155.183402@cse.unsw.edu.au>
References: <dac45060610090716s7afb4f95mb639866d11a2347e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark Ryden on Monday October 9
Sender: linux-raid-owner@vger.kernel.org
To: Mark Ryden <markryde@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 9, markryde@gmail.com wrote:
> Hello,
> 
> I wonder what is the "type-0.90.0" superblock and "md-1" superblocks
> of md and what is the differnce between them? Is it merely
> some version of kernel md driver ?

Two different formats for the metadata describing the array.
I usually refer to them as v0.90 and v1.
Some of the differences are subtle.  Some of the less subtle are:
  - v0.90 is limited to 28 components in an array.  v1 allows > 256.
  - v1 supports restarting driver recovery that was interrupted by
       a clean shutdown.  v0.90 doesn't.
  - v1 can easily be moved between machines with different byte-order.
       v0.90 needs explicit conversion.
  - v0.90 records a small number to identify the array.  v1 stores a
       textual name.
  - v0.90 can be used with 'in kernel autodetect' (i.e. partition type
       0xfd). v1 cannot (I consider this an improvement :-)
  - v0.90 can get confused if a partition and a whole device are
       aligned so that the superblock would be at exactly the same
       location.   v1 avoids this confusion.

> In case it is so - is there a way to know which is
> the version of the md superblocks which is in use in my kernel ?
> 

2.6 kernels support both, though there have been a number of v1
specific bugs slowly being ironed out over the months.  From 2.6.18 I
consider v1 perfectly stable for regular use.  In earlier kernels it
was quite usable but there were a few minor bugs.

mdadm create v0.90 by default, though the default can be changed in
/etc/mdadm.conf.


> I see that in drivers/md/md.c
> there is an array of super_type with 2 elements,
> the name	of the first is  "0.90.0",and the name of the second
> is "md-1".
> 
> when running :
> mdadm --detail /dev/md0
> I see:
> /dev/md0:
>         Version : 00.90.01
> 			..
> 			
> is this "Version" field is the superblock type ?

The "01" at the end is really a version number for the driver rather
than a version number for the metadata (aka superblock) - md version
numbers were not thought out probably and so are confusing.

Yes, the "Version" reported by mdadm --detail reflects the superblock
type.

NeilBrown
