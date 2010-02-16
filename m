From: Michael <michael@rw23.de>
Subject: Re: Map Block number from hdd to md
Date: Tue, 16 Feb 2010 12:14:38 +0100
Message-ID: <84f3bb2dd3f8170f1e80df476770bdb5@rw23.de>
References: <7362c3826262551b46e9b0bb1a777633@rw23.de> <20100216122014.18696241@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100216122014.18696241@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 Feb 2010 12:20:14 +1100, Neil Brown <neilb@suse.de> wrote:
>> is there any method to find that bad block in context of the raid block
>> device? reading all files is not a good option on large raidsets.
>> level 5, 64k chunk, algorithm 2
> 
> It isn't that hard.  The code is in drivers/md/raid5.c in the
kernel.....
> 
> Rather than trying to describe in general, give me the block number,
> device,
> and "mdadm --examine" of that device, and I'll tell you how I get the
> answer.


the bad block number was 122060740.

[root@raw sqla]mdadm --examine /dev/sda3
/dev/sda3:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 9815a2c6:c83a9a53:2a8015ce:9d8e5e8c (local to host raw)
  Creation Time : Thu Feb 11 16:01:12 2010
     Raid Level : raid6
  Used Dev Size : 966060672 (921.31 GiB 989.25 GB)
     Array Size : 2898182016 (2763.92 GiB 2967.74 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 2

  Reshape pos'n : 974014464 (928.89 GiB 997.39 GB)
     New Layout : left-symmetric

    Update Time : Tue Feb 16 11:58:37 2010
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 16372b12 - correct
         Events : 363519

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8        3        2      active sync   /dev/sda3

   0     0       8       35        0      active sync   /dev/sdc3
   1     1       8       51        1      active sync   /dev/sdd3
   2     2       8        3        2      active sync   /dev/sda3
   3     3       8       83        3      active sync   /dev/sdf3
   4     4       8       99        4      active   /dev/sdg3

thank you.

iam currently reshaping my raid5 to a raid6.

i want to give you a note that i have had the "too-old metadata" problem
with "mdadm - v3.1.1 - 19th November 2009"
commenting out that check started my array again. i thought this should
have been fixed in that version? 

what is the right way to stop the reshaping process? kill <pid of mdadm
--grow/assemble> and then mdadm --stop /dev/mdX or just mdadm --stop
/dev/mdX without killing?

other question: what happens when a operating raid5/6 encounters a bad
block at read time? does it just mark the corresponding devices as faild?

> If you were desperate, you could use 'dd' to read each of the chunks
into a
> file, then write a little c/perl/whatever program to xor those files
> together, then use 'dd' to write that file back out the the target
chunk.
> 
> NeilBrown

sounds easy so far. mapping blocks to chunks is also easy? and what to do
in a raid6 case?
