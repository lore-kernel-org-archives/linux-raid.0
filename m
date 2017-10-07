From: Phil Turmel <philip@turmel.org>
Subject: Re: hung grow
Date: Sat, 7 Oct 2017 17:29:22 -0400
Message-ID: <74fde85a-2bf0-a627-239d-b12721f0cc32@turmel.org>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com>
 <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
 <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
 <3173c10a-fbd9-f563-4c90-a9f63e020773@youngman.org.uk>
 <CADg2FGbSyvLykThXBpMd4MOuHgh2Q_-zPGm-HFxdYW2z4qsNDQ@mail.gmail.com>
 <c583e62d-f4c1-755e-3985-a37164910c2e@youngman.org.uk>
 <d21f169e-0546-aa00-ce19-b6688ba74da6@turmel.org>
 <CADg2FGbnMzLBqWthKY5Uo__ANC2kAqH_8B1G23nhW+7hWJ=KeA@mail.gmail.com>
 <CADg2FGYc-sPjwukuhonoUUCr3ze3PQWv8gtZPnUT=E4CvsQftg@mail.gmail.com>
 <7e23d39b-aebb-0852-c98f-758bd99d3eb9@turmel.org>
 <CADg2FGZatpLPHbuJUEuitbipfX77T1XXduEpLTQjPzq2e56fgg@mail.gmail.com>
 <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org>
 <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com>
 <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com>
 <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/07/2017 04:45 PM, Curt wrote:
> Here's the output of -E for sdf1 and one other, in case it's needed.
> As I understand it the UUID is what has to do with the superblock, but
> UUID's match between them.
> 
> mdadm -E /dev/sdf1
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 714a612d:9bd35197:36c91ae3:c168144d
>   Creation Time : Fri Jun 15 15:52:05 2012
>      Raid Level : raid6
>   Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
>      Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
>    Raid Devices : 7
>   Total Devices : 7
> Preferred Minor : 127
> 
>     Update Time : Sat Sep  2 01:00:37 2017
>           State : active
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : cd217ebc - correct
>          Events : 11559404
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     5       8       65        5      active sync   /dev/sde1
> 
>    0     0       8       81        0      active sync   /dev/sdf1
>    1     1       8       33        1      active sync   /dev/sdc1
>    2     2       8       17        2      active sync
>    3     3      65      129        3      active sync   /dev/sdy1
>    4     4       8       49        4      active sync   /dev/sdd1
>    5     5       8       65        5      active sync   /dev/sde1
>    6     6       0        0        6      faulty removed
> 
> *****************************
> mdadm -E /dev/sda1
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 0.91.00
>            UUID : 714a612d:9bd35197:36c91ae3:c168144d
>   Creation Time : Fri Jun 15 15:52:05 2012
>      Raid Level : raid6
>   Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
>      Array Size : 11721023232 (11178.04 GiB 12002.33 GB)
>    Raid Devices : 8
>   Total Devices : 6
> Preferred Minor : 127
> 
>   Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
>   Delta Devices : 1 (7->8)
> 
>     Update Time : Wed Oct  4 12:49:57 2017
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : ce71a9cb - correct
>          Events : 11559681
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     3       8        1        3      active sync   /dev/sda1
> 
>    0     0       8       97        0      active sync   /dev/sdg1
>    1     1       8       49        1      active sync   /dev/sdd1
>    2     2       8       33        2      active sync   /dev/sdc1
>    3     3       8        1        3      active sync   /dev/sda1
>    4     4       8       65        4      active sync   /dev/sde1
>    5     5       0        0        5      faulty removed
>    6     6       8       16        6      active   /dev/sdb
>    7     7       0        0        7      faulty removed
> 

Hmm.  Please run the assemble again, with the --verbose option, and
paste all the output here so we can see what's happening.

Also grab the corresponding tail of dmesg (however many lines cover the
assembly attempt).

Phil
