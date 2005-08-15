From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: convert legacy array in place?
Date: Mon, 15 Aug 2005 14:29:38 +1000
Message-ID: <17152.6706.174775.819015@cse.unsw.edu.au>
References: <42FFBA3C.1010102@csun.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephen Walton on Sunday August 14
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Walton <stephen.walton@csun.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday August 14, stephen.walton@csun.edu wrote:
> Hi,
> 
> It seems like this should be a FAQ but careful google and mailing list 
> archive searches didn't seem to turn up anything.
> 
> I have two machines with legacy RAID-0 arrays created with raidtools.  I 
> have updated one to Fedora Core 4 and now use mdadm.  Am I correct in 
> thinking I have to use "mdadm --build" every boot to access the array?  
> My mdadm.conf contains
> 
> DEVICES /dev/hda1 /dev/hdb1 /dev/hdc1
> ARRAY /dev/md0 level=raid0 num-devices=3 
> devices=/dev/hda1,/dev/hdb1,/dev/hdc1
> 
> but the array doesn't seem to come up by itself on boot.

If it is a "legacy array" in that it was created with
"persisent-superblock = no"
then you are right. You need to use "mdadm --build" to assemble it.
--assemble ONLY works with arrays that have superblocks.
With --build, you need to make sure that you get the chunksize correct
of course (as it isn't stored in the superblock).

> 
> On the same lines, can this array be converted to a new style array just 
> by writing new superblocks, or do I have to do the 
> backup-reformat-restore thing?

An array with superblocks is slightly smaller than the legacy array
(due to the superblocks).  So you cannot do a straight conversion.
If you have afford to loose the last 64k-per-device of the array, then
you can simply re-create it as a with-superblock array.

If you are using ext2 or ext3, then you may be able to resize you
filesystem down with resize2fs and then remake the array.

NeilBrown
