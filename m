From: Anugraha Sinha <asinha.mailinglist@gmail.com>
Subject: Re: RAID6 reshape stalls immediately
Date: Mon, 9 Nov 2015 22:27:42 +0900
Message-ID: <56409F4E.5000508@gmail.com>
References: <84a8qtgwqk.wl-peter.chubb@nicta.com.au>
 <563CAFC1.2080708@gmail.com> <84611dw2cw.wl-peter.chubb@nicta.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84611dw2cw.wl-peter.chubb@nicta.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

Dear Peter,

Apologies for the late reply.

On 11/8/2015 1:18 PM, Peter Chubb wrote:
>
> ls -l /root/raid5-backup
> -rw------- 1 root root 6295552 Nov  4 12:04 raid5-backup
>
> It hasn't changed since the first write when the reshape started.

That means there is no write happening on the root file which was chosen 
for backup.
Just a check, for sanity, I hope the root partition is not filled up.

>
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : 6ff23c3d:01042464:77338dc6:710dfaee
>             Name : lemma:0  (local to host lemma)
>    Creation Time : Tue Oct 27 11:52:53 2015
>       Raid Level : raid6
>     Raid Devices : 6
>
>   Avail Dev Size : 3906748416 (1862.88 GiB 2000.26 GB)
>       Array Size : 7813496832 (7451.53 GiB 8001.02 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262056 sectors, after=0 sectors
>            State : clean
>      Device UUID : fbd91407:208c66cc:1020f996:d7b1cd5d
>
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 0
>    Delta Devices : 1 (5->6)
>       New Layout : left-symmetric
>
>      Update Time : Sun Nov  8 15:12:08 2015
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : b3ec395a - correct
>           Events : 48094
>
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>
>     Device Role : Active device 1
>     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

\snip\

> And /proc/mdstat is still:
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdi1[6] sdh1[5] sdd1[4] sde1[2] sdb1[1] sda1[0]
>        5860122624 blocks super 1.2 level 6, 512k chunk, algorithm 18 [6/5] [UUUU_U]
>        [>....................]  reshape =  0.0% (0/1953374208) finish=5766.8min speed=5469K/sec
>        bitmap: 0/15 pages [0KB], 65536KB chunk
>
> unused devices: <none>
>

\snip\
1. your mdstat says that sdb1 device is down. However, examine says sdb1 
seems OK. I am not sure why?

Could you check for the daemon(process) running for md0 and see the 
strace of it. Where is it waiting?

Also I would want to check, what have been the last few dmesg in your 
system, any updated since the resyncing/reshaping started, as you shared 
in the last mail.

I am looping in to Phil explicitly for some help here.

@Phil,
Need some help here!

Regards
Anugraha Sinha
