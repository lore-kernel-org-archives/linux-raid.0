From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: cluster RAID
Date: Sun, 25 May 2003 20:57:01 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16080.41341.194808.277607@notabene.cse.unsw.edu.au>
References: <000801c3228d$c6816dd0$3200a8c0@nimiak>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kai-Min Sung on Sunday May 25
To: Kai-Min Sung <k@kaisung.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 25, k@kaisung.com wrote:
> Hi,
> 	I have a shared storage environment (2 disks accessible by 2
> nodes through iSCSI) and am trying to assemble the same RAID-1 array on
> both nodes. Whenever I try to assemble the RAID-1 array on the second
> node, it always begins reconstructing the mirror. My guess for why it's
> doing this is that after the first node assembles the array, it marks a
> dirty flag in the RAID metadata blocks on disk. (It only resets the
> dirty flag when it deactivates the array). When the second node tries to
> assemble the same array, it reads the metadata blocks and sees that it
> is dirty. Then it proceeds with reconstruction. My question is does
> reconstruction happen, simply because the dirty flag is set? Why doesn't
> it first check if the checksums on all the mirror disks match (i.e. the
> array is consistent) and bypass reconstruction? Btw, I plan for both
> nodes to be accessing different partitions in the array, so there
> shouldn't be any synchronization problems. Also, I'm using mdadm-1.2.0
> for my testing.

What you are doing doesn't really make sense (at least not to me).

Having two hosts both trying to control a raid1 array cannot work as
neither host can make an guarantees about consistancy.

If you plan for both nodes to be accessing different partitions on the
array, why not be up-front about that and have two different raid1
arrays.

e.g. If your two drives are sda and sdb, then partition them into
  sda1, sda2, sdb1, sdb2

and then make md0 on node X from sda1 and sdb1, and
   md3 (or whatever) on node Y from sda2 and sdb2.


To answer your question - yes, the second node reconstucts because the
super block is marked dirty.  I'm not sure what you mean by "check if
the checksums on all mirror disks match".  What checksums?
  checksums of all data blocks?  That is as much work as a complete resync
  checksums of super blocks?  That wouldn't tell us anything useful.

NeilBrown
