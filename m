From: Victor Garcia <vichor@gmail.com>
Subject: Write mostly flag
Date: Sun, 1 Jan 2017 07:37:25 +0000
Message-ID: <CACUwJN1tPMv6KcL+zASxcMWs6GXVT1jdbOYNOun9ADEYC_Mh2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all

I am trying to set up a raid 1 array using an SSD and a standard SAT
HDD drives. As I read, it's better to set the write-mostly flag to the
HDD partition of the array to keep SSD performance times.

This is the command I'm using:

# mdadm --create /dev/md1 -n 2 -l 1 --metadata=0.90 --bitmap=internal
/dev/nvme0n1p5 -W /dev/sda8 --write-behind

I expect seeing the (W) indicator in mdstat, but this is not showing:

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sda8[1] nvme0n1p5[0]
      52400064 blocks [2/2] [UU]
      [>....................]  resync =  0.3% (175936/52400064)
finish=9.8min speed=87968K/sec

unused devices: <none>

 But if I force later on the flag by means of the sys FS handle, then
it does appear:

# cat /sys/block/md1/md/dev-sda8/state
in_sync
# echo writemostly > /sys/block/md1/md/dev-sda8/state
# cat /sys/block/md1/md/dev-sda8/state
in_sync,write_mostly
# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sda8[1](W) nvme0n1p5[0]
      52400064 blocks [2/2] [UU]
      [==>..................]  resync = 11.0% (5806336/52400064)
finish=9.8min speed=78966K/sec
      bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>

How is it that the (W) is not showing in the first place?

BTW, this is the system being used:

# uname -a
Linux ubuntu 4.8.0-22-generic #24-Ubuntu SMP Sat Oct 8 09:15:00 UTC
2016 x86_64 x86_64 x86_64 GNU/Linu

Thanks and regards
Victor
