From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: syncing RAID1 with more than 10MB/sec
Date: Wed, 30 Mar 2005 22:25:21 -0800
Message-ID: <424B97D1.1000506@nsr500.net>
References: <200503300940.j2U9enm06046@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200503300940.j2U9enm06046@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Generally the min/max values make no difference as long as max is > 45000. 
  System use during resync is the biggest factor other than raw CPU.

Check actual resync times:

 > cat /var/log/messages.8 | synctime
array, blocks, sec, blocks/s, start, finish
md10,    2104448,    63, 33403.9, Mar 16 23:33:37, Mar 16 23:34:40
md11,    2096384,    64, 32756.0, Mar 16 23:35:30, Mar 16 23:36:34
md13,    2096384,   127, 16507.0, Mar 16 23:36:34, Mar 16 23:37:37
md12,    2096384,   191, 10975.8, Mar 16 23:37:37, Mar 16 23:38:41
md12,    2104448,    61, 34499.1, Mar 16 23:50:38, Mar 16 23:51:39
  md5,    2096384,    63, 33275.9, Mar 16 23:51:50, Mar 16 23:52:53
md12,    2104448,    61, 34499.1, Mar 17 00:00:39, Mar 17 00:01:40
  md6,    2104384,   122, 17249.0, Mar 17 00:01:40, Mar 17 00:02:41
  md5,    2104384,   183, 11499.4, Mar 17 00:02:41, Mar 17 00:03:42
  md7,    6289344,   366, 17184.0, Mar 17 00:03:42, Mar 17 00:06:45
  md9,   52170944,  1873, 27854.2, Mar 17 00:06:45, Mar 17 00:31:52
  md8,   52187008,  3489, 14957.6, Mar 17 00:31:52, Mar 17 00:58:48

 > cat ~/bin/synctime | cksum
1035800810 528
 > cat ~/bin/synctime
#!/bin/awk -f
#GNU Awk 3.1.1
#Copyright (C) 1989, 1991-2002 Free Software Foundation.
#md resync time csv

BEGIN{
         printf "array, blocks, sec, blocks/s, start, finish\n"
         }

/md: syncing RAID array/{
         sdate = $1 " " $2 " " $3
         "date -d \"" sdate "\" +%s" | getline start
         dev = $10
         }
/md: using.*window,/{
         size = $14
         }
/md:.*sync done\./{
         fdate = $1 " " $2 " " $3
         "date -d \"" fdate "\" +%s" | getline finish
         delta = finish-start
         printf "%4s, %10s, %5s, %6.1f, %s, %s\n",
                 dev,size,delta,size/delta,sdate,fdate
         }
#end

Guy wrote:
>>-----Original Message-----
>>From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>>owner@vger.kernel.org] On Behalf Of Nils-Henner Krueger
>>Sent: Wednesday, March 30, 2005 4:13 AM
>>To: linux-raid@vger.kernel.org
>>Subject: syncing RAID1 with more than 10MB/sec
>>
>>Syncing a raid1 takes long time for large disks because of
>>the 10MB/sec limit:
>>
>>Mar 30 10:58:31 imap1 kernel: raid1: raid set md2 not clean;
>>reconstructing mirrors
>>Mar 30 10:58:31 imap1 kernel: raid1: raid set md2 active with 2 out of 2
>>mirrors
>>Mar 30 10:58:31 imap1 kernel: md: syncing RAID array md2
>>Mar 30 10:58:31 imap1 kernel: md: minimum _guaranteed_ reconstruction
>>speed: 100 KB/sec/disc.
>>Mar 30 10:58:31 imap1 kernel: md: using maximum available idle IO
>>bandwith (but not more than 10000 KB/sec) for reconstruction.
>>
>>Is it possible to raise this value (without recompiling)?
>>I know about possible performance tradeoffs with other
>>processes, I'm just generally interested.
>>
>>Thanks.
>>
>>nils-henner
> 
> 
> Yes.  For details:
> man md
> 
> The default of 10,000 has been increased to 100,000 in newer kernels.
> I don't know which kernels.
> 
> If you want to override the defaults you could add these 3 lines to
> /etc/sysctl.conf:
> # RAID rebuild min/max speed K/Sec per device
> dev.raid.speed_limit_min = 1000
> dev.raid.speed_limit_max = 100000
> 
> Adjust above as required.  The above will take effect after a reboot.
> 
> To see current values type these 2 lines:
> cat /proc/sys/dev/raid/speed_limit_min
> cat /proc/sys/dev/raid/speed_limit_max
> 
> To temporarily change the defaults use these 2 commands:
> echo 1000 > /proc/sys/dev/raid/speed_limit_min
> echo 100000 > /proc/sys/dev/raid/speed_limit_max
> 
> Adjust above as required.  The above will take effect now.
> 
> Guy
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
  | for direct mail add "private_" in front of user name
