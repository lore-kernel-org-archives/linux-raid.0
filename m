From: Martin Bosner <martin@bosner.de>
Subject: Re: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 20:11:27 +0100
Message-ID: <1E236039-E660-464A-9DDD-7555BAA37A51@bosner.de>
References: <58AA4B1E.1030809@bosner.de>
 <e01061cb-ea4c-4f64-16e8-e6027adbc70d@turmel.org>
 <E18A7C79-09E0-4361-9F89-68AE1E6FCBF6@bosner.de>
 <5cc1566c-1b4c-c663-56a1-2040b93b46d7@turmel.org>
 <231629B1-0888-4B3D-BD81-F641937AC045@bosner.de>
 <676bd1fa-4b97-2c6a-05b8-bd23290fb9a6@turmel.org>
 <54F6D166-0D54-49EF-B967-124DC582B299@bosner.de>
 <58AB3D0F.50602@youngman.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58AB3D0F.50602@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On 20 Feb 2017, at 20:01, Wols Lists <antlists@youngman.org.uk> wrote:
>> 
> You can try "--assemble --force". It sounds like you might well get away
> with it.

Would it be possible to start the array by adding sdk1 (setting state as active) and resetting the state of sdm1? The array failed while i was copying stuff to another place ...

With —assemble —force i get this:


mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
  Used Dev Size : -1
   Raid Devices : 36
  Total Devices : 35
    Persistence : Superblock is persistent

    Update Time : Wed Feb 15 14:08:28 2017
          State : active, FAILED, Not Started
 Active Devices : 33
Working Devices : 35
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 512K

           Name : media-storage:0  (local to host media-storage)
           UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
         Events : 140559

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
      14       0        0       14      removed
       8       8      129        8      active sync   /dev/sdi1
       9       8      145        9      active sync   /dev/sdj1
      20       0        0       20      removed
      39       8      177       11      active sync   /dev/sdl1
      12       8      193       12      spare rebuilding   /dev/sdm1
      13       8      209       13      active sync   /dev/sdn1
      14       8      225       14      active sync   /dev/sdo1
      40       8      241       15      active sync   /dev/sdp1
      16      65        1       16      active sync   /dev/sdq1
      17      65       17       17      active sync   /dev/sdr1
      18      65       33       18      active sync   /dev/sds1
      19      65       49       19      active sync   /dev/sdt1
      20      65       65       20      active sync   /dev/sdu1
      21      65       81       21      active sync   /dev/sdv1
      22      65       97       22      active sync   /dev/sdw1
      43      65      113       23      active sync   /dev/sdx1
      36      65      129       24      active sync   /dev/sdy1
      25      65      145       25      active sync   /dev/sdz1
      41      65      161       26      active sync   /dev/sdaa1
      27      65      177       27      active sync   /dev/sdab1
      28      65      193       28      active sync   /dev/sdac1
      37      65      209       29      active sync   /dev/sdad1
      38      65      225       30      active sync   /dev/sdae1
      42      65      241       31      active sync   /dev/sdaf1
      32      66        1       32      active sync   /dev/sdag1
      33      66       17       33      active sync   /dev/sdah1
      34      66       33       34      active sync   /dev/sdai1
      35      66       49       35      active sync   /dev/sdaj1

      44       8      161        -      spare   /dev/sdk1




Cheers
Martin