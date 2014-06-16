From: Pete <psid@riverland.net.au>
Subject: How to fix this superblock?
Date: Mon, 16 Jun 2014 10:59:27 +0930
Message-ID: <20140616105927.828a6765.psid@riverland.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all. Please excuse, newbie here, finding out how much I don't know
about md.

I have a RAID1 array which is running in degraded mode. When I try to
re-add the device that used to be part of the array, I'm told that it's
too small, though it used to be fine.

/proc/mdstat:

md1 : active raid1 sdc3[2]
      2920305508 blocks super 1.0 [2/1] [_U]

When I try to re-add the device that used to be part of the array, mdadm
says it's not large enough:

# mdadm --add /dev/md1 /dev/sdb3
mdadm: /dev/sdb3 not large enough to join array

The partition tables hadn't changed when this started. Since then I've
re-partitioned sdb to make sdb3 a few GB bigger, but it's still not
large enough.

Looking at the working device's superblock, there's a heap of "failed"
so I'm guessing that superblock has been damaged:

# mdadm -E /dev/sdc3

/dev/sdc3:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 129ec25f:f07e292a:5bf0829d:19793e6c
           Name : pioneer:1  (local to host pioneer)
  Creation Time : Thu Nov 21 21:19:12 2013
     Raid Level : raid1
   Raid Devices : 2

  Used Dev Size : 5841405976 (2785.40 GiB 2990.80 GB)
     Array Size : 5840611016 (2785.02 GiB 2990.39 GB)
      Used Size : 5840611016 (2785.02 GiB 2990.39 GB)
   Super Offset : 5841406232 sectors
          State : clean
    Device UUID : 6bbc382c:244cf1ad:4fd61c87:4e40e592

    Update Time : Fri Jun 13 17:05:57 2014
       Checksum : 93cf5353 - correct
         Events : 444384

    Array Slot : 2 (failed, failed, 1, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed, failed,
failed, failed, failed, failed, failed, failed, failed, failed, failed,
 [snip]
failed) Array State : _U 383 failed


Could it be that whatever happened to the superblock on sdc3 is giving
it an incorrect idea of the array size? Is that something I can fix?

Would I be better off creating a new array on sdb3+missing and copying
data to that? Then I would zero the superblock on sdc3 and hopefully
add it to the new array.

Would appreciate any help.

Thanks.  Pete
