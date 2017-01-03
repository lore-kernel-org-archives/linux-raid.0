From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: Write mostly flag
Date: Tue, 3 Jan 2017 17:38:21 +0800
Message-ID: <586B710D.1020808@suse.com>
References: <CACUwJN1tPMv6KcL+zASxcMWs6GXVT1jdbOYNOun9ADEYC_Mh2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACUwJN1tPMv6KcL+zASxcMWs6GXVT1jdbOYNOun9ADEYC_Mh2A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Victor Garcia <vichor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 01/01/2017 03:37 PM, Victor Garcia wrote:
> Hello all
>
> I am trying to set up a raid 1 array using an SSD and a standard SAT
> HDD drives. As I read, it's better to set the write-mostly flag to the
> HDD partition of the array to keep SSD performance times.
>
> This is the command I'm using:
>
> # mdadm --create /dev/md1 -n 2 -l 1 --metadata=0.90 --bitmap=internal
> /dev/nvme0n1p5 -W /dev/sda8 --write-behind
>
> I expect seeing the (W) indicator in mdstat, but this is not showing:
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sda8[1] nvme0n1p5[0]
>        52400064 blocks [2/2] [UU]
>        [>....................]  resync =  0.3% (175936/52400064)
> finish=9.8min speed=87968K/sec
>
> unused devices: <none>
>
>   But if I force later on the flag by means of the sys FS handle, then
> it does appear:
>
> # cat /sys/block/md1/md/dev-sda8/state
> in_sync
> # echo writemostly > /sys/block/md1/md/dev-sda8/state
> # cat /sys/block/md1/md/dev-sda8/state
> in_sync,write_mostly
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sda8[1](W) nvme0n1p5[0]
>        52400064 blocks [2/2] [UU]
>        [==>..................]  resync = 11.0% (5806336/52400064)
> finish=9.8min speed=78966K/sec
>        bitmap: 1/1 pages [4KB], 65536KB chunk
>
> unused devices: <none>
>
> How is it that the (W) is not showing in the first place?

Seems only 0.9 metadata has the issue while 1.x is ok from my side,
maybe below changes could help you.

diff --git a/super0.c b/super0.c
index 938cfd95fa25..4ad591ba022e 100644
--- a/super0.c
+++ b/super0.c
@@ -915,6 +915,9 @@ static int write_init_super0(struct supertype *st)
                 while (Kill(di->devname, NULL, 0, -1, 1) == 0)
                         ;

+               if (di->disk.state & (1 << MD_DISK_WRITEMOSTLY))
+                       sb->disks[di->disk.number].state |= 
1<<MD_DISK_WRITEMOSTLY;
+
                 sb->disks[di->disk.number].state &= ~(1<<MD_DISK_FAULTY);

                 sb->this_disk = sb->disks[di->disk.number];

Regards,
Guoqing
