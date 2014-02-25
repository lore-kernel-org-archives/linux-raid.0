From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: md raid6: slow resync if fs is mounted rw
Date: Tue, 25 Feb 2014 23:55:15 +0100
Message-ID: <530D1F53.5070703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear list,

I am seeing a strange performance issue on a 4 x 4TB md raid6 on kernel
3.12. Initial resync goes nice and fast at 130MB/s:

> # cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md1 : active raid6 sda3[0] sdd3[3] sdc3[2] sdb3[1]
>       7751269376 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]
>       [=>...................]  resync =  7.5% (293925504/3875634688) finish=458.4min speed=130210K/sec
> 
> md0 : active raid1 sda2[0] sdd2[3] sdc2[2] sdb2[1]
>       29280128 blocks super 1.2 [4/4] [UUUU]
> 
> unused devices: <none>

...unless the ext4 filesystem on the array is mounted read-write!
Then, speed plummets to 1 - 7MB/s. The filesystem is empty and totally
idle; a simple "mount -o remount,ro" restores the speed to 130MB/s.

I dumped the /sys/block/md1/md tree with the filesystem mounted ro and
rw, the diff looks like this:

> # diff -u md.rw md.ro
> [...]
> --- md.rw/stripe_cache_active   2014-02-25 17:33:31.250019324 +0100
> +++ md.ro/stripe_cache_active   2014-02-25 17:33:31.250019324 +0100
> @@ -1 +1 @@
> -0
> +256
> diff -u md.rw/sync_speed md.ro/sync_speed
> --- md.rw/sync_speed    2014-02-25 17:33:31.250019324 +0100
> +++ md.ro/sync_speed    2014-02-25 17:33:31.250019324 +0100
> @@ -1 +1 @@
> -1052
> +126244

So, stripe_cache_active is zero if the fs is mounted rw. Hmm.

Interestingly, if I increase sync_speed_min to 100MB/s, I do get 100MB/s.

Any idea what is going on?

Best regards,
Jakob Unterwurzacher
