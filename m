From: Neil Brown <neilb@suse.de>
Subject: Re: How do I repair a checksum error in the superblock?
Date: Sat, 25 Sep 2010 17:31:24 +1000
Message-ID: <20100925173124.4d73d984@notabene>
References: <4C9BE30C.9060301@thenewhams.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C9BE30C.9060301@thenewhams.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Newham <adam@thenewhams.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 23 Sep 2010 16:30:20 -0700
Adam Newham <adam@thenewhams.com> wrote:

> 
> I've got a sick RAID-5 array and looking for advice on the best way to 
> fix it. I've Google'd the hell out of it/read the FAQ and think I know 
> what I need to do but I what to make sure as I'd rather not have to 
> restore the data from backups (as they're incomplete and would be very 
> time consuming)
> 
> The machine is configured as follows:
> 
>     * 4 x 1 TB drives (SATA) - software RAID-5, with LVM consuming all
>       3TB and then ext3 on top giving 2.7 TB
>     * 1 x OS drive (IDE) (I actually have 1x drive with RHEL5 and
>       another with Ubuntu which with the newer kernel is a lot more
>       friendly with my motherboard)
> 
> 
> Basically I had the machine die due to a bad motherboard and DIMM. 
> During a boot a disc check was performed and at 1.6% Linux performed a 
> "kernel panic". I re-installed the OS and I'm now trying to recovery the 
> RAID. it looks like I have 3x problems.
> 
>     * When the original OS was installed, the OS drive was located on
>       /dev/hda[x]. Under the new OS (Ubuntu 10.04), its now populated at
>       /dev/sda[x]. The RAID was originally located on /dev/sd[abcd]/
>       With the OS drive in /dev/sda[x], the OS is populating the RAID at
>       /dev/sd[bcde]. I modified the /etc/mdadm/mdadm.conf file to
>       reflect this. I could probably get round this by going back to the
>       RHEL5 OS, but it would be nice to know how to do this.
> 
> At the moment I fixed it by modifying the /etc/mdadm/mdadm.conf file  as 
> follows:
> 
> DEVICE /dev/sd[bcde]1
> ARRAY /dev/md0 level=raid5 num-devices=4 
> UUID=08558923:881d9efd:464c249d:988d2ec6
> 
>     * The next problem (and is my main problem) is that one of the
>       drives (/dev/sde) has a checksum error in the superblock. So when
>       the try to assemble the array, I get the following:
> 
> sudo mdadm --assemble --verbose /dev/md0
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
> mdadm: added /dev/sdc1 to /dev/md0 as 1
> mdadm: added /dev/sdd1 to /dev/md0 as 2
> mdadm: failed to add /dev/sde1 to /dev/md0: Invalid argument
> mdadm: added /dev/sdb1 to /dev/md0 as 0
> mdadm: /dev/md0 assembled from 3 drives - not enough to start the array 
> while not clean - consider --force.
> 
> /var/log/messages contains the following:
> 
> md: sde1 does not have a valid v0.90 superblock, not importing!
> md: md_import_device returned -22
> 
> If I dump out the info for the drive (/dev/sde1) I see the following:
> 
> sudo mdadm --examine /dev/sde1
> /dev/sde1:
>            Magic : a92b4efc
>          Version : 00.90.03
>             UUID : 08558923:881d9efd:464c249d:988d2ec6
>    Creation Time : Mon Nov  3 17:42:21 2008
>       Raid Level : raid5
>    Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>       Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
>     Raid Devices : 4
>    Total Devices : 4
> Preferred Minor : 0
> 
>      Update Time : Sun Aug 15 12:33:06 2010
>            State : active
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : e828e258 - expected e828e260
>           Events : 143
> 
>           Layout : left-symmetric
>       Chunk Size : 64K
> 
>        Number   Major   Minor   RaidDevice State
> this     3       8       49        3      active sync   /dev/sdd1
> 
>     0     0       8        1        0      active sync   /dev/sda1
>     1     1       8       17        1      active sync   /dev/sdb1
>     2     2       8       33        2      active sync   /dev/sdc1
>     3     3       8       49        3      active sync   /dev/sdd1
> 
> How do I fix this? Googling seems to imply recreating the array over the 
> top and specify the UUID? Should I force the assemble with 3x drives? 
> There is also a --update which updates the metadata on the disk?

Yes.  Try those.
I would do
   mdadm --assemble --force --update=summaries /dev/md0 /dev/sd[abcd]1

and see if that works.

> 
>     * The last problem is that I believe that one of the drives has
>       additional metadata. This caused Ubuntu to see an additional
>       partition /dev/md0lp1 in addition to /dev/md0. What is the best
>       way of removing it?

Did you mean "/dev/md0p1", or was there really an 'l' in there??

That just means that the array (/dev/md0) has a partition table.  If you want
to remove a partition table, then maybe use fdisk.

NeilBrown



> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

