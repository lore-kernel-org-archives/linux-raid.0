From: "Michael J. Shaver" <jmshaver@gmail.com>
Subject: Re: RAID6 - CPU At 100% Usage After Reassembly
Date: Sun, 4 Sep 2016 10:38:27 -0400
Message-ID: <CADEsfxrKeSv5dRNfBoyybHaemPSqCcamTmSZ4P+Yey-rLd8hEg@mail.gmail.com>
References: <CAOW94ut0uHS8+k0jutOT9bfT__WLbbOJmQC2CFa15HVVe9L4fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOW94ut0uHS8+k0jutOT9bfT__WLbbOJmQC2CFa15HVVe9L4fg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Francisco,

You are almost certainly hitting the same issue reported several times
both here and on other forums, although your case is the first one I
have seen for raid6:

http://www.spinics.net/lists/raid/msg53056.html
http://www.spinics.net/lists/raid/msg52235.html
https://bbs.archlinux.org/viewtopic.php?id=212108
https://forums.gentoo.org/viewtopic-t-1043706.html

At this time, there have been a couple suggestions on possible fixes
(disable transparent huge page support in the kernel)

Another gentleman, Bart Van Assche, had suggested a set of patches to
the kernel scheduler that may help with the problem:

https://lkml.org/lkml/2016/8/3/289

I am still trying to wrap my head around the patches themselves, and
haven't tried each of the patches individually. Disabling transparent
huge page support had no effect for me. At this time, my array is
still locked up with the exact s
ame symptoms you report. I am slowly learning about the spin lock
mechanism within the kernel to try to identify the underlying problem,
but this is admittedly out of my area of expertise.

To help correlate your problem with what others observed, would it be
possible for you to share the call stack for the following three
processes?

mdXXX_raid6
mdXXX_reshape
systemd-udevd

Or any other processes reporting deadlock while the reshape is trying to run.

Curious to see if you observe the same call stack.

I will definitely let you know if I have any major revelations. thanks Michael

On Sun, Sep 4, 2016 at 12:04 AM, Francisco Parada
<advanceandconquer@gmail.com> wrote:
> Hello everyone,
>
> I know this gets a ton of visibility, so I'll keep it as concise as possible.
>
> I'm running Ubuntu 16.04.1 and I have (read had) a 7 drive RAID6
> array.  I attempted to grow the array by adding 3 additional drives
> for a total of 10, but it seems that one of the brand new drives had
> 60+ bad blocks (according to "badblocks -vw").  I came to this
> conclusion, because I had a power outage during the grow that lasted
> longer than my 1500VA battery backup could withstand, so when I
> attempted to continue the reshape, I noticed that the assemble
> wouldn't start upon reboot.  All drives were marked as spares:
>
> =================================================================================================================
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md127 : inactive sdi[0](S) sdh[2](S) sdj[3](S) sdf[7](S) sdg[9](S)
> sdd[10](S) sde[11](S) sdb[13](S) sdc[12](S)
>       26371219608 blocks super 1.2
> =================================================================================================================
>
>
> Notice above, that there's only 9 drives instead of 10, which I was
> supposed to have.  The drive that's missing is "sdk", but that's
> because using "badblocks -vw" has wiped out the drive in an effort to
> figure out if there was actually something wrong with said drive
> (You're probably gasping, but it had a missing GPT table, and no
> matter what I tried to recover it, the drive would just stop
> responding to reads and writes).  So I attempted to assemble the array
> with "/dev/sdk" missing as shown below, but I get this:
>
> ===================================================================================================================
> # mdadm -Afv /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
> /dev/sdg /dev/sdh /dev/sdi /dev/sdj missing
> mdadm: looking for devices for /dev/md127
> mdadm: cannot open device missing: No such file or directory
> mdadm: missing has no superblock - assembly aborted
> ===================================================================================================================
>
>
> But I guess that doesn't matter, because almost all other drives are
> almost sync'ed as specified in the events output of mdadm (once again,
> keep in mind that "/dev/sdk" is blank, thus the "no md superblock"
> error):
>
> ==============================================
> # mdadm -E /dev/sd[b-k] | grep Events
>          Events : 280026
>          Events : 280026
>          Events : 280026
>          Events : 280026
>          Events : 280026
>          Events : 280026
>          Events : 280026
> mdadm: No md superblock detected on /dev/sdk.
>          Events : 280026
>          Events : 280011
> ==============================================
>
>
> So I attempt to reassemble it, by leaving out "/dev/sdk" and it seems
> to assemble it, with some warnings of course:
>
> ===========================================================================================================
> # mdadm -Afv /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
> /dev/sdg /dev/sdh /dev/sdi /dev/sdj
> mdadm: looking for devices for /dev/md127
> mdadm: /dev/sdb is identified as a member of /dev/md127, slot 7.
> mdadm: /dev/sdc is identified as a member of /dev/md127, slot 8.
> mdadm: /dev/sdd is identified as a member of /dev/md127, slot 6.
> mdadm: /dev/sde is identified as a member of /dev/md127, slot 9.
> mdadm: /dev/sdf is identified as a member of /dev/md127, slot 4.
> mdadm: /dev/sdg is identified as a member of /dev/md127, slot 1.
> mdadm: /dev/sdh is identified as a member of /dev/md127, slot 2.
> mdadm: /dev/sdi is identified as a member of /dev/md127, slot 0.
> mdadm: /dev/sdj is identified as a member of /dev/md127, slot 3.
> mdadm: :/dev/md127 has an active reshape - checking if critical
> section needs to be restored
> mdadm: No backup metadata on device-7
> mdadm: No backup metadata on device-8
> mdadm: No backup metadata on device-9
> mdadm: added /dev/sdg to /dev/md127 as 1
> mdadm: added /dev/sdh to /dev/md127 as 2
> mdadm: added /dev/sdj to /dev/md127 as 3 (possibly out of date)
> mdadm: added /dev/sdf to /dev/md127 as 4
> mdadm: no uptodate device for slot 10 of /dev/md127
> mdadm: added /dev/sdd to /dev/md127 as 6
> mdadm: added /dev/sdb to /dev/md127 as 7
> mdadm: added /dev/sdc to /dev/md127 as 8
> mdadm: added /dev/sde to /dev/md127 as 9
> mdadm: added /dev/sdi to /dev/md127 as 0
> mdadm: /dev/md127 has been started with 8 drives (out of 10).
> ===========================================================================================================
>
>
> But now the reshape goes from 80000K to 1000K and eventually 0K speed
> shortly after hitting "enter" to reassemble:
>
> ===========================================================================================================
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md127 : active raid6 sdi[0] sde[11] sdc[12] sdb[13] sdd[10] sdf[7] sdh[2] sdg[9]
>       14650675200 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [10/8] [UUU_U_UUUU]
>       [=======>.............]  reshape = 39.1% (1146348628/2930135040)
> finish=51538126.9min speed=0K/sec
>       bitmap: 0/22 pages [0KB], 65536KB chunk
>
> unused devices: <none>
> ===========================================================================================================
>
>
> So I did a little probing and it seems that my CPU is running at 100%
> by "md127_raid6".  I should note that it has been this way for over a
> week now, the time doesn't reflect it because I had to perform a
> reboot.  So I'm at a loss, because even if I try to optimize reshape
> speeds, the reshape still remains at 0K/sec.
>
> =================================================================================
> top - 22:28:53 up  1:56,  3 users,  load average: 3.05, 2.04, 0.92
> Tasks: 317 total,   4 running, 313 sleeping,   0 stopped,   0 zombie
> %Cpu(s):  4.4 us, 50.5 sy,  0.0 ni, 44.1 id,  1.0 wa,  0.0 hi,  0.0 si,  0.0 st
> KiB Mem :  1521584 total,   220812 free,   774868 used,   525904 buff/cache
> KiB Swap: 25153532 total, 25000764 free,   152768 used.   477708 avail Mem
>
>   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+   COMMAND
>   435 root      20   0       0      0      0 R  98.0  0.0   5:27.12
> md127_raid6
> 28941 cisco     20   0  546436  34336  25080 R   2.9  2.3   0:18.32
> gnome-disks
>  3557 message+  20   0   44364   4632   3068 S   2.0  0.3   0:06.53
> dbus-daemon
> =================================================================================
>
> Any ideas?  Your help would be greatly appreciated.
>
> Thanks in advance
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
