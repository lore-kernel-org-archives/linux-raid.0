From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 01 Sep 2011 18:12:35 +0200
Message-ID: <4E5FAEF3.60501@macroscoop.nl>
References: <4E5FA4B5.6010407@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FA4B5.6010407@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/2011 05:28 PM, Pim Zandbergen wrote:
>
>
> What should I do to find the cause?

Additional information:

Both the original 2TB drives as well as the new 3TB drives were GPT
formatted with partition type FD00

This is information about the currently shrunk array:


# mdadm --detail  /dev/md0
/dev/md0:
         Version : 0.90
   Creation Time : Wed Feb  8 23:22:15 2006
      Raid Level : raid5
      Array Size : 4696690944 (4479.11 GiB 4809.41 GB)
   Used Dev Size : 782781824 (746.52 GiB 801.57 GB)
    Raid Devices : 7
   Total Devices : 7
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Aug 30 21:50:50 2011
           State : clean
  Active Devices : 7
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 1bf1b0e2:82d487c5:f6f36a45:766001d1
          Events : 0.3157574

     Number   Major   Minor   RaidDevice State
        0       8      161        0      active sync   /dev/sdk1
        1       8      177        1      active sync   /dev/sdl1
        2       8      193        2      active sync   /dev/sdm1
        3       8      145        3      active sync   /dev/sdj1
        4       8      209        4      active sync   /dev/sdn1
        5       8      225        5      active sync   /dev/sdo1
        6       8      129        6      active sync   /dev/sdi1

