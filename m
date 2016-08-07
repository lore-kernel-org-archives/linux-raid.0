From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid5 reshape stuck at 0% - SuSE leap 42.1
Date: Sun, 7 Aug 2016 13:09:17 +0100
Message-ID: <57A724ED.5070808@youngman.org.uk>
References: <57A69012.1010406@youngman.org.uk>
 <alpine.DEB.2.02.1608071154110.3593@uplift.swm.pp.se>
 <57A719CC.6080301@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57A719CC.6080301@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/16 12:21, Wols Lists wrote:
> On 07/08/16 10:54, Mikael Abrahamsson wrote:
>> > On Sun, 7 Aug 2016, Wols Lists wrote:
>> > 
>>> >> I also can't run the array :-(
>> > 
>> > What does "cat /proc/mdstat" say?
> The vm is shut down right now, but it said inactive, four drives,
> [UUU_], iirc. I'll post it when I get it back up. Didn't mention raid
> type, so that could be messed up somewhere.
> 
> Two drives are mirrored, it should be rebuilding on to third, and a
> fourth is spare (ready to rebuild into raid6)

/dev/sdd seems to have disappeared - maybe I removed it ... I've been
mucking about a fair bit ...

Note that "mdadm" is the version that came with the system, "./mdadm" is
the latest version downloaded via git.

And being SuSE, with systemd, "--continue" is supposed to fire off a
background mdadm, I believe. ps tells me that isn't happening...

kanga:/home/anthony # cd mdadm/
kanga:/home/anthony/mdadm # ./mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Fri Aug  5 18:16:24 2016
     Raid Level : raid5
  Used Dev Size : 8380416 (7.99 GiB 8.58 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Sun Aug  7 01:20:23 2016
          State : active, Not Started
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

  Delta Devices : 1, (2->3)

           Name : kanga:testarray  (local to host kanga)
           UUID : cf52ebc0:886a35cd:688274b4:3f16096c
         Events : 157

    Number   Major   Minor   RaidDevice State
       4       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       3       8       64        2      active sync   /dev/sde
kanga:/home/anthony/mdadm # mdadm /dev/md127 --grow --continue
kanga:/home/anthony/mdadm # ps -fea | grep mdadm
root      1953  1855  0 13:02 pts/0    00:00:00 grep --color=auto mdadm
kanga:/home/anthony/mdadm # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : inactive sdc[1] sde[3] sdb[4]
      25141248 blocks super 1.2

unused devices: <none>
kanga:/home/anthony/mdadm # ./mdadm /dev/md127 --grow --continue
kanga:/home/anthony/mdadm # ps -fea | grep mdadm
root      1967  1855  0 13:03 pts/0    00:00:00 grep --color=auto mdadm
kanga:/home/anthony/mdadm #


