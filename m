From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: small mdadm issue under debian
Date: Thu, 29 Oct 2009 01:30:18 -0600
Message-ID: <200910290130.18829.tfjellstrom@shaw.ca>
References: <200910290124.59090.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910290124.59090.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu October 29 2009, Thomas Fjellstrom wrote:
> I've been trying to get mdadm to auto assemble my raid array for a while
> now, and as I'm trying to test which kernels give me back some
>  performance (testing 2.6.26 right now), I find that with this kernel,
>  its happily auto assembling my 1.1 versioned metadata array. 3.6.30 does
>  not, nor does .31 or .32 for that matter. Same version of mdadm, for
>  some reason, when the mdadm-raid init script is run, it fails to
>  assemble the raid array I've specified in mdadm.conf. And again, it
>  automagically works with 2.6.26.
> 
> color me confused.
> 

I totally forgot:

root@natasha:/home/moose# mdadm --version
mdadm - v3.0.3 - 22nd October 2009

root@natasha:/home/moose# uname -a
Linux natasha 2.6.26-2-amd64 #1 SMP Wed Aug 19 22:33:18 UTC 2009 x86_64 
GNU/Linux

root@natasha:/home/moose# mdadm -D /dev/md0
/dev/md0:
        Version : 1.01
  Creation Time : Wed Oct 14 08:55:25 2009
     Raid Level : raid5
     Array Size : 3907049472 (3726.05 GiB 4000.82 GB)
  Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Thu Oct 29 01:28:10 2009
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : natasha:0  (local to host natasha)
           UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
         Events : 4952

    Number   Major   Minor   RaidDevice State
       0       8       64        0      active sync   /dev/sde
       1       8       80        1      active sync   /dev/sdf
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       5       8       96        4      active sync   /dev/sdg


And I'm running Debian Sid.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
