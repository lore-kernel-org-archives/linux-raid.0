From: NeilBrown <neilb@suse.com>
Subject: Re: degraded raid array with bad blocks
Date: Wed, 22 Jul 2015 08:48:12 +1000
Message-ID: <20150722084812.55016c7c@noble>
References: <55A7F47D.1020004@fabianfischer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55A7F47D.1020004@fabianfischer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Fabian Fischer <raid@fabianfischer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 Jul 2015 20:14:21 +0200 Fabian Fischer
<raid@fabianfischer.org> wrote:

> Hi,
> today I had some problems with my mdadm raid5 (4disks). Firstly I try to
> explaine what happened and what the result is:
> 
> One disk in my array has some bad blocks. After some hardware-changes
> one of the intact disks was thrown out of the array due to a faulty
> sata-cable.
> I shut down the server and replaced the cable.
> After booting, the removed disk wasn't re added to the array (maybe
> because of different event count). --re-add doesn't work.
> So I used --add.

You need a bitmap configured for --re-add to be useful.
(It is generally a good idea anyway).

> 
> Because of the bad blocks on one of the remaining disks, the rebuild
> stops when reaching the first bad block. The re added disk is declared
> as spare, 2 disks active and the disk with bad blocks as faulty.

That shouldn't happen.
Your devices all have a bad block log present, so when rebuilding hits
a bad block it should just record that as a bad block on the recovering
disk and keep going.  That is the whole point of the bad block log.

What kernel are you running?  And what version of mdadm?


> 
> /dev/md127:
>         Version : 1.2
>   Creation Time : Tue Apr 19 08:51:32 2011
>      Raid Level : raid5
>      Array Size : 5860538880 (5589.05 GiB 6001.19 GB)
>   Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
> 
>     Update Time : Thu Jul 16 19:02:09 2015
>           State : clean, FAILED
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 1
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>            Name : FiFa-Server:0
>            UUID : 839fb405:d0b1f13a:5a55ee42:fc8a2061
>          Events : 107223
> 
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       80        1      active sync   /dev/sdf
>        5       8       32        2      active sync   /dev/sdc
>        6       0        0        6      removed
> 
>        4       8       96        -      faulty   /dev/sdg
>        6       8       64        -      spare   /dev/sde
> 
> 
> In my opinion there a 3 possibilities to get the array back working. I
> am not sure whether both possibilities really exist and which one is the
> most promising.
> 	- Using the 'spare'-disk as active disk. The data on the disk
> 	  should be still there.
> 	- Ignoring the bad blocks and loose information stored in this
> 	  blocks
> 	- force start the array without the 'spare' disk and copy the
> 	  data to backup-storage, or does the bad block will cause the
> 	  array to fail when reaching a bad block?

If you have somewhere to store backed up data, and if you can assemble
the array with "--assemble --force", then taking that approach and
copying all the data to somewhere else is the safest option.

To do anything else would require a clear understanding of the history
of the array.  Maybe re-creating the array using the 3 "best" devices
would help, but you would want to be really sure what you were doing.

The data in the record bad blocks is probably lost already anyway -
hopefully there is nothing critical there.

Given the update times on the superblocks are very close the array is
probably quite consistent.

I think "--assemble --force" listing the three devices was "Device
Role: Active device ..." should work and give you a degraded array.
Then 'fsck' that and copy data off.
Then maybe recreate the array from scratch.

NeilBrown



> 
> In the attachment you can find the output of --examine.
> In can not explain why 3 disk have a Bad Block Log. According to
> smart-values only sdg has Reallocated_Sector_Ct >0
> Another thing I can't explain is why sdg (which is the disk with known
> bad blocks) has a lower event count.
> 
> 
> I hope I can get some great ideas how to fix my array.
> 
> Fabian
> 

