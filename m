From: Eric BENARD / Free <ebenard@free.fr>
Subject: faulty mdstat
Date: Thu, 7 Aug 2003 14:20:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308071420.20993.ebenard@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

here is what /proc/mdstat gives to me after a crash of the server.
2 drives (one on md1 and one on md4 have de (F).

This means they are faulty.

Should I do :
mdadm /dev/md1 -a /dev/ide/host2/bus0/target0/lun0/part5
mdadm /dev/md4 -a /dev/ide/host2/bus0/target0/lun0/part7

or is there an other way to solve the problem ?

Concerning md5 (raid 5), 3 drives are used. I assume the one marked [3] is not 
used. What can it be used for ?

Best regards
Eric

>Personalities : [raid0] [raid1] [raid5] 
>read_ahead 1024 sectors
>md0 : active raid1 ide/host2/bus1/target0/lun0/part1[1] 
ide/host2/bus0/target0/lun0/part1[0]
>      15936 blocks [2/2] [UU]
>      
>md1 : active raid1 ide/host2/bus1/target0/lun0/part5[1] 
ide/host2/bus0/target0/lun0/part5[0](F)
>      851328 blocks [2/1] [_U]
>      
>md3 : active raid0 ide/host2/bus1/target0/lun0/part6[1] 
ide/host2/bus0/target0/lun0/part6[0]
>      802944 blocks 64k chunks
>      
>md4 : active raid1 ide/host2/bus1/target0/lun0/part7[1] 
ide/host2/bus0/target0/lun0/part7[0](F)
>      1686720 blocks [2/1] [_U]
>      
>md2 : active raid1 ide/host2/bus1/target1/lun0/part1[1] 
ide/host2/bus0/target1/lun0/part1[0]
>      2554176 blocks [2/2] [UU]
>      
>md5 : active raid5 ide/host2/bus1/target1/lun0/part6[2] 
ide/host2/bus1/target0/lun0/part8[1] ide/host2/bus0/target1/lun0/part6[3] 
ide/host2/bus0/target0/lun0/part8[0]
>      228524416 blocks level 5, 64k chunk, algorithm 0 [3/3] [UUU]
>      
>unused devices: <none>
>
>

