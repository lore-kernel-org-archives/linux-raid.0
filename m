From: Anshuman Aggarwal <anshuman@brillgene.com>
Subject: Re: 4 partition raid 5 with 2 disks active and 2 spare, how to force?
Date: Fri, 26 Mar 2010 21:58:25 +0530
Message-ID: <6093BE49-EE3B-41B5-9519-C6D5D0496C64@brillgene.com>
References: <S1753093Ab0CYHZE/20100325072504Z+37@vger.kernel.org> <2E4545D6-8F4E-4779-9103-960C52983A72@brillgene.com> <4877c76c1003250437r346e18en8da0f6f804bef634@mail.gmail.com> <DFC0232A-8DCD-4815-AA08-DA7065F01221@brillgene.com> <4877c76c1003252038o655b2a29p9d994df27b5d2afd@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003252038o655b2a29p9d994df27b5d2afd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks again. I have visited those pages (twice no less) and nothing seems to be new from the concepts (both raid and lvm) since I last studied them. 

My problem is that I'm not familiar enough with the recovery tools and the common practical pitfalls to do this comfortably without the hand holding of this mailing list :)

Here is the requested output:
Note: Since I have 3-4 other arrays running (root device etc.) which don't have anything to do with this one and are all working fine...I am just putting the output of the relevant devices (in order to avoid confusing everybody). Please let me know if you still require the full output.  

mdadm -Dvvs /dev/md_d127
mdadm: md device /dev/md_d127 does not appear to be active.

mdadm --assemble  /dev/md_d127 /dev/sda1 /dev/sdb5 /dev/sdc5 /dev/sdd5
mdadm: /dev/md_d127 assembled from 2 drives and 1 spare - not enough to start the array.

Says that the device /dev/md_d127 is not active (because its not active in /proc/mdstat)	
mdadm -Evvs  /dev/sda1 /dev/sdb5 /dev/sdc5 /dev/sdd5
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
           Name : GATEWAY:127  (local to host GATEWAY)
  Creation Time : Sat Aug 22 09:44:21 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
     Array Size : 1758296832 (838.42 GiB 900.25 GB)
  Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 571fa32b:d76198a1:0f5d3a2d:31f6d6b8

Internal Bitmap : 2 sectors from superblock
    Update Time : Fri Mar 19 00:56:15 2010
       Checksum : 7e769165 - expected aa523227
         Events : 3796145

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : spare
   Array State : .AA. ('A' == active, '.' == missing)
/dev/sdb5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
           Name : GATEWAY:127  (local to host GATEWAY)
  Creation Time : Sat Aug 22 09:44:21 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
     Array Size : 1758296832 (838.42 GiB 900.25 GB)
  Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f8ebb9f8:b447f894:d8b0b59f:ca8e98eb

Internal Bitmap : 2 sectors from superblock
    Update Time : Fri Mar 19 00:56:15 2010
       Checksum : 1005cfbc - correct
         Events : 3796145

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : .AA. ('A' == active, '.' == missing)
/dev/sdc5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
           Name : GATEWAY:127  (local to host GATEWAY)
  Creation Time : Sat Aug 22 09:44:21 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
     Array Size : 1758296832 (838.42 GiB 900.25 GB)
  Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d9ce99fc:79bc1e9d:197d5b11:c990e007

Internal Bitmap : 2 sectors from superblock
    Update Time : Fri Mar 19 00:56:15 2010
       Checksum : a9f9f59f - correct
         Events : 3796145

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : .AA. ('A' == active, '.' == missing)
/dev/sdd5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
           Name : GATEWAY:127  (local to host GATEWAY)
  Creation Time : Sat Aug 22 09:44:21 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
     Array Size : 1758296832 (838.42 GiB 900.25 GB)
  Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 763a832f:1a9a7ea8:ce90d4a3:32e8ae54

Internal Bitmap : 2 sectors from superblock
    Update Time : Fri Mar 19 00:56:15 2010
       Checksum : c78aab46 - correct
         Events : 3796145

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : spare
   Array State : .AA. ('A' == active, '.' == missing)


Regards,
Anshuman

On 26-Mar-2010, at 9:08 AM, Michael Evans wrote:

> On Thu, Mar 25, 2010 at 7:09 AM, Anshuman Aggarwal
> <anshuman@brillgene.com> wrote:
>> Thanks Michael, I am clear about the problem of why the multiple failure would cause me to lose data. Which is why I wanted to consult this mailing list before proceeding.
>> 
>> Could you tell me how to keep the array read-only?  and mark one or both of these spares as active forcibly? and Also, once I am able to use these spares as active and the data is not consistent in a particular stripe, how does the kernel resolve the inconsistency (as in what data does it use, the one based on the data stripes or the one based on the parity?) this one is just academic interest since it'll be difficult to figure out which is the right data anyways.
>> 
>> Thanks,
>> Anshuman
>> 
> 
> Please, read the wikipedia page first,
> 
> http://en.wikipedia.org/wiki/RAID
> 
> and then this
> 
> http://wiki.tldp.org/LVM-on-RAID (some links need updating, but it's
> still up to date for concepts)
> 
> 
> With that background nearly out of the way, please stop, and read them
> both again.  Yes, seriously.  In order to prevent data loss you'll
> need to have a good understanding of what RAID does, so that you can
> watch out for ways it can fail.
> 
> The next step, before we do /anything/ else is for you to post the
> COMPLETE output of these commands.
> 
> mdadm -Dvvs
> mdadm -Evvs
> 
> They will help everyone on the list better understand the state of the
> metadata records and what potential solutions might be possible.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

